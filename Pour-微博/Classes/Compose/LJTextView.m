//
//  LJTextView.m
//  Pour-微博
//
//  Created by 刘健 on 2017/3/5.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJTextView.h"

#import "Masonry.h"

@interface LJTextView ()

@property (nonatomic, strong) UILabel *placeholder;

@end

@implementation LJTextView

#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    
    [self setupUI];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    [self setupUI];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - PrivateMethod
- (void)setupUI {
    [self addSubview:self.placeholder];
    
    [self.placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(4);
        make.top.mas_equalTo(8);
    }];
    
    // 监听文本是否有改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)textDidChange {
    self.placeholder.hidden = [self hasText];
}

#pragma maek - Lazy
- (UILabel *)placeholder {
    if (_placeholder == nil) {
        _placeholder = [[UILabel alloc] init];
        _placeholder.text = @"分享新鲜事...";
        _placeholder.textColor = [UIColor lightGrayColor];
        _placeholder.font = self.font;
    }
    return _placeholder;
}

@end
