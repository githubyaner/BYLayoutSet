//
//  BYInteractionTransitionAnimation.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 2018/3/19.
//  Copyright © 2018年 Berton. All rights reserved.
//

#import "BYInteractionTransitionAnimation.h"

@interface BYInteractionTransitionAnimation ()
@property (nonatomic, assign) BOOL canReceive;
@property (nonatomic, strong) UIViewController *remVC;
@end

@implementation BYInteractionTransitionAnimation

- (void)writeToViewController:(UIViewController *)toVC {
    self.remVC = toVC;
    [self addPanGestureRecognizer:toVC];
}

- (void)addPanGestureRecognizer:(UIViewController *)toVC {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognizer:)];
    [toVC.view addGestureRecognizer:pan];
}

- (void)panRecognizer:(UIPanGestureRecognizer *)pan {
    CGPoint panPoint = [pan translationInView:pan.view.superview];
    CGPoint locationPoint = [pan locationInView:pan.view.superview];
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.isActive = YES;
        if (locationPoint.y <= self.remVC.view.bounds.size.height / 2.0) {
            [self.remVC.navigationController popViewControllerAnimated:YES];
        }
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        if (locationPoint.y >= self.remVC.view.bounds.size.height / 2.0) {
            self.canReceive = YES;
        } else {
            self.canReceive = NO;
        }
        [self updateInteractiveTransition:panPoint.y / self.remVC.view.bounds.size.height];
    } else if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded) {
        self.isActive = NO;
        if (!self.canReceive || pan.state == UIGestureRecognizerStateCancelled) {
            [self cancelInteractiveTransition];
        } else {
            [self finishInteractiveTransition];
        }
    }
}

@end
