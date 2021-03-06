//
//  LJBrowserViewController.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/21.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJBrowserViewController.h"
#import "LJBrowserLayout.h"
#import "LJBrowserCollectionViewCell.h"

#import <Masonry.h>
#import "SVProgressHUD.h"

@interface LJBrowserViewController () <UICollectionViewDataSource>
/**
 所有配图
 */
@property (nonatomic, strong) NSArray *bmiddle_pic;
/**
 当前点击索引
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UICollectionView *collectView;
/**
 关闭按钮
 */
@property (nonatomic, strong) UIButton *closeBtn;
/**
 保存按钮
 */
@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation LJBrowserViewController

#pragma mark - Life Cycle
- (instancetype)initWithArray:(NSArray *)bmiddle_pic withIndexPath:(NSIndexPath *)indexPath {
    self = [super init];
    
    self.bmiddle_pic = bmiddle_pic;
    self.indexPath = indexPath;
    
    [self setupUI];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 让collectionView滚动到点击的位置
    // 例如有三张图片，点击第二张，显示第二张而不是第一张
    [self.collectView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
}

#pragma mark - PrivateMethod
/**
 初始化UI
 */
- (void)setupUI {
    [self.view addSubview:self.collectView];
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 50));
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.bottom.mas_equalTo(self.view).mas_equalTo(-20);
    }];
    
    [self.view addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 50));
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.bottom.mas_equalTo(self.view).mas_equalTo(-20);
    }];
}

- (void)closeBtnClicked {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)saveBtnClicked {
    // 1.获取当前显示图片的索引
    NSIndexPath *indexPath = [[self.collectView indexPathsForVisibleItems] lastObject];
    // 2.获取当前显示的cell
    LJBrowserCollectionViewCell *cell = [self.collectView dequeueReusableCellWithReuseIdentifier:@"browserCell" forIndexPath:indexPath];
    // 3.获取当前显示的图片
    UIImage *image = cell.imageView.image;
    // 4.保存图片
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

/**
 保存图片之后的函数回调

 @param image <#image description#>
 @param error <#error description#>
 @param contextInfo <#contextInfo description#>
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [SVProgressHUD setMaximumDismissTimeInterval:0.8];
    if (error != nil) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败"];
        return;
    }
    [SVProgressHUD showSuccessWithStatus:@"保存图片成功"];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bmiddle_pic.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LJBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"browserCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    cell.imageURL = self.bmiddle_pic[indexPath.item];
    return cell;
}

#pragma mark - lazy
- (NSArray *)bmiddle_pic {
    if (_bmiddle_pic == nil) {
        _bmiddle_pic = [[NSArray alloc] init];
    }
    return _bmiddle_pic;
}

- (NSIndexPath *)indexPath {
    if (_indexPath == nil) {
        _indexPath = [[NSIndexPath alloc] init];
    }
    return _indexPath;
}

- (UICollectionView *)collectView {
    if (_collectView == nil) {
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[LJBrowserLayout alloc] init]];
        _collectView.dataSource = self;
        [_collectView registerClass:LJBrowserCollectionViewCell.self forCellWithReuseIdentifier:@"browserCell"];
    }
    return _collectView;
}

- (UIButton *)closeBtn {
    if (_closeBtn == nil) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        _closeBtn.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
        [_closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)saveBtn {
    if (_saveBtn == nil) {
        _saveBtn = [[UIButton alloc] init];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        _saveBtn.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
        [_saveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
@end
