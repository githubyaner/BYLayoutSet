//
//  BYBlueToothTool.h
//  BYLayoutSet
//
//  Created by SunShine.Rock on 2016/11/25.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYBlueToothTool : NSObject

//初始化
+ (BYBlueToothTool *)bluetoothTool;

/*
 *  function
 */
//运行到App层
- (void)runApp;
//设置读频率
- (void)setReadHZ:(NSString *)hz;
//添加标签/修改标签 - 更新
- (void)updateTagForEPC:(NSString *)tagName;
//阅读标签 - 更新
- (void)readTags;
//清除蓝牙
- (void)cleanBluetooth;

/*
 *  block
 */
@property (nonatomic, copy) void(^runAppBack)(NSString *codeStr, id data);
@property (nonatomic, copy) void(^readHZBack)(NSString *codeStr, id data);
@property (nonatomic, copy) void(^updateTagBack)(NSString *codeStr, id data);
@property (nonatomic, copy) void(^readTagsBack)(NSString *codeStr, id data);
@property (nonatomic, copy) void(^readTagsBack_Command29)(NSString *codeStr, id data);
@end
