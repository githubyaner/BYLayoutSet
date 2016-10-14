//
//  BYDocumentListVC.m
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/10/13.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYDocumentListVC.h"
#import "BYDocumentReader.h"

@interface BYDocumentListVC ()

@end

@implementation BYDocumentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"文档列表";
    
    UIBarButtonItem *goBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_down"]  style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItems = @[goBackBtn];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - btn actions
/*
 *  此处直接处理的是项目里面的文件.也可访问沙盒存储的文件.
 */
- (IBAction)readDOC:(id)sender {
    NSString *localPath = [NSString stringWithFormat:@"doc文件.doc"];
    BYDocumentReader *readerVC= [[BYDocumentReader alloc] initWithLocalPath:localPath];
    [self.navigationController pushViewController:readerVC animated:YES];
}
- (IBAction)readDOCX:(id)sender {
    NSString *localPath = [NSString stringWithFormat:@"docx文件.docx"];
    [self goToReaderVC:localPath];
}
- (IBAction)readPPT:(id)sender {
    NSString *localPath = [NSString stringWithFormat:@"pptx文件.pptx"];
    [self goToReaderVC:localPath];
}
- (IBAction)readPDF:(id)sender {
    NSString *localPath = [NSString stringWithFormat:@"pdf文件.pdf"];
    [self goToReaderVC:localPath];
}
- (IBAction)readXLS:(id)sender {
    NSString *localPath = [NSString stringWithFormat:@"xlsx文件.xlsx"];
    [self goToReaderVC:localPath];
}
- (IBAction)readHTML:(id)sender {
    NSString *localPath = [NSString stringWithFormat:@"html文件.html"];
    [self goToReaderVC:localPath];
}
- (IBAction)readURL:(id)sender {
    NSString *url = @"https://www.baidu.com";
    [self goToReaderVCOfUrl:url];
}

#pragma mark - push 
- (void)goToReaderVC:(NSString *)path {
    BYDocumentReader *readerVC = [[BYDocumentReader alloc] initWithLocalPath:path];
    [self.navigationController pushViewController:readerVC animated:YES];
}
- (void)goToReaderVCOfUrl:(NSString *)url {
    BYDocumentReader *readerVC = [[BYDocumentReader alloc] initWithUrl:url];
    [self.navigationController pushViewController:readerVC animated:YES];
}


@end
