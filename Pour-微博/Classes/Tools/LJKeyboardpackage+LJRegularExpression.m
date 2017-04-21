//
//  LJKeyboardpackage+LJRegularExpression.m
//  Pour-微博
//
//  Created by 刘健 on 2017/4/19.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJKeyboardpackage+LJRegularExpression.h"
#import "LJKeyboardAttachment.h"

@implementation LJKeyboardpackage (LJRegularExpression)

+ (NSMutableAttributedString *)creatMutableAttrString:(NSString *)string withFont:(UIFont *)font {
    
    // 1.表情规则
    NSString *pattern = @"\\[.*?\\]";
    
    // 2.创建正则表达式对象
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) return nil;
    
    // 3.匹配结果
    NSArray *results = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    
    // 4.创建属性字符串
    NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    // 5.遍历属性字符串
    // ⚠️要从后往前遍历，因一旦强文字替换成表情之后字符串的长度就会改变会导致 array 中的range 不正确，从后往前遍历则不会出现这样的问题，因为range是从前往后计算的
    for (NSInteger i = results.count - 1; i >= 0; i --) {
        NSTextCheckingResult *result = results[i];
        NSString *chs = [string substringWithRange:result.range];
        NSString *pngPath = [self findPngPath:chs];
        
        if (!pngPath) {
            continue;
        } else {
            LJKeyboardAttachment *attachment = [[LJKeyboardAttachment alloc] init];
            attachment.image = [UIImage imageWithContentsOfFile:pngPath];
            attachment.bounds = CGRectMake(0, -4, font.lineHeight, font.lineHeight);
            NSAttributedString *emoAttrStr = [NSAttributedString attributedStringWithAttachment:attachment];
            [mutableAttStr replaceCharactersInRange:result.range withAttributedString:emoAttrStr];
        }
    }
    return mutableAttStr;
    
}

/**
 根据照片的 chs 来查找该照片的路径

 @param string chs
 @return 照片路径
 */
+ (NSString *)findPngPath:(NSString *)string {
    LJKeyboardpackage *boardPackage = [[LJKeyboardpackage alloc] init];
    NSMutableArray *packages = [boardPackage loadEmotionPackages];
    
    NSMutableArray *emoticons = nil;
    // 遍历每一个表情包
    for (LJKeyboardpackage *package in packages) {
        if (package.emoticons) {
            emoticons = package.emoticons;
        } else {
            NSLog(@"该表情包没有值");
            continue;
        }
        
        NSString *pngPath;
        // 遍历表情包中的表情
        for (LJKeyboardEmoticon *emoticon in emoticons) {
            NSString *emoticonChs = nil;
            if (emoticon.chs) {
                emoticonChs = emoticon.chs;
            } else {
                continue;
            }
            
            if ([emoticonChs isEqualToString:string]) {
                pngPath = emoticon.pngPath;
                break;
            }
        }
        
        if (pngPath) {
            return pngPath;
        }
        
    }
    return nil;
}

@end
