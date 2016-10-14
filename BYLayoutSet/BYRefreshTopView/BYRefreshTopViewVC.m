//
//  BYRefreshTopViewVC.m
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/9/30.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYRefreshTopViewVC.h"
#import "BYRefreshTopView.h"
#import "MJRefresh.h"

#import "BYContentVC.h"

@interface BYRefreshTopViewVC () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *goBackBtn;
@property (nonatomic, strong) UIBarButtonItem *backBtn;
@end

@implementation BYRefreshTopViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"下拉背景+上拉详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //http://img15.3lian.com/2015/f1/48/d/90.jpg
    //http://img1.3lian.com/img013/v4/57/d/111.jpg
    //http://www.fwjia.com/thumb/d/file/2013-08-08/ffcecd940e0eb53a6f94b8e4f6d4c545__450.jpg
    BYRefreshTopView *topView = [[BYRefreshTopView alloc] initWithFrame:CGRectMake(0, -250, self.view.frame.size.width, 250)];
    [self.tableView addSubview:topView];
    [topView topImageViewSetImageWithUrl:@"http://www.fwjia.com/thumb/d/file/2013-08-08/ffcecd940e0eb53a6f94b8e4f6d4c545__450.jpg"];
    
    [self addRefresh];
    
    
    self.goBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_down"]  style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItems = @[_goBackBtn];
}

- (UIWebView *)webView {
    if (!_webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.tableView.contentSize.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.delegate = self;
//        _webView.scrollView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - other
- (void)goBack {
    if (![_webView canGoBack]) {
        [self back];
        return;
    }
    [_webView goBack];
    if (!self.backBtn) {
        self.backBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        [self.navigationItem setLeftBarButtonItems:@[_goBackBtn, _backBtn] animated:YES];
    }
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)present {
    BYContentVC *presentVC = [BYContentVC new];
    [self presentViewController:presentVC animated:YES completion:nil];
    NSLog(@"%@", self.navigationItem.leftBarButtonItem);
}


#pragma mark - uitableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"小标 %ld", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        if (scrollView.contentOffset.y <= -64 + -200) {
            [self present];
        }
    }
}

#pragma mark - mjrefresh
- (void)addRefresh {
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf.tableView.legendHeader endRefreshing];
    }];
    self.tableView.legendHeader.backgroundColor = [UIColor clearColor];
    
    
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf goToDetailAnimation];
        [weakSelf.tableView.legendFooter endRefreshing];
    }];
    self.tableView.legendFooter.backgroundColor = [UIColor clearColor];
    [self.tableView.legendFooter setTitle:@"上拉显示详情" forState:MJRefreshFooterStateIdle];
    [self.tableView.legendFooter setTitle:@"正在加载详情" forState:MJRefreshFooterStateRefreshing];
    [self.tableView.legendFooter setTitle:@"加载成功" forState:MJRefreshFooterStateNoMoreData];
    // 禁止自动加载
    self.tableView.legendFooter.automaticallyRefresh = NO;
}

- (void)addRefreshForWebView {
    __weak typeof(self) weakSelf = self;
    [self.webView.scrollView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf backToFirstPageAnimation];
        [weakSelf.webView.scrollView.legendHeader endRefreshing];
    }];
    [self.webView.scrollView.legendHeader setTitle:@"下拉返回简介" forState:MJRefreshHeaderStateIdle];
    [self.webView.scrollView.legendHeader setTitle:@"正在返回简介" forState:MJRefreshHeaderStatePulling];
    [self.webView.scrollView.legendHeader setTitle:@"返回成功" forState:MJRefreshHeaderStateRefreshing];
    self.webView.scrollView.legendHeader.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.legendHeader.updatedTimeHidden = YES;
}

#pragma mark - Animation
// 进入详情的动画
- (void)goToDetailAnimation {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.webView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
        strongSelf.tableView.frame = CGRectMake(0, -[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
        [weakSelf addRefreshForWebView];
    }];
}


// 返回第一个界面的动画
- (void)backToFirstPageAnimation {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        strongSelf.webView.frame = CGRectMake(0, _tableView.contentSize.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [_webView removeFromSuperview];
        _webView = nil;
    }];
}

#pragma mark - webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

@end
