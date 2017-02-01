//
//  MessageTableViewController.m
//  Pour-微博
//
//  Created by 😄 on 2016/11/29.
//  Copyright © 2016年 😄. All rights reserved.
//

#import "LJMessageTableViewController.h"

@interface LJMessageTableViewController ()

@end

@implementation LJMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.visitorView setSubView:@"visitordiscover_image_message" with:@"登录后，别人评论你的微博，发给你的消息，都会在这里收到通知" withIson:YES];
    
}
@end
