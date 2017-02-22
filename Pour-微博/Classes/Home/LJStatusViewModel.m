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
    
//    // 4.处理来源
//    if (self.status.created_at != nil) {
//        // 1.将服务器返回的时间转换为NSDate
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"EE MM dd HH:mm:ss Z yyyy";
//        // 不指定以下代码在真机中可能无法转换
//        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
//        NSDate *createDate = [formatter dateFromString:_status.created_at];
//        
//        // 创建一个日历类
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSString *result = @"";
//        NSString *formatterStr = @"HH:mm";
//        if ([calendar isDateInToday:createDate]) {
//            //今天
//            // 3.比较两个时间之间的差值
//            NSTimeInterval interval = [createDate timeIntervalSinceNow];
//            if ((-interval) < 60 ) {
//                result = @"刚刚";
//            }else if((-interval) < 60 *60){
//                NSString *stringInterbal = [NSString stringWithFormat:@"%d",(int)(-interval) / 60 ];
//                result = [stringInterbal stringByAppendingString:@"分钟前"];
//            }else if ([calendar isDateInYesterday:createDate]){
//                formatterStr = [@"昨天" stringByAppendingString:formatterStr];
//                formatter.dateFormat = formatterStr;
//                result = [formatter stringFromDate:createDate];
//            }else{
//                NSDateComponents *comps = [calendar components:NSCalendarUnitYear fromDate:createDate toDate:[NSDate init] options:NSCalendarWrapComponents];
//                if (comps.year >= 1) {
//                    formatterStr = [@"yyyy-MM-dd" stringByAppendingString:formatterStr];
//                }else{
//                    formatterStr = [@"MM-dd" stringByAppendingString:formatterStr];
//                }
//                formatter.dateFormat = formatterStr;
//                result = [formatter stringFromDate:createDate];
//            }
//            self.created_Time = result;
//        }
//    }
    
    self.created_Time = @"123";
    
    // 5.处理配图URL
    //if (self.status.pic_urls.count!= 0) {
    if (self.status.retweeted_status.pic_urls.count != 0) {
        
        for (id dict in self.status.retweeted_status.pic_urls) {
            NSString *urlStr = dict[@"thumbnail_pic"];
            NSURL *url = [NSURL URLWithString:urlStr];
            [self.thumbnail_pic addObject:url];
            [self.bmiddle_pic addObject:[urlStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"]];
        }
        
    }else{
        for (id dict in self.status.pic_urls) {
            NSString *urlStr = dict[@"thumbnail_pic"];
            NSURL *url = [NSURL URLWithString:urlStr];
            [self.thumbnail_pic addObject:url];
            [self.bmiddle_pic addObject:[urlStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"]];
        }
    }
    
    // 6.处理转发正文
    if (self.status.retweeted_status.text) {
//        if (self.status.retweeted_status.user) {
//            NSString *str = [@"@" stringByAppendingString:self.status.retweeted_status.user.screen_name];
//            self.forwardText = [str stringByAppendingString:self.status.retweeted_status.text];
//        }
        //self.forwardText = @"抱歉，此微博已被作者删除。";
        NSString *str = [@"@" stringByAppendingString:self.status.retweeted_status.user.screen_name];
        self.forwardText = [str stringByAppendingString:self.status.retweeted_status.text];
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
