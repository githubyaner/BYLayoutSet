//
//  BYCalendarVC.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 2016/11/21.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYCalendarVC.h"
#import "BYTempWebVC.h"
#import "FSCalendar.h"
#import "BYCalendarCell.h"

@interface BYCalendarVC () <FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance>
{
    NSInteger _year;
    NSInteger _month;
}
@property (nonatomic, strong) FSCalendar *calendar;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSMutableArray *dateArr;
@end

@implementation BYCalendarVC

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    // 450 for iPad and 300 for iPhone
    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 300;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 64, view.frame.size.width, height)];
    calendar.delegate = self;
    calendar.dataSource = self;
    calendar.allowsMultipleSelection = YES;//多选
    calendar.scrollDirection = FSCalendarScrollDirectionVertical;//滑动方向
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;//不属于本月的不显示
    calendar.backgroundColor = [UIColor whiteColor];
    [view addSubview:calendar];
    self.calendar = calendar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"日历";
    [self getCurrentMonth];
    self.dateArr = [NSMutableArray arrayWithArray:@[@"2016/12/12", @"2016/12/18", @"2016/12/22"]];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy/MM/dd";
    [self customizedNavigation];
    for (NSString *dateStr in self.dateArr) {
        [self.calendar selectDate:[self.dateFormatter dateFromString:dateStr]];
    }
    [self layoutOtherViews];
}

- (void)customizedNavigation {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_down"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    UIBarButtonItem *detailBtn = ({
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeInfoLight];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithCustomView:btn];
        temp;
    });
    self.navigationItem.rightBarButtonItems = @[detailBtn];
}

- (void)layoutOtherViews {
    UIButton *todayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    todayBtn.frame = CGRectMake(30, self.calendar.frame.size.height + 70, ([UIScreen mainScreen].bounds.size.width - 90) / 2, 40);
    [todayBtn setTitle:@"今天" forState:UIControlStateNormal];
    [todayBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [todayBtn addTarget:self action:@selector(today) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:todayBtn];
    UIButton *alertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    alertBtn.frame = CGRectMake(30 + ([UIScreen mainScreen].bounds.size.width - 90) / 2 + 30, self.calendar.frame.size.height + 70, ([UIScreen mainScreen].bounds.size.width - 90) / 2, 40);
    [alertBtn setTitle:@"已选中" forState:UIControlStateNormal];
    [alertBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [alertBtn addTarget:self action:@selector(alert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alertBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Other Function

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)detail {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BYLayoutSet" message:@"使用\"FSCalendar\"" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"前往GitHub" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BYTempWebVC *webVC = [[BYTempWebVC alloc] initWithUrl:@"https://github.com/WenchaoD/FSCalendar" BYVCTYPE:BYVCTYPE_POP];
        [weakSelf.navigationController pushViewController:webVC animated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
}

- (void)today {
    [self.calendar setCurrentPage:[NSDate date] animated:YES];
}

- (void)alert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BYLayoutSet" message:[NSString stringWithFormat:@"%@", self.dateArr] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - <FSCalendarDelegateAppearance>

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date {
    return [UIColor clearColor];
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date {
    return [UIColor lightGrayColor];
}

#pragma mark - <FSCalendarDelegate>

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    return YES;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    NSString *dateStr = [self.dateFormatter stringFromDate:date];
    FSCalendarCell *cell = (FSCalendarCell *)[calendar cellForDate:date atMonthPosition:monthPosition];
    [self.dateArr addObject:dateStr];
    cell.imageView.hidden = NO;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    return YES;
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    NSString *dateStr = [self.dateFormatter stringFromDate:date];
    [self.dateArr removeObject:dateStr];
    FSCalendarCell *cell = (FSCalendarCell *)[calendar cellForDate:date atMonthPosition:monthPosition];
    cell.imageView.hidden = YES;
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    calendar.frame = (CGRect){calendar.frame.origin, bounds.size};
}

#pragma mark - <FSCalendarDataSource>

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    if ([self.dateArr containsObject:[self.dateFormatter stringFromDate:date]]) {
        cell.imageView.hidden = NO;
    } else {
        cell.imageView.hidden = YES;
    }
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar {
    return [self minimumDate];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar {
    return [self maximumDate];
}

- (UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date {
    return [UIImage imageNamed:@"icon_footprint"];
}

#pragma mark - help

- (void)getCurrentMonth {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger year = [dateComponent year];
    _year = year;
    NSInteger month = [dateComponent month];
    _month = month;
}

- (NSDate *)minimumDate {
    NSInteger year = _year;
    NSInteger month = _month;
    NSString *minimumDate = [NSString stringWithFormat:@"%@/%@/01", @(year), @(month)];
    return [self.dateFormatter dateFromString:minimumDate];
}

- (NSDate *)maximumDate {
    NSInteger year = _year;
    NSInteger month = _month;
    if (month + 2 > 12) {
        month = month + 2 - 12;
        year = year + 1;
    }
    NSString *tempDateStr = [NSString stringWithFormat:@"%@/%@/01", @(year), @(month)];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSRange days = [calender rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[self.dateFormatter dateFromString:tempDateStr]];
    NSString *maximumDate = [NSString stringWithFormat:@"%@/%@/%@", @(year), @(month), @(days.length)];
    return [self.dateFormatter dateFromString:maximumDate];
}

#pragma mark - dealloc

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

@end
