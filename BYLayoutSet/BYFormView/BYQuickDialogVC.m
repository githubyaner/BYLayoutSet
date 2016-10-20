//
//  BYQuickDialogVC.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/18.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYQuickDialogVC.h"
#import "BYQDDataBuilder.h"
#import "QuickDialog.h"

#import "BYFormVC.h"
#import "BYTempWebVC.h"

@interface BYQuickDialogVC () <QuickDialogEntryElementDelegate>

@end

@implementation BYQuickDialogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"QuickDialog";
    
    NSArray *keyArr = [BYQDDataBuilder keyArray];
    for (NSString *key in keyArr) {
        ((QEntryElement *)[self.root elementWithKey:key]).delegate = self;
    }
    
    UIBarButtonItem *detailBtn = ({
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeInfoLight];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithCustomView:btn];
        temp;
    });
    self.navigationItem.rightBarButtonItems = @[detailBtn];
}

- (void)detail {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BYLayoutSet" message:@"使用\"QuickDialog\"" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"前往GitHub" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BYTempWebVC *webVC = [[BYTempWebVC alloc] initWithUrl:@"https://github.com/escoz/QuickDialog" BYVCTYPE:BYVCTYPE_POP];
        [weakSelf.navigationController pushViewController:webVC animated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
}

- (void)pushBYFormVC {
    BYFormVC *vc = [[BYFormVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 数据监测
- (BOOL)QEntryShouldChangeCharactersInRange:(NSRange)range withString:(NSString *)string forElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    return YES;
}
- (void)QEntryEditingChangedForElement:(QEntryElement *)element  andCell:(QEntryTableViewCell *)cell {
    NSLog(@"key = %@", element.key);
}
- (void)QEntryDidBeginEditingElement:(QEntryElement *)element  andCell:(QEntryTableViewCell *)cell {
    
}
- (void)QEntryDidEndEditingElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    
}
- (BOOL)QEntryShouldReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    return YES;
}
- (void)QEntryMustReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    
}

@end
