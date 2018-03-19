//
//  BYBlueToothUtil.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 2016/11/25.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYBlueToothUtil.h"

#define MSG_CRC_INIT		    0xFFFF
#define MSG_CCITT_CRC_POLY		0x1021

@implementation BYBlueToothUtil
#pragma mark - 10进制与16进制互转
/**UInt16换为16进制的 - UInt16*/
+ (NSString *)hexFromUInt16:(UInt16)uInt16 {
    NSString *nLetterValue;
    NSString *str = @"";
    UInt16 ttmpig;
    for (int i = 0; i < 9; i++) {
        ttmpig = uInt16 % 16;
        uInt16 = uInt16 / 16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue = @"A";break;
            case 11:
                nLetterValue = @"B";break;
            case 12:
                nLetterValue = @"C";break;
            case 13:
                nLetterValue = @"D";break;
            case 14:
                nLetterValue = @"E";break;
            case 15:
                nLetterValue = @"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u", ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (uInt16 == 0) {
            break;
        }
    }
    return str;
}
/**16进制转10进制 - NSString*/
+ (NSString *)decimalFromHex:(NSString *)hexStr {
    NSString *decimalStr = [NSString stringWithFormat:@"%ld", strtoul([hexStr UTF8String], 0, 16)];
    return decimalStr;
}
#pragma mark - 16进制与NSData互转
/**16进制字符串转NSData(bytes)。*/
+ (NSMutableData *)dataFromHex:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:10];
    NSRange range;
    if ([str length] %2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}
/**NSData转换为16进制的。*/
+ (NSString *)hexFromData:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}
#pragma mark - 字符与16进制互转
/**普通字符串转16进制*/
+ (NSString *)hexFromString:(NSString *)string {
    NSData *myD;
    if ([self IsChinese:string]) {
        myD = [string dataUsingEncoding:NSUTF16StringEncoding];
    } else {
        myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    }
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for(int i = 0; i < [myD length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x", bytes[i] & 0xff];///16进制数
        if([newHexStr length] == 1) {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr, newHexStr];
        } else {
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr, newHexStr];
        }
    }
    return hexStr; 
}
/**中文转16进制*/
+ (NSString *)hexFromChinese:(NSString*)chineseStr {
    NSStringEncoding encodingGB18030 =  CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *responseData = [chineseStr dataUsingEncoding:encodingGB18030];
    Byte *bytes = (Byte *)[responseData bytes];
    NSString *hexStr = @"";
    for(int i = 0; i < [responseData length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
        if([newHexStr length] == 1) {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr, newHexStr];
        } else {
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr, newHexStr];
        }
    }
    return hexStr;
}

/**16进制转普通字符串*/
+ (NSString *)stringFromHex:(NSString *)hexStr {
    char *myBuffer = (char *)malloc((int)[hexStr length] / 2 + 1);
    bzero(myBuffer, [hexStr length] / 2 + 1);
    for (int i = 0; i < [hexStr length] - 1; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [hexStr substringWithRange:NSMakeRange(i, 2)];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
}
/**16进制转中文*/
+ (NSString *)chineseFromHex:(NSString *)hexStr {
    char *myBuffer = (char *)malloc((int)[hexStr length] / 2 + 1);
    bzero(myBuffer, [hexStr length] / 2 + 1);
    for (int i = 0; i < [hexStr length] - 1; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [hexStr substringWithRange:NSMakeRange(i, 2)];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:NSUnicodeStringEncoding];
    free(myBuffer);
    NSString *temp1 = [unicodeString stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *temp2 = [temp1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *temp3 = [[@"\"" stringByAppendingString:temp2] stringByAppendingString:@"\""];
    NSData *tempData = [temp3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *temp4 = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    NSString *string = [temp4 stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
    return string;
}

#pragma mark - 计算CRC-16
/**计算CRC-16*/
UInt16 CalcCRC(Byte msgbuf[], int msglen) {
    UInt16 calcCrc = MSG_CRC_INIT;
    UInt8  i;
    for (i = 1; i < msglen; ++i) {
        CRC_calcCrc8(&calcCrc, MSG_CCITT_CRC_POLY, msgbuf[i]);
    }
    return calcCrc;
}
/**计算CRC-16 Pointer*/
UInt16 CalcCRC_Pointer(Byte *msgbuf, int msglen) {
    UInt16 calcCrc = MSG_CRC_INIT;
    UInt8  i;
    for (i = 1; i < msglen; ++i) {
        CRC_calcCrc8(&calcCrc, MSG_CCITT_CRC_POLY, msgbuf[i]);
    }
    return calcCrc;
}

void CRC_calcCrc8(UInt16 *crcReg, UInt16 poly, UInt16 u8Data) {
    UInt16 i;
    UInt16 xorFlag;
    UInt16 bit;
    UInt16 dcdBitMask = 0x80;
    for(i = 0; i < 8; i++) {
        xorFlag = *crcReg & 0x8000;
        *crcReg <<= 1;
        bit = ((u8Data & dcdBitMask) == dcdBitMask);
        *crcReg |= bit;
        if(xorFlag) {
            *crcReg = *crcReg ^ poly;
        }
        dcdBitMask >>= 1;
    }
}

#pragma mark - other help

/**判断是否有中文*/
+ (BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length]; i++) {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

@end
