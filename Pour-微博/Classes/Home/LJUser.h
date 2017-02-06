//
//  LJUser.h
//  Pour-微博
//
//  Created by 刘健 on 2017/2/5.
//  Copyright © 2017年 😄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJUser : NSObject
/**
 字符串型的用户UID
 */
@property (nonatomic, strong) NSString *idstr;

/**
 用户昵称
 */
@property (nonatomic, strong) NSString *screen_name;

/**
 用户头像地址（中图），50×50像素
 */
@property (nonatomic, strong) NSString *profile_image_url;

/**
 用户认证类型
 */
@property (nonatomic, assign) int verified_type;

/**
 会员等级，范围1～6
 */
@property (nonatomic, assign) int mbrank;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
