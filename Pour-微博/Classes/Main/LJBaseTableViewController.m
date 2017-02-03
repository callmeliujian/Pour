//
//  BaseTableViewController.m
//  Pour-微博
//
//  Created by 😄 on 2016/11/30.
//  Copyright © 2016年 😄. All rights reserved.
//

#import "LJBaseTableViewController.h"

#import "LJOAuthViewController.h"
#import "LJUserAccount.h"

@interface LJBaseTableViewController ()

@end

@implementation LJBaseTableViewController


//根据登录状态加载不同页面
- (void)loadView
{
    self.isLogin = [LJUserAccount isLogin];
    
    if (self.isLogin)
        [super loadView];
    else
        [self setupVisitorView];
}

- (void)setupVisitorView
{
    self.visitorView = [[LJVisitorView alloc] init];
    self.view = self.visitorView;
    
    //绑定登陆按钮相应事件
    [self.visitorView.loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //绑定注册按钮相应事件
    [self.visitorView.registerButton addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerButtonClicked)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:UIBarButtonItemStylePlain target:self action:@selector(loginButtonClicked)];
    
    
}

- (void)loginButtonClicked
{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LJOAuthViewController" bundle:nil];
    LJOAuthViewController *vc = [sb instantiateInitialViewController];
    [self presentViewController:vc animated:true completion:nil];
}

- (void)registerButtonClicked
{
    NSLog(@"2");
}

@end
