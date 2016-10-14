//
//  UIViewController+BYGuevaraTransitionExtension.m
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/10/12.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "UIViewController+BYGuevaraTransitionExtension.h"
#import <objc/runtime.h>

@implementation UIViewController (BYGuevaraTransitionExtension)
/*
 *  set 与 get 方法
 *  在分类中创建属性,不会自动生成set和get方法,需要在运行时动态添加
 */

- (CGFloat)sf_targetHeight {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSf_targetHeight:(CGFloat)sf_targetHeight {
    objc_setAssociatedObject(self, @selector(sf_targetHeight), @(sf_targetHeight), OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)sf_targetView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSf_targetView:(UIView *)sf_targetView {
    objc_setAssociatedObject(self, @selector(sf_targetView), sf_targetView, OBJC_ASSOCIATION_RETAIN);
}

@end
