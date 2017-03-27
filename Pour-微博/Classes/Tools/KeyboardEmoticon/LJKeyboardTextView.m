//
//  LJKeyboardTextView.m
//  表情键盘
//
//  Created by 刘健 on 2017/3/27.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "LJKeyboardTextView.h"
#import "LJKeyboardAttachment.h"

@implementation LJKeyboardTextView

- (void)insertEmoticon:(LJKeyboardEmoticon *)emoticon {
    __weak typeof(self) weakSelf = self;
    // 1.emoji表情图文混排
    if (emoticon.emojiStr) {
        // 取出光标所在位置
        UITextRange *range = weakSelf.selectedTextRange;
        [weakSelf replaceRange:range withText:emoticon.emojiStr];
    }
    
    // 2.新浪的图片的图文混排
    if (emoticon.pngPath) {
        // 创建原有文字属性字符串
        NSMutableAttributedString *attrMStr = [[NSMutableAttributedString alloc] initWithAttributedString:weakSelf.attributedText];
        // 创建图片属性字符串
        LJKeyboardAttachment *attachment = [[LJKeyboardAttachment alloc] init];
        attachment.emoticonChs = emoticon.chs;
        attachment.bounds = CGRectMake(0, -4, weakSelf.font.lineHeight, weakSelf.font.lineHeight);
        attachment.image = [UIImage imageWithContentsOfFile:emoticon.pngPath];
        NSAttributedString *imageAttrStr = [NSAttributedString attributedStringWithAttachment:attachment];
        // 将光标所在位置的字符串进行替换
        NSRange range = weakSelf.selectedRange;
        [attrMStr replaceCharactersInRange:range withAttributedString:imageAttrStr];
        // 显示
        weakSelf.attributedText = attrMStr;
        // 重新设置光标位置
        weakSelf.selectedRange = NSMakeRange(range.location + 1, 0);
        // 重新设置大小
        weakSelf.font = [UIFont systemFontOfSize:14.0];
    }
    
    // 3.删除最近一个文字或者表情
    if (emoticon.isRemoveBtn) {
        [weakSelf deleteBackward];
    }
    
}

- (NSString *)emoticonStr {
    
    NSRange range = NSMakeRange(0, self.attributedText.length);
    NSMutableString *mutableStr = [[NSMutableString alloc] init];
    
    [self.attributedText enumerateAttributesInRange:range options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        LJKeyboardAttachment *tempAttachment = attrs[@"NSAttachment"];
        if (tempAttachment) {
            [mutableStr appendString:tempAttachment.emoticonChs];
        } else {
            [mutableStr appendString:[self.text substringWithRange:range]];
        }
    }];
    
    NSLog(@"%@",mutableStr);
    
    return mutableStr;
    
}

@end
