//
//  BaseTableViewController.h
//  Pour-微博
//
//  Created by 😄 on 2016/11/30.
//  Copyright © 2016年 😄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJVisitorView.h"

@interface LJBaseTableViewController : UITableViewController

//保存用户登录状态
@property (nonatomic, assign) BOOL isLogin;

//访客视图
@property (nonatomic, strong) LJVisitorView *visitorView;

@end
