//
//  BYTreeTableViewListVC.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/19.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYTreeTableViewListVC.h"
#import "BYTempWebVC.h"

#import "BYMultistageVC.h"
#import "BYQQTreeVC.h"
#import "BYFileTreeVC.h"

@interface BYTreeTableViewListVC ()

@end

@implementation BYTreeTableViewListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TreeTableView";
    
    UIBarButtonItem *goBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_down"]  style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItems = @[goBackBtn];

    UIBarButtonItem *detailBtn = ({
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeInfoLight];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithCustomView:btn];
        temp;
    });
    self.navigationItem.rightBarButtonItems = @[detailBtn];

}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)detail {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BYLayoutSet" message:@"使用\"MTreeViewFramework\"" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"前往GitHub" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BYTempWebVC *webVC = [[BYTempWebVC alloc] initWithUrl:@"https://github.com/MMicker/MTreeViewFramework" BYVCTYPE:BYVCTYPE_POP];
        [weakSelf.navigationController pushViewController:webVC animated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (0 == indexPath.section) {
        cell.textLabel.text = @"多级展开";
    } else if (1 == indexPath.section) {
        cell.textLabel.text = @"QQ联系人";
    } else if (2 == indexPath.section) {
        cell.textLabel.text = @"文件层级";
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return @"多级展开";
    } else if (1 == section) {
        return @"QQ联系人";
    } else if (2 == section) {
        return @"文件层级";
    }
    return @"";
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (0 == indexPath.section) {
        //多级展开
        BYMultistageVC *vc = [[BYMultistageVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (1 == indexPath.section) {
        //QQ联系人
        BYQQTreeVC *vc = [[BYQQTreeVC alloc] init];
        vc.isGrouped = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (2 == indexPath.section) {
        //文件层级
        BYFileTreeVC *vc = [[BYFileTreeVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
