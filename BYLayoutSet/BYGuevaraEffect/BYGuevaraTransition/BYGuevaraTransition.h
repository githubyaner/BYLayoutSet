//
//  BYGuevaraTransition.h
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/10/12.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BYGuevaraTransitionType) {
    BYGuevaraTransitionPush,
    BYGuevaraTransitionPop,
};

@interface BYGuevaraTransition : NSObject <UIViewControllerAnimatedTransitioning>
- (instancetype)initWithTransitionType:(BYGuevaraTransitionType)type;
@end
