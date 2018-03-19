//
//  BYBlueToothUtil.h
//  BYLayoutSet
//
//  Created by SunShine.Rock on 2016/11/25.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYBlueToothUtil : NSObject

#pragma mark - 10进制与16进制互转
/**UInt16换为16进制的 - UInt16*/
+ (NSString *)hexFromUInt16:(UInt16)uInt16;
/**16进制转10进制 - NSString*/
+ (NSString *)decimalFromHex:(NSString *)hexStr;
#pragma mark - 16进制与NSData互转
/**16进制字符串转NSData(bytes)。*/
+ (NSMutableData *)dataFromHex:(NSString *)str;
/**NSData转换为16进制的。*/
+ (NSString *)hexFromData:(NSData *)data;
#pragma mark - 字符与16进制互转
/**普通字符串转16进制*/
+ (NSString *)hexFromString:(NSString *)string;
/**中文转16进制*/
+ (NSString *)hexFromChinese:(NSString*)chineseStr;
/**16进制转普通字符串*/
+ (NSString *)stringFromHex:(NSString *)hexStr;
/**16进制转中文*/
+ (NSString *)chineseFromHex:(NSString *)hexStr;

/**计算CRC-16*/
UInt16 CalcCRC(Byte msgbuf[], int msglen);
/**计算CRC-16 Pointer*/
UInt16 CalcCRC_Pointer(Byte *msgbuf, int msglen);

/**判断是否有中文*/
+ (BOOL)IsChinese:(NSString *)str;

@end
