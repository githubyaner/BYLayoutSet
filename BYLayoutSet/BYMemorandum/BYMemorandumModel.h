//
//  BYMemorandumModel.h
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/24.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface BYMemorandumModel : NSObject
+ (BYMemorandumModel *)memorandumModel;//初始化一个model
+ (BYMemorandumModel *)modelWithModel:(BYMemorandumModel*)model;//根据传来的model,生成一个新的model(赋值并开辟空间)
- (void)updateData;//更新计算数据

/**存储数据库数据*/
@property (nonatomic, copy) NSString *creatDate;//创建时间
@property (nonatomic, copy) NSString *titleText;//标题
@property (nonatomic, copy) NSString *noteText;//备注
@property (nonatomic, copy) NSString *clookDate;//闹钟(提醒时间)
@property (nonatomic, copy) NSString *loopType;//提醒重复类型
@property (nonatomic, assign) BOOL isFinish;//是否完成备忘

/**计算项目*/
@property (nonatomic, assign) CGFloat height;//高度
@property (nonatomic, assign) CGFloat textHeight;//note的高度
@property (nonatomic, assign) BOOL isNote;//是否有note
@property (nonatomic, assign) BOOL isClook;//是否有闹钟(提醒时间)
@property (nonatomic, assign) BOOL isRemind;//是否重复提醒

/**yyyy-MM-dd HH:mm:ss转化成String*/
+ (NSString *)dateStrFromDate:(NSDate *)date;
/**String转化成yyyy-MM-dd HH:mm:ss*/
+ (NSDate *)dateFromDateStr:(NSString *)dateStr;
/**文字处理*/
+ (void)conversionCharacterText:(NSString *)text withLabel:(UILabel *)label;
@end
