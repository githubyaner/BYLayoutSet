//
//  BYMemorandumData.h
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/24.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYMemorandumModel.h"

@interface BYMemorandumData : NSObject
- (void)addData:(BYMemorandumModel *)model;
- (void)deleteData:(BYMemorandumModel *)model;
- (void)updateData:(BYMemorandumModel *)model;
- (void)searchData:(void(^)(NSArray *array))dataBlock;
@end
