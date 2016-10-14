//
//  BYAlarmClockPushLocal.m
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/10/13.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYAlarmClockPushLocal.h"

@implementation BYAlarmClockPushLocal
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setMyObject];
    }
    return self;
}
- (void)setMyObject {
//    [self setUpLocalNotification:@"2016-09-18 13:46"];
//    [self myLocalNotification];
//    [self timingTask];
}

#pragma mark - timer
- (void)timingTask {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    NSString *newDateStr = [NSString stringWithFormat:@"%@ 14:06:00", dateStr];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSDate *newDate = [dateFormatter dateFromString:newDateStr];
    NSTimer *timer  = [[NSTimer alloc] initWithFireDate:newDate interval:10 target:self selector:@selector(timeOutStop) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    NSTimer *timer1 = [NSTimer timerWithTimeInterval:66 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
    }];
}

- (void)timeOutStop {
    NSLog(@"触发了");
}

#pragma mark - local notifcation
#pragma mark - 闹钟
- (void)alarmClock {
    //首先获取一个时间
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    //设置一个时间点. 比如 16:16:16
    NSString *newDateStr = [NSString stringWithFormat:@"%@ 16:16:16", dateStr];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSDate *newDate = [dateFormatter dateFromString:newDateStr];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (localNotification) {
        localNotification.fireDate = newDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.repeatInterval = NSCalendarUnitDay;//设置每天重复
        localNotification.alertTitle = @"闹钟";
        localNotification.alertBody = @"懒虫起床了!~~";
        localNotification.alertAction = @"再睡会~";
        //如果有需要传的东西可以设置一下userInfo
        localNotification.userInfo = @{@"key": @"value"};
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

- (void)searchMyLocalNotification {
    NSArray *locArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *localNotification in locArr) {
        NSDictionary *userInfo = localNotification.userInfo;
        //你可以通过userInfo中的数据(key和value)来判断是不是你想要的通知
        
        //然后你可以删除此通知,或者将此通知替换掉
        [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
    }
}
#pragma mark - 定时推送
- (void)setUpLocalNotification:(NSString *)dateStr {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (localNotification == nil) {
        return;
    }
    
    //处理时间字符串
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *fireDate = [formatter dateFromString:dateStr];
    NSAssert(fireDate, @"dateStr类型不匹配,或者为nil");
    
    //设置UILocalNotification
    [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];//设置时区
    localNotification.fireDate = fireDate;//设置触发时间
    localNotification.repeatInterval = 0;//设置重复间隔
    
    localNotification.alertBody = @"定时推送的信息";
    localNotification.alertTitle = @"定时推送";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    //当然你也可以调取当前的气泡,并且设置.也可以设置一个userInfo进行传递信息
    /*
     [localNotification setApplicationIconBadgeNumber:66];
     localNotification.applicationIconBadgeNumber += 1;
     localNotification.userInfo = @{@"KEY" : @"VALUE"};
     */
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)myLocalNotification {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification != nil) {
        NSDate *now = [NSDate new];
        notification.fireDate = [now dateByAddingTimeInterval:5];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = @"default";
        
        notification.alertTitle = @"定时推送";
        notification.alertBody = @"刚定的火箭,赶紧去提箭!";
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}


@end
