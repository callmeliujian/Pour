//
//  LJComposeViewController.m
//  Pour-微博
//
//  Created by 刘健 on 2017/3/5.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJComposeViewController.h"
#import "LJTextView.h"
#import "LJNetworkTools.h"
#import "SVProgressHUD.h"

@interface LJComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeItem;

- (IBAction)closeBtnClicked:(id)sender;

- (IBAction)sendBtnClicked:(id)sender;
/**
 文本输入框
 */
@property (weak, nonatomic) IBOutlet LJTextView *customTextView;
/**
 发送按钮
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendItem;


@end

@implementation LJComposeViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 弹出键盘
    [self.customTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 关闭键盘
    [self.customTextView resignFirstResponder];
}

#pragma mark - PrivateMethod
- (IBAction)closeBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)sendBtnClicked:(id)sender {
    NSString *text = self.customTextView.text;
    [[LJNetworkTools shareInstance] sendStatuses:text withBlock:^(id responseObject, NSError * error) {
        // 微博发送失败处理
        if (error != nil) {
            [SVProgressHUD showErrorWithStatus:@"发送微博失败"];
            NSLog(@"-----------发送微博失败------------------");
            NSLog(@"%@",responseObject);
            NSLog(@"-----------------end-------------------");
            return ;
        }
        
        // 发送成功
        [SVProgressHUD showSuccessWithStatus:@"微博发送成功"];
        [self closeBtnClicked:self.closeItem];
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.sendItem.enabled = textView.hasText;
}

@end
