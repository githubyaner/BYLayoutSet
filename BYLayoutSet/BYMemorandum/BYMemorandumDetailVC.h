//
//  BYMemorandumDetailVC.h
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/24.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "XLFormViewController.h"
#import "BYMemorandumModel.h"

typedef NS_ENUM(NSInteger, BYMemorandumDetailType){
    BYMemorandumDetailTypeAdd,
    BYMemorandumDetailTypeUpdate,
};


@protocol BYMemorandumDetailVCDelegate <NSObject>
- (void)saveDataSuccess;
@end


@interface BYMemorandumDetailVC : XLFormViewController
@property (nonatomic, assign) BYMemorandumDetailType type;
@property (nonatomic, assign) id <BYMemorandumDetailVCDelegate> delegate;
/*
 *  BYMemorandumDetailTypeAdd   不需要传model,为nil
 *  BYMemorandumDetailType      需要传model
 */
- (instancetype)initWithModel:(BYMemorandumModel *)model type:(BYMemorandumDetailType)type;
@end
