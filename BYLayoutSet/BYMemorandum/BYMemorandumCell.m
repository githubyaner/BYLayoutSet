//
//  BYMemorandumCell.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/24.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYMemorandumCell.h"
#define CellFont(s) [UIFont fontWithName:@"STHeitiSC-Light" size:s]

#define CELL_WIDTH [UIScreen mainScreen].bounds.size.width / 6 * 5

@implementation BYMemorandumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, self.frame.size.height)];
        _contentV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_contentV];
        
        self.textL = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, CELL_WIDTH - 10 - 35, 25)];
        _textL.font = CellFont(18);
        _textL.textColor = [UIColor blackColor];
        [self.contentV addSubview:_textL];
        
        self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, CELL_WIDTH - 10 - 35, 0)];
        _noteLabel.textColor = [UIColor lightGrayColor];
        _noteLabel.font = CellFont(15);
        _noteLabel.numberOfLines = 0;
        [self.contentV addSubview:_noteLabel];
        _noteLabel.hidden = YES;
        
        self.clookL = [[UILabel alloc] initWithFrame:CGRectMake(5, _noteLabel.frame.size.height + 35 + 5, CELL_WIDTH - 10 - 35, 20)];
        _clookL.textColor = [UIColor lightGrayColor];
        _clookL.font = CellFont(15);
        [self.contentV addSubview:_clookL];
        _clookL.hidden = YES;
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, self.contentV.frame.size.height)];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        _lineView.alpha = 0.35;
        [self.contentV addSubview:_lineView];
        _lineView.hidden = YES;
        
        self.infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
        _infoBtn.frame = CGRectMake(CELL_WIDTH - 35, (self.frame.size.height - 30) / 2, 30, 30);
        [_infoBtn addTarget:self action:@selector(myInfo) forControlEvents:UIControlEventTouchUpInside];
        [self.contentV addSubview:_infoBtn];
    }
    return self;
}

- (void)setModel:(BYMemorandumModel *)model {
    _model = model;
    //title
    _textL.text = model.titleText;
    if (!model.isNote && !model.isClook) {
        _textL.frame = CGRectMake(5, 5, CELL_WIDTH - 10 - 35, 35);
    } else {
        _textL.frame = CGRectMake(5, 5, CELL_WIDTH - 10 - 35, 25);
    }
    //note
    if (model.isNote) {
        _noteLabel.hidden = NO;
        _noteLabel.frame = CGRectMake(5, 35, CELL_WIDTH - 10 - 35, model.textHeight);
//        _noteLabel.text = model.noteText;
        [BYMemorandumModel conversionCharacterText:model.noteText withLabel:_noteLabel];
    } else {
        _noteLabel.hidden = YES;
    }
    //clook
    if (model.isClook) {
        _clookL.hidden = NO;
        if (model.isNote) {
            _clookL.frame = CGRectMake(5, 35 + model.textHeight + 5, CELL_WIDTH - 10 - 35, 20);
        } else {
            _clookL.frame = CGRectMake(5, 35 + model.textHeight, CELL_WIDTH - 10 - 35, 20);
        }
        if (model.isRemind) {
            _clookL.text = [NSString stringWithFormat:@"%@(%@)", model.clookDate, model.loopType];
        } else {
            _clookL.text = model.clookDate;
        }
        NSString *nowDateStr = [BYMemorandumModel dateStrFromDate:[NSDate date]];
        NSDate *nowDate = [BYMemorandumModel dateFromDateStr:nowDateStr];
        NSDate *clookDate = [BYMemorandumModel dateFromDateStr:model.clookDate];
        NSComparisonResult result = [nowDate compare:clookDate];
        if (result == NSOrderedSame || result == NSOrderedDescending) {
            _clookL.textColor = [UIColor redColor];
        } else {
            _clookL.textColor = [UIColor lightGrayColor];
        }
    } else {
        _clookL.hidden = YES;
    }
    self.contentV.frame = CGRectMake(0, 0, CELL_WIDTH, model.height);
    if (model.isFinish) {
        _lineView.hidden = NO;
        self.lineView.frame = CGRectMake(0, 0, CELL_WIDTH, model.height);
    } else {
        _lineView.hidden = YES;
    }
    _infoBtn.frame = CGRectMake(CELL_WIDTH - 35, (model.height - 30) / 2, 30, 30);
    
}

#pragma mark - action
- (void)myInfo {
    if ([self.delegate respondsToSelector:@selector(cellDidClickInfo:)]) {
        [self.delegate cellDidClickInfo:self];
    }
}

#pragma mark - help
//判断字符串是否为空
- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
