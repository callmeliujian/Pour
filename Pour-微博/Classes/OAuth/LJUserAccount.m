//
//  LJUserAccount.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/3.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJUserAccount.h"

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
        return account;
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
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
    self.remind_in = [aDecoder decodeObjectForKey:@"remind_in"];
    self.uid = [aDecoder decodeObjectForKey:@"uid"];
    self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
    expireDate = [aDecoder decodeObjectForKey:@"expireDate"];
    return self;
    
}

- (void)setExpires_in:(NSNumber *)expires_in {
    // 生成过期时间
    expireDate = [NSDate dateWithTimeIntervalSinceNow:[expires_in doubleValue]];
}

@end
