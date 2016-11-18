//
//  BYMemorandumVC.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/24.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYMemorandumVC.h"
#import "BYMemorandumTableView.h"
#import "BYMemorandumCell.h"
#import "BYMemorandumModel.h"
#import "BYMemorandumData.h"
#import "BYMemorandumDetailVC.h"

@interface BYMemorandumVC () <UITableViewDelegate, UITableViewDataSource, BYMemorandumDetailVCDelegate, BYMemorandumCellDelegate>
@property (nonatomic, strong) UIImageView *toolView;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *infoBtn;
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, assign) UITableViewCellEditingStyle editingStyle;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) BYMemorandumData *data;
@end

@implementation BYMemorandumVC

#pragma mark - notifaction
- (instancetype)init {
    self = [super init];
    if (self) {
        //获取通知中心单例对象
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        //接受刷新登陆传来的通知
        [center addObserver:self selector:@selector(afreshTableView:) name:@"Memorandum" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)afreshTableView:(NSNotification *)sender {
    [self.tableView reloadData];
}

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"备忘录";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *goBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_down"]  style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItems = @[goBackBtn];
    
    self.data = [[BYMemorandumData alloc] init];
    
    [self layoutSubView];
}

- (void)layoutSubView {
    self.toolView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width / 6, [UIScreen mainScreen].bounds.size.height - 64)];
    _toolView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:211 / 255.0 blue:135 / 255.0 alpha:1];
    [self.view addSubview:_toolView];
    _toolView.userInteractionEnabled = YES;
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    _addBtn.frame = CGRectMake(5, 5, _toolView.frame.size.width - 10, _toolView.frame.size.width - 10);
    [_addBtn addTarget:self action:@selector(addCell) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:_addBtn];
    
    self.tableView = [[BYMemorandumTableView alloc] initWithFrame:CGRectMake(_toolView.frame.size.width, 64, [UIScreen mainScreen].bounds.size.width - _toolView.frame.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.data searchData:^(NSArray *array) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.dataSource = [NSMutableArray arrayWithArray:array];
        [strongSelf.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
//返回主页
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//添加一个cell
- (void)addCell {
    BYMemorandumDetailVC *vc = [[BYMemorandumDetailVC alloc] initWithModel:nil type:BYMemorandumDetailTypeAdd];
    vc.delegate = self;
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}
//查看更多
- (void)viewMore:(BYMemorandumModel *)model {
    BYMemorandumDetailVC *vc = [[BYMemorandumDetailVC alloc] initWithModel:model type:BYMemorandumDetailTypeUpdate];
    vc.delegate = self;
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}

#pragma mark - cell delegate

- (void)cellDidClickInfo:(BYMemorandumCell *)cell {
    BYMemorandumDetailVC *vc = [[BYMemorandumDetailVC alloc] initWithModel:cell.model type:BYMemorandumDetailTypeUpdate];
    vc.delegate = self;
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}

#pragma mark - BYMemorandumDetailVCDelegate

- (void)saveDataSuccess {
    __weak typeof(self) weakSelf = self;
    [self.data searchData:^(NSArray *array) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.dataSource removeAllObjects];
        strongSelf.dataSource = [NSMutableArray arrayWithArray:array];
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - tableview delegate & datasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"我的备忘录";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYMemorandumModel *model = self.dataSource[indexPath.row];
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    BYMemorandumCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[BYMemorandumCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    BYMemorandumModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

//增添,删除,移动
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        BYMemorandumModel *model = strongSelf.dataSource[indexPath.row];
        [strongSelf.data deleteData:model];
        
        [strongSelf.dataSource removeObjectAtIndex:indexPath.row];
        [strongSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }];
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"更多" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        BYMemorandumModel *model = [strongSelf.dataSource objectAtIndex:indexPath.row];
        [strongSelf viewMore:model];
    }];
    moreAction.backgroundColor = [UIColor orangeColor];
    NSArray *arr = @[deleteAction, moreAction];
    return arr;
}

/*
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // NSLog(@"from(%i)-to(%i)", sourceIndexPath.row, destinationIndexPath.row);
    // 更换数据的顺序
    [self.dataSource exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}
 */



#pragma  mark - KVO

@end
