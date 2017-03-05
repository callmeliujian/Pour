//
//  LJComposeViewController.m
//  Pour-微博
//
//  Created by 刘健 on 2017/3/5.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJComposeViewController.h"

@interface LJComposeViewController ()

- (IBAction)closeBtnClicked:(id)sender;

- (IBAction)sendBtnClicked:(id)sender;


@end

@implementation LJComposeViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - PrivateMethod
- (IBAction)closeBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)sendBtnClicked:(id)sender {
}
@end
