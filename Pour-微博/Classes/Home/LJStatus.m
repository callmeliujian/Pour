//
//  LJStatus.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/5.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJStatus.h"


@implementation LJStatus

- (instancetype)initWithDic:(NSDictionary *)dic {
    
    [self setValuesForKeysWithDictionary:dic];
    
    return self;
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key  isEqual: @"user"]) {
        LJUser *user = [[LJUser alloc] initWithDic:value];
        self.user = user;
        return;
    }
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
