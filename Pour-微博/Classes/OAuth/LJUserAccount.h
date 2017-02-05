//
//  LJUserAccount.h
//  Pour-微博
//
//  Created by 刘健 on 2017/2/3.
//  Copyright © 2017年 😄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJUserAccount : NSObject

@property (nonatomic, strong) NSString *access_token;
// 从授权那一开始经过多少秒过期 api获得
@property (nonatomic, assign) NSNumber *expires_in;


@property (nonatomic, strong) NSString *remind_in;

@property (nonatomic, strong) NSString *uid;
// 用户昵称
@property (nonatomic, strong) NSString *screen_name;

// 用户头像地址（高清），高清头像原图
@property (nonatomic, strong) NSString *avatar_hd;

- (LJUserAccount* )initWithDict:(NSDictionary *)dict;

// 保存授权信息
- (BOOL) saveAccout;

// 加载授权信息
+ (LJUserAccount *) loadUserAccout;

+ (BOOL)isLogin;

- (void)loadUserInfo:(void(^)())block;

@end
