//
//  LJUser.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/5.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJUser.h"

@implementation LJUser

- (instancetype)initWithDic:(NSDictionary *)dic {
    
    [self setValuesForKeysWithDictionary:dic];
    
    return self;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
