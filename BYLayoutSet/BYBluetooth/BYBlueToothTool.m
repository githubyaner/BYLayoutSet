//
//  BYBlueToothTool.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 2016/11/25.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYBlueToothTool.h"
#import "BYBlueToothUtil.h"
#import "BabyBluetooth.h"

typedef NS_ENUM(NSInteger, BYOperationType){
    BYOperationTypeDefaultNone = 0,//default
    BYOperationTypeRunApp,
    BYOperationTypeReadHZ,
    BYOperationTypeUpdateTag,
    BYOperationTypeReadTags,
    BYOperationTypeReadTags_Command29,
};

#define PERIPHERALS_NAME @"HMSoft"

@interface BYBlueToothTool ()
@property (nonatomic, strong) BabyBluetooth *baby;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBCharacteristic *characteristic;
@property (nonatomic, assign) BYOperationType type;
@property (nonatomic, copy) NSString *result;
@end

@implementation BYBlueToothTool

//初始化
+ (BYBlueToothTool *)bluetoothTool {
    BYBlueToothTool *tool = [[BYBlueToothTool alloc] init];
    return tool;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.result = @"";
        self.type = BYOperationTypeDefaultNone;
        self.baby = [[BabyBluetooth alloc] init];
        //设置蓝牙委托
        [self babyDelegate];
        //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态
        _baby.scanForPeripherals().connectToPeripherals().discoverServices().discoverCharacteristics().begin();
    }
    return self;
}

#pragma mark - BabyBluetooth

//设置蓝牙委托
-(void)babyDelegate{
    __weak typeof(self) weakSelf = self;
#pragma mark - 状态
    [_baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            NSLog(@"设备打开成功.");
        }
        if (central.state == CBManagerStatePoweredOff) {
            NSLog(@"蓝牙处于关闭状态,请您打开.");
        }
    }];
#pragma mark - 扫描并连接
    //查找并且连接
    __block BOOL isFirst = YES;
    [_baby setFilterOnConnectToPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        if(isFirst && [peripheralName hasPrefix:PERIPHERALS_NAME]){
            isFirst = NO;
            return YES;
        }
        return NO;
    }];
#pragma mark - 连接委托
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [_baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"设备：%@--连接成功",peripheral.name);
    }];
    //设置设备连接失败的委托
    [_baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
    }];
    //设置设备断开连接的委托
    [_baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        [weakSelf.baby cancelNotify:weakSelf.peripheral characteristic:weakSelf.characteristic];
        weakSelf.peripheral = nil;
        weakSelf.characteristic = nil;
        [weakSelf.baby.centralManager connectPeripheral:peripheral options:nil];
    }];
#pragma mark - service
    //设置发现设备的Services的委托
    [_baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            //每个service
            NSLog(@"服务ID===%@", service.UUID);
        }
    }];
    //设置发现设service的Characteristics的委托
    [_baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===服务ID:%@",service.UUID);
        for (CBCharacteristic *characteristic in service.characteristics) {
            NSLog(@"特征ID:%@", characteristic.UUID.UUIDString);
            weakSelf.peripheral = peripheral;
            weakSelf.characteristic = characteristic;
            [weakSelf notifyValuesPeripheral:peripheral characteristic:characteristic];
        }
    }];
#pragma mark - write callback
    [_baby setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        if (error) {
            NSLog(@"error = %@", error.userInfo);
        } else {
            NSLog(@"写入成功");
            weakSelf.result = @"";
        }
    }];
}

#pragma mark - 监听
- (void)notifyValuesPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic {
    __weak typeof(self) weakSelf = self;
    [self.baby notify:peripheral characteristic:characteristic block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        //接收到值会进入这个方法
//        NSLog(@"新的值:%@, 特征ID:%@", [BYBlueToothUtil convertDataToHexStr:characteristic.value], characteristic.UUID.UUIDString);
        NSString *hexStr = [BYBlueToothUtil hexFromData:characteristic.value];
        weakSelf.result = [weakSelf.result stringByAppendingString:hexStr];
        [weakSelf processTheReturnValue];
    }];
}

#pragma mark - Process the return value

- (void)processTheReturnValue {
    if ([self dataIntegrity]) {
        NSLog(@"result = %@", self.result);
        [self analyticalData];
    }
}

//判断数据是否完整
- (BOOL)dataIntegrity {
    if (self.result.length < 14) {
        return NO;
    }
    NSString *crc = [self.result substringWithRange:NSMakeRange(self.result.length - 4, 4)];
    NSString *bytesStr = [self.result substringWithRange:NSMakeRange(0, self.result.length - 4)];
    NSData *hexData = [BYBlueToothUtil dataFromHex:bytesStr];
    Byte *hexByte = (Byte *)[hexData bytes];
    int length = (int)[hexData length];
    UInt16 crcUint16 = CalcCRC_Pointer(hexByte, length);
    NSString *crcStr = [[BYBlueToothUtil hexFromUInt16:crcUint16] lowercaseString];
    if (crcStr.length % 2 != 0) {
        crcStr = [@"0" stringByAppendingString:crcStr];
    }
    if ([crc isEqualToString:crcStr]) {
        return YES;
    } else {
        return NO;
    }
}

