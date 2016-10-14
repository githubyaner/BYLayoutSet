//
//  BYRefreshTopView.h
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/9/30.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYRefreshTopView : UIView
@property (nonatomic, strong) UIImageView *topImageView;
- (void)topImageViewSetImageWithUrl:(NSString *)url;
@end
