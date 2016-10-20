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
    
    self.vcs = @[@[@"带进度条浏览器+今日头条详情", @"淘宝效果", @"格拉瓦电影转场效果", @"Timer+闹钟+定时推送", @"文档阅读器", @"左右tableview", @"cell展开视图"], @[@"表单", @"TreeTableView"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate & datasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (0 == section) {
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
                
            default:
                break;
        }
    }
}

#pragma mark - cell action

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

@end
