//
//  LJKeyboardpackage.h
//  表情键盘
//
//  Created by 刘健 on 2017/3/8.
//  Copyright © 2017年 刘健. All rights reserved.
//

/**
 说明：
 1. Emoticons.bundle 的根目录下存放的 emoticons.plist 保存了 packages 表情包信息
    >packages 是一个数组, 数组中存放的是字典
    >字典中的属性 id 对应的分组路径的名称
 2. 在 id 对应的目录下，各自都保存有 info.plist
    >group_name_cn   保存的是分组名称
    >emoticons       保存的是表情信息数组
    >code            UNICODE 编码字符串
    >chs             表情文字，发送给新浪微博服务器的文本内容
    >png             表情图片，在 App 中进行图文混排使用的图片
 */

#import <Foundation/Foundation.h>

@interface LJKeyboardEmoticon : NSObject

/**
 当前表情对应的字符串
 */
@property (nonatomic, strong) NSString *chs;
/**
 当前表情对应图片
 */
@property (nonatomic, strong) NSString *png;
/**
 emoji表情对应的字符串
 */
@property (nonatomic, strong) NSString *code;
/**
 转换之后的emoji表情字符串
 */
@property (nonatomic, strong) NSString *emojiStr;
/**
 当前图片表情的绝对路径
 */
@property (nonatomic, strong) NSString *pngPath;

/**
 当前组对应的文件夹名称
 */
@property (nonatomic, strong) NSString *ID;
/**
 记录当前表情是否为删除按钮
 */
@property (nonatomic, assign) BOOL isRemoveBtn;

/**
 表情的使用频率
 */
@property (nonatomic, assign) NSUInteger count;

//- (instancetype)initWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict WithID:(NSString *)ID;

@end

@interface LJKeyboardpackage : NSObject

/**
 当前组名称
 */
@property (nonatomic, strong) NSString *group_name_cn;
/**
 当前组对应的文件夹名称
 */
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSMutableArray <LJKeyboardEmoticon*>*emoticons;

- (NSMutableArray<LJKeyboardpackage *> *)loadEmotionPackages;

- (void)addFavourtEmoticon:(LJKeyboardEmoticon *)emoticon;

@end
