//
//  LJStatus.h
//  Pour-微博
//
//  Created by 刘健 on 2017/2/5.
//  Copyright © 2017年 😄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJUser.h"

@interface LJStatus : NSObject


/**
 微博创建时间
 */
@property (nonatomic, strong) NSString *created_at;
/**
 字符串型的微博ID
 */
@property (nonatomic, strong) NSString *idstr;
/**
 微博信息内容
 */
@property (nonatomic, strong) NSString *text;
/**
 微博来源
 */
@property (nonatomic, strong) NSString *source;

/**
 微博作者用户信息
 */
@property (nonatomic, strong) LJUser *user;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
