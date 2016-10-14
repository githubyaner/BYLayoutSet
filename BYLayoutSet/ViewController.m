//
//  ViewController.m
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/9/18.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "ViewController.h"
#import "BYScrollTableView.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import "BYWebViewController.h"
#import "BYRefreshTopViewVC.h"
#import "BYGuevaraVC.h"
#import "BYAlarmClockPushLocal.h"
#import "BYDocumentListVC.h"
#import "BYExpandVC.h"
#import "BYScrollTableViewVC.h"

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) NSArray *vcs;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    self.vcs = @[@"带进度条浏览器+今日头条详情", @"淘宝效果", @"格拉瓦电影转场效果", @"Timer+闹钟+定时推送", @"文档阅读器", @"cell展开视图", @"左右tableview"];
    
    for (int i = 0; i < _vcs.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2, 100 + i * 60, 300, 50);
        [btn addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:_vcs[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        btn.titleLabel.numberOfLines = 0;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.layer.cornerRadius = 5;
        btn.layer.borderColor = [UIColor brownColor].CGColor;
        btn.layer.borderWidth = 2;
        btn.layer.masksToBounds = YES;
        [self.scrollView addSubview:btn];
    }
    
    [self.scrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 100 + self.vcs.count * 60 + 100)];
}

- (void)handleAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:_vcs[0]]) {
        [self push];
    } else if ([sender.titleLabel.text isEqualToString:_vcs[1]]) {
        [self taobao];
    } else if ([sender.titleLabel.text isEqualToString:_vcs[2]]) {
        [self guevara];
    } else if ([sender.titleLabel.text isEqualToString:_vcs[3]]) {
        [self alarmCloclkAndPushLocal];
    } else if ([sender.titleLabel.text isEqualToString:_vcs[4]]) {
        [self dcocumentRead];
    } else if ([sender.titleLabel.text isEqualToString:_vcs[5]]) {
        [self cellExpand];
    } else if ([sender.titleLabel.text isEqualToString:_vcs[6]]) {
        [self tableviewToTableView];
    }
}

- (void)push {
    BYWebViewController *vc = [[BYWebViewController alloc] initWithUrl:@"http://v.huya.com/lol/" BYVCTYPE:BYVCTYPE_DISMISS];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}
- (void)taobao {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
