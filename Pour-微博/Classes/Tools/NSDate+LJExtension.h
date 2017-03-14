//
//  NSDate+LJExtension.h
//  Pour-微博
//
//  Created by 刘健 on 2017/3/14.
//  Copyright © 2017年 😄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LJExtension)

+ (NSDate *)creatDate:(NSString *)timeStr withFormatterStr:(NSString *)formatterStr;

- (NSString *)descriptionStr;

@end
