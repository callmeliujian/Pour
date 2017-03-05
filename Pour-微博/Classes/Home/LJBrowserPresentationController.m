//
//  LJBrowserPresentationController.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/27.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJBrowserPresentationController.h"

@interface LJBrowserPresentationController ()<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

/**
 定义标记记录当前是否是展现
 */
@property (nonatomic, assign) BOOL isPresent;
/**
 当前点击图片对应的索引
 */
@property (nonatomic, strong) NSIndexPath *index;


@end

@implementation LJBrowserPresentationController

/**
 设置默认数据

 @param index <#index description#>
 @param browserDelegate <#browserDelegate description#>
 */
- (void)setDefaultInfo:(NSIndexPath*)index withDelegate:(id <LJBrowserPresentationDelegate>)browserDelegate {
    self.index = index;
    self.browserDelegate = browserDelegate;
}

#pragma mark - UIViewControllerTransitioningDelegate
// 该方法用于返回一个负责转场动画的对象
// 可以在该对象中控制弹出视图的尺寸等
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[LJBrowserPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

/**
 返回一个负责转场如何出现的对象

 @param dismissed <#dismissed description#>
 @return <#return value description#>
 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.isPresent = true;
    return self;
}

/**
 用于返回一个负责转场如何消失的对象

 @param dismissed <#dismissed description#>
 @return <#return value description#>
 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.isPresent = false;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
/**
 告诉系统展现和消失的动画时长
 暂时不用

 @param transitionContext <#transitionContext description#>
 @return <#return value description#>
 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 3.0;
}

/**
 专门用于管理modal如何展现和消失，无论是展现还是消失都会调用该方法

 @param transitionContext <#transitionContext description#>
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.isPresent) {
        // 展现
        [self willPresentedController:transitionContext];
    }else {
        // 消失
        [self willDismissedController:transitionContext];
    }
}

/**
 执行展现动画

 @param transitionContext <#transitionContext description#>
 */
- (void)willPresentedController:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSAssert(self.index != NULL, @"必须设置被点击cell的indexPath");
    NSAssert(self.browserDelegate != nil, @"必须设置代理才能展现");
    
    // 1.获取需要弹出视图
    // 通过ToViewKey取出的就是toVC对应的view
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    if (!toView) return;
    
    // 2.1新建一个UIImageView，并且在上面显示的内容必须和被点击的图片一模一样
    UIImageView *imageView = [self.browserDelegate browserPresentationWillShowImageView:self withIndexPath:self.index];
    // 2.2获取点击图片相对于window的frame，因为容器试图是全屏的，而图片是添加到容器视图上的，所以必须获取相对于window的frame
    imageView.frame = [self.browserDelegate browserPresentationWillFromFrame:self withIndexPath:self.index];
    [transitionContext.containerView addSubview:imageView];
    // 2.3获取点击图片最终显示的尺寸
    
    CGRect toFrame = [self.browserDelegate browserPresentationWillToFrame:self withIndexPath:self.index];
    // 3.执行动画
    [UIView animateWithDuration:3.0 animations:^{
        imageView.frame = toFrame;
    } completion:^(BOOL finished) {
        // 移除自己添加的UIImageView
        [imageView removeFromSuperview];
        // 显示图片浏览器
        [transitionContext.containerView addSubview:toView];
        // 告诉系统动画之行完毕
        [transitionContext completeTransition:true];
    }];
    
}

- (void)willDismissedController:(id<UIViewControllerContextTransitioning>)transitionContext {
    [transitionContext completeTransition:true];
}

@end
