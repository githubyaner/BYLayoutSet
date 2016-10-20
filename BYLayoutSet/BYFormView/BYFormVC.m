//
//  BYFormVC.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/18.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYFormVC.h"
#import "XLForm.h"

#import "BYTempWebVC.h"

@interface CurrencyFormatter : NSNumberFormatter
@property (readonly) NSDecimalNumberHandler *roundingBehavior;
@end

@implementation CurrencyFormatter
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setNumberStyle: NSNumberFormatterCurrencyStyle];
        [self setGeneratesDecimalNumbers:YES];
        NSUInteger currencyScale = [self maximumFractionDigits];
        _roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:currencyScale raiseOnExactness:FALSE raiseOnOverflow:TRUE raiseOnUnderflow:TRUE raiseOnDivideByZero:TRUE];
    }
    return self;
}
@end

@interface BYFormVC ()

@end

@implementation BYFormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"XLForm";
    
    UIBarButtonItem *detailBtn = ({
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeInfoLight];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithCustomView:btn];
        temp;
    });
    self.navigationItem.rightBarButtonItems = @[detailBtn];
    
    // Do any additional setup after loading the view.
    [self layoutForm];
}

- (void)detail {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BYLayoutSet" message:@"使用\"XLForm\"" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"前往GitHub" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BYTempWebVC *webVC = [[BYTempWebVC alloc] initWithUrl:@"https://github.com/xmartlabs/XLForm" BYVCTYPE:BYVCTYPE_POP];
        [weakSelf.navigationController pushViewController:webVC animated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
}

- (void)layoutForm {
    XLFormDescriptor *form;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //设置表单
    form = [XLFormDescriptor formDescriptorWithTitle:@"XLForm"];
    
    //设置分区 -- 第一个分区
    section = [XLFormSectionDescriptor formSectionWithTitle:@"第一分区"];
    [form addFormSection:section];
    
    //设置行
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Title1" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Title1" forKey:@"textField.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Title2" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Title2" forKey:@"textField.placeholder"];
    [section addFormRow:row];
    
    //第二个分区
    section = [XLFormSectionDescriptor formSectionWithTitle:@"第二分区"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"用户名" rowType:XLFormRowDescriptorTypeText title:@"用户名"];
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"密码" rowType:XLFormRowDescriptorTypePassword title:@"密码"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"日期时间" rowType:XLFormRowDescriptorTypeDateTimeInline title:@"日期时间"];
    row.value = [NSDate new];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"导服费" rowType:XLFormRowDescriptorTypeDecimal title:@"导服费"];
    CurrencyFormatter *numberFormatter = [[CurrencyFormatter alloc] init];
    row.valueFormatter = numberFormatter;
    row.value = [NSDecimalNumber numberWithDouble:666.66];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.disabled = @YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"用户昵称" rowType:XLFormRowDescriptorTypeTwitter title:@"用户昵称"];
    row.disabled = @YES;
    row.value = @"Berton";
    [section addFormRow:row];

    
    //第三个分区
    section = [XLFormSectionDescriptor formSectionWithTitle:@"第三分区"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"文本框" rowType:XLFormRowDescriptorTypeTextView];
    [row.cellConfigAtConfigure setObject:@"请输入您的个人简介..." forKey:@"textView.placeholder"];
//    row.height = 300.f;
    [section addFormRow:row];
    
    //第四个分区
    section = [XLFormSectionDescriptor formSectionWithTitle:@"第四分区"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"文本框(Title)" rowType:XLFormRowDescriptorTypeTextView title:@"个人简介"];
    [section addFormRow:row];
    
    
    //第五个分区
    section = [XLFormSectionDescriptor formSectionWithTitle:@"按钮"];
    [form addFormSection:section];
    
    XLFormRowDescriptor * buttonRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"返回上一页" rowType:XLFormRowDescriptorTypeButton title:@"返回上一页"];
    buttonRow.action.formSelector = @selector(back);
    [section addFormRow:buttonRow];
    
    
    self.form = form;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 数据监听

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    [super formRowDescriptorValueHasChanged:formRow oldValue:oldValue newValue:newValue];
    NSLog(@"formRow tag = %@", formRow.tag);
}

@end
