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

- (void)loadStatuses:(void(^)(NSArray *arry,NSError *error))block;

@end
