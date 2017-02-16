//
//  LJRefreshView.h
//  Pour-微博
//
//  Created by 刘健 on 2017/2/16.
//  Copyright © 2017年 😄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJRefreshView : UIView

/**
 菊花
 */
@property (nonatomic, strong) UIImageView *loadingImageView;
/**
 箭头
 */
@property (nonatomic, strong) UIImageView *arrowImageView;
/**
 提示视图
 */
@property (nonatomic, strong) UIView *tipView;

- (void)rotationArrow:(BOOL)flag;

@end
