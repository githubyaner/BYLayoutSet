//
//  BYGuideListVC.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 2016/12/15.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYGuideListVC.h"
#import "XLForm.h"

#import "BYTempWebVC.h"

#import "BYGuideViewVC.h"
#import "BYNewFeaturesVC.h"

@interface BYGuideListVC ()

@end

@implementation BYGuideListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"引导";
    [self customizedNavigation];
    [self layoutForm];
}

- (void)customizedNavigation {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_down"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)layoutForm {
    XLFormDescriptor *form;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    
    //设置表单
    form = [XLFormDescriptor formDescriptorWithTitle:@"引导"];
    section = [XLFormSectionDescriptor formSectionWithTitle:@"界面指引"];//设置分区tite
    [form addFormSection:section];
    // NativeEventFormViewController
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"界面指引" rowType:XLFormRowDescriptorTypeButton title:@"界面指引"];//设置单个cell
    row.action.viewControllerClass = [BYGuideViewVC class];
    [section addFormRow:row];
    
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"新功能引导"];
    section.footerTitle = @"首次打开App的时候进行新功能展示.";
    [form addFormSection:section];
    // TextFieldAndTextView
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"新功能引导" rowType:XLFormRowDescriptorTypeButton title:@"新功能引导"];
    row.action.formSegueIdentifier = @"BYNewFeaturesVCSegue";
    [section addFormRow:row];
    
    self.form = form;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - xlform delegate

- (void)didSelectFormRow:(XLFormRowDescriptor *)formRow {
    if ([formRow.tag isEqualToString:@"界面指引"]) {
        [self guideViewVC];
    } else if ([formRow.tag isEqualToString:@"新功能引导"]) {
        [self newFeaturesVC];
    }
}

#pragma mark - cell function

- (void)guideViewVC {
    BYGuideViewVC *guideViewVC = [[BYGuideViewVC alloc] init];
    [self.navigationController pushViewController:guideViewVC animated:YES];
}

- (void)newFeaturesVC {
    BYNewFeaturesVC *newFeaturesVC = [[BYNewFeaturesVC alloc] init];
    [self presentViewController:newFeaturesVC animated:YES completion:nil];
    [self newFeaturesVCDetail:newFeaturesVC];
}

- (void)newFeaturesVCDetail:(UIViewController *)vc {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BYLayoutSet" message:@"使用\"ZWIntroductionViewController\"" preferredStyle:UIAlertControllerStyleAlert];
    [vc presentViewController:alert animated:YES completion:nil];
    [alert addAction:[UIAlertAction actionWithTitle:@"前往GitHub" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BYTempWebVC *webVC = [[BYTempWebVC alloc] initWithUrl:@"https://github.com/squarezw/ZWIntroductionViewController" BYVCTYPE:BYVCTYPE_DISMISS];
        UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:webVC];
        [vc presentViewController:na animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
}

@end
