//
//  BYDocumentListVC.m
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/10/13.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYDocumentListVC.h"
#import "BYDocumentReader.h"

@interface BYDocumentListVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *vcs;
@end

@implementation BYDocumentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"文档列表";
    
    UIBarButtonItem *goBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_down"]  style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItems = @[goBackBtn];
    
    self.vcs = @[@"doc", @"docx", @"pptx", @"pdf", @"xlsx", @"html", @"url"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate & datasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"文档类型";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vcs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.vcs[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self readDOC];
            break;
        case 1:
            [self readDOCX];
            break;
        case 2:
            [self readPPTX];
            break;
        case 3:
            [self readPDF];
            break;
        case 4:
            [self readXLSX];
            break;
        case 5:
            [self readHTML];
            break;
        case 6:
            [self readURL];
            break;
            
        default:
            break;
    }
}

#pragma mark - cell actions
/*
 *  此处直接处理的是项目里面的文件.也可访问沙盒存储的文件.
 */
- (void)readDOC {
    NSString *localPath = [NSString stringWithFormat:@"doc文件.doc"];
    BYDocumentReader *readerVC= [[BYDocumentReader alloc] initWithLocalPath:localPath];
    [self.navigationController pushViewController:readerVC animated:YES];
}
- (void)readDOCX {
    NSString *localPath = [NSString stringWithFormat:@"docx文件.docx"];
    [self goToReaderVC:localPath];
}
- (void)readPPTX {
    NSString *localPath = [NSString stringWithFormat:@"pptx文件.pptx"];
    [self goToReaderVC:localPath];
}
- (void)readPDF {
    NSString *localPath = [NSString stringWithFormat:@"pdf文件.pdf"];
    [self goToReaderVC:localPath];
}
- (void)readXLSX {
    NSString *localPath = [NSString stringWithFormat:@"xlsx文件.xlsx"];
    [self goToReaderVC:localPath];
}
- (void)readHTML {
    NSString *localPath = [NSString stringWithFormat:@"html文件.html"];
    [self goToReaderVC:localPath];
}
- (void)readURL {
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
