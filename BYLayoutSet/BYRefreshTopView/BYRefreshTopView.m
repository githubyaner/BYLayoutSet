//
//  BYRefreshTopView.m
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/9/30.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYRefreshTopView.h"
#import "UIImageView+WebCache.h"

#define ImageHeight self.frame.size.height

@implementation BYRefreshTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, ImageHeight)];
        _topImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_topImageView];
    }
    return self;
}

- (void)topImageViewSetImageWithUrl:(NSString *)url {
    /* 
     //我自己写的子线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        [self.topImageView setImage:image];
    });
     */
    
    //SDWebImage
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}

@end
