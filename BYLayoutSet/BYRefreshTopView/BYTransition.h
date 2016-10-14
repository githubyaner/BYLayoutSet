//
//  BYTransition.h
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/10/11.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BYTransitionType) {
    BYTransitionTypePresent = 0,//管理present动画
    BYTransitionTypeDismiss//管理dismiss动画
};

@interface BYTransition : NSObject <UIViewControllerAnimatedTransitioning>
//根据定义的枚举初始化的两个方法
+ (instancetype)transitionWithTransitionType:(BYTransitionType)type;
- (instancetype)initWithTransitionType:(BYTransitionType)type;
@end
