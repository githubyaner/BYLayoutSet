//
//  BYFormListVC.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/18.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYFormListVC.h"
#import "BYFormVC.h"
#import "BYQuickDialogVC.h"
#import "XLForm.h"

#import "BYQDDataBuilder.h"

@interface BYFormListVC ()

@end

@implementation BYFormListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"表单";
    
    // Do any additional setup after loading the view.
    UIBarButtonItem *goBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_down"]  style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItems = @[goBackBtn];
    
    [self layoutForm];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)layoutForm {
    XLFormDescriptor *form;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //设置表单
    form = [XLFormDescriptor formDescriptorWithTitle:@"表单"];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"XLForm"];//设置分区tite
    [form addFormSection:section];
    
    // NativeEventFormViewController
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"XLForm" rowType:XLFormRowDescriptorTypeButton title:@"XLForm"];//设置单个cell
    row.action.viewControllerClass = [BYFormVC class];
    [section addFormRow:row];
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"QuickDialog"];
    [form addFormSection:section];
    
    
    // TextFieldAndTextView
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"QuickDialog" rowType:XLFormRowDescriptorTypeButton title:@"QuickDialog"];
    row.action.formSegueIdentifier = @"BYQuickDialogVCSegue";
    
    [section addFormRow:row];

    self.form = form;
}

#pragma mark - 协议中调用的方法
- (void)formVC {
    BYFormVC *vc = [[BYFormVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)quickDialogVC {
    QRootElement *root = [BYQDDataBuilder create];
    BYQuickDialogVC *vc = [[BYQuickDialogVC alloc] initWithRoot:root];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - XLFormViewControllerDelegate
- (void)didSelectFormRow:(XLFormRowDescriptor *)formRow {
    if ([formRow.tag isEqualToString:@"XLForm"]) {
        [self formVC];
    } else if ([formRow.tag isEqualToString:@"QuickDialog"]) {
        [self quickDialogVC];
    }
}

@end
