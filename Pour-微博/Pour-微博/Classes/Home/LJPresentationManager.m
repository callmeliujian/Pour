//
//  LJPresentationManager.m
//  Pour-微博
//
//  Created by 😄 on 2016/12/12.
//  Copyright © 2016年 😄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJPresentationManager.h"
#import "LJPresentationController.h"

@interface LJPresentationManager()<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property BOOL isPresent;

@end

@implementation LJPresentationManager


/**
 返回负责专场动画的对象
 
 @param presented <#presented description#>
 @param presenting <#presenting description#>
 @param source <#source description#>
 @return <#return value description#>
 */
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return [[LJPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

/**
 转场动画如何出现
 
 @param presented <#presented description#>
 @param presenting <#presenting description#>
 @param source <#source description#>
 @return <#return value description#>
 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isPresent = YES;
    return self;
}

/**
 专场动画如何消失
 
 @param dismissed <#dismissed description#>
 @return <#return value description#>
 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresent = NO;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning代理方法

/**
 告诉系统展示和消失动画的时长
 
 @param transitionContext <#transitionContext description#>
 @return <#return value description#>
 */
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPresent) {
        //获得需要展示的view
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        //需要展示的view添加到containerView
        [[transitionContext containerView] addSubview:toView];
        //添加动画
        toView.transform = CGAffineTransformMakeScale(1.0, 0.0);
        //设置锚点
        toView.layer.anchorPoint = CGPointMake(0.5,0);
        //执行动画
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else{
        //获得之前的view
        UIView *formView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        //formView.transform = CGAffineTransformMakeScale(1.0, 0000001);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            formView.transform = CGAffineTransformMakeScale(1.0, 0.00001);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    
}

@end
