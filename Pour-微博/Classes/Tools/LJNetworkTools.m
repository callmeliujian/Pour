//
//  LJNetworkTools.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/2.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJNetworkTools.h"
#import "LJUserAccount.h"

@implementation LJNetworkTools

+ (LJNetworkTools *)shareInstance {
    static LJNetworkTools *shareNetworkToolsInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *baseURL = [NSURL URLWithString:@"https://api.weibo.com/"];
        shareNetworkToolsInstance = [[self alloc] initWithBaseURL:baseURL sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSSet *set = [NSSet setWithObjects:@"text/plain",@"application/json", @"text/json", @"text/javascript", nil];
        shareNetworkToolsInstance.responseSerializer.acceptableContentTypes = set;
    });
    return shareNetworkToolsInstance;
}

- (void)loadStatuses:(void (^)(NSArray *, NSError *))block {
    
    NSAssert([LJUserAccount loadUserAccout] != nil, @"必须授权之后才能获取数据");
    
    // 1.准备路径
    NSString *path = @"2/statuses/home_timeline.json";
    // 2.准备参数
    NSDictionary *parameters = @{@"access_token": [LJUserAccount loadUserAccout].access_token};
    // 3.发送GET请求
    [self GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        block([responseObject objectForKey:@"statuses"],nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
    
}

@end
