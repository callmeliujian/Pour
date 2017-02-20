//
//  LJNetworkTools.h
//  Pour-微博
//
//  Created by 刘健 on 2017/2/2.
//  Copyright © 2017年 😄. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface LJNetworkTools : AFHTTPSessionManager

+ (LJNetworkTools *)shareInstance;

//- (void)loadStatuses:(void(^)(NSString *, NSArray *arry,NSError *error))block;
//- (void)loadStatuses:(NSString *)since_id withBlock:(void (^)(NSString *, NSArray *, NSError *))block;
- (void)loadStatuses:(NSString *)since_id withMax_id:(NSString *)max_id withBlock:(void (^)(NSString *, NSArray *, NSError *))block;
@end
