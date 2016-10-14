//
//  BYWebViewController.h
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/10/9.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  选择返回的类型
 */
typedef NS_ENUM(NSInteger, BYVCTYPE) {
    BYVCTYPE_POP,//
    BYVCTYPE_DISMISS,//
};

@interface BYWebViewController : UIViewController
- (instancetype)initWithUrl:(NSString *)url BYVCTYPE:(BYVCTYPE)type;
@end
