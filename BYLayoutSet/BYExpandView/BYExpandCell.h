//
//  BYExpandCell.h
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/10/13.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYExpandCell;
@protocol BYExpandCellDelegate;

@interface BYExpandModel : NSObject
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, assign) CGFloat height;
@end

@interface BYExpandUpView : UIView
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIButton *arrowBtn;
@property (nonatomic, strong) BYExpandCell *cell;
- (void)setWithModel:(BYExpandModel *)model;
@end

@interface BYExpandView : UIView
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) BYExpandCell *cell;
- (void)setWithModel:(BYExpandModel *)model;
@end

@interface BYExpandCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) BYExpandView *expandView;
@property (nonatomic, strong) BYExpandUpView *expandUpView;
@property (nonatomic, strong) BYExpandModel *model;
@property (nonatomic, assign) id<BYExpandCellDelegate> delegate;
@end

@protocol BYExpandCellDelegate <NSObject>
- (void)byExpandCellDidExpand:(BYExpandCell *)cell;
@end
