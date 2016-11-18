//
//  BYMemorandumCell.h
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/24.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYMemorandumModel.h"
@class BYMemorandumCell;

@protocol BYMemorandumCellDelegate <NSObject>
- (void)cellDidClickInfo:(BYMemorandumCell *)cell;
@end

@interface BYMemorandumCell : UITableViewCell
@property (nonatomic, strong) BYMemorandumModel *model;

@property (nonatomic, assign) id <BYMemorandumCellDelegate> delegate;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UILabel *textL;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UILabel *clookL;
@property (nonatomic, strong) UIButton *infoBtn;
@property (nonatomic, strong) UIView *lineView;
@end
