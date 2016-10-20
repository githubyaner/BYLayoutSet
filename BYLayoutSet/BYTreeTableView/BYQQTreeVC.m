//
//  BYQQTreeVC.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/19.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYQQTreeVC.h"
#import "BYQQTreeCell.h"

#define DegreesToRadians(degrees) (degrees * M_PI / 180)


@interface BYQQTreeVC ()

@end

@implementation BYQQTreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"QQ联系人";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - BYTreeTableViewController

- (void)doConfigTreeView {
    self.treeView.rowHeight = 60.0f;
    self.treeView.rootNode = [MTreeNode initWithParent:nil expand:NO];
    NSArray *sectionData = @[@{@"name":@"我的设备", @"data":@"2/2"},
                             @{@"name":@"手机通讯录", @"data":@"未权限"},
                             @{@"name":@"我的好友", @"data":@"21/42"},
                             @{@"name":@"宝马", @"data":@"12/22"},
                             @{@"name":@"奔驰", @"data":@"32/50"}];
    
    for (NSUInteger i = 0; i < [sectionData count]; i++) {
        MTreeNode *node = [MTreeNode initWithParent:self.treeView.rootNode expand:(2 == i)];
        for (int j = 0; j < 4; j++) {
            MTreeNode *subnode = [MTreeNode initWithParent:node expand:NO];
            subnode.content = @{@"name":@"Berton", @"image":@"User",@"detail":@"Everything is going on, but don't give up trying.", @"status":@"4G"};
            [node.subNodes addObject:subnode];
        }
        node.content = sectionData[i];
        [self.treeView.rootNode.subNodes addObject:node];
    }
}


#pragma mark - tableview delegate & datasource


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1 == section ? 20 : 0.00001f ;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 1 == section ? 20 : 0.00001f)];
    footerView.alpha = 0;
    return footerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MTreeNode *subNode = [[self.treeView.rootNode subNodes] objectAtIndex:section];
    NSDictionary *nodeData = subNode.content;
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 50)];
    {
        sectionView.tag = 1000 + section;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTaped:)];
        [sectionView addGestureRecognizer:recognizer];
        sectionView.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.5f;
        [sectionView addSubview:line];
    }
    {
        UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 20, 8, 10)];
        tipImageView.image = [UIImage imageNamed:@"tip"];
        tipImageView.tag = 10;
        [sectionView addSubview:tipImageView];
        [self doTipImageView:tipImageView expand:subNode.expand];
    }
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 200, 30)];
        label.font = [UIFont systemFontOfSize:17.0f];
        label.tag = 20;
        label.text = nodeData[@"name"];
        [sectionView addSubview:label];
    }
    {
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 100, 10, 90, 30)];
        numberLabel.font = [UIFont systemFontOfSize:12.0f];
        numberLabel.textColor = [UIColor lightGrayColor];
        numberLabel.textAlignment = NSTextAlignmentRight;
        numberLabel.tag = 30;
        numberLabel.text = nodeData[@"data"];
        [sectionView addSubview:numberLabel];
    }
    {
        if (1 == section || 4 == section) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, sectionView.frame.size.height - 0.33, sectionView.frame.size.width, 0.33)];
            lineView.backgroundColor = [UIColor colorWithRed:200 / 255.0 green:199 / 255.0 blue:204 / 255.0 alpha:1];
            lineView.tag = 40;
            [sectionView addSubview:lineView];
        }
    }
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MTreeNode *subNode = [self.treeView nodeAtIndexPath:indexPath];
    NSDictionary *nodeData = subNode.content;
    static NSString *cellID = @"cellID";
    BYQQTreeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[BYQQTreeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.separatorInset = UIEdgeInsetsMake(0, 65, 0, 0);
    }
    cell.nameL.text = nodeData[@"name"];
    cell.detailL.text = nodeData[@"detail"];
    cell.icon.image = [UIImage imageNamed:nodeData[@"image"]];
    cell.statusL.text = nodeData[@"status"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.treeView expandNodeAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action

- (void)doTipImageView:(UIImageView *)imageView expand:(BOOL)expand {
    [UIView animateWithDuration:0.2f animations:^{
        imageView.transform = (expand) ? CGAffineTransformMakeRotation(DegreesToRadians(90)) : CGAffineTransformIdentity;
    }];
}

- (void)sectionTaped:(UIGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    NSUInteger tag = view.tag - 1000;
    UIImageView *tipImageView = [view viewWithTag:10];
    MTreeNode *subNode = [self.treeView nodeAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:tag]];
    [self.treeView expandNodeAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:tag]];
    [self doTipImageView:tipImageView expand:subNode.expand];
    
    UIView *lineView = [view viewWithTag:40];
    if (lineView) {
        if (subNode.expand) {
            lineView.hidden = YES;
        } else {
            lineView.hidden = NO;
        }
    }
}


@end
