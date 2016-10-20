//
//  BYMultistageVC.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/19.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYMultistageVC.h"

@interface BYMultistageVC ()

@end

@implementation BYMultistageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"多级展开";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - BYTreeTableViewController

- (void)doConfigTreeView {
    [super doConfigTreeView];
    self.treeView.rootNode = [MTreeNode initWithParent:nil expand:NO];
    for (int i = 0; i < 3; i++) {
        MTreeNode *node = [MTreeNode initWithParent:self.treeView.rootNode expand:(0 == i)];
        for (int j = 0; j < 4; j++) {
            MTreeNode *subnode = [MTreeNode initWithParent:node expand:NO];
            [node.subNodes addObject:subnode];
            if (0 == j || 2 == j) {//在第一个cell和第三个cell添加子cell
                for (int k = 0; k < 5; k++) {
                    MTreeNode *subnode1 = [MTreeNode initWithParent:subnode expand:NO];
                    [subnode.subNodes addObject:subnode1];
                }
                subnode.expand = YES;
            }
        }
        [self.treeView.rootNode.subNodes addObject:node];
    }
}

#pragma mark - tableview delegate & datasource


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

//为header设置手势
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MTreeNode *subNode = [[self.treeView.rootNode subNodes] objectAtIndex:section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 40)];
    label.tag = 1000 + section;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTaped:)];
    [label addGestureRecognizer:recognizer];
    label.userInteractionEnabled = YES;
    label.text = [NSString stringWithFormat:@"it's headerView, depth = %@", @(subNode.depth)];
    label.backgroundColor = [UIColor whiteColor];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MTreeNode *subNode = [self.treeView nodeAtIndexPath:indexPath];
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.separatorInset = UIEdgeInsetsMake(0, subNode.depth * 20.0f, 0, 0);
    cell.textLabel.text = [NSString stringWithFormat:@"it'scell %@, depth = %@", @(indexPath.row), @(subNode.depth)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.treeView expandNodeAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MTreeView delegate

- (void)treeView:(MTreeView *)treeView willexpandNodeAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willexpandNodeAtIndexPath = [%@, %@]", @(indexPath.section), @(indexPath.row));
}

- (void)treeView:(MTreeView *)treeView didexpandNodeAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didexpandNodeAtIndexPath = [%@, %@]", @(indexPath.section), @(indexPath.row));
}


#pragma mark - Action

- (void)sectionTaped:(UIGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    NSUInteger tag = view.tag - 1000;
    [self.treeView expandNodeAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:tag]];
}


@end
