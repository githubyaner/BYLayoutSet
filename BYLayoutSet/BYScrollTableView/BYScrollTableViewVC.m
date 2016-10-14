//
//  BYScrollTableViewVC.m
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/10/13.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYScrollTableViewVC.h"
#import "BYScrollTableView.h"

@interface BYScrollTableViewVC () <BYScrollTableViewDelegate>
@property (nonatomic, strong) BYScrollTableView *scrollTableView;
@end

@implementation BYScrollTableViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"左右tableview";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *goBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_down"]  style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItems = @[goBackBtn];
    
    //先创建,请求数据->赋值   点击->请求数据->赋值
    self.scrollTableView = [[BYScrollTableView alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, [UIScreen mainScreen].bounds.size.height - 130)];
    _scrollTableView.delegate = self;
    [self.view addSubview:_scrollTableView];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - BYScrollTableViewDelegate

- (void)byScrollTableViewDidback {
    NSLog(@"返回了");
}

- (void)byScrollTableViewDidSelectCell:(UITableViewCell *)cell {
    NSLog(@"点击的是:%@", cell.textLabel.text);
    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]];
    [_scrollTableView refreshTheData:arr];
}


@end
