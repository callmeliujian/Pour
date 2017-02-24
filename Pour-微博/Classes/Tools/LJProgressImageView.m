//
//  LJProgressImageView.m
//  ImageLoadingAnimation
//
//  Created by 刘健 on 2017/2/23.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "LJProgressImageView.h"
#import "LJProgressView.h"

@interface LJProgressImageView ()



@property (nonatomic, strong) LJProgressView *progressView;

@end

@implementation LJProgressImageView

#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.progress = 0;
    
    [self setupUI];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.progressView.frame = self.bounds;
}

#pragma mark - 内部控制方法
- (void)setupUI {
    [self addSubview:self.progressView];
    self.progressView.backgroundColor = [UIColor clearColor];
}


#pragma mark - Lazy
- (LJProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[LJProgressView alloc] init];
    }
    return _progressView;
}

#pragma mark - Set 
- (void)setProgress:(CGFloat)progress {
    if (_progress != progress) {
        _progress = progress;
    }
    
    self.progressView.progress = _progress;
    
}

@end
