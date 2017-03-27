//
//  LJKeyboardTextView.h
//  表情键盘
//
//  Created by 刘健 on 2017/3/27.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJKeyboardpackage.h"

@interface LJKeyboardTextView : UITextView

/**
 插入表情
 */
- (void)insertEmoticon:(LJKeyboardEmoticon *)emoticon;

/**
 将textview中的内容转换成字符串（emoji表情、浪小花表情等）
 */
- (NSString *)emoticonStr;

@end
