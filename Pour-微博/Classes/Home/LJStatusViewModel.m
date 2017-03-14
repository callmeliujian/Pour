//
//  LJStatusViewModel.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/7.
//  Copyright © 2017年 😄. All rights reserved.
//
// M: 模型(保存数据)
// V: 视图(展现数据)
// C: 控制器(管理模型和视图, 桥梁)
// VM:
// 作用: 1.可以对M和V进行瘦身
//      2.处理业务逻辑


#import "LJStatusViewModel.h"
#import "NSDate+LJExtension.h"

@interface LJStatusViewModel()

@end

@implementation LJStatusViewModel

- (instancetype)initWithStatus:(LJStatus *)status {
    self.status = status;
    // 1.处理头像
    self.icon_URL = [NSURL URLWithString:self.status.user.profile_image_url];
    
    // 2.处理会员图标
    if (self.status.user.mbrank >= 1 && self.status.user.mbrank <= 6) {
        NSString *stringInt = [NSString stringWithFormat:@"%d",self.status.user.mbrank];
        NSString *imageName = [@"common_icon_membership_level" stringByAppendingString:stringInt];
        self.mbrankImage = [UIImage imageNamed:imageName];
    }
    
    // 3.处理认证图片
    switch (_status.user.verified_type) {
        case 0:
            self.verified_image = [UIImage imageNamed:@"avatar_vip"];
            break;
        case 2:
        case 3:
        case 5:
            self.verified_image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
        case 220:
            self.verified_image = [UIImage imageNamed:@"avatar_grassroot"];
        default:
            self.verified_image = nil;
            break;
    }
    
    // 4.处理时间
    // Tue Mar 14 10:18:49 +0800 2017
    NSString *timeStr = self.status.created_at;
    if (timeStr) {
        // 1.将服务器返回的时间格式化NSDate
        NSDate *creatDate = [NSDate creatDate:timeStr withFormatterStr:@"EE MM dd HH:mm:ss Z yyyy"];
        self.created_Time = [creatDate descriptionStr];
    }

    
    // 5.处理配图URL
    if (self.status.retweeted_status.pic_urls.count != 0) {
        for (id dict in self.status.retweeted_status.pic_urls) {
            NSString *urlStr = dict[@"thumbnail_pic"];
            NSURL *url = [NSURL URLWithString:urlStr];
            [self.thumbnail_pic addObject:url];
            [self.bmiddle_pic addObject:[urlStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"]];
        }
    } else {
        for (id dict in self.status.pic_urls) {
            NSString *urlStr = dict[@"thumbnail_pic"];
            NSURL *url = [NSURL URLWithString:urlStr];
            [self.thumbnail_pic addObject:url];
            [self.bmiddle_pic addObject:[urlStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"]];
        }
    }
    
    // 6.处理转发正文
    if (self.status.retweeted_status.text) {
        if (self.status.retweeted_status.user.screen_name) {
            NSString *str = [@"@" stringByAppendingString:self.status.retweeted_status.user.screen_name];
            self.forwardText = [str stringByAppendingString:self.status.retweeted_status.text];
        } else {
            NSString *str = @"微博已被删除";
            self.forwardText = [str stringByAppendingString:self.status.retweeted_status.text];
        }
    }
    return self;
}

- (NSMutableArray *)thumbnail_pic {
    if (_thumbnail_pic == nil) {
        _thumbnail_pic = [[NSMutableArray alloc] init];
    }
    return _thumbnail_pic;
}

- (NSMutableArray *)bmiddle_pic {
    if (_bmiddle_pic == nil) {
        _bmiddle_pic = [[NSMutableArray alloc] init];
    }
    return _bmiddle_pic;
}

@end
