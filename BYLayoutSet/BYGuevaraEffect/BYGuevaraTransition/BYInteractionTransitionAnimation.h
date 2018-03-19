//
//  BYInteractionTransitionAnimation.h
//  BYLayoutSet
//
//  Created by SunShine.Rock on 2018/3/19.
//  Copyright © 2018年 Berton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYInteractionTransitionAnimation : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL isActive;//是否正在进行
- (void)writeToViewController:(UIViewController *)toVC;//写入二级VC
@end
