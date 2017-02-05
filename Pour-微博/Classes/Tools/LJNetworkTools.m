//
//  LJNetworkTools.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/2.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJNetworkTools.h"

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

@end
