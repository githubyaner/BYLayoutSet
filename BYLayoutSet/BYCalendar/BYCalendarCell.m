//
//  BYCalendarCell.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 2016/11/21.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYCalendarCell.h"

@implementation BYCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *selectionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_footprint"]];
        [self.contentView insertSubview:selectionImageView atIndex:0];
        self.selectionImageView = selectionImageView;
        _selectionImageView.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.selectionImageView.frame = CGRectMake((self.frame.size.width - 10) / 2, self.frame.size.height - 10, 10, 10);
}

- (void)setSelect:(BOOL)select {
    _select = select;
    if (_select) {
        _selectionImageView.hidden = NO;
    } else {
        _selectionImageView.hidden = YES;
    }
}

@end
