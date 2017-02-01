//
//  MainViewController.m
//  Pour-微博
//
//  Created by 😄 on 2016/11/29.
//  Copyright © 2016年 😄. All rights reserved.
//

#import "LJMainViewController.h"
#import "LJHomeTableViewController.h"
#import "LJMessageTableViewController.h"
#import "LJDiscoverTableViewController.h"
#import "LJProfileTableViewController.h"
#import "LJNullTableViewController.h"

@interface LJMainViewController ()

@property (nonatomic, strong) LJHomeTableViewController *homeTableVC;
@property (nonatomic, strong) LJMessageTableViewController *messageTableVC;
@property (nonatomic, strong) LJDiscoverTableViewController *discoverTableVC;
@property (nonatomic, strong) LJProfileTableViewController *ProfileTableVC;
@property (nonatomic, strong) LJNullTableViewController *NullTableVC;

//发布微博按钮
@property (nonatomic, strong) UIButton *composeButton;


@end

@implementation LJMainViewController

- (UIButton *)composeButton
{
    if (!_composeButton) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(composeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        self.composeButton = btn;
    }
    return _composeButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self initChildVC];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tabBar addSubview:self.composeButton];
    
    self.composeButton.frame = CGRectMake(2*(self.tabBar.bounds.size.width / (self.childViewControllers.count)), 0, self.composeButton.frame.size.width, self.composeButton.frame.size.height);
    
}

//初始化子控制器
- (void)initChildVC
{
    
    self.tabBar.tintColor = [UIColor orangeColor];
    
    self.homeTableVC = [[LJHomeTableViewController alloc] init];
    self.messageTableVC = [[LJMessageTableViewController alloc] init];
    self.discoverTableVC = [[LJDiscoverTableViewController alloc] init];
    self.ProfileTableVC = [[LJProfileTableViewController alloc] init];
    
    [self setChildViewController:self.homeTableVC childVCTiele:@"首页" childVCImage:@"tabbar_home" childVCSelectimage:@"tabbar_home_highlighted"];
    
    [self setChildViewController:self.messageTableVC childVCTiele:@"消息" childVCImage:@"tabbar_message_center" childVCSelectimage:@"tabbar_message_center_highlighted"];
    
    [self setChildViewController:self.NullTableVC childVCTiele:@"" childVCImage:@"" childVCSelectimage:@""];
    
    [self setChildViewController:self.discoverTableVC childVCTiele:@"发现" childVCImage:@"tabbar_discover" childVCSelectimage:@"tabbar_discover_highlighted"];
    
    [self setChildViewController:self.ProfileTableVC childVCTiele:@"我" childVCImage:@"tabbar_profile" childVCSelectimage:@"tabbar_profile_highlighted"];
}

//添加子控制器
- (void)setChildViewController:(UITableViewController *)childVC childVCTiele:(NSString*)childVCName childVCImage:(NSString *)imageName childVCSelectimage:(NSString *)selectImageName
{
    childVC.title = childVCName;
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    childVC.tabBarItem.selectedImage = [UIImage imageNamed:selectImageName];
    
    //给每个子控制器添加导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVC];
    
    [self addChildViewController:nav];
}

//微博发送按钮被点击时调用的函数
- (void)composeBtnClicked
{
    NSLog(@"---------");
}

@end
