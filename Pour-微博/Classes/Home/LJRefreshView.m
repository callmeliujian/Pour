//
//  LJRefreshView.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/16.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJRefreshView.h"
#import "Masonry.h"

@interface LJRefreshView ()

@property (nonatomic, strong) UIView *maskView;

/**
 正在刷新
 */
@property (nonatomic, strong) UILabel *tipLabel;
/**
 下拉刷新
 */
@property (nonatomic, strong) UILabel *pullDownToRefreshLabel;

@end

@implementation LJRefreshView

#pragma mark - LifeCycle
-(instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    [self addSubview:self.maskView];
    [self.maskView addSubview:self.loadingImageView];
    [self.maskView addSubview:self.tipLabel];
    [self.maskView addSubview:self.tipView];
    [self.tipView addSubview:self.arrowImageView];
    [self.tipView addSubview:self.pullDownToRefreshLabel];
    
    [self buildMaskView];
    [self buildloadingImageView];
    [self buildtipLabel];
    [self buildTipView];
    [self buildArrowImageView];
    [self buildPullDownToRefreshLabel];
    
    return self;
}

#pragma mark - PublicMethod

/**
 旋转箭头
 */
- (void)rotationArrow:(BOOL)flag {
    CGFloat angle;
    angle = flag? -0.01 : 0.01;
    angle += M_PI;
    [UIView animateWithDuration:0.5 animations:^{
        self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, angle);
    }];
}

/**
 显示加载视图
 */
- (void)startLoadingImageView {
    // 0.隐藏提示视图
    self.tipView.hidden = YES;
    
    if ([self.loadingImageView.layer animationForKey:@"lj"]) {
        // 如果添加过动画直接返回
        return;
    }
    
    // 1.创建动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    // 2.设置动画属性
    anim.toValue = [NSNumber numberWithFloat:2 * M_PI];
    anim.duration = 5.0;
    anim.repeatCount = MAXFLOAT;
    
    [self.loadingImageView.layer addAnimation:anim forKey:@"lj"];
}

- (void)stopLoadingView {
    self.tipView.hidden = false;
    [self.loadingImageView.layer removeAllAnimations];
}

#pragma mark - PrivateMehtod

- (void)buildMaskView {
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self);
    }];
}

- (void)buildloadingImageView {
    [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.left.mas_equalTo(self).mas_offset(8);
        make.top.mas_equalTo(self.mas_top).mas_offset(8);
    }];
}

- (void)buildtipLabel {
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(48);
        make.top.mas_equalTo(self.mas_top).mas_offset(15);
    }];
}

- (void)buildTipView {
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
}

- (void)buildArrowImageView {
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.left.mas_equalTo(self.tipView).mas_offset(8);
        make.top.mas_equalTo(self.tipView.mas_top).mas_offset(8);
    }];
}

- (void)buildPullDownToRefreshLabel {
    [self.pullDownToRefreshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(48);
        make.top.mas_equalTo(self.mas_top).mas_offset(12);
    }];
}

#pragma mark - lazy
- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor whiteColor];
    }
    return _maskView;
}

- (UIImageView *)loadingImageView {
    if (_loadingImageView == nil) {
        _loadingImageView = [[UIImageView alloc] init];
        _loadingImageView.image = [UIImage imageNamed:@"tableview_loading"];
    }
    return _loadingImageView;
}

- (UILabel *)tipLabel {
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"正在刷新...";
        _tipLabel.textColor = [UIColor blackColor];
        [_tipLabel sizeToFit];
        _tipLabel.backgroundColor = [UIColor whiteColor];
    }
    return _tipLabel;
}

- (UIView *)tipView {
    if (_tipView == nil) {
        _tipView = [[UIView alloc] init];
        _tipView.backgroundColor = [UIColor whiteColor];
    }
    return _tipView;
}

- (UIImageView *)arrowImageView {
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"tableview_pull_refresh"];
    }
    return _arrowImageView;
}

- (UILabel *)pullDownToRefreshLabel {
    if (_pullDownToRefreshLabel == nil) {
        _pullDownToRefreshLabel = [[UILabel alloc] init];
        _pullDownToRefreshLabel.text = @"下拉刷新";
        _pullDownToRefreshLabel.textColor = [UIColor blackColor];
        [_pullDownToRefreshLabel sizeToFit];
    }
    return _pullDownToRefreshLabel;
}

@end
