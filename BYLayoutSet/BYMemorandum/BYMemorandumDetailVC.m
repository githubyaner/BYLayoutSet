//
//  BYMemorandumDetailVC.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/24.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYMemorandumDetailVC.h"
#import "BYMemorandumData.h"
#import "XLForm.h"

@interface BYMemorandumDetailVC ()
//@property (nonatomic, strong) BYMemorandumModel *otherModel;//新增的时候创建
@property (nonatomic, strong) BYMemorandumModel *sendModel;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, assign) BOOL dateHidden;
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, strong) XLFormRowDescriptor *titleRow;
@property (nonatomic, strong) XLFormRowDescriptor *noteRow;
@property (nonatomic, strong) XLFormRowDescriptor *dateRow;
@property (nonatomic, strong) XLFormRowDescriptor *clookRow;
@property (nonatomic, strong) XLFormRowDescriptor *loopTypeRow;

@property (nonatomic, strong) XLFormRowDescriptor *finishRow;
@end

@implementation BYMemorandumDetailVC

- (instancetype)initWithModel:(BYMemorandumModel *)model type:(BYMemorandumDetailType)type {
    self = [super init];
    if (self) {
        self.type = type;
        if (type == BYMemorandumDetailTypeAdd) {
            self.title = @"新增备忘录";
            self.sendModel = [BYMemorandumModel memorandumModel];
            self.isAdd = YES;
        } else {
            self.title = @"修改备忘录";
            self.sendModel = [BYMemorandumModel modelWithModel:model];
            self.isAdd = NO;
        }
        self.disabled = self.sendModel.isFinish;
        self.dateHidden = !self.sendModel.isClook;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *goBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_down"]  style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItems = @[goBackBtn];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItems = @[saveBtn];
    
    [self layoutForm];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)save {
    if ([self isBlankString:_sendModel.titleText]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BYLayoutSet" message:@"请您填写标题!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //保存
    BYMemorandumData *data = [[BYMemorandumData alloc] init];
    if (self.type == BYMemorandumDetailTypeAdd) {
        [data addData:_sendModel];
    } else {
        [data updateData:_sendModel];
    }
    //协议传出
    if ([self.delegate respondsToSelector:@selector(saveDataSuccess)]) {
        [self.delegate saveDataSuccess];
    }
    [self.tableView endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)layoutForm {
    XLFormDescriptor *form;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    //设置表单
    form = [XLFormDescriptor formDescriptorWithTitle:@"备忘录"];
    
    //设置分区 -- 第一个分区
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    //设置行
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"titleText" rowType:XLFormRowDescriptorTypeText title:@"标题"];
//    [row.cellConfigAtConfigure setObject:@"标题" forKey:@"textField.placeholder"];
    row.required = YES;
    row.value = self.sendModel.titleText;
    [section addFormRow:row];
    row.disabled = @(self.disabled);
    self.titleRow = row;
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"noteText" rowType:XLFormRowDescriptorTypeTextView title:@"备注"];
//    [row.cellConfigAtConfigure setObject:@"请输入您的备注..." forKey:@"textView.placeholder"];
    row.value = self.sendModel.noteText;
    [section addFormRow:row];
    row.disabled = @(self.disabled);
    self.noteRow = row;
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"isClook" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"指定日期提醒"];
    row.value = @(self.sendModel.isClook);;
    [section addFormRow:row];
    row.disabled = @(self.disabled);
    self.dateRow = row;
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"clookDate" rowType:XLFormRowDescriptorTypeDateTimeInline title:@"提醒日期"];
    row.value = [BYMemorandumModel dateFromDateStr:self.sendModel.clookDate];
    [section addFormRow:row];
    row.disabled = @(self.disabled);
    row.hidden = @(self.dateHidden);
    self.clookRow = row;
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"loopType" rowType:XLFormRowDescriptorTypeSelectorPush title:@"重复提醒"];
    row.selectorOptions = @[@"永不", @"每分钟", @"每小时", @"每天", @"每周", @"每月", @"每年"];
    row.value = self.sendModel.loopType;
    row.disabled = @(self.disabled);
    row.hidden = @(self.dateHidden);
    [section addFormRow:row];
    self.loopTypeRow = row;
    
    //设置分区 -- 第二个分区
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];

    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"isFinish" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否完成"];
    row.value = @(self.sendModel.isFinish);
    row.hidden = @(self.isAdd);
    [section addFormRow:row];
    
    self.form = form;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - XLForm
- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    if ([@"titleText" isEqualToString:formRow.tag]) {
        self.sendModel.titleText = [newValue isKindOfClass:[NSNull class]] ? @"" : newValue;
    } else if ([@"noteText" isEqualToString:formRow.tag]) {
        self.sendModel.noteText = [newValue isKindOfClass:[NSNull class]] ? @"" : newValue;
    } else if ([@"isClook" isEqualToString:formRow.tag]) {
        [self.tableView endEditing:YES];
        self.sendModel.isClook = [newValue boolValue];
        self.dateHidden = !(self.sendModel.isClook);
        if (self.sendModel.isClook) {
            self.clookRow.value = [BYMemorandumModel dateFromDateStr:self.sendModel.clookDate];
            self.loopTypeRow.value = self.sendModel.loopType;
        } else {
            self.sendModel.clookDate = @"";
            self.sendModel.loopType = @"永不";
            self.clookRow.value = self.sendModel.clookDate;
            self.loopTypeRow.value = self.sendModel.loopType;
        }
        self.clookRow.hidden = @(self.dateHidden);
        self.loopTypeRow.hidden = @(self.dateHidden);
    } else if ([@"clookDate" isEqualToString:formRow.tag]) {
        if ([newValue isKindOfClass:[NSNull class]]) {
            self.sendModel.clookDate = @"";
        } else {
            self.sendModel.clookDate = [BYMemorandumModel dateStrFromDate:newValue];
        }
    } else if ([@"loopType" isEqualToString:formRow.tag]) {
        self.sendModel.loopType = [newValue isKindOfClass:[NSNull class]] ? @"永不" : newValue;
        if ([newValue isKindOfClass:[NSNull class]]) {
            self.loopTypeRow.value = @"永不";
        }
    } else if ([@"isFinish" isEqualToString:formRow.tag]) {
        [self.tableView endEditing:YES];
        
        self.sendModel.isFinish = [newValue boolValue];
        self.disabled = self.sendModel.isFinish;
        
        self.titleRow.disabled = @(self.disabled);
        self.noteRow.disabled = @(self.disabled);
        self.dateRow.disabled = @(self.disabled);
        self.clookRow.disabled = @(self.disabled);
        self.loopTypeRow.disabled = @(self.disabled);
        [self.tableView reloadData];
    }
}

#pragma mark - help
//判断字符串是否为空
- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
