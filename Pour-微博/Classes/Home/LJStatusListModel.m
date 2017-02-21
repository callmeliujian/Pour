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

#import <SDWebImage/UIImageView+WebCache.h>

@interface LJStatusListModel ()



@end

@implementation LJStatusListModel

/**
 调用LJNetworkTools的loadStatuses获取主页微博数据
 */
- (void)loadData:(BOOL)lastStatus finished:(void(^)(NSMutableArray*,NSError*))finishedBlock {
    
    LJStatusViewModel *statusViewModel = [self.statuses firstObject];
    NSString *since_id = statusViewModel.status.idstr;
    if (since_id == nil) {
        since_id = @"0";
    }
    NSString *max_id = @"0";
    if (lastStatus) {
        since_id = @"0";
        LJStatusViewModel *max_id_statusViewModel = [self.statuses lastObject];
        if (max_id_statusViewModel.status.idstr) {
            max_id = max_id_statusViewModel.status.idstr;
        }
    }
    
    
    
    [[LJNetworkTools shareInstance] loadStatuses:since_id withMax_id:max_id withBlock:^(NSString *since_id, NSArray *array, NSError *error) {
        // 1.安全校验
        if (error != nil) {
//            [SVProgressHUD showErrorWithStatus:@"获取微博数据失败"];
//            NSLog(@"----%@",error);
            finishedBlock(nil,error);
            return;
        }
        
        // 2.字典数组转化为模型数组
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        self.statuses = [[NSMutableArray alloc] init];
        for (id dic in array) {
            LJStatus *model = [[LJStatus alloc] init];
            id status = [model initWithDic:dic];
            LJStatusViewModel *viewModel = [[LJStatusViewModel alloc] initWithStatus:status];
            [mutableArray addObject:viewModel];
        }
        
        // 3.处理微博数据
        if (![since_id isEqualToString:@"0"]) {
            NSArray *array = [NSArray arrayWithArray:mutableArray];
            self.statuses = [mutableArray arrayByAddingObjectsFromArray:array];
            
        }else if (![max_id isEqualToString:@"0"]){
            NSArray *array = [NSArray arrayWithArray:mutableArray];
            self.statuses = [array arrayByAddingObjectsFromArray:mutableArray];
        }
        else {
            self.statuses = mutableArray;
        }
        
        
        // 4.缓存微博所有配图
        [self cachesImages:mutableArray finished:finishedBlock];
        
//        // 5.关闭菊花
//        
//        
//        // 6.显示刷新提醒
//        
        
    }];
}

/**
 缓存配图
 
 @param viewModels <#viewModels description#>
 */
- (void)cachesImages:(NSArray *)viewModels finished:(void(^)(NSMutableArray*,NSError*))finishedBlock{
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
                    NSLog(@"success");
                    dispatch_group_leave(group);
                }];
                
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"all");
            
            finishedBlock(viewModels,nil);
            
        });
    }
}

#pragma mark - lazy
- (void)setStatuses:(NSMutableArray *)statuses {
    if (_statuses != statuses && statuses.count != 0) {
        _statuses = statuses;
    }
}

@end
