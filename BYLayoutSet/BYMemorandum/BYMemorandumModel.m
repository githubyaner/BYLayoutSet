//
//  BYMemorandumModel.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/24.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYMemorandumModel.h"
#define CellFont(s) [UIFont fontWithName:@"STHeitiSC-Light" size:s]

@implementation BYMemorandumModel
+ (BYMemorandumModel *)memorandumModel {
    BYMemorandumModel *model = [[BYMemorandumModel alloc] init];
    model.creatDate = [self dateStrFromCreateDate:[NSDate date]];
    model.titleText = @"";
    model.noteText = @"";
    model.clookDate = @"";
    model.loopType = @"永不";
    model.isFinish = NO;
    
    model.height = 45;
    model.textHeight = 0;
    model.isNote = NO;
    model.isClook = NO;
    model.isRemind = NO;
    return model;
}

+ (BYMemorandumModel *)modelWithModel:(BYMemorandumModel *)model {
    BYMemorandumModel *sendModel = [[BYMemorandumModel alloc] init];
    sendModel.creatDate = model.creatDate;
    sendModel.titleText = model.titleText;
    sendModel.noteText = model.noteText;
    sendModel.clookDate = model.clookDate;
    sendModel.loopType = model.loopType;
    sendModel.isFinish = model.isFinish;
    
    sendModel.height = model.height;
    sendModel.textHeight = model.textHeight;
    sendModel.isNote = model.isNote;
    sendModel.isClook = model.isClook;
    sendModel.isRemind = model.isRemind;
    return sendModel;
}

- (void)updateData {
    if ([self isBlankString:self.clookDate]) {
        self.isClook = NO;
    } else {
        self.isClook = YES;
    }
    if ([self.loopType isEqualToString:@"永不"]) {
        self.isRemind = NO;
    } else {
        self.isRemind = YES;
    }
    
    CGFloat textHeight = 0.0f;
    if ([self isBlankString:self.noteText]) {
        self.isNote = NO;
    } else {
        self.isNote = YES;
        UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, [UIScreen mainScreen].bounds.size.width / 6 * 5 - 10 - 45, MAXFLOAT)];
        noteLabel.textColor = [UIColor lightGrayColor];
        noteLabel.font = CellFont(15);
        noteLabel.numberOfLines = 0;
//        noteLabel.text = self.noteText;
        [[self class] conversionCharacterText:self.noteText withLabel:noteLabel];
        [noteLabel sizeToFit];
        textHeight = noteLabel.frame.size.height;
    }
    self.textHeight = textHeight;
    if (self.isClook) {
        if (0 == textHeight) {
            self.height = 5 + 25 + 5 + 20 + 5;
        } else {
            self.height = 5 + 25 + 5 + textHeight + 5 + 20 + 5;
        }
    } else {
        if (0 == textHeight) {
            self.height = 45;
        } else {
            self.height = 5 + 25 + 5 + textHeight + 5;
        }
    }
    
    //判断新的clook是不是和旧的一样.
    //一样就添加本地推送,并且设置是否重复提醒.如果添加过了不做任何操作.
    //如果不一样,把上一个推送删除,创建新的本地推送.
    //通知执行完,会从队列中消失
    
    //后台执行
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf searchMyLocalNotification];
    });
    
    
//    NSLog(@"title = %@, isnote = %@, isclook = %@, isremind = %@, isfinish = %@", self.titleText, @(self.isNote), @(self.isClook), @(self.isRemind), @(self.isFinish));
}

#pragma mark - localnotification

- (void)searchMyLocalNotification {
    NSArray *locArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *localNotification in locArr) {
        NSDictionary *userInfo = localNotification.userInfo;
        if ([self.creatDate isEqualToString:userInfo[@"key"]]) {
            /**查询到执行*/
            //判断完成时,或者没有触发时间就删除
            if (self.isFinish || !self.isClook) {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
                return;
            }
            NSString *loopType = userInfo[@"loopType"];
            if (![loopType isEqualToString:self.loopType]) {
                //先删除
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
                //重新添加
                [self addLocalNotification];
            }
            //如果没有完成
            if ([self.clookDate isEqualToString:[[self class] dateStrFromDate:localNotification.fireDate]]) {
                //不做操作
            } else {
                //先删除
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
                //重新添加
                [self addLocalNotification];
            }
            return;
        }
    }
    //查询不到执行
    [self addLocalNotification];
}

//本地推送必须设置声音或者其他元素.不然添加不上.
- (void)addLocalNotification {
    //如果已完成,或者没有时间就return
    if (self.isFinish || !self.isClook) {
        return;
    }
    
    //判断时间是不是小于等于当前时间
    NSString *newDateStr = [[self class] dateStrFromDate:[NSDate date]];
    NSDate *nowDate = [[self class] dateFromDateStr:newDateStr];
    NSDate *clookDate = [[self class] dateFromDateStr:self.clookDate];
    NSComparisonResult result = [nowDate compare:clookDate];
    if (result == NSOrderedSame || result == NSOrderedDescending) {
        return;
    }
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification != nil) {
        notification.fireDate = [[self class] dateFromDateStr:self.clookDate];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = @"default";
        
        notification.alertTitle = self.titleText;
        notification.alertBody = self.noteText;
        
        notification.userInfo = @{@"key":self.creatDate, @"loopType":[NSString stringWithFormat:@"%@", self.loopType]};
        
        notification.repeatInterval = [self obtainLoopType];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (NSCalendarUnit)obtainLoopType {
    if ([@"每分钟" isEqualToString:self.loopType]) {
        return NSCalendarUnitMinute;
    } else if ([@"每小时" isEqualToString:self.loopType]) {
        return NSCalendarUnitHour;
    } else if ([@"每天" isEqualToString:self.loopType]) {
        return NSCalendarUnitDay;
    } else if ([@"每周" isEqualToString:self.loopType]) {
        return NSCalendarUnitWeekday;
    } else if ([@"每月" isEqualToString:self.loopType]) {
        return NSCalendarUnitMonth;
    } else if ([@"每年" isEqualToString:self.loopType]) {
        return NSCalendarUnitYear;
    } else {
        return 0;
    }
}

#pragma mark - help nsdate
/**判断字符串是否为空*/
- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
/**createDate专用*/
+ (NSString *)dateStrFromCreateDate:(NSDate *)createDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:createDate];
    return dateStr;
}
/**yyyy-MM-dd HH:mm:ss转化成String*/
+ (NSString *)dateStrFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}
/**String转化成yyyy-MM-dd HH:mm:ss*/
+ (NSDate *)dateFromDateStr:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    return date;
}


/**文字处理*/
+ (void)conversionCharacterText:(NSString *)text withLabel:(UILabel *)label {
    NSMutableAttributedString *muAtt = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;//设置两端对齐
    paragraphStyle.paragraphSpacing = 0.0f;//段落后间距
    paragraphStyle.paragraphSpacingBefore = 0.0f;//段落前间距
    paragraphStyle.firstLineHeadIndent = 0.0f;//首行缩进
    paragraphStyle.headIndent = 0.0f;//头部缩进
    
    NSDictionary *dict = @{NSFontAttributeName: CellFont(15), NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraphStyle};
    [muAtt setAttributes:dict range:NSMakeRange(0, text.length)];
    
    NSAttributedString *att = [muAtt copy];
    [label setAttributedText:att];
}


@end
