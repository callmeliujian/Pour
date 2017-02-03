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

@interface LJOAuthViewController () <UIWebViewDelegate>

// 网页容器
@property (weak, nonatomic) IBOutlet UIWebView *customWebView;

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
       // NSLog(@"%@",code);
        [self loadAccessToken:code];
        [self dismissViewControllerAnimated:true completion:nil];
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
        
        LJUserAccount *userAccount = [[LJUserAccount alloc] initWithDict:responseObject];
        //[userAccount saveAccout];
        NSLog(@"%d",[userAccount saveAccout]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
