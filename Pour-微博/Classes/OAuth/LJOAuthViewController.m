//
//  LJOAuthViewController.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/2.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJOAuthViewController.h"
#import "LJNetworkTools.h"
#import "LJUserAccount.h"
#import "LJWelcomeViewController.h"

#import "SVProgressHUD.h"

@interface LJOAuthViewController () <UIWebViewDelegate>

// 网页容器

@property (weak, nonatomic) IBOutlet UIWebView *customWebView;

/**
 关闭按钮

 @param sender <#sender description#>
 */
- (IBAction)closeBrnClick:(id)sender;

/**
 自动填充按钮

 @param sender <#sender description#>
 */
- (IBAction)autoBrnClick:(id)sender;


@end

@implementation LJOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlStr = @"https://api.weibo.com/oauth2/authorize?client_id=1841459026&redirect_uri=http://www.baidu.com";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.customWebView loadRequest:request];
    
    
}

#pragma mark - delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // 显示提醒
    [SVProgressHUD showInfoWithStatus:@"正在加载"];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 关闭提醒
    [SVProgressHUD dismiss];
}

// 该方法每次请求都会调用
// 返回false表示不允许请求

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlStr = request.URL.absoluteString;
    if (![urlStr hasPrefix:@"http://www.baidu.com/"]) {
        NSLog(@"不是授权界面");
        return true;
    }
    NSString *key = @"code=";
    if ([request.URL.query hasPrefix:key]) {
        NSString *code = [request.URL.query substringFromIndex:5];
    
        [self loadAccessToken:code];
        return false;
    }
    NSLog(@"授权失败");
    return false;
}

- (void)loadAccessToken:(NSString *)codeStr {
    NSString *path = @"oauth2/access_token";
    NSDictionary *parameters = @{@"client_id": @"1841459026",
                                 @"client_secret": @"22eb72e274c6a478817b9e4b68faa65f",
                                 @"grant_type": @"authorization_code",
                                 @"code": codeStr,
                                 @"redirect_uri": @"http://www.baidu.com"};
    LJNetworkTools *networkTools = [LJNetworkTools shareInstance];
    [networkTools POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 1.将授权信息转化为模型
        LJUserAccount *userAccount = [[LJUserAccount alloc] initWithDict:responseObject];
        // 2.获取用户信息 并保存用户信息
       // [userAccount loadUserInfo];
        [userAccount loadUserInfo:^{
            [userAccount saveAccout];
            // 3.跳转到欢迎界面
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LJWelcomeViewController" bundle:nil];
            LJWelcomeViewController *vc = [sb instantiateInitialViewController];
            [UIApplication sharedApplication].keyWindow.rootViewController = vc;
        }];
        
        [self closeBrnClick:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (IBAction)closeBrnClick:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}

- (IBAction)autoBrnClick:(id)sender {
    
    NSString *jsStrUserId = @"document.getElementById('userId').value = '15776813081';";
    [self.customWebView stringByEvaluatingJavaScriptFromString:jsStrUserId];
    NSString *jsStrPasswd = @"document.getElementById('passwd').value = 'brysJ910';";
    [self.customWebView stringByEvaluatingJavaScriptFromString:jsStrPasswd];
}
@end
