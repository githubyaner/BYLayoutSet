//
//  BYQDDataBuilder.h
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/18.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickDialog.h"

static NSString *ROOT_KEY = @"ROOT_KEY";
//static NSString *LABEL_KEY = @"LABEL_KEY";
static NSString *INPUT_KEY = @"INPUT_KEY";
//static NSString *BOOL_KEY = @"BOOL_KEY";
//static NSString *BUTTON_KEY = @"BUTTON_KEY";
//static NSString *TEXT_KEY = @"TEXT_KEY";
static NSString *TEXTFIELD_KEY = @"TEXTFIELD_KEY";
static NSString *SECURE_KEY = @"SECURE_KEY";
static NSString *KEYBOARDAPPEARANCE_KEY = @"KEYBOARDAPPEARANCE_KEY";
static NSString *CORRECTION_KEY = @"CORRECTION_KEY";
static NSString *CAPITALIZATION_KEY = @"CAPITALIZATION_KEY";
static NSString *GOOGLE_KEY = @"GOOGLE_KEY";
static NSString *ENABLERETURN_KEY = @"ENABLERETURN_KEY";
static NSString *IMAGE_KEY = @"IMAGE_KEY";
static NSString *IMAGETEXT_KEY = @"IMAGETEXT_KEY";
static NSString *DATE_KEY = @"DATE_KEY";

@interface BYQDDataBuilder : NSObject<QuickDialogEntryElementDelegate>
+ (NSArray *)keyArray;
+ (QRootElement *)create;
@end
