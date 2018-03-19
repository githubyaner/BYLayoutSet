//
//  BYBluetoothVC.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 2016/11/22.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYBluetoothVC.h"
#import "BYTempWebVC.h"
#import "BYBlueToothTool.h"
#import "BYBlueToothUtil.h"
#import "BYBluetoothWriteVC.h"

@interface BYBluetoothVC ()
@property (nonatomic, strong) BYBlueToothTool *tool;
@end

@implementation BYBluetoothVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"蓝牙";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self customizedNavigation];
    self.tool = [BYBlueToothTool bluetoothTool];
    [self setWriteDataBtn];
}

- (void)customizedNavigation {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_down"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    UIBarButtonItem *detailBtn = ({
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeInfoLight];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithCustomView:btn];
        temp;
    });
    self.navigationItem.rightBarButtonItems = @[detailBtn];
}

- (void)setWriteDataBtn {
    UIButton *runBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    runBtn.frame = CGRectMake(30, 100, ([UIScreen mainScreen].bounds.size.width - 90) / 2, 40);
    [runBtn setTitle:@"Run App" forState:UIControlStateNormal];
    [runBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [runBtn addTarget:self action:@selector(runApp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:runBtn];
    
    UIButton *readHZBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    readHZBtn.frame = CGRectMake(30 + ([UIScreen mainScreen].bounds.size.width - 90) / 2 + 30, 100, ([UIScreen mainScreen].bounds.size.width - 90) / 2, 40);
    [readHZBtn setTitle:@"Read HZ" forState:UIControlStateNormal];
    [readHZBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [readHZBtn addTarget:self action:@selector(readHZ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:readHZBtn];
    
    UIButton *writeBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    writeBtn.frame = CGRectMake(30, 200, ([UIScreen mainScreen].bounds.size.width - 90) / 2, 40);
    [writeBtn setTitle:@"Write Data" forState:UIControlStateNormal];
    [writeBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [writeBtn addTarget:self action:@selector(writeData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:writeBtn];
    
    UIButton *readBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    readBtn.frame = CGRectMake(30 + ([UIScreen mainScreen].bounds.size.width - 90) / 2 + 30, 200, ([UIScreen mainScreen].bounds.size.width - 90) / 2, 40);
    [readBtn setTitle:@"Read Data" forState:UIControlStateNormal];
    [readBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [readBtn addTarget:self action:@selector(readData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:readBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation function

- (void)detail {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BYLayoutSet" message:@"使用\"BabyBluetooth\"" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"前往GitHub" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BYTempWebVC *webVC = [[BYTempWebVC alloc] initWithUrl:@"https://github.com/coolnameismy/BabyBluetooth" BYVCTYPE:BYVCTYPE_POP];
        [weakSelf.navigationController pushViewController:webVC animated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - write and read
//运行在App层
- (void)runApp {
    [self.tool runApp];
    self.tool.runAppBack = ^(NSString *codeStr, id data) {
        
    };
}
//设置读频率
- (void)readHZ {
    [self.tool setReadHZ:nil];
    self.tool.readHZBack = ^(NSString *codeStr, id data) {
        
    };
}
//更新标签数据
- (void)writeData {
    BYBluetoothWriteVC *writeVC = [[BYBluetoothWriteVC alloc] init];
    writeVC.tool = self.tool;
    [self.navigationController pushViewController:writeVC animated:YES];
}
//读取数据
- (void)readData {
    [self.tool readTags];
    self.tool.readTagsBack = ^(NSString *codeStr, id data) {
        
    };
    self.tool.readTagsBack_Command29 = ^(NSString *codeStr, id data) {
//        NSLog(@"data = %@", data);
    };
}

#pragma mark - dealloc 取消所有外设连接

- (void)dealloc {
    [self.tool cleanBluetooth];
}

@end
