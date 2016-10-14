//
//  BYGuevaraTransition.m
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/10/12.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYGuevaraTransition.h"
#import "UIViewController+BYGuevaraTransitionExtension.h"

#define BYWEBVIEW_WIDTH ([[UIScreen mainScreen] bounds].size.width > [[UIScreen mainScreen] bounds].size.height ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)//屏幕宽度
#define BYWEBVIEW_HEIGHT ([[UIScreen mainScreen] bounds].size.height > [[UIScreen mainScreen] bounds].size.width ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)//屏幕高度
#define Duration 1.5f

@interface BYGuevaraTransition()
@property (assign, nonatomic) BYGuevaraTransitionType type;
@end

@implementation BYGuevaraTransition

- (instancetype)initWithTransitionType:(BYGuevaraTransitionType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

//返回动画时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //为了将两种动画的逻辑分开，变得更加清晰，我们分开书写逻辑，
    switch (_type) {
        case BYGuevaraTransitionPush:
            [self pushAnimation:transitionContext];
            break;
            
        case BYGuevaraTransitionPop:
            [self popAnimation:transitionContext];
            break;
    }
}


- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //起始位置
    CGRect originFrame = [fromVC.sf_targetView convertRect:fromVC.sf_targetView.bounds toView:fromVC.view];
    //动画移动的视图镜像
    UIView *customView = [self customSnapshoFromView:fromVC.sf_targetView];
    customView.frame = originFrame;
    
    //移动的目标位置
    CGRect finishFrame = [toVC.sf_targetView convertRect:toVC.sf_targetView.bounds toView:toVC.view];
    
    //获取背景视图
    UIView *containView = [transitionContext containerView];
    
    //背景视图 灰色高度
    CGFloat height = CGRectGetMidY(finishFrame);
    toVC.sf_targetHeight = height;
    
    //背景视图 灰色
    UIView *backgray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYWEBVIEW_WIDTH, BYWEBVIEW_HEIGHT)];
    backgray.backgroundColor = [UIColor lightGrayColor];
    //背景视图  白色
    UIView *backwhite = [[UIView alloc] initWithFrame:CGRectMake(0, height, BYWEBVIEW_HEIGHT, BYWEBVIEW_HEIGHT - height)];
    backwhite.backgroundColor = [UIColor whiteColor];
    
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    [containView addSubview:toVC.view];
    [containView addSubview:backgray];
    [backgray addSubview:backwhite];
    [containView addSubview:customView];
    
    //动画
    [UIView animateWithDuration:Duration / 3 animations:^{
        //改变位置
        customView.frame = finishFrame;
        //设置放大效果
        customView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:Duration / 3 animations:^{
                //改为原来大小
                customView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (finished) {
                    //移除视图
                    [UIView animateWithDuration:Duration / 3 animations:^{
                        customView.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [backgray removeFromSuperview];
                            [customView removeFromSuperview];
                            //设置转场状态
                            [transitionContext completeTransition:YES];
                        }
                    }];
                    //圆形展开图
                    [self addPathAnimateWithView:backgray fromPoint:customView.center];
                }
            }];
        }
    }];
}

- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //起始位置
    CGRect originFrame = [fromVC.sf_targetView convertRect:fromVC.sf_targetView.bounds toView:fromVC.view];
    
    //动画移动的视图镜像
    UIView *customView = [self customSnapshoFromView:fromVC.sf_targetView];
    customView.frame = originFrame;
    
    //移动的目标位置
    CGRect finishFrame = [toVC.sf_targetView convertRect:toVC.sf_targetView.bounds toView:toVC.view];
    
    //获取背景视图
    UIView *containView = [transitionContext containerView];
    
    //背景视图 灰色
    UIView *backgray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYWEBVIEW_WIDTH, BYWEBVIEW_HEIGHT)];
    backgray.backgroundColor = [UIColor lightGrayColor];
    //背景视图 白色
    UIView *backwhite = [[UIView alloc] initWithFrame:CGRectMake(0, fromVC.sf_targetHeight, BYWEBVIEW_WIDTH, BYWEBVIEW_HEIGHT - fromVC.sf_targetHeight)];
    backwhite.backgroundColor = [UIColor whiteColor];
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    [containView addSubview:toVC.view];
    [containView addSubview:fromVC.view];
    [containView addSubview:backgray];
    [backgray addSubview:backwhite];
    [containView addSubview:customView];
    
    //圆形回缩图
    [self addPathAnimateWithView:backgray fromPoint:customView.center];
    
    [UIView animateWithDuration:Duration / 3 delay:Duration / 3 options:UIViewAnimationOptionTransitionNone animations:^{
        //改变位置
        customView.frame = finishFrame;
        //设置放大效果
        customView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        if (finished) {
            [fromVC.view removeFromSuperview];
            [UIView animateWithDuration:Duration / 3 animations:^{
                backgray.alpha = 0.0;
                //改为原来大小
                customView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (finished) {
                    //移除视图
                    [backgray removeFromSuperview];
                    [customView removeFromSuperview];
                    //设置转场状态
                    [transitionContext completeTransition:YES];
                }
            }];
        }
    }];
}

#pragma mark - other animate

//加入收合动画 -- 圆形展开&回缩
- (void)addPathAnimateWithView:(UIView *)toView fromPoint:(CGPoint)point{
    //create path
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, BYWEBVIEW_WIDTH, BYWEBVIEW_HEIGHT)];
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:point radius:0.1 startAngle:0 endAngle:2 * M_PI clockwise:NO]];
    
    //create path 2
    CGFloat radius = point.y > 0 ? BYWEBVIEW_HEIGHT * 3 /4: BYWEBVIEW_HEIGHT * 3 / 4 - point.y;
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, BYWEBVIEW_WIDTH, BYWEBVIEW_HEIGHT)];
    [path2 appendPath:[UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:0 endAngle:2 * M_PI clockwise:NO]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //shapeLayer.path = path.CGPath;
    toView.layer.mask = shapeLayer;
    
    //判断是push还是pop并且设置相应的路径
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = _type == BYGuevaraTransitionPush ? (__bridge id)path.CGPath : (__bridge id)path2.CGPath;
    pathAnimation.toValue   = _type == BYGuevaraTransitionPush ? (__bridge id)path2.CGPath : (__bridge id)path.CGPath;
    pathAnimation.duration  = Duration / 3;
    pathAnimation.repeatCount = 1;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [shapeLayer addAnimation:pathAnimation forKey:@"pathAnimate"];
}

//产生targetView镜像
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    //通过传入的图像大小生成一个不透明的镜像 -- 获取图形上下文
    //opaque：NO 不透明
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    //渲染自己 -- 设置图形上下文
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //通过图形上下文获取一个image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文 -- 释放内存
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}


@end
