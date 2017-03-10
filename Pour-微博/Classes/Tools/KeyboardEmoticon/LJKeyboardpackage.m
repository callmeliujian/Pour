//
//  LJKeyboardpackage.m
//  表情键盘
//
//  Created by 刘健 on 2017/3/8.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "LJKeyboardpackage.h"

@implementation LJKeyboardEmoticon
#pragma mark - LifeCycle
- (instancetype)initWithDict:(NSDictionary *)dict WithID:(NSString *)ID{
    self = [super init];
    self.ID = ID;
    [self setValuesForKeysWithDictionary:dict];
    
    return self;
}

- (instancetype)initisRemoveBtn:(BOOL)isRemoveBtn {
    self.isRemoveBtn = isRemoveBtn;
    return self;
}

#pragma mark - PrivateMethod
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

#pragma mark - Set
- (void)setCode:(NSString *)code {
    if (_code == nil) {
        _code = [[NSString alloc] init];
    }
    // 1.创建一个扫描器
    NSScanner *scanner = [[NSScanner alloc] initWithString:code];
    // 2.从字符串中扫描出对应的16进制数
    uint32_t result = 0;
    [scanner scanHexInt:&result];
    // 3.根据扫描的16进制创建字符串
    NSString *smiley = [[NSString alloc] initWithBytes:&result length:sizeof(result) encoding:NSUTF32LittleEndianStringEncoding];
    self.emojiStr = smiley;
}
- (void)setPng:(NSString *)png {
    NSString *path = [[NSBundle mainBundle] pathForResource:self.ID ofType:nil inDirectory:@"Emoticons.bundle"];
    self.pngPath = [path stringByAppendingPathComponent:png];
}

@end

@implementation LJKeyboardpackage

#pragma mark - LifeCycle
- (instancetype)initWithId:(NSString *)ID {
    self = [super init];
    
    self.ID = ID;
    
    return self;
}

#pragma mark - PublicMethod
- (NSMutableArray<LJKeyboardpackage *> *)loadEmotionPackages {
    NSMutableArray<LJKeyboardpackage*> *models = [NSMutableArray array];
    // 添加第0组
    LJKeyboardpackage *package = [[LJKeyboardpackage alloc] initWithId:nil];
    [package appendEmptyEmoticons];
    [models addObject:package];
    // 1.加载emoticons.plist文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emoticons.plist" ofType:nil inDirectory:@"Emoticons.bundle"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray<NSDictionary *> *array = dict[@"packages"];
    
    // 2.取出所有表情
    
    for (id packageDict in array) {
        LJKeyboardpackage *package = [[LJKeyboardpackage alloc] initWithId:packageDict[@"ID"]];
        [package loadEmoticons];
        [package appendEmptyEmoticons];
        [models addObject:package];
    }
    
    return models;
}

- (void)addFavourtEmoticon:(LJKeyboardEmoticon *)emoticon {
    [self.emoticons removeLastObject];
    
    // 判断表情是否添加过了
    if (![self.emoticons containsObject:emoticon]) {
        [self.emoticons removeLastObject];
        [self.emoticons addObject:emoticon];
    }
    
    // 表情使用频率排序
    [self.emoticons sortUsingComparator:^NSComparisonResult(LJKeyboardEmoticon *obj1, LJKeyboardEmoticon *obj2) {
        return obj1.count < obj2.count;
    }];
    
    // 添加删除按钮
    [self.emoticons addObject:[[LJKeyboardEmoticon alloc] initisRemoveBtn:true]];
}

#pragma mark - PrivateMethod
/**
 加载当前组的表情数据
 */
- (void)loadEmoticons {
    // 1.拼接当前组info.plist路径
    NSString *path = [[NSBundle mainBundle] pathForResource:self.ID ofType:nil inDirectory:@"Emoticons.bundle"];
    NSString *filePath = [path stringByAppendingPathComponent:@"info.plist"];
    // 2.根据路径加载info.plist文件
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    // 3.从字典中取出组名
    self.group_name_cn = dict[@"group_name_cn"];
    // 4.从字典中取出表情
    NSArray *array = dict[@"emoticons"];
    NSMutableArray<LJKeyboardEmoticon*> *models = [NSMutableArray array];
    NSInteger index = 0;
    for (id emoticonDict in array) {
        if (index == 20) {
            LJKeyboardEmoticon *emoticon = [[LJKeyboardEmoticon alloc] initisRemoveBtn:true];
            [models addObject:emoticon];
            index = 0;
            continue;
        }
        LJKeyboardEmoticon *emoticon = [[LJKeyboardEmoticon alloc] initWithDict:emoticonDict WithID:self.ID];
        [models addObject:emoticon];
        index++;
    }
    self.emoticons = models;
    
}

/**
 第21个按钮为删除按钮
 */
- (void)appendEmptyEmoticons {
    // 判断是否为最近一组
    if (self.emoticons == nil) {
        self.emoticons = [NSMutableArray array];
    }
    // 补全按钮
    NSInteger number = self.emoticons.count % 21;
    for (NSInteger i = number; i < 20; i++) {
        LJKeyboardEmoticon *emoticon = [[LJKeyboardEmoticon alloc] initisRemoveBtn:false];
        [self.emoticons addObject:emoticon];
    }
    // 补全删除按钮
    LJKeyboardEmoticon *emoticon = [[LJKeyboardEmoticon alloc] initisRemoveBtn:true];
    [self.emoticons addObject:emoticon];
}

@end
