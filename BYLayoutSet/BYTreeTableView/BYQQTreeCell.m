//
//  BYQQTreeCell.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/19.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYQQTreeCell.h"

#define CELL_WIDTH [UIScreen mainScreen].bounds.size.width
#define CELL_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation BYQQTreeCell

- (UIImageView *)icon {
    if (!_icon) {
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        _icon.layer.cornerRadius = _icon.frame.size.height / 2;
        _icon.layer.masksToBounds = YES;
        _icon.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_icon];
    }
    return _icon;
}

- (UILabel *)nameL {
    if (!_nameL) {
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, CELL_WIDTH - 110, 25)];
        _nameL.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_nameL];
    }
    return _nameL;
}

- (UILabel *)detailL {
    if (!_detailL) {
        self.detailL = [[UILabel alloc] initWithFrame:CGRectMake(65, 30, CELL_WIDTH - 110, 25)];
        _detailL.font = [UIFont systemFontOfSize:14];
        _detailL.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_detailL];
    }
    return _detailL;
}

- (UILabel *)statusL {
    if (!_statusL) {
        self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(CELL_WIDTH - 45, 10, 40, 40)];
        _statusL.font = [UIFont systemFontOfSize:14];
        _statusL.textColor = [UIColor lightGrayColor];
        _statusL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_statusL];
    }
    return _statusL;
}

@end
