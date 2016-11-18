//
//  BYMemorandumData.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 16/10/24.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYMemorandumData.h"
#import "FMDB.h"

@interface BYMemorandumData ()
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@end

@implementation BYMemorandumData

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dbQueue = [[self class] getTheDBQueue];
    }
    return self;
}

+ (FMDatabaseQueue *)getTheDBQueue {
    // 1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [doc stringByAppendingPathComponent:@"BYMemorandum.sqlite"];
    
    // 2.得到数据库
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:filename];
    
    //字段 id, createDate, titleText, noteText, clookDate, loopType, isFinish
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS t_BYMemorandum (id integer PRIMARY KEY AUTOINCREMENT, creatDate TEXT NOT NULL, titleText TEXT NOT NULL, noteText TEXT NOT NULL, clookDate TEXT NOT NULL, loopType TEXT DEFAULT '永不', isFinish bit DEFAULT '0');";
        [db executeUpdate:sqlCreateTable];
//        BOOL result = [db executeUpdate:sqlCreateTable];
//        if (result) {
//            NSLog(@"成功创表");
//        } else {
//            NSLog(@"创表失败");
//        }
        
        
        /**使用FMDB添加字段*/
        /*
        if (![db columnExists:@"noteText" inTableWithName:@"t_BYMemorandum"]){
            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE t_BYMemorandum ADD noteText TEXT NOT NULL DEFAULT ''"];
            [db executeUpdate:alertStr];
        }
         */
    }];
    return dbQueue;
}

- (void)addData:(BYMemorandumModel *)model {
    if (!self.dbQueue) {
        self.dbQueue = [[self class] getTheDBQueue];
    }
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *addDataStr = [NSString stringWithFormat:@"INSERT INTO t_BYMemorandum (creatDate, titleText, noteText, clookDate, loopType, isFinish) VALUES ('%@', '%@', '%@', '%@', '%@', '%d');", model.creatDate, model.titleText, model.noteText, model.clookDate, model.loopType, model.isFinish];
        [db executeUpdate:addDataStr];
//        BOOL isSuccess = [db executeUpdate:addDataStr];
//        NSLog(@"添加:%@", @(isSuccess));
    }];
}

- (void)deleteData:(BYMemorandumModel *)model {
    if (!self.dbQueue) {
        self.dbQueue = [[self class] getTheDBQueue];
    }
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *deleteDataStr = [NSString stringWithFormat:@"DELETE FROM t_BYMemorandum WHERE creatDate = '%@';", model.creatDate];
        [db executeUpdate:deleteDataStr];
//        BOOL isSuccess = [db executeUpdate:deleteDataStr];
//        NSLog(@"删除:%@", @(isSuccess));
    }];
}

- (void)updateData:(BYMemorandumModel *)model {
    if (!self.dbQueue) {
        self.dbQueue = [[self class] getTheDBQueue];
    }
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *updateDataStr = [NSString stringWithFormat:@"UPDATE t_BYMemorandum SET titleText = '%@', noteText = '%@', clookDate= '%@', loopType = '%@', isFinish = '%d' WHERE creatDate = '%@';", model.titleText, model.noteText, model.clookDate, model.loopType, model.isFinish, model.creatDate];
        [db executeUpdate:updateDataStr];
//        BOOL isSuccess = [db executeUpdate:updateDataStr];
//        NSLog(@"更新:%@", @(isSuccess));
    }];
}

- (void)searchData:(void (^)(NSArray *))dataBlock {
    if (!self.dbQueue) {
        self.dbQueue = [[self class] getTheDBQueue];
    }
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        // 查询数据
        NSString *searchDataStr = @"SELECT * FROM t_BYMemorandum;";
        FMResultSet *result = [db executeQuery:searchDataStr];
        NSMutableArray *resultArray = [NSMutableArray array];
        while ([result next]) {
//            int ID = [result intForColumnIndex:0];
            NSString *creatDate = [result stringForColumn:@"creatDate"];
            NSString *titleText = [result stringForColumn:@"titleText"];
            NSString *noteText = [result stringForColumn:@"noteText"];
            NSString *clookDate = [result stringForColumn:@"clookDate"];
            NSString *loopType = [result stringForColumn:@"loopType"];
            BOOL isFinish = [result boolForColumn:@"isFinish"];
            BYMemorandumModel *model = [BYMemorandumModel memorandumModel];
            model.creatDate = creatDate;
            model.titleText = titleText;
            model.noteText = noteText;
            model.clookDate = clookDate;
            model.loopType = loopType;
            model.isFinish = isFinish;
            [resultArray addObject:model];
//            NSLog(@"id = %@, creatDate: %@, titleText: %@, noteText: %@, clookDate: %@, loopType: %@, isFinish: %@", @(ID), creatDate, titleText, noteText, clookDate, loopType, @(isFinish));
        }
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = [resultArray count] - 1; i >= 0; i--) {
            BYMemorandumModel *model = resultArray[i];
            [model updateData];//必须更新数据.计算高度
            [array addObject:model];
        }
        dataBlock(array);
    }];
}
@end
