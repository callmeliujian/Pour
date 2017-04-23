//
//  LJStatusListModel.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/21.
//  Copyright © 2017年 😄. All rights reserved.
//

/*
 *since_id false	int64 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
 *max_id false int64 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
 *默认情况下, 新浪返回的数据是按照微博ID从大到小得返回给我们的
 *也就意味着微博ID越大, 这条微博发布时间就越晚
 *经过分析, 如果要实现下拉刷新需要, 指定since_id为第一条微博的id
 *如果要实现上拉加载更多, 需要指定max_id为最后一条微博id-1.
 */


#import "LJStatusListModel.h"
#import "LJStatusViewModel.h"
#import "LJNetworkTools.h"
#import "LJUserAccount.h"
#import "LJSQLiteManager.h"
#import "LJStatus.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface LJStatusListModel ()

@end

@implementation LJStatusListModel

/**
 调用LJNetworkTools的loadStatuses获取主页微博数据
 */
- (void)loadData:(BOOL)lastStatus finished:(void(^)(NSMutableArray*,NSError*))finishedBlock {
    NSString *since_id = [self.statuses firstObject].status.idstr ? : @"0";
    NSString *max_id = @"0";
    if (lastStatus) {
        since_id = @"0";
        max_id = [self.statuses lastObject].status.idstr ? : @"0";
    }
    
    // 获取userID，如果userID为空说明用户未登录所以不用刷新数据
    NSString *userID = [LJUserAccount loadUserAccout].uid;
    if (!userID) {
        NSLog(@"---------userID为空------------");
        return;
    }
    
    // 拼接select语句
    NSString *querySQL = [@"select * from t_status where userID = " stringByAppendingString:userID];
    if (![since_id isEqualToString:@"0"]) {
        NSString *temp = [@" and statusID > " stringByAppendingString:since_id];
        querySQL = [querySQL stringByAppendingString:temp];
    }else if (![max_id isEqualToString:@"0"]){
        NSString *temp = [@" and statusID < " stringByAppendingString:max_id];
        querySQL = [querySQL stringByAppendingString:temp];
    }
    querySQL = [querySQL stringByAppendingString:@" order by statusID desc limit 20;"];
    
    // 从数据库中查询数据
    [[LJSQLiteManager shareInstance].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:querySQL withArgumentsInArray:nil];
        NSMutableArray<LJStatusViewModel *> *models = [NSMutableArray array];
        while (result.next) {
            NSString *statusText = [result stringForColumn:@"statusText"];
            NSData *data = [statusText dataUsingEncoding:NSUTF8StringEncoding];
            if (!data) continue;
            NSError *error = nil;
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                NSLog(@"读取本地数据出错：%@", error);
                continue;
            }
            LJStatus *status = [[LJStatus alloc] initWithDic:dict];
            [models addObject:[[LJStatusViewModel alloc] initWithStatus:status]];
        }
        if (models.count > 0) {
            // 从本地加载数据
            NSLog(@"-----从本地获取到数据-------");
            if (![since_id isEqualToString:@"0"]) {
                [models addObjectsFromArray:self.statuses];
            }else if (![max_id isEqualToString:@"0"]){
                [self.statuses addObjectsFromArray:models];
            }
            else {
                self.statuses = models;
            }
            finishedBlock(models, nil);
            return ;
        }
        // 本地没有数据从网络加载数据
        [self loadDataFromNetWorkWithSice_id:since_id withMax_id:max_id finished:finishedBlock];
    }];
}

/**
 从网络获取数据
 */
