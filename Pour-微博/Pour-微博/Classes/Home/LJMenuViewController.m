//
//  LJMenuViewController.m
//  Pour-微博
//
//  Created by 😄 on 2016/12/12.
//  Copyright © 2016年 😄. All rights reserved.
//

#import "LJMenuViewController.h"
#import <Masonry.h>


@interface LJMenuViewController ()

/**
 菜单背景图片
 */
@property (nonatomic, strong) UIImageView *menuImageView;

/**
 菜单上的TBVC
 */
@property (nonatomic, strong) UITableView *menuTBVC;


@end

@implementation LJMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景图片
    [self setImageView];
    
    //添加tbvc
    [self addTBVC];
    
}

- (void)addTBVC
{
    self.menuTBVC = [[UITableView alloc] init];
    [self.view addSubview:self.menuTBVC];
    [self.menuTBVC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(15);
        make.bottom.equalTo(self.view).mas_offset(-10);
        make.left.equalTo(self.view).mas_offset(10);
        make.right.equalTo(self.view).mas_offset(-10);
    }];
}
/**
 初始化背景图片
 */
- (void)setImageView
{
    self.menuImageView = [[UIImageView alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"popover_background"];
    
    //拉伸图片
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];// 指定为拉伸模式，伸缩后重新赋值
    
    self.menuImageView.image = image;
    
    [self.view addSubview:self.menuImageView];
    
    [self.menuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view).mas_offset(0);
    }];
}

@end
