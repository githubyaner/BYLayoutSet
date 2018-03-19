//
//  BYCalendarCell.h
//  BYLayoutSet
//
//  Created by SunShine.Rock on 2016/11/21.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "FSCalendarCell.h"

@interface BYCalendarCell : FSCalendarCell
@property (nonatomic, weak) UIImageView *selectionImageView;
@property (nonatomic, weak) CAShapeLayer *selectionLayer;
@property (nonatomic, assign) BOOL select;
@end
