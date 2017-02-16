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
    
    [self addSubview:self.loadingImageView];
    [self addSubview:self.tipLabel];
    [self addSubview:self.tipView];
    [self.tipView addSubview:self.arrowImageView];
    [self.tipView addSubview:self.pullDownToRefreshLabel];
    
    [self buildloadingImageView];
    [self buildtipLabel];
    [self buildTipView];
    [self buildArrowImageView];
    [self buildPullDownToRefreshLabel];
    
    return self;
}

#pragma mark - 外部控制方法
- (void)rotationArrow:(BOOL)flag {
    CGFloat angle;
    angle = flag? -0.01 : 0.01;
    angle += M_PI;
    [UIView animateWithDuration:0.5 animations:^{
        self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, angle);
    }];
}

#pragma mark - 内部控制方法
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
        make.top.mas_equalTo(self.mas_top).mas_offset(25);
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
    }
    return _tipLabel;
}

- (UIView *)tipView {
    if (_tipView == nil) {
        _tipView = [[UIView alloc] init];
        _tipView.backgroundColor = [UIColor purpleColor];
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
