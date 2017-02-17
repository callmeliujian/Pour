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

#import "SVProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define iOS10 ([[UIDevice currentDevice].systemVersion intValue]>=10?YES:NO)

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
/**
 刷新提醒视图
 */
@property (nonatomic, strong) UILabel *tipLabel;


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
    
}


#pragma mark - 内部控制方法

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
/**
 调用LJNetworkTools的loadStatuses获取主页微博数据
 */
- (void)loadData {
    
    /*
     since_id false	int64 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
     max_id false int64 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
     默认情况下, 新浪返回的数据是按照微博ID从大到小得返回给我们的
     也就意味着微博ID越大, 这条微博发布时间就越晚
     经过分析, 如果要实现下拉刷新需要, 指定since_id为第一条微博的id
     如果要实现上拉加载更多, 需要指定max_id为最后一条微博id-1.
     */
    
    LJStatusViewModel *statusViewModel = [self.statuses firstObject];
    NSString *since_id = statusViewModel.status.idstr;
    if (since_id == nil) {
        since_id = @"0";
    }
    [[LJNetworkTools shareInstance] loadStatuses:since_id withBlock:^(NSString *since_id, NSArray *array, NSError *error) {
        // 1.安全校验
        if (error != nil) {
            [SVProgressHUD showErrorWithStatus:@"获取微博数据失败"];
            NSLog(@"----%@",error);
            return;
        }
        // 2.字典数组转化为模型数组
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        self.statuses = [[NSMutableArray alloc] init];
        for (id dic in array) {
            LJStatus *model = [[LJStatus alloc] init];
            id status = [model initWithDic:dic];
            LJStatusViewModel *viewModel = [[LJStatusViewModel alloc] initWithStatus:status];
            [mutableArray addObject:viewModel];
        }
        // 3.处理微博数据
        
        
        if (![since_id isEqualToString:@"0"]) {
            NSArray *array = [NSArray arrayWithArray:mutableArray];
            self.statuses = [mutableArray arrayByAddingObjectsFromArray:array];
            
        }else{
            self.statuses = mutableArray;
        }
        
        
//        if (![since_id isEqualToString:@"0"]) {
//            for (id temp in self.statuses) {
//                [mutableArray addObject:temp];
//                if (mutableArray.count != 0) {
//                    self.statuses = mutableArray;
//                }
//                
//            }
//            
//        }else{
//            self.statuses = mutableArray;
//        }
        
        // 4.缓存微博所有配图
        [self cachesImages:mutableArray];
        
        // 5.关闭菊花
        [self.refreshControl endRefreshing];
        
        // 6.显示刷新提醒
        [self showRefreshStatus:mutableArray.count];
        
    }];
    
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
    // 2.执行动画
    [UIView animateWithDuration:1.0 animations:^{
        self.tipLabel.transform = CGAffineTransformMakeTranslation(0, 44);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.tipLabel.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.tipLabel.hidden = YES;
        }];
    }];



}

/**
 缓存配图

 @param viewModels <#viewModels description#>
 */
- (void)cachesImages:(NSArray *)viewModels {
    // 0.创建一个组
    dispatch_group_t group = dispatch_group_create();
    for (LJStatusViewModel *viewModel in viewModels) {
        
        // 1.从模型中取出数组配图
        if (viewModel.thumbnail_pic) {
            // 2.遍历数组配图下载图片
            for (NSURL*url in viewModel.thumbnail_pic) {
                // 将当前的下载操作加入到组中
                dispatch_group_enter(group);
                
                [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    NSLog(@"success");
                    dispatch_group_leave(group);
                }];
                
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"all");
            // 保存微博数据
            //self.statuses = viewModels;
            [self.tableView reloadData];
        });
}
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
    //return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.获得cell
    LJStatusViewModel *viewModel = self.statuses[indexPath.row];
    NSString *cellID = (viewModel.status.retweeted_status != NULL)? @"forwardCell" : @"homeCell";
    
    if ([cellID isEqualToString:@"homeCell"]) {
        LJHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[LJHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.viewModel = viewModel;
        
        return cell;
    }
    LJHomeForwardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LJHomeForwardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.viewModel = viewModel;
    
    return cell;
    
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
    if (_statuses != statuses && statuses.count != 0) {
        _statuses = statuses;
    }
    //[self.tableView reloadData];
}

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

@end
