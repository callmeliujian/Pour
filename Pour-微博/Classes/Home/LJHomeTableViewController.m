//
//  HomeTableViewController.m
//  Pour-微博
//
//  Created by 😄 on 2016/11/29.
//  Copyright © 2016年 😄. All rights reserved.
//

#import "LJHomeTableViewController.h"
#import "UIBarButtonItem+LJ.h"
#import "LJButton.h"
#import "LJMenuViewController.h"
#import "LJPresentationController.h"
#import "LJPresentationManager.h"
#import "LJUserAccount.h"
#import "LJNetworkTools.h"
#import "LJStatus.h"
#import "LJHomeTableViewCell.h"
#import "LJHomeForwardTableViewCell.h"
#import "LJStatus.h"
#import "LJRefreshControl.h"
#import "LJStatusListModel.h"
#import "LJBrowserViewController.h"
#import "LJBrowserPresentationController.h"
//#import "UITableView+FDTemplateLayoutCell.h"

#import "SVProgressHUD.h"

#define iOS10 ([[UIDevice currentDevice].systemVersion intValue]>=10?YES:NO)

@interface LJHomeTableViewController () <UIViewControllerAnimatedTransitioning>

/**
 标题按钮
 */
@property (nonatomic, strong)LJButton *titleButton;
/**
 菜单控制器
 */
@property (nonatomic, strong)LJMenuViewController *menuVC;

@property BOOL isPresent;
/**
 刷新提醒视图
 */
@property (nonatomic, strong) UILabel *tipLabel;
/**
 最后一条微博标记
 */
@property (nonatomic, assign) BOOL lastStatus;

/**
 微博数据
 */
@property (nonatomic, strong) LJStatusListModel *statusListModel;

@property (nonatomic, strong) LJBrowserPresentationController *browserPresentionManager;

@end

@implementation LJHomeTableViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.判断用户是否登陆
    if (!self.isLogin) {
        [self.visitorView setSubView:@"visitordiscover_feed_image_house" with:@"登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过" withIson:NO];
        return;
    }
    // 2.初始化导航条
    [self setupNav];
    // 3.获取微博数据
    [self loadData];
    
    // 4.设置tableView
    self.tableView.estimatedRowHeight = 400;
    // 5.下拉刷新
    self.refreshControl = [[LJRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    
    // 6.添加刷新视图
    [self addRefreshView];
    
    self.lastStatus = false;
    
    // 7.注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBrowser:) name:@"LJShowPhotoBrowserController" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 内部控制方法

/**
 监听图片点击通知

 @param notice 收到的通知
 */
- (void)showBrowser:(NSNotification *)notice {
    // 凡是通过网络或者通知收到的数据，都需要进行安全校验
    if (!notice.userInfo[@"bmiddle_pic"]) {
        [SVProgressHUD showErrorWithStatus:@"没有图片"];
        return;
    }
    
    if (!notice.userInfo[@"indexPath"]) {
        [SVProgressHUD showErrorWithStatus:@"没有索引"];
        return;
    }
    
    // 弹出图片浏览器，将所有图片和当前点击的索引传递给浏览器
    LJBrowserViewController *browserVC = [[LJBrowserViewController alloc] initWithArray:notice.userInfo[@"bmiddle_pic"] withIndexPath:notice.userInfo[@"indexPath"]];
    // 设置转场动画代理
    browserVC.transitioningDelegate = self.browserPresentionManager;
    // 设置转场动画样式
    browserVC.modalPresentationStyle = UIModalPresentationCustom;
    [self.browserPresentionManager setDefaultInfo:notice.userInfo[@"indexPath"] withDelegate:notice.object];
    [self presentViewController:browserVC animated:true completion:nil];
    
}

- (void)loadData {

    [self.statusListModel loadData:self.lastStatus finished:^(NSMutableArray *models, NSError *error) {
        // 1.安全校验
        if (error != nil) {
            [SVProgressHUD showErrorWithStatus:@"获取微博数据失败"];
            NSLog(@"------------------------获取微博数据失败-error-----------------");
            NSLog(@"%@",error);
            NSLog(@"--------------------------------end-------------------------");
            return;
        }
        
        // 2.关闭菊花
        [self.refreshControl endRefreshing];
        
        // 3.显示刷新提醒
        [self showRefreshStatus:models.count];
        
        // 4.刷新表格
        [self.tableView reloadData];
        
    }];
    
}

/**
 刷新视图
 */
- (void)addRefreshView {
    NSArray *subviews=self.navigationController.navigationBar.subviews;
    for (UIView *view in subviews) {
        if (iOS10) {
            //iOS10,改变了状态栏的类为_UIBarBackground
            //iOS9以及iOS9之前使用的是_UINavigationBarBackground
            if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                view.hidden = YES;
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
                imageView.backgroundColor = [UIColor whiteColor];
                [self.navigationController.navigationBar insertSubview:imageView atIndex:0];
            }
        }
    }
    [self.navigationController.navigationBar insertSubview:self.tipLabel atIndex:0];
}


- (void)showRefreshStatus:(NSInteger)count {
    // 1.设置提醒文本
    if (count == 0) {
        self.tipLabel.text = @"没有更多数据";
    }else {
        NSString *str = [@"刷新到" stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)count]];
        str = [str stringByAppendingString:@"条数据"];
        self.tipLabel.text = str;
    }
    self.tipLabel.hidden = NO;
    CGRect rect = self.tipLabel.frame;
    // 2.执行动画
