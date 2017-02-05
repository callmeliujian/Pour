//
//  LJUserAccount.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/3.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJUserAccount.h"
#import "LJNetworkTools.h"

@interface LJUserAccount() <NSCoding>

@end

static LJUserAccount *account;
// 真正过期时间
static NSDate *expireDate;

@implementation LJUserAccount

- (LJUserAccount*)initWithDict:(NSDictionary *)dict {
    [self setValuesForKeysWithDictionary:dict];
    return self;
}

// 当kvc发现没有对应的key时就会调用
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

- (NSString *)description {
    return [NSString stringWithFormat:@"access_token: %@ expires_in: %@ remind_in: %@ uid: %@",self.access_token,self.expires_in,self.remind_in,self.uid];
}

+ (LJUserAccount *)loadUserAccout {
    // 1.判断是否加载过了
    if (account != nil) {
        // 已经有过登陆数据
        return account;
    }
    // 从文件获取登陆数据
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true)lastObject];
    // 生成缓存路径
    NSString *filePath = [path stringByAppendingString:@"useraccount.plist"];
    
    LJUserAccount *userAccout = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (userAccout == nil) {
        return nil;
    }
    
   // NSComparisonResult
    NSLog(@"%@",expireDate);
    NSLog(@"%@",[NSDate date]);
    if ([expireDate compare:[NSDate date]] == NSOrderedAscending) {
        
        return nil;
    }
    
    account = userAccout;
    
    return account;
};

- (BOOL) saveAccout {
    // 获取缓存目录的路径
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true)lastObject];
    // 生成缓存路径
    NSString *filePath = [path stringByAppendingString:@"useraccount.plist"];
    
    NSLog(@"%@",filePath);
    
    // 归档对象
    return [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

+ (BOOL)isLogin {
    return [self loadUserAccout] != nil;
}

#pragma mark - delegate
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.remind_in forKey:@"remind_in"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.expires_in forKey:@"expires_in"];
    [aCoder encodeObject:expireDate forKey:@"expireDate"];
    [aCoder encodeObject:self.avatar_hd forKey:@"avatar_hd"];
    [aCoder encodeObject:self.screen_name forKey:@"screen_name"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
    self.remind_in = [aDecoder decodeObjectForKey:@"remind_in"];
    self.uid = [aDecoder decodeObjectForKey:@"uid"];
    self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
    expireDate = [aDecoder decodeObjectForKey:@"expireDate"];
    self.avatar_hd = [aDecoder decodeObjectForKey:@"avatar_hd"];
    self.screen_name = [aDecoder decodeObjectForKey:@"screen_name"];
    return self;
    
}

- (void)setExpires_in:(NSNumber *)expires_in {
    // 生成过期时间
    expireDate = [NSDate dateWithTimeIntervalSinceNow:[expires_in doubleValue]];
}

- (void)loadUserInfo:(void (^)())block {
    
    NSAssert(self.access_token != nil, @"使用该方法必须授权");
    
    NSString *path = @"2/users/show.json";
    
    NSDictionary *parameters = @{@"access_token": self.access_token,
                                 @"uid": self.uid};
    LJNetworkTools *networkTools = [LJNetworkTools shareInstance];
    
    [networkTools GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@",responseObject);
        
        // 1. 取出用户信息
        self.avatar_hd = responseObject[@"avatar_hd"];
        self.screen_name = responseObject[@"screen_name"];
        
        block();
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

//- (void)loadUserInfo {
//    
//    NSAssert(self.access_token != nil, @"使用该方法必须授权");
//    
//    NSString *path = @"2/users/show.json";
//    
//    NSDictionary *parameters = @{@"access_token": self.access_token,
//                                 @"uid": self.uid};
//    LJNetworkTools *networkTools = [LJNetworkTools shareInstance];
//    
//    [networkTools GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //NSLog(@"%@",responseObject);
//        
//        // 1. 取出用户信息
//        self.avatar_hd = responseObject[@"avatar_hd"];
//        self.screen_name = responseObject[@"screen_name"];
//        
//        [self saveAccout];
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//    
//}

@end
