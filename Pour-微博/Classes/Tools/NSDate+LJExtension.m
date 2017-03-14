//
//  NSDate+LJExtension.m
//  Pour-微博
//
//  Created by 刘健 on 2017/3/14.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "NSDate+LJExtension.h"

@implementation NSDate (LJExtension)

+ (NSDate *)creatDate:(NSString *)timeStr withFormatterStr:(NSString *)formatterStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatterStr;
    
    // 如果不指定以下代码，在真机中可能无法转换
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    return [formatter dateFromString:timeStr];
}

/**
 刚刚(一分钟内)
 X分钟前(一小时内)
 X小时前(当天)
 
 昨天 HH:mm(昨天)
 
 MM-dd HH:mm(一年内)
 yyyy-MM-dd HH:mm(更早期)
 */

/**
 生成当前时间对应的字符串
 */
- (NSString *)descriptionStr {
    // 1.创建时间格式化对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    
    // 2.创建一个日历类
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 3.定义变量记录时间格式
    NSString *formatterStr = @"HH:mm";
    
    // 4.判断是否为今天
    if ([calendar isDateInToday:self]) {
        // 今天
        // 比较两个时间之间的差值
        
        NSTimeInterval interval = [[NSDate new]timeIntervalSinceDate:self];
        if (interval < 60.0) {
            return @"刚刚";
        } else if (interval < 60.0 *60.0) {
            return [[NSString stringWithFormat:@"%d",(int)(interval / 60.0)] stringByAppendingString:@"分钟前"];
        } else if (interval < 60.0 * 60.0 * 24) {
            return [[NSString stringWithFormat:@"%d",(int)(interval / (60.0 * 60.0))] stringByAppendingString:@"小时前"];
        }
        
    } else if ([calendar isDateInYesterday:self]) {
        // 昨天
        formatterStr = [@"昨天" stringByAppendingString:formatterStr];
    } else {
        NSDateComponents *comps = [calendar components:NSCalendarUnitYear fromDate:self toDate:[NSDate new] options:NSCalendarWrapComponents];
        if (comps.year >= 1) {
            // 更早时间
            formatterStr = [@"yyyy-MM-dd " stringByAppendingString:formatterStr];
        } else {
            // 一年以内
            formatterStr = [@"MM-dd " stringByAppendingString:formatterStr];
        }
    }
    formatter.dateFormat = formatterStr;
    return [formatter stringFromDate:self];
}


@end