//解析数据
- (void)analyticalData {
    NSString *codeStr;
    NSString *status = [self.result substringWithRange:NSMakeRange(6, 4)];
    if ([@"0000" isEqualToString:status]) {
        codeStr = @"操作成功";
    } else {
        codeStr = [self resultCode:status];
    }
    switch (self.type) {
        case BYOperationTypeRunApp:
        {
            if (self.runAppBack) {
                self.runAppBack(codeStr, nil);
            }
        }
            break;
        case BYOperationTypeReadHZ:
        {
            if (self.readHZBack) {
                self.readHZBack(codeStr, nil);
            }
        }
            break;
        case BYOperationTypeUpdateTag:
        {
            if (self.updateTagBack) {
                self.updateTagBack(codeStr, nil);
            }
        }
            break;
        case BYOperationTypeReadTags:
        {
            /**command29 操作*/
            if ([@"0000" isEqualToString:status]) {
                [self readTags_Command29];
            }
            if (self.readTagsBack) {
                self.readTagsBack(codeStr, nil);
            }
        }
            break;
        case BYOperationTypeReadTags_Command29:
        {
            if (![@"0000" isEqualToString:status]) {
                if (self.readTagsBack_Command29) {
                    self.readTagsBack_Command29(codeStr, nil);
                }
            } else {
                NSMutableArray *dataArr = [NSMutableArray array];
                //MetadataFlags为0x0000,不返回任何相关标签参数。只是返回标签EPC号(包括标签PC，CRC)。
                NSString *tagCount = [self.result substringWithRange:NSMakeRange(16, 2)];
                NSString *ecpID = [self.result substringWithRange:NSMakeRange(26, self.result.length - 26 - 8)];
                NSInteger count = [[BYBlueToothUtil decimalFromHex:tagCount] integerValue];
                for (int i = 0; i < count; i++) {
                    NSString *dataStr = [BYBlueToothUtil stringFromHex:[ecpID substringWithRange:NSMakeRange(i * 16, 16)]];
                    if (dataStr == nil) {
                        dataStr = [BYBlueToothUtil chineseFromHex:[ecpID substringWithRange:NSMakeRange(i * 16, 16)]];
                    }
                    [dataArr addObject:dataStr];
                    NSLog(@"dataStr = %@", dataStr);
                }
                if (self.readTagsBack_Command29) {
                    self.readTagsBack_Command29(codeStr, dataArr);
                }
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Bluetooth Function
//运行到App层
- (void)runApp {
    if (!self.peripheral || !self.characteristic) {
        NSLog(@"外设未连接或正在连接~");
        return;
    }
    self.type = BYOperationTypeRunApp;
    Byte byte[5];
    byte[0] = 0xFF;
    byte[1] = 0x00;
    byte[2] = 0x04;
    UInt16 uInt16 = CalcCRC(byte, 3);
    NSString *hexStr = [BYBlueToothUtil hexFromUInt16:uInt16];
    NSData *hexData = [BYBlueToothUtil dataFromHex:hexStr];
    Byte *hexByte = (Byte *)[hexData bytes];
    byte[3] = hexByte[0];
    byte[4] = hexByte[1];
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithoutResponse];
}
//设置读频率
- (void)setReadHZ:(NSString *)hz {
    if (!self.peripheral || !self.characteristic) {
        NSLog(@"外设未连接或正在连接~");
        return;
    }
    if (hz == nil || [@"" isEqualToString:hz]) {
        hz = @"2700";//最大读取功率
    }
    self.type = BYOperationTypeReadHZ;
    Byte byte[7];
    byte[0] = 0xFF;
    byte[1] = 0x02;
    byte[2] = 0x92;
    byte[3] = 0x0A;
    byte[4] = 0x8C;
    UInt16 uInt16 = CalcCRC(byte, 5);
    NSString *hexStr = [BYBlueToothUtil hexFromUInt16:uInt16];
    NSData *hexData = [BYBlueToothUtil dataFromHex:hexStr];
    Byte *hexByte = (Byte *)[hexData bytes];
    byte[5] = hexByte[0];
    byte[6] = hexByte[1];
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithoutResponse];
}
//添加标签/修改标签 - 更新
- (void)updateTagForEPC:(NSString *)tagName {
    if (!self.peripheral || !self.characteristic) {
        NSLog(@"外设未连接或正在连接~");
        return;
    }
    if (tagName == nil || [@"" isEqualToString:tagName]) {
        NSLog(@"请您输入名称");
        return;
    } else {
        if (tagName.length > 4) {
            NSLog(@"请您输入4位以下(含4位)的名称");
            return;
        }
    }
    self.type = BYOperationTypeUpdateTag;
    NSString *hexTagName = [BYBlueToothUtil hexFromString:tagName];
    NSData *hexTagNameData = [BYBlueToothUtil dataFromHex:hexTagName];
    Byte *hexTagNameByte = (Byte *)[hexTagNameData bytes];
#warning 使用utf-8和utf-16转码后的中文不一样.
    Byte byte[19];
    byte[0] = 0xFF;
    byte[1] = 0x0C;
    byte[2] = 0x23;
    byte[3] = 0x03;
    byte[4] = 0xE8;
    byte[5] = 0x00;
    byte[6] = 0x00;
    //**data
    byte[7] = hexTagNameByte[0];
    byte[8] = hexTagNameByte[1];
    byte[9] = hexTagNameByte[2];
    byte[10] = hexTagNameByte[3];
    byte[11] = hexTagNameByte[4];
    byte[12] = hexTagNameByte[5];
    byte[13] = hexTagNameByte[6];
    byte[14] = hexTagNameByte[7];
    
    UInt16 uInt16 = CalcCRC(byte, 15);
    NSString *hexStr = [BYBlueToothUtil hexFromUInt16:uInt16];
    NSData *hexData = [BYBlueToothUtil dataFromHex:hexStr];
    Byte *hexByte = (Byte *)[hexData bytes];
    byte[15] = hexByte[0];
    byte[16] = hexByte[1];
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithoutResponse];
}

//阅读标签
- (void)readTags {
    if (!self.peripheral || !self.characteristic) {
        NSLog(@"外设未连接或正在连接~");
        return;
    }
    self.type = BYOperationTypeReadTags;
    Byte byte[10];
    byte[0] = 0xFF;
    byte[1] = 0x05;
    byte[2] = 0x22;
    byte[3] = 0x00;
    byte[4] = 0x00;
    byte[5] = 0x00;
    byte[6] = 0x03;//1秒=1000毫秒 03e8
    byte[7] = 0xE8;//1秒=1000毫秒 03e8
    
    UInt16 uInt16 = CalcCRC(byte, 8);
    NSString *hexStr = [BYBlueToothUtil hexFromUInt16:uInt16];
    NSData *hexData = [BYBlueToothUtil dataFromHex:hexStr];
    Byte *hexByte = (Byte *)[hexData bytes];
    byte[8] = hexByte[0];
    byte[9] = hexByte[1];
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithoutResponse];
}

