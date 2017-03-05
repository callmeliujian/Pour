//
//  LJPictureCollectionView.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/21.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJPictureCollectionView.h"
#import "LJHomePictureCollectionViewCell.h"
#import "LJBrowserPresentationController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "Masonry.h"

@interface LJPictureCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate,LJBrowserPresentationDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
/**
 显示配图
 */
@property (nonatomic, strong) LJHomePictureCollectionViewCell *cell;

@end

@implementation LJPictureCollectionView

- (instancetype)init {
    
    self = [self initWithFrame:CGRectZero collectionViewLayout:self.layout];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    self.dataSource = self;
    
    self.delegate = self;
    
    return self;
    
}

#pragma mark - LJBrowserPresentationDelegate
- (UIImageView *)browserPresentationWillShowImageView:(LJBrowserPresentationController *)browserPresenationController withIndexPath:(NSIndexPath *)indexPath {
    // 1.创建一个新的UIImageView
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = true;
    
    // 2.设置UIImageView的图片为点击图片
    LJHomePictureCollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    imageView.image = cell.customIconImageView.image;
#warning todo
//    NSString *key = [self.viewModel.bmiddle_pic[indexPath.item] absoluteString];
//    UIImage *image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:key];
//    imageView.image = image;
    
    [imageView sizeToFit];
    // 3.返回图片
    return imageView;
}

/**
 用于获取点击图片相对于windows的frame

 @param browserPresenationController <#browserPresenationController description#>
 @param indexpath <#indexpath description#>
 @return <#return value description#>
 */
- (CGRect)browserPresentationWillFromFrame:(LJBrowserPresentationController *)browserPresenationController withIndexPath:(NSIndexPath *)indexpath {
    // 1.拿到被点击的cell
    LJHomePictureCollectionViewCell *cell = [self cellForItemAtIndexPath:indexpath];
    // 2.将被点击的cell的坐标系从collectionview转换到keywindow
    CGRect frame = [self convertRect:cell.frame toCoordinateSpace:[UIApplication sharedApplication].keyWindow];
    return frame;
}

/**
 获取点击图片最终的frame

 @param browserPresenationController <#browserPresenationController description#>
 @param indexpath <#indexpath description#>
 @return <#return value description#>
 */
- (CGRect)browserPresentationWillToFrame:(LJBrowserPresentationController *)browserPresenationController withIndexPath:(NSIndexPath *)indexpath {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.width;
    
    // 1.拿到被点击的cell
    LJHomePictureCollectionViewCell *cell = [self cellForItemAtIndexPath:indexpath];
    // 2.拿到被点击的图片
    UIImage *image = cell.customIconImageView.image;
    // 3.计算图片宽高比
    CGFloat scale = image.size.height / image.size.width;
    // 4.利用宽高比乘以屏幕宽度，等比缩放图片
    CGFloat imageHeight = scale * width;
    
    CGFloat offsetY = 0;
    
    if (imageHeight < height)
        offsetY = (height - imageHeight) * 0.5;
    
    return CGRectMake(0, offsetY, width, imageHeight);
    
}

#pragma mark - delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1.获取当前点击图片的url
    NSURL *url = self.viewModel.bmiddle_pic[indexPath.item];
    // 2.取出被点击的cell
    LJHomePictureCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    // 3.下载图片 设置进度
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        cell.customIconImageView.progress = (CGFloat)receivedSize / (CGFloat)expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        // 弹出一个控制器(图片浏览器), 告诉控制器哪些图片需要展示, 告诉控制器当前展示哪一张
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LJShowPhotoBrowserController" object:self userInfo:@{@"bmiddle_pic":self.viewModel.bmiddle_pic, @"indexPath":indexPath}];
        
    }];
    
    
}

#pragma mark - dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.viewModel.thumbnail_pic.count) {
        return self.viewModel.thumbnail_pic.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pictureCell" forIndexPath:indexPath];
    self.cell.url = self.viewModel.thumbnail_pic[indexPath.item];
    return self.cell;
}

- (void)setViewModel:(LJStatusViewModel *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    // 8.更新配图
    [self reloadData];
    
    // 9.更新配图尺寸
    if (!CGSizeEqualToSize([self calculateSize].cellSize, CGSizeZero)) {
        self.layout.itemSize = [self calculateSize].cellSize;
        [self setNeedsUpdateConstraints];
    }
}

/**
 计算cell和collectionview的尺寸
 
 没有配图: cell = zero, collectionview = zero
 一张配图: cell = image.size, collectionview = image.size
 四张配图: cell = {90, 90}, collectionview = {2*w+m, 2*h+m}
 其他张配图: cell = {90, 90}, collectionview =
 
 @return LJSize包含cell和collecionview尺寸
 */
- (LJSize *)calculateSize {
    if (_cellAndCollSize == nil) {
        _cellAndCollSize = [[LJSize alloc] init];
    }
    NSUInteger count = self.viewModel.thumbnail_pic.count;
    
    // 没有配图
    if (count == 0) {
        self.cellAndCollSize.cellSize = CGSizeZero;
        self.cellAndCollSize.collectionviewSize = CGSizeZero;
        return self.cellAndCollSize;
    }
    
    // 一张配图
    if (count == 1) {
        NSString *key = [self.viewModel.thumbnail_pic.firstObject absoluteString];
        UIImage *image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:key];
        self.cellAndCollSize.cellSize = image.size;
        self.cellAndCollSize.collectionviewSize = image.size;
        return self.cellAndCollSize;
    }
    
    // 四张配图
    CGFloat imageWidth = 90;
    CGFloat imageHeigh = 90;
    CGFloat imageMargin = 10;
    if (count == 4) {
        int col = 2;
        int row = col;
        // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
        CGFloat width = imageWidth * col + (col - 1) * imageMargin;
        // 高度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
        CGFloat height = imageHeigh * row + (row - 1) * imageMargin;
        self.cellAndCollSize.cellSize = CGSizeMake(imageWidth, imageHeigh);
        self.cellAndCollSize.collectionviewSize = CGSizeMake(width, height);
        return self.cellAndCollSize;
    }
    
    // 其他张配图
    int col = 3;
    float row = (count - 1) / 3 + 1;
    // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
    CGFloat width = imageWidth * col + (col - 1) * imageMargin;
    // 宽度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
    CGFloat height = imageHeigh * row + (row - 1) * imageMargin;
    self.cellAndCollSize.cellSize = CGSizeMake(imageWidth, imageHeigh);
    self.cellAndCollSize.collectionviewSize = CGSizeMake(width, height);
    return self.cellAndCollSize;
    
}

- (UICollectionViewFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _layout;
}

- (void)updateConstraints {
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.cellAndCollSize.collectionviewSize.height);
        make.width.mas_equalTo(self.cellAndCollSize.collectionviewSize.width);
    }];
    
    [super updateConstraints];
}


@end
