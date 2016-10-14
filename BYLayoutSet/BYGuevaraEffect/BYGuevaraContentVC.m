//
//  BYGuevaraContentVC.m
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/10/12.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYGuevaraContentVC.h"
#import "BYGuevaraTransition.h"
#import "UIViewController+BYGuevaraTransitionExtension.h"
#import "UIImageView+WebCache.h"

@interface BYGuevaraContentVC () <UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BYGuevaraTransition *animate;
@end

@implementation BYGuevaraContentVC

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"影片详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutSubViews];
    
    self.animate = [[BYGuevaraTransition alloc] initWithTransitionType:BYGuevaraTransitionPop];
}

- (void)layoutSubViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2-64)];
    back.contentMode = UIViewContentModeScaleToFill;
    back.backgroundColor = [UIColor lightGrayColor];
    [back sd_setImageWithURL:[NSURL URLWithString:@"http://www.fwjia.com/thumb/d/file/2013-08-08/ffcecd940e0eb53a6f94b8e4f6d4c545__450.jpg"]];
    UIView *image = [[UIView alloc] initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height / 2 - 64 - 70, [UIScreen mainScreen].bounds.size.width / 3 - 20, ([UIScreen mainScreen].bounds.size.width / 3 - 20) * 1.3)];
    image.backgroundColor = self.iconColor;
    self.sf_targetView = image;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 250)];
    headView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:back];
    [headView addSubview:image];
    self.tableView.tableHeaderView = headView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navigationcontroller delegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0) {
    if (operation == UINavigationControllerOperationPop) {
        return self.animate;
    } else {
        return nil;
    }
}


#pragma mark -- tableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"评论:%ld", indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
