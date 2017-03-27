//
//  LJKeyboardEmoticonViewController.h
//  表情键盘
//
//  Created by 刘健 on 2017/3/7.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJKeyboardpackage.h"

@interface LJKeyboardEmoticonViewController : UIViewController

@property (nonatomic, copy) void(^emoticonBlock)(LJKeyboardEmoticon *emoticon);

- (instancetype)initWithEmoticonBlock:(void (^)(LJKeyboardEmoticon *emoticon))block;

@end
