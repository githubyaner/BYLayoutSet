//
//  BYTreeTableViewController.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/19.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYTreeTableViewController.h"

@interface BYTreeTableViewController ()

@end

@implementation BYTreeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:239.0f / 255.0f green:239.0f / 255.0f blue:244.0f / 255.0f alpha:1];
//    self.treeView = [[MTreeView alloc] initWithFrame:self.view.bounds style:self.isGrouped ? UITableViewStyleGrouped : UITableViewStylePlain];
    self.treeView = [[MTreeView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _treeView.delegate = self;
    _treeView.dataSource = self;
    _treeView.treeViewDelegate = self;
    [self.view addSubview:_treeView];
    self.treeView.backgroundColor = [UIColor clearColor];
    [self doConfigTreeView];
    [self.treeView reloadData];
}

- (void)doConfigTreeView {
    
}


#pragma mark - tableview delegate & datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_treeView numberOfSectionsInTreeView:_treeView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_treeView treeView:_treeView numberOfRowsInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_treeView expandNodeAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MTreeView delegate
- (void) treeView:(MTreeView *)treeView willexpandNodeAtIndexPath:(NSIndexPath *)indexPath {
}

- (void) treeView:(MTreeView *)treeView didexpandNodeAtIndexPath:(NSIndexPath *)indexPath {
}

@end
