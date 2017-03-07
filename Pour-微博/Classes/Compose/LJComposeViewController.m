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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottomCons;
- (IBAction)emoticonBtnClick:(id)sender;

@end

@implementation LJComposeViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 发送键盘更改通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    // 弹出键盘 弹出键盘有bug
//    [self.customTextView becomeFirstResponder];
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 弹出键盘
    [self.customTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 关闭键盘
    [self.customTextView resignFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - PrivateMethod

/**
 更改键盘通知调用的函数
 
  弹出: UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}";
  关闭: UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 667}, {375, 258}}";
 
  弹出: 250 关闭 0
  屏幕的高度 - 键盘的y值
  667 - 409 = 258
  667 - 667 = 0

 @param notice <#notice description#>
 */
- (void)keyboardWillChange:(NSNotification *)notice {
    // 1.获取键盘frame
    CGRect rect = [notice.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.获取屏幕高度
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    // 3.计算需要移动的距离
    CGFloat offsetY = height - rect.origin.y;
    // 4.修改底部工具条约束
    self.toolbarBottomCons.constant = offsetY;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
   // NSLog(@"%@",notice);
    
}

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

/**
 切换键盘
 
 如果是系统默认的键盘inputView = nil
 如果不是系统自带的键盘, 那么inputView != nil
 注意点: 要想切换切换, 必须先关闭键盘, 切换之后再打开

 @param sender <#sender description#>
 */
- (IBAction)emoticonBtnClick:(id)sender {
    // 关闭键盘
    [self.customTextView resignFirstResponder];
    
    // 1.判断inputView是否为nil
    if (self.customTextView.inputView != nil) {
        // 切换为系统键盘
        self.customTextView.inputView = nil;
    } else {
        //  切换为自定义键盘
        self.customTextView.inputView = [[UISwitch alloc] init];
    }
    
    // 重新打开键盘
    [self.customTextView becomeFirstResponder];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.sendItem.enabled = textView.hasText;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 滑动 customTextView 取消键盘显示
    [self.customTextView resignFirstResponder];
}
@end
