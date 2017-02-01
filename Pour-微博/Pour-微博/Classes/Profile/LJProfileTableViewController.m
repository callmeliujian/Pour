//
//  ProfileTableViewController.m
//  Pour-微博
//
//  Created by 😄 on 2016/11/29.
//  Copyright © 2016年 😄. All rights reserved.
//

#import "LJProfileTableViewController.h"

@interface LJProfileTableViewController ()

@end

@implementation LJProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.visitorView setSubView:@"visitordiscover_image_profile" with:@"登录后，你的微博、相册、个人资料会显示在这里，展示给别人" withIson:YES];
    
}
@end
