//
//  DiscoverTableViewController.m
//  Pour-微博
//
//  Created by 😄 on 2016/11/29.
//  Copyright © 2016年 😄. All rights reserved.
//

#import "LJDiscoverTableViewController.h"

@interface LJDiscoverTableViewController ()

@end

@implementation LJDiscoverTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.isLogin) {
        [self.visitorView setSubView:@"visitordiscover_image_message" with:@"登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过" withIson:YES];
        
        return;
    }
    
    
}
@end
