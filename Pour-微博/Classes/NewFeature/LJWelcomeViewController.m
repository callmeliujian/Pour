//
//  LJWelcomeViewController.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/4.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJWelcomeViewController.h"
#import "LJUserAccount.h"
#import "LJMainViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface LJWelcomeViewController ()

/**
 头像距离view底部约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconBottomCons;

/**
 设置头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation LJWelcomeViewController

#pragma mark -Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置头像圆角，如果不设置masksToBounds=YES圆角不会生效
    self.iconImageView.layer.cornerRadius = 45;
    self.iconImageView.layer.masksToBounds = YES;
    
    // 2.设置头像
    NSAssert([LJUserAccount loadUserAccout] != nil, @"必须授权之后才能显示欢迎界面");
    NSURL *url = [NSURL URLWithString:[LJUserAccount loadUserAccout].avatar_hd];
    [self.iconImageView sd_setImageWithURL:url];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 1.让头像执行动画
    self.iconBottomCons.constant = [UIScreen mainScreen].bounds.size.height - self.iconBottomCons.constant;
    [UIView animateWithDuration:2.0 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            self.titleLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
            // 跳转到首页
            [UIApplication sharedApplication].keyWindow.rootViewController = [[LJMainViewController alloc] init];
            
        }];
    }];
}

@end
