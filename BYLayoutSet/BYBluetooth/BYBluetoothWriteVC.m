//
//  BYBluetoothWriteVC.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 2016/11/25.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYBluetoothWriteVC.h"
#import "XLForm.h"
#import "BYBlueToothTool.h"
#import "BYBlueToothUtil.h"

@interface BYBluetoothWriteVC ()

@end

@implementation BYBluetoothWriteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置标签";
    [self customizedNavigation];
    [self layoutForm];
}

- (void)customizedNavigation {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(updateTag)];
}

#pragma mark - 布局cell
- (void)layoutForm {
    XLFormDescriptor *form;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //设置表单
    form = [XLFormDescriptor formDescriptorWithTitle:@"XLForm"];
    
    //设置分区
    section = [XLFormSectionDescriptor formSectionWithTitle:nil];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"名称" rowType:XLFormRowDescriptorTypeText title:@"名称"];
    row.required = YES;
    [row.cellConfigAtConfigure setObject:@"4位(含4位)以下字数名称" forKey:@"textField.placeholder"];
    row.value = @"";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"状态" rowType:XLFormRowDescriptorTypeTwitter title:@"状态"];
    row.disabled = @YES;
    [section addFormRow:row];
    
    //提示
    section.footerTitle = @"请将单个标签置于充电宝(阅读器)上,然后输入4位(含4位)以下字数名称,点击保存即可.";
    
    self.form = form;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - xlfrom

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    if ([@"名称" isEqualToString:formRow.tag]) {
        if ([newValue isKindOfClass:[NSNull class]]) {
            formRow.value = @"";
        }
        NSLog(@"name = %@", newValue);
    }
}

#pragma mark - navigation function
//更新tag
- (void)updateTag {
    XLFormRowDescriptor *row = [self.form formRowWithTag:@"名称"];
    [self.tool updateTagForEPC:[NSString stringWithFormat:@"%@", row.value]];
    self.tool.updateTagBack = ^(NSString *codeStr, id data) {
        
    };
}

@end
