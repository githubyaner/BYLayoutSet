//
//  BYContentVC.m
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/10/11.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYContentVC.h"
#import "BYTransition.h"
#import "UIImageView+WebCache.h"

@interface BYContentVC () <UIViewControllerTransitioningDelegate>

@end

@implementation BYContentVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.fwjia.com/thumb/d/file/2013-08-08/ffcecd940e0eb53a6f94b8e4f6d4c545__450.jpg"]];
    [self.view addSubview:imageView];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 30, 25, 25);
    [btn addTarget:self action:@selector(handleDismiss) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dismiss
- (void)handleDismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    //这里我们初始化presentType
    return [BYTransition transitionWithTransitionType:BYTransitionTypePresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    //这里我们初始化dismissType
    return [BYTransition transitionWithTransitionType:BYTransitionTypeDismiss];
}
@end
