//
//  LJPresentationController.m
//  Pour-微博
//
//  Created by 😄 on 2016/12/12.
//  Copyright © 2016年 😄. All rights reserved.
//

#import "LJPresentationController.h"
#import "LJPresentationManager.h"

@interface LJPresentationController()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIButton *coverButton;

@end

@implementation LJPresentationController

- (UIButton *)coverButton
{
    if (_coverButton == nil) {
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = [UIScreen mainScreen].bounds;
        _coverButton = btn;
        [btn addTarget:self action:@selector(coverButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverButton;
}

/**
 布局转场动画弹出的空间
 */
- (void)containerViewWillLayoutSubviews
{
    self.presentedView.frame = CGRectMake(100, 45, 200, 200);
    [self.containerView insertSubview:self.coverButton atIndex:0];
}

/**
 coverButton按钮点击事件
 */
- (void)coverButtonClicked
{
    LJPresentationManager *pm = [[LJPresentationManager alloc] init];
    self.presentedViewController.transitioningDelegate = pm;
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