//阅读标签
- (void)readTags_Command29 {
    if (!self.peripheral || !self.characteristic) {
        NSLog(@"外设未连接或正在连接~");
        return;
    }
    self.type = BYOperationTypeReadTags_Command29;
    Byte byte[8];
    byte[0] = 0xFF;
    byte[1] = 0x03;
    byte[2] = 0x29;
    byte[3] = 0x00;
    byte[4] = 0x00;
    byte[5] = 0x00;
    UInt16 uInt16 = CalcCRC(byte, 6);
    NSString *hexStr = [BYBlueToothUtil hexFromUInt16:uInt16];
    NSData *hexData = [BYBlueToothUtil dataFromHex:hexStr];
    Byte *hexByte = (Byte *)[hexData bytes];
    byte[6] = hexByte[0];
    byte[7] = hexByte[1];
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithoutResponse];
}


#pragma mark - clean bluetooth
//清除蓝牙
- (void)cleanBluetooth {
    self.type = BYOperationTypeDefaultNone;
    //取消监听
    if (self.peripheral || self.characteristic) {
        [self.baby cancelNotify:self.peripheral characteristic:self.characteristic];
    }
    //删除自动重连
    [self.baby AutoReconnectCancel:self.peripheral];
    //断开所有peripheral的连
    [self.baby cancelAllPeripheralsConnection];
    //取消扫描
    [self.baby cancelScan];
    self.baby = nil;
}

#pragma mark - ResultCode

- (NSString *)resultCode:(NSString *)status {
    NSString *code = @"";
    NSDictionary *codeDic = @{@"0000":@"操作成功", @"0100":@"数据长度出错", @"0105":@"不可用参数值，参数错误", @"0400":@"盘存不到标签，没有标签", @"040A":@"一般标签错误", @"0424":@"存储区锁定", @"0504":@"温度超限", @"0505":@"驻波比过大，反射过大",};
    code = codeDic[status];
    if (code != nil) {
        return code;
    } else {
        return @"操作异常";
    }
}

@end