- (void)loadDataFromNetWorkWithSice_id:since_id withMax_id:max_id finished:(void(^)(NSMutableArray*,NSError*))finishedBlock {
    [[LJNetworkTools shareInstance] loadStatuses:since_id withMax_id:max_id withBlock:^(NSString *since_id, NSArray *array, NSError *error) {
        NSLog(@"-------从网络获取数据-------");
        // 1.安全校验
        if (error != nil) {
            finishedBlock(nil,error);
            return;
        }
        
        // 2.字典数组转化为模型数组
        NSMutableArray *models = [[NSMutableArray alloc] init];
        for (id dic in array) {
            LJStatus *status = [[LJStatus alloc] initWithDic:dic];
            LJStatusViewModel *viewModel = [[LJStatusViewModel alloc] initWithStatus:status];
            [models addObject:viewModel];
        }
        
        // 3.处理微博数据
        if (![since_id isEqualToString:@"0"]) {
            
            [models addObjectsFromArray:self.statuses];
        }else if (![max_id isEqualToString:@"0"]){
            [self.statuses addObjectsFromArray:models];
        }
        else {
            self.statuses = models;
        }
        
        // 4.缓存微博所有配图
        [self cachesImages:models finished:finishedBlock];
        
        // 5.缓存微博数据到数据库
        [self cacheData:array];
        
    }];
}

/**
 缓存微博内容到数据库
 数据库的主键为statusID既微博id
 statusText为微博数据，强json所有的字段合为一个字符串存到此处
 userid存贮当前登陆的用户id
 @param list 模型数组
 */
- (void)cacheData:(NSArray<NSDictionary *> *)list {
    // 判断userID是否为空
    NSString *userID = [LJUserAccount loadUserAccout].uid;
    if (!userID) {
        NSLog(@"----------userID为空-------------");
        return;
    }
    for (NSDictionary *dict in list) {
        // 判断statusID是否为空
        NSString *statusID = dict[@"idstr"];
        if (!statusID) {
            NSLog(@"-------------statusid（微博id）为空");
            return;
        }
        
        // 将微博数据转化为字符串
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            NSLog(@"---转化为字符串失败---error：%@----",error);
            continue;
        }
        NSString *statusText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!statusText) {
            NSLog(@"-----没有数据-------");
            continue;
        }
        
        // 插入到数据库
        NSString *insertSQL = @"insert into t_status (statusID, statusText, userID) values (?, ?, ?)";
        [[LJSQLiteManager shareInstance].dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:insertSQL withArgumentsInArray:@[statusID, statusText, userID]];
        }];
    }
}

/**
 缓存配图
 
 @param viewModels <#viewModels description#>
 */
- (void)cachesImages:(NSMutableArray *)viewModels finished:(void(^)(NSMutableArray*,NSError*))finishedBlock{
    
    if (viewModels.count == 0) {
        return;
    }
    
    // 0.创建一个组
    dispatch_group_t group = dispatch_group_create();
    for (LJStatusViewModel *viewModel in viewModels) {
        
        // 1.从模型中取出数组配图
        if (viewModel.thumbnail_pic) {
            // 2.遍历数组配图下载图片
            for (NSURL*url in viewModel.thumbnail_pic) {
                // 将当前的下载操作加入到组中
                dispatch_group_enter(group);
                
                [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    //NSLog(@"success");
                    dispatch_group_leave(group);
                }];
                
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            finishedBlock(viewModels,nil);
            
        });
    }
}

/**
 清楚缓存数据 默认清除3天前的
 */
+ (void)cleanCacheDate {
    NSDate *threeDatesAgo = [NSDate dateWithTimeIntervalSinceNow: -3 * 24 * 60 * 60];
    // 删除20s前数据
    NSDate *temp = [NSDate dateWithTimeIntervalSinceNow: -30];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 2017-04-23 11:49:16
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [dateFormatter stringFromDate:threeDatesAgo];
    
    NSString *deleteSQL = [@"delete from t_status where createTime < '" stringByAppendingString: dateString];
    deleteSQL = [deleteSQL stringByAppendingString:@"'"];
    deleteSQL = [deleteSQL stringByAppendingString:@";"];
    [[LJSQLiteManager shareInstance].dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSQL withVAList:nil];
    }];
}

#pragma mark - lazy
- (void)setStatuses:(NSMutableArray *)statuses {
    if (_statuses != statuses && statuses.count != 0) {
        _statuses = statuses;
    }
}

@end
