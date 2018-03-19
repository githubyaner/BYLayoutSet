//
//  ViewController.m
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/9/18.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "ViewController.h"

#import "BYWebViewController.h"
#import "BYRefreshTopViewVC.h"
#import "BYGuevaraVC.h"
#import "BYAlarmClockPushLocal.h"
#import "BYDocumentListVC.h"
#import "BYExpandVC.h"
#import "BYScrollTableViewVC.h"
#import "BYFormListVC.h"
#import "BYTreeTableViewListVC.h"
#import "BYMemorandumVC.h"
#import "BYScanCodeVC.h"
#import "BYCalendarVC.h"
#import "BYBluetoothVC.h"
#import "BYGuideListVC.h"


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *vcs;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.vcs = @[@[@"备忘录"], @[@"带进度条浏览器+今日头条详情", @"淘宝效果", @"格拉瓦电影转场效果", @"Timer+闹钟+定时推送", @"文档阅读器", @"左右tableview", @"cell展开视图", @"二维码扫描"], @[@"表单", @"TreeTableView", @"日历", @"蓝牙", @"界面指引"]];
}
+ (BOOL)isBetweenTheStartTime:(NSString *)startTime endTime:(NSString *)endTime andCurrentTime:(NSString *)currentTime {
    if (startTime == nil || endTime == nil) {
        return NO;
    }
    NSInteger isTime1 = [startTime compare:currentTime];
    NSInteger isTime2 = [endTime compare:currentTime];
    //1为前者大于后者,-1为前者小于后者
    if (isTime1 == -1 && isTime2 == 1) {
        return YES;
    } else if (isTime1 == 0 && isTime2 == 1) {
        return YES;
    } else if (isTime1 == 0 && isTime2 == 0) {
        return YES;
    } else if (isTime1 == -1 && isTime2 == 0) {
        return YES;
    }
    //判断点击的时间与开始时间和结束时间相同的情况.三者都是同一天.
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate & datasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return @"Memorandum";
    } else if (1 == section) {
        return @"BYLayoutSet";
    } else {
        return @"Other Source";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 80;
    } else {
        return 40;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.vcs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.vcs[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.vcs[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (0 == indexPath.section) {
        [self memorandum];
    } else if (1 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
                [self webVC];
                break;
            case 1:
                [self taoBao];
                break;
            case 2:
                [self guevara];
                break;
            case 3:
                [self alarmCloclkAndPushLocal];
                break;
            case 4:
                [self dcocumentRead];
                break;
            case 5:
                [self tableviewToTableView];
                break;
            case 6:
                [self cellExpand];
                break;
            case 7:
                [self scanCode];
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                [self formView];
                break;
            case 1:
                [self treeTableView];
                break;
            case 2:
                [self calendar];
                break;
            case 3:
                [self bluetooth];
                break;
            case 4:
                [self guideView];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - cell action

- (void)memorandum {
    BYMemorandumVC *vc = [[BYMemorandumVC alloc] init];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}

- (void)webVC {
    BYWebViewController *vc = [[BYWebViewController alloc] initWithUrl:@"http://v.huya.com/lol/" BYVCTYPE:BYVCTYPE_DISMISS];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}
- (void)taoBao {
    BYRefreshTopViewVC *vc = [[BYRefreshTopViewVC alloc] init];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}
- (void)guevara {
    BYGuevaraVC *vc = [[BYGuevaraVC alloc] init];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}
- (void)alarmCloclkAndPushLocal {
    BYAlarmClockPushLocal *object = [[BYAlarmClockPushLocal alloc] init];
    NSLog(@"暂无信息, %@", object);
}

- (void)dcocumentRead {
    BYDocumentListVC *vc = [[BYDocumentListVC alloc] init];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}

- (void)cellExpand {
    BYExpandVC *vc = [[BYExpandVC alloc] init];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}
+ (NSString*)urlstring:(NSString*)strurl {
    NSURL *url = [NSURL URLWithString:strurl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
    //NSLog(@" html = %@",retStr);
     return retStr;
}
- (void)tableviewToTableView {
    BYScrollTableViewVC *vc = [[BYScrollTableViewVC alloc] init];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}

- (void)formView {
    BYFormListVC *vc = [[BYFormListVC alloc] init];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}

- (void)treeTableView {
    BYTreeTableViewListVC *vc = [[BYTreeTableViewListVC alloc] init];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}

- (void)scanCode {
    BYScanCodeVC *vc = [[BYScanCodeVC alloc] init];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}

- (void)calendar {
    BYCalendarVC *vc = [[BYCalendarVC alloc] init];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}

- (void)bluetooth {
    BYBluetoothVC *vc = [[BYBluetoothVC alloc] init];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}

- (void)guideView {
    BYGuideListVC *vc = [[BYGuideListVC alloc] init];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}

@end
