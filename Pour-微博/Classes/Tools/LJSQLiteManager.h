//
//  LJSQLiteManager.h
//  Pour-微博
//
//  Created by 刘健 on 2017/4/21.
//  Copyright © 2017年 😄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface LJSQLiteManager : NSObject

/**
 数据库队列对象
 */
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

/**
 生成单例对象
 */
+ (LJSQLiteManager *)shareInstance;

/**
 通过数据的名字打开数据库

 @param dbName 数据库名字
 */
- (void)opendbWithdbName:(NSString *)dbName;

@end
