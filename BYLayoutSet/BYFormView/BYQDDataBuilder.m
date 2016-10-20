//
//  BYQDDataBuilder.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/18.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYQDDataBuilder.h"

@implementation BYQDDataBuilder

+ (NSArray *)keyArray {
    return @[ROOT_KEY, INPUT_KEY, TEXTFIELD_KEY, SECURE_KEY, KEYBOARDAPPEARANCE_KEY, CORRECTION_KEY, CAPITALIZATION_KEY, GOOGLE_KEY, ENABLERETURN_KEY, IMAGE_KEY, IMAGETEXT_KEY, DATE_KEY];
}

+ (QRootElement *)create {
    QRootElement *root = [[QRootElement alloc] init];
    root.key = ROOT_KEY;
    root.grouped = YES;
    root.title = @"QuickDialog";
    root.controllerName = @"BYQuickDialogVC";
    
    //设置第一个分区
    QSection *section1 = [[QSection alloc] initWithTitle:@"第一分区"];
    [root addSection:section1];
    
    //设置row
    QLabelElement *label = [[QLabelElement alloc] initWithTitle:@"Key" Value:@"value"];
//    label.key = LABEL_KEY;
    [section1 addElement:label];
    
    QEntryElement *inputLabel = [[QEntryElement alloc] initWithTitle:@"Input" Value:@"Value" Placeholder:@"Value"];
    inputLabel.key = INPUT_KEY;
    [section1 addElement:inputLabel];
    
    QBooleanElement *boolean = [[QBooleanElement alloc] initWithTitle:@"boolean" BoolValue:YES];
//    boolean.key = BOOL_KEY;
    [section1 addElement:boolean];
    
    QButtonElement *myButton = [[QButtonElement alloc] initWithTitle:@"BYFormVC"];
//    myButton.key = BUTTON_KEY;
    myButton.controllerAction = @"pushBYFormVC";
    [section1 addElement:myButton];
    
    QTextElement *text = [[QTextElement alloc] initWithText:@"Don't aim for success if you want it; just do what you love and believe in, and it will come naturally.\n 如果你想要成功，不要去追求成功；尽管做你自己热爱的事情并且相信它，成功自然到来。"];
//    text.key = TEXT_KEY;
    [section1 addElement:text];

    
    //设置第二个分区
    QSection *section2 = [[QSection alloc] initWithTitle:@"UITextInputTraits"];
    
    //设置row
    QEntryElement *textField = [[QEntryElement alloc] initWithTitle:nil Value:nil Placeholder:@"placeholder"];
    textField.key = TEXTFIELD_KEY;
    [section2 addElement:textField];
    
    QEntryElement *secureElement = [[QEntryElement alloc] initWithTitle:@"密码" Value:@"" Placeholder:@"请输入密码"];
    secureElement.key = SECURE_KEY;
    secureElement.secureTextEntry = YES;
    [section2 addElement:secureElement];
    
    QEntryElement *keyboardAppearanceElement = [[QEntryElement alloc] initWithTitle:@"首字母大写" Value:@"" Placeholder:@"Berton"];
    keyboardAppearanceElement.keyboardAppearance = UIKeyboardAppearanceAlert;
    keyboardAppearanceElement.key = KEYBOARDAPPEARANCE_KEY;
    [section2 addElement:keyboardAppearanceElement];
    
    QEntryElement *correctionElement = [[QEntryElement alloc] initWithTitle:@"首字母大写" Value:@"" Placeholder:@"Berton"];
    correctionElement.autocorrectionType = UITextAutocorrectionTypeNo;
    correctionElement.key = CORRECTION_KEY;
    [section2 addElement:correctionElement];
    
    QEntryElement *capitalizationElement = [[QEntryElement alloc] initWithTitle:@"大写" Value:@"" Placeholder:@"全部大写"];
    capitalizationElement.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    capitalizationElement.key = CAPITALIZATION_KEY;
    [section2 addElement:capitalizationElement];
    
    QEntryElement *googleElement = [[QEntryElement alloc] initWithTitle:@"Return Key" Value:@"" Placeholder:@"Google"];
    googleElement.returnKeyType = UIReturnKeyGoogle;
    googleElement.key = GOOGLE_KEY;
    [section2 addElement:googleElement];
    
    QEntryElement *enableReturnElement = [[QEntryElement alloc] initWithTitle:@"自动纠正" Value:@"" Placeholder:@"自动纠正"];
    enableReturnElement.key = ENABLERETURN_KEY;
    enableReturnElement.enablesReturnKeyAutomatically = YES;
    [section2 addElement:enableReturnElement];
    [root addSection:section2];
    
    
    QEntryElement *regularEntryElementWithImage = [[QEntryElement alloc] initWithTitle:@"Entry with image" Value:@"" Placeholder:@"YES"];
    regularEntryElementWithImage.image = [UIImage imageNamed:@"icon_init"];
    regularEntryElementWithImage.key = IMAGE_KEY;
    [section2 addElement:regularEntryElementWithImage];
    
    
    QMultilineElement *multilineWithImage = [QMultilineElement new];
    multilineWithImage.title = @"Multiline with image";
    multilineWithImage.image = [UIImage imageNamed:@"icon_init"];
    multilineWithImage.key = IMAGETEXT_KEY;
    [section2 addElement:multilineWithImage];
    
    QDateTimeInlineElement *dateElement = [[QDateTimeInlineElement alloc] initWithTitle:@"日期时间" date:[NSDate date] andMode:UIDatePickerModeDateAndTime];
    dateElement.key = DATE_KEY;
    [section2 addElement:dateElement];
    
    return root;

}

@end
