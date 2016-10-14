//
//  BYScrollTableView.h
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/9/27.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BYScrollTableViewDelegate <NSObject>
- (void)byScrollTableViewDidback;
- (void)byScrollTableViewDidSelectCell:(UITableViewCell *)cell;
@end

@interface BYScrollTableViewLeft : UIView
@property (nonatomic, strong) UITableView *tableView;
@end

@interface BYScrollTableViewRight : UIView
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UITableView *tableView;
@end

@interface BYScrollTableView : UIView
@property (nonatomic, assign) id <BYScrollTableViewDelegate> delegate;
@property (nonatomic, strong) BYScrollTableViewLeft *leftView;
@property (nonatomic, strong) BYScrollTableViewRight *rightView;
- (void)refreshTheData:(NSMutableArray *)data;
@end
