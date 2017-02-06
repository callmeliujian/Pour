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
#import "LJStatus.h"

#import "SVProgressHUD.h"

@interface LJHomeTableViewController () 


/**
 标题按钮
 */
@property (nonatomic, strong)LJButton *titleButton;
/**
 菜单控制器
 */
@property (nonatomic, strong)LJMenuViewController *menuVC;
/**
 保存所有的微博数据
 */
@property (nonatomic, strong)NSMutableArray *statuses;

@property BOOL isPresent;


@end

@implementation LJHomeTableViewController


#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.statuses = [[NSMutableArray alloc] init];
    
    // 1.判断用户是否登陆
    if (!self.isLogin) {
        [self.visitorView setSubView:@"visitordiscover_feed_image_house" with:@"登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过" withIson:NO];
        return;
    }
    
    // 2.初始化导航条
    [self setupNav];
    
    // 3.获取微博数据
    [self loadData];
    
    
    
}

/**
 调用LJNetworkTools的loadStatuses获取主页微博数据
 */
- (void)loadData {
    
    [[LJNetworkTools shareInstance] loadStatuses:^(NSArray *array, NSError *error) {
       
        if (error != nil) {
            [SVProgressHUD showErrorWithStatus:@"获取微博数据失败"];
            
            NSLog(@"----%@",error);
            return;
        }
        

        
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        self.statuses = [[NSMutableArray alloc] init];
        for (id dic in array) {
            LJStatus *model = [[LJStatus alloc] init];
            id status = [model initWithDic:dic];
     //       NSLog(@"%@",status);
            [mutableArray addObject:status];
        }
        
        
        self.statuses = mutableArray;
        

        
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
    NSLog(@"1");
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
 
 @param presented <#presented description#>
 @param presenting <#presenting description#>
 @param source <#source description#>
 @return <#return value description#>
 */
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return [[LJPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

/**
 转场动画如何出现
 
 @param presented <#presented description#>
 @param presenting <#presenting description#>
 @param source <#source description#>
 @return <#return value description#>
 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isPresent = YES;
    return self;
}

/**
 专场动画如何消失
 
 @param dismissed <#dismissed description#>
 @return <#return value description#>
 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresent = NO;
    return self;
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statuses.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.获得cell
    NSString *cellID = @"ID";
    LJHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LJHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.status = self.statuses[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

#pragma mark - UIViewControllerAnimatedTransitioning代理方法

/**
 告诉系统展示和消失动画的时长
 
 @param transitionContext <#transitionContext description#>
 @return <#return value description#>
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

#pragma mark - lazy
- (void)setStatuses:(NSMutableArray *)statuses {
    _statuses = statuses;
    [self.tableView reloadData];
}

@end
