//
//  BYExpandCell.m
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/10/13.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYExpandCell.h"

#define BYWEBVIEW_WIDTH ([[UIScreen mainScreen] bounds].size.width > [[UIScreen mainScreen] bounds].size.height ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)//屏幕宽度
#define BYWEBVIEW_HEIGHT ([[UIScreen mainScreen] bounds].size.height > [[UIScreen mainScreen] bounds].size.width ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)//屏幕高度

@implementation BYExpandModel

@end

@implementation BYExpandUpView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BYWEBVIEW_WIDTH - 60, frame.size.height)];
        _titleL.text = @"点我展开";
        [self addSubview:_titleL];
        self.arrowBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _arrowBtn.frame = CGRectMake(BYWEBVIEW_WIDTH - 60, 0, 60, frame.size.height);
        [_arrowBtn setTitle:@"↓" forState:UIControlStateNormal];
        [self addSubview:_arrowBtn];
        _arrowBtn.enabled = NO;
    }
    return self;
}

- (void)setWithModel:(BYExpandModel *)model {
    NSLog(@"upview赋值");
}

@end


@implementation BYExpandView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BYWEBVIEW_WIDTH, frame.size.height)];
        _contentL.backgroundColor = [UIColor brownColor];
        _contentL.text = @"我是详情";
        [self addSubview:_contentL];
    }
    return self;
}

- (void)setWithModel:(BYExpandModel *)model {
    NSLog(@"view赋值");
}

@end

@implementation BYExpandCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.expandUpView = [[BYExpandUpView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 70)];
        [self.contentView addSubview:_expandUpView];
        _expandUpView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleExpand)];
        [_expandUpView addGestureRecognizer:tap];
        
        self.expandView = [[BYExpandView alloc] initWithFrame:CGRectMake(0, 70, BYWEBVIEW_WIDTH, 200)];
        [self.contentView addSubview:_expandView];
        _expandView.hidden = YES;
    }
    return self;
}

- (void)setModel:(BYExpandModel *)model {
    _model = model;
    [self.expandUpView setWithModel:model];
    [self.expandView setWithModel:model];
    
    //防止复用
    if (self.model.isExpand) {
        self.expandView.hidden = NO;
        [_expandUpView.arrowBtn setTitle:@"↑" forState:UIControlStateNormal];
    } else {
        [_expandUpView.arrowBtn setTitle:@"↓" forState:UIControlStateNormal];
        self.expandView.hidden = YES;
    }
}

- (void)handleExpand {
    self.model.isExpand = !self.model.isExpand;
    if (self.model.isExpand) {
        //展开
        [_expandUpView.arrowBtn setTitle:@"↑" forState:UIControlStateNormal];
        self.expandView.hidden = NO;
        self.model.height = 70 + 200;
    } else {
        //关闭
        [_expandUpView.arrowBtn setTitle:@"↓" forState:UIControlStateNormal];
        self.expandView.hidden = YES;
        self.model.height = 70;
    }
    if ([self.delegate respondsToSelector:@selector(byExpandCellDidExpand:)]) {
        [self.delegate byExpandCellDidExpand:self];
    }
}

@end
