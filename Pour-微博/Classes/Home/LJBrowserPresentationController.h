//
//  LJBrowserPresentationController.h
//  Pour-微博
//
//  Created by 刘健 on 2017/2/27.
//  Copyright © 2017年 😄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJBrowserPresentationController.h"

@class LJBrowserPresentationController;

@protocol LJBrowserPresentationDelegate <NSObject>

/**
 用于创建一个和点击图片一模一样的UIImageView
 */
- (UIImageView *)browserPresentationWillShowImageView:(LJBrowserPresentationController *)browserPresenationController withIndexPath:(NSIndexPath *)indexPath;

/**
 用于获取点击图片相对于window的frame
 */
- (CGRect)browserPresentationWillFromFrame:(LJBrowserPresentationController *)browserPresenationController withIndexPath:(NSIndexPath *)indexpath;

/**
 用于获取点击图片最终的frame
 */
- (CGRect)browserPresentationWillToFrame:(LJBrowserPresentationController *)browserPresenationController withIndexPath:(NSIndexPath *)indexpath;

@end

@interface LJBrowserPresentationController : UIPresentationController <UIViewControllerTransitioningDelegate>

/**
 代理对象
 */
@property (nonatomic, weak) id<LJBrowserPresentationDelegate> browserDelegate;

- (void)setDefaultInfo:(NSIndexPath*)index withDelegate:(id <LJBrowserPresentationDelegate>)browserDelegat;

@end
