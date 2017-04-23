//
//  LJSQLiteManager.m
//  Pour-微博
//
//  Created by 刘健 on 2017/4/21.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJSQLiteManager.h"

@implementation LJSQLiteManager

+ (LJSQLiteManager *)shareInstance {
    static LJSQLiteManager *shareinstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareinstance = [[LJSQLiteManager alloc] init];
    });
    return shareinstance;
}

- (void)opendbWithdbName:(NSString *)dbName {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject];
    NSString *filePath = [path stringByAppendingPathComponent:dbName];
    NSLog(@"%@",filePath);
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    [self creatTable];
}

/**
 创建表
 */
- (void)creatTable {
    NSString *createTableSQL = @"CREATE TABLE IF NOT EXISTS t_status ('statusID' INTEGER NOT NULL PRIMARY KEY,'statusText' TEXT,'userID' INTEGER, 'createTime' text default (datetime('now', 'localtime')));";
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdate:createTableSQL withArgumentsInArray:nil]) {
            NSLog(@"创建表成功");
        }
    }];
}

@end
