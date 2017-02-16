//
//  LJRefreshControl.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/16.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJRefreshControl.h"
#import "LJRefreshView.h"
#import "Masonry.h"

@interface LJRefreshControl ()

@property (nonatomic, strong) LJRefreshView *refreshView;


@end

@implementation LJRefreshControl

#pragma mark - LifeCycle 
- (instancetype)init {
    self = [super init];
    
    [self addSubview:self.refreshView];
    
    [self builRefreshView];
    // 监听UIRefreshControl frame改变
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    return self;
}

#pragma mark - 内部控制方法
- (void)builRefreshView {
    [self.refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 50));
        make.center.mas_equalTo(self);
    }];
}

bool rotationFlag = false;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.frame.origin.y == 0 || self.frame.origin.y == -64) {
        return;
    }
    
    if (self.frame.origin.y < -50 && !rotationFlag) {
        // 向上旋转
        rotationFlag = true;
        [self.refreshView rotationArrow:rotationFlag];
    }else if (self.frame.origin.y > -50 && rotationFlag) {
        // 向下旋转
        rotationFlag = false;
        [self.refreshView rotationArrow:rotationFlag];
    }
}

#pragma mark - Lazy
- (LJRefreshView *)refreshView {
    if (_refreshView == nil) {
        _refreshView = [[LJRefreshView alloc] init];
    }
    return _refreshView;
}

@end
