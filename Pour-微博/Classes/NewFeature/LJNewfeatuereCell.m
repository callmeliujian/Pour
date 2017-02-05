//
//  LJNewfeatuereCell.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/4.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJNewfeatuereCell.h"
#import "LJMainViewController.h"

#import "Masonry.h"

@interface LJNewfeatuereCell()

@property (nonatomic, strong) UIButton *startButton;

@end

@implementation LJNewfeatuereCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    [self setupUI];
    
    return self;
}

- (void)setupUI {
    // 1.添加子控件
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.startButton];
    
    // 2.设置布局
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(padding);
    }];
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-130);
    }];
    
}

- (void)startAniamtion {
    self.startButton.hidden = false;
    self.startButton.userInteractionEnabled = false;
    self.startButton.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:6 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.startButton.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.startButton.userInteractionEnabled = true;
    }];
}

- (void)startBtnClicked {
    // 跳转到首页
    [UIApplication sharedApplication].keyWindow.rootViewController = [[LJMainViewController alloc] init];
}

#pragma mark - lazy

- (UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (void)setIndex:(NSInteger)index {
    NSString *string = @"new_feature_";
    NSString *stringInt = [NSString stringWithFormat:@"%ld",index];
    NSString *name = [string stringByAppendingString:stringInt];
    self.iconView.image = [UIImage imageNamed:name];
    
    self.startButton.hidden = true;
    if (index == 4) {
        self.startButton.hidden = false;
    }
    
}

- (UIButton *)startButton {
    if (_startButton == nil) {
        _startButton = [[UIButton alloc] init];
        [_startButton setImage:[UIImage imageNamed:@"new_feature_button_highlighted"] forState:UIControlStateSelected];
        
        [_startButton setImage:[UIImage imageNamed:@"new_feature_button"] forState:UIControlStateNormal];
        [_startButton sizeToFit];
        [_startButton addTarget:self action:@selector(startBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

@end
