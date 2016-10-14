//
//  BYDocumentReader.m
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/10/13.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYDocumentReader.h"
#import <WebKit/WebKit.h>

#define BYWEBVIEW_WIDTH ([[UIScreen mainScreen] bounds].size.width > [[UIScreen mainScreen] bounds].size.height ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)//屏幕宽度
#define BYWEBVIEW_HEIGHT ([[UIScreen mainScreen] bounds].size.height > [[UIScreen mainScreen] bounds].size.width ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)//屏幕高度

@interface BYDocumentReader () <UIDocumentInteractionControllerDelegate, UIWebViewDelegate, WKNavigationDelegate>
@property (nonatomic, strong) UIDocumentInteractionController *documentReader;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) NSString *localPath;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WKWebView *wkWebView;
@end

@implementation BYDocumentReader

- (instancetype)initWithLocalPath:(NSString *)localPath {
    self = [super init];
    if (self) {
        self.localPath = localPath;
        self.url = [[NSBundle mainBundle] URLForResource:localPath withExtension:nil];
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.urlStr = url;
        self.url = [NSURL URLWithString:url];
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"文档详情";
    
    [self customizedNavigation];
    [self setMyWebView];
}

- (void)customizedNavigation {
    if (self.urlStr) {
        UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
        self.navigationItem.rightBarButtonItems = @[share];
    } else {
        UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openDocumentReader)];
        UIBarButtonItem *look = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(setMyDocumentReader)];
        self.navigationItem.rightBarButtonItems = @[share, look];
    }
}

- (void)setMyWebView {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, BYWEBVIEW_WIDTH, BYWEBVIEW_HEIGHT)];
        _wkWebView.navigationDelegate = self;
        [self.view addSubview:_wkWebView];
        [self.wkWebView loadRequest:request];
    } else {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, BYWEBVIEW_WIDTH, BYWEBVIEW_HEIGHT)];
        _webView.delegate = self;
        [self.view addSubview:_webView];
        [self.webView loadRequest:request];
    }
}

- (void)setMyDocumentReader {
    if (self.urlStr) {
        return;
    }
    self.documentReader = [UIDocumentInteractionController interactionControllerWithURL:self.url];
    [_documentReader setDelegate:self];
    
    //当前APP打开  需实现协议方法才可以完成预览功能
    [_documentReader presentPreviewAnimated:YES];
}

- (void)openDocumentReader {
    if (self.urlStr) {
        return;
    }
    self.documentReader = [UIDocumentInteractionController interactionControllerWithURL:self.url];
    [_documentReader setDelegate:self];

    //第三方打开 手机中安装有可以打开此格式的软件都可以打开
    [_documentReader presentOpenInMenuFromBarButtonItem:self.navigationItem.rightBarButtonItems[0] animated:YES];
}

- (void)share {
    NSLog(@"分享你的网页");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"error = %@", error);
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"error = %@", error);
}

#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller {
    return self;
}
//- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
//    return self.view;
//}
//- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
//    return self.view.frame;
//}
//点击预览窗口的“Done”(完成)按钮时调用
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController*)_controller {
    
}
@end
