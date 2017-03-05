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

 @param browserPresenationController <#browserPresenationController description#>
 @param indexPath <#indexPath description#>
 @return <#return value description#>
 */
- (UIImageView *)browserPresentationWillShowImageView:(LJBrowserPresentationController *)browserPresenationController withIndexPath:(NSIndexPath *)indexPath;

/**
 用于获取点击图片相对于window的frame

 @param indexpath <#indexpath description#>
 @return <#return value description#>
 */
- (CGRect)browserPresentationWillFromFrame:(LJBrowserPresentationController *)browserPresenationController withIndexPath:(NSIndexPath *)indexpath;

/**
 用于获取点击图片最终的frame

 @param indexpath <#indexpath description#>
 @return <#return value description#>
 */
- (CGRect)browserPresentationWillToFrame:(LJBrowserPresentationController *)browserPresenationController withIndexPath:(NSIndexPath *)indexpath;

@end

@interface LJBrowserPresentationController : UIPresentationController

/**
 代理对象
 */
@property (nonatomic, weak) id<LJBrowserPresentationDelegate> browserDelegate;

- (void)setDefaultInfo:(NSIndexPath*)index withDelegate:(id <LJBrowserPresentationDelegate>)browserDelegat;

@end
