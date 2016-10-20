//
//  BYTempWebVC.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/19.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYTempWebVC.h"

#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

#define BYWEBVIEW_DEFAULT 0.0
#define BYWEBVIEW_INITIAL 0.2
#define BYWEBVIEW_MIDDLE 0.5
#define BYWEBVIEW_FINSH 1.0


#define BYWEBVIEW_WIDTH ([[UIScreen mainScreen] bounds].size.width > [[UIScreen mainScreen] bounds].size.height ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)//屏幕宽度
#define BYWEBVIEW_HEIGHT ([[UIScreen mainScreen] bounds].size.height > [[UIScreen mainScreen] bounds].size.width ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)//屏幕高度
#define BYWEBVIEW_64 64.0


@interface BYTempWebVC () <UIWebViewDelegate, WKNavigationDelegate>
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BYVCTYPE type;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIBarButtonItem *goBackBtn;
@property (nonatomic, strong) UIBarButtonItem *backBtn;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation BYTempWebVC

- (instancetype)initWithUrl:(NSString *)url BYVCTYPE:(BYVCTYPE)type {
    self = [super init];
    if (self) {
        self.url = url;
        self.type = type;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_wkWebView) {
        [_wkWebView stopLoading];
    }
    if (_webView) {
        [_webView stopLoading];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, BYWEBVIEW_WIDTH, BYWEBVIEW_HEIGHT)];
        _wkWebView.navigationDelegate = self;
        _wkWebView.scrollView.delegate = self;
        [self.view addSubview:_wkWebView];
        //添加监听事件
        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        //加载网页
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    } else {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, BYWEBVIEW_WIDTH, BYWEBVIEW_HEIGHT)];
        _webView.delegate = self;
        _wkWebView.scrollView.delegate = self;
        [self.view addSubview:_webView];
        //加载网页
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, BYWEBVIEW_WIDTH, 2)];
    _progressView.progressTintColor = [UIColor brownColor];
    [self.view addSubview:_progressView];
    _progressView.hidden = YES;
    [_progressView setProgress:0.0f];
    
    if (BYVCTYPE_DISMISS == self.type) {
        self.goBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_down"]  style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];;
        self.navigationItem.leftBarButtonItems = @[_goBackBtn];
    } else {
        self.goBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return"]  style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];;
        self.navigationItem.leftBarButtonItems = @[_goBackBtn];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - other action
- (void)goBack {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        if (![_wkWebView canGoBack]) {
            [self back];
            return;
        }
        [_wkWebView goBack];
        if (!self.backBtn) {
            self.backBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
            [self.navigationItem setLeftBarButtonItems:@[_goBackBtn, _backBtn] animated:YES];
        }
    } else {
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
}

- (void)back {
    if (BYVCTYPE_POP == self.type) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark - Key Value Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.wkWebView && [@"estimatedProgress" isEqualToString:keyPath]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:BYWEBVIEW_DEFAULT animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
    if (object == self.wkWebView && [@"title" isEqualToString:keyPath]) {
        self.title = self.wkWebView.title;
    }
}

#pragma mark - webview delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.progressView.hidden = NO;
    [self.progressView setProgress:BYWEBVIEW_MIDDLE animated:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSLog(@"%@",context);
    NSString *jsTitle = @"document.title";
    //准备执行的js代码
    JSValue *value = [context evaluateScript:jsTitle];
    self.title = [NSString stringWithFormat:@"%@", value];
    //设置progressview
    [self.progressView setProgress:BYWEBVIEW_FINSH animated:YES];
    self.progressView.hidden = YES;
    [self.progressView setProgress:BYWEBVIEW_DEFAULT animated:NO];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.progressView.hidden = YES;
    [self.progressView setProgress:BYWEBVIEW_DEFAULT animated:NO];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - wknavigation delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
    [self.progressView setProgress:BYWEBVIEW_DEFAULT animated:NO];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - dealloc
- (void)dealloc {
    if (_wkWebView) {
        _wkWebView.navigationDelegate = nil;
        _wkWebView.scrollView.delegate = nil;
        [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.wkWebView removeObserver:self forKeyPath:@"title"];
    }
    if (_webView) {
        _webView.delegate = nil;
        _webView.scrollView.delegate = nil;
    }
}

@end

