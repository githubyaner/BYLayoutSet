//
//  BYScrollTableView.m
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/9/27.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYScrollTableView.h"

@implementation BYScrollTableViewLeft
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutMySubView];
    }
    return self;
}

- (void)layoutMySubView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10) style:UITableViewStylePlain];
    [self addSubview:_tableView];
}

@end


@implementation BYScrollTableViewRight
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutMySubView];
    }
    return self;
}

- (void)layoutMySubView {
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    [self addSubview:_toolBar];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _backBtn.frame = CGRectMake(10, 5, 30, 30);
//    [_backBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [_backBtn setTintColor:[UIColor brownColor]];
    [_backBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [_toolBar addSubview:_backBtn];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 45, self.frame.size.width - 10, self.frame.size.height - 10 - 40) style:UITableViewStylePlain];
    [self addSubview:_tableView];
}

@end


@interface BYScrollTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) BOOL isShowRight;
@property (nonatomic, strong) NSMutableArray *dataSourceLeft;
@property (nonatomic, strong) NSMutableArray *dataSourceRight;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation BYScrollTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isShowRight = NO;
        self.layer.cornerRadius = 3;
        self.layer.borderColor = [UIColor brownColor].CGColor;
        self.layer.borderWidth = 1.5f;
        self.clipsToBounds = YES;
        [self layoutMySubView];
    }
    return self;
}

- (void)layoutMySubView {
    self.leftView = [[BYScrollTableViewLeft alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _leftView.backgroundColor = [UIColor whiteColor];
    _leftView.tableView.delegate = self;
    _leftView.tableView.dataSource = self;
    [self addSubview:_leftView];
    
    self.rightView = [[BYScrollTableViewRight alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    _rightView.backgroundColor = [UIColor whiteColor];
    _rightView.tableView.delegate = self;
    _rightView.tableView.dataSource = self;
    [_rightView.backBtn addTarget:self action:@selector(handleBack) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightView];
    [self setNeedsDisplay];
    
    [self.rightView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}



#pragma mark - tableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftView.tableView) {
//        return self.dataSourceLeft.count;
        return 30;
    } else {
        return self.dataSourceRight.count;
//        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftView.tableView) {
        static NSString *cellID = @"leftCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"left %ld", indexPath.row];
        return cell;
    } else {
        static NSString *cellID = @"rightCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"right %ld", indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftView.tableView) {
        [self scrollTableView];
        
        //取消选中状态
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([self.delegate respondsToSelector:@selector(byScrollTableViewDidSelectCell:)]) {
            [self.delegate byScrollTableViewDidSelectCell:cell];
        }
    }
}

#pragma mark - action
- (void)handleBack {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.rightView.frame = CGRectMake(weakSelf.frame.size.width, 0, weakSelf.frame.size.width, weakSelf.frame.size.height);
    }];
    self.isShowRight = NO;
    
    if ([self.delegate respondsToSelector:@selector(byScrollTableViewDidback)]) {
        [self.delegate byScrollTableViewDidback];
    }
}

- (void)scrollTableView {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.rightView.frame = CGRectMake(0, 0, weakSelf.frame.size.width, weakSelf.frame.size.height);
    }];
    self.isShowRight = YES;
}

- (void)refreshTheData:(NSMutableArray *)data {
    if (_isShowRight) {
        [self.dataSourceRight removeAllObjects];
        self.dataSourceRight = [data mutableCopy];
        [self.rightView.tableView reloadData];
    } else {
        [self.dataSourceLeft removeAllObjects];
        self.dataSourceLeft = [data mutableCopy];
        [self.leftView.tableView reloadData];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    CGFloat x = self.rightView.frame.origin.x;
    if (0.0 == x) {
        [self.dataSourceRight removeAllObjects];
        [self.rightView.tableView reloadData];
    }
}

#pragma mark - dealloc
- (void)dealloc {
     [self.rightView removeObserver:self forKeyPath:@"frame"];
}

@end