//    [UIView animateWithDuration:2.0 animations:^{
//        self.tipLabel.transform = CGAffineTransformMakeTranslation(0, 44);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionTransitionNone animations:^{
//            self.tipLabel.transform = CGAffineTransformIdentity;
//        } completion:^(BOOL finished) {
//            self.tipLabel.hidden = YES;
//        }];
//    }];
    [UIView animateWithDuration:2.0 animations:^{
        self.tipLabel.frame = CGRectMake(0, 44, self.tipLabel.frame.size.width, self.tipLabel.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionTransitionNone animations:^{
            self.tipLabel.frame = rect;
        } completion:nil];
    }];
}
/**
 初始化导航控制器
 */
- (void)setupNav {
    //添加home导航条左面的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initBarButtonitemWithImage:@"navigationbar_friendattention" withHighImage:@"navigationbar_friendattention_highlighted" WithTarget:self WithAction:@selector(leftBarButtonItemClicked)];
    
    //添加home导航条右面的按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initBarButtonitemWithImage:@"navigationbar_pop" withHighImage:@"navigationbar_pop_highlighted" WithTarget:self WithAction:@selector(rightBarButtonItemClicked)];
    
    //添加home导航条中间的按钮
    self.titleButton = [[LJButton alloc] init];
    LJUserAccount *userAccout = [LJUserAccount loadUserAccout];
    [self.titleButton setTitle:userAccout.screen_name forState:UIControlStateNormal];
    
    
    [self.titleButton addTarget:self action:@selector(titleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.titleView = self.titleButton;
}


/**
 标题按钮被点击
 */
- (void)titleButtonClicked {
    //改变按钮选中状态
    self.titleButton.selected = !self.titleButton.selected;
    
    //弹出菜单
    self.menuVC = [[LJMenuViewController alloc] init];
    
    //自定义转场动画
    //1.设置代理
    LJPresentationManager *pm = [[LJPresentationManager alloc] init];
    self.menuVC.transitioningDelegate = pm;
    //2.设置转场样式
    self.menuVC.modalPresentationStyle = UIModalPresentationCustom;
    
   
    [self presentViewController:self.menuVC animated:YES completion:nil];
}

- (void)leftBarButtonItemClicked {
    NSLog(@"leftBarButtonItemClicked");
}

- (void)rightBarButtonItemClicked {
    // 1.创建二维码控制器
    UIStoryboard *QRStroyboard = [UIStoryboard storyboardWithName:@"LJQRCode" bundle:nil];
    UIViewController *QRVC = [QRStroyboard instantiateInitialViewController];
    // 2.弹出二维码控制器
    [self presentViewController:QRVC animated:true completion:nil];
}

- (UIBarButtonItem *)creatBarButtonitem:(NSString *)imageName withHighImage:(NSString *)highImageName {
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    [button sizeToFit];
   
    return [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

/**
 返回负责专场动画的对象
 */
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return [[LJPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

/**
 转场动画如何出现
 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isPresent = YES;
    return self;
}

/**
 专场动画如何消失
 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresent = NO;
    return self;
}

#pragma mark - UITableVIewDeletage

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    LJStatusViewModel *viewModel = self.statusListModel.statuses[indexPath.row];
//    NSString *identifier = (viewModel.status.retweeted_status != nil) ? @"forwardCell" : @"homeCell";
//    return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(LJHomeTableViewCell *cell) {
//        cell.viewModel = viewModel;
//    }];
//}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statusListModel.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.获得cell
    LJStatusViewModel *viewModel = self.statusListModel.statuses[indexPath.row];
    NSString *cellID = (viewModel.status.retweeted_status != NULL)? @"forwardCell" : @"homeCell";
    UITableViewCell *cell;
    
    if ([cellID isEqualToString:@"homeCell"]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[LJHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        ((LJHomeTableViewCell*)cell).viewModel = viewModel;
        
    }else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[LJHomeForwardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        ((LJHomeForwardTableViewCell*)cell).viewModel = viewModel;
    }

    if (indexPath.row == self.statusListModel.statuses.count - 1) {
        NSLog(@"---viewModel.status.user.screen_name---%@",viewModel.status.user.screen_name);
        self.lastStatus = YES;
        [self loadData];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UIViewControllerAnimatedTransitioning代理方法

/**
 告诉系统展示和消失动画的时长
 */
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPresent) {
        //获得需要展示的view
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        //需要展示的view添加到containerView
        [[transitionContext containerView] addSubview:toView];
        //添加动画
        toView.transform = CGAffineTransformMakeScale(1.0, 0.0);
        //设置锚点
        toView.layer.anchorPoint = CGPointMake(0.5,0);
        //执行动画
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else{
        //获得之前的view
        UIView *formView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        //formView.transform = CGAffineTransformMakeScale(1.0, 0000001);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            formView.transform = CGAffineTransformMakeScale(1.0, 0.00001);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    
}

#pragma mark - Lazy
- (UILabel *)tipLabel {
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        _tipLabel.backgroundColor = [UIColor orangeColor];
        _tipLabel.text = @"没有更多数据";
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}

- (LJStatusListModel *)statusListModel {
    if (_statusListModel == nil) {
        _statusListModel = [[LJStatusListModel alloc] init];
    }
    return _statusListModel;
}

- (LJBrowserPresentationController *)browserPresentionManager {
    if (_browserPresentionManager == nil) {
        _browserPresentionManager = [[LJBrowserPresentationController alloc] initWithPresentedViewController:nil presentingViewController:nil];
    }
    return _browserPresentionManager;
}

@end
