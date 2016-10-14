//
//  UIViewController+BYGuevaraTransitionExtension.h
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/10/12.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIViewController (BYGuevaraTransitionExtension)
@property (nonatomic, assign) CGFloat sf_targetHeight;
@property (nonatomic, weak) UIView *sf_targetView;
@end
