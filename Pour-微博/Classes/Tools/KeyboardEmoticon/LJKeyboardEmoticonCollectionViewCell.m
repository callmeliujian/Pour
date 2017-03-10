//
//  LJKeyboardEmoticonCollectionViewCell.m
//  表情键盘
//
//  Created by 刘健 on 2017/3/8.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "LJKeyboardEmoticonCollectionViewCell.h"

@interface LJKeyboardEmoticonCollectionViewCell ()

@property (nonatomic, strong) UIButton *iconButton;

@end

@implementation LJKeyboardEmoticonCollectionViewCell

#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [self setupUI];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    [self setupUI];
    
    return self;
}

#pragma mark - PrivateMethod
- (void)setupUI {
    [self.contentView addSubview:self.iconButton];
    
    self.iconButton.frame = CGRectInset(self.bounds, 3, 3);
}

#pragma mark - Lazy
- (UIButton *)iconButton {
    if (_iconButton == nil) {
        _iconButton = [[UIButton alloc] init];
        _iconButton.backgroundColor = [UIColor whiteColor];
        _iconButton.titleLabel.font = [UIFont systemFontOfSize:30];
        _iconButton.userInteractionEnabled = false;
    }
    return _iconButton;
}

#pragma mark - Set
- (void)setEmoticon:(LJKeyboardEmoticon *)emoticon {
    // 显示emoji表情
    [self.iconButton setTitle:emoticon.emojiStr forState:UIControlStateNormal];
    // 设置图片biaoq
    [self.iconButton setImage:nil forState:UIControlStateNormal];
    if (emoticon.chs != nil) {
        [self.iconButton setImage:[UIImage imageWithContentsOfFile:emoticon.pngPath] forState:UIControlStateNormal];
    }
    // 设置删除按钮
    if (emoticon.isRemoveBtn) {
        [self.iconButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [self.iconButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
    }
}

@end
