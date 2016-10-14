//
//  BYExpandVC.m
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/10/13.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYExpandVC.h"
#import "BYExpandCell.h"

@interface BYExpandVC () <BYExpandCellDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation BYExpandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"cell展开视图";
    UIBarButtonItem *goBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_down"]  style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItems = @[goBackBtn];
    
    self.dataSource = [NSMutableArray array];
    
    for (int i = 0; i < 2; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int j = 0; j < 5; j++) {
            BYExpandModel *model = [[BYExpandModel alloc] init];
            model.height = 70;
            model.isExpand = NO;
            [arr addObject:model];
        }
        [self.dataSource addObject:arr];
    }
    [self.tableView reloadData];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    BYExpandCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[BYExpandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indexPath = indexPath;
    if (0 != self.dataSource.count) {
        cell.model = self.dataSource[indexPath.section][indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYExpandModel *model = self.dataSource[indexPath.section][indexPath.row];
    return model.height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - BYExpandCellDelegate

- (void)byExpandCellDidExpand:(BYExpandCell *)cell {
    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView reloadData];
    }];
}

@end
