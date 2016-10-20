//
//  BYTreeTableViewController.h
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/19.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTreeView.h"

@interface BYTreeTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MTreeViewDelegate>
@property (nonatomic, strong) MTreeView *treeView;
@property (nonatomic) BOOL isGrouped; //default NO
/**
 *  钩子函数，子类对TreeView进行配置
 */
- (void)doConfigTreeView;
@end
