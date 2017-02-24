//
//  LJBrowserCollectionViewCell.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/22.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJBrowserCollectionViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface LJBrowserCollectionViewCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

/**
 图片下载提示视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation LJBrowserCollectionViewCell

#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [self setupUI];
    
    return self;
}

#pragma mark - 内部控制方法
- (void)setupUI {
    // 1.添加子控件
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.contentView addSubview:self.indicatorView];
    
    // 2.布局子控件
    self.scrollView.frame = [UIScreen mainScreen].bounds;
    self.scrollView.backgroundColor = [UIColor darkGrayColor];
    self.indicatorView.center = self.contentView.center;
    
}

/**
 重新设置scrollView的属性
 */
- (void)resetView {
    
    self.scrollView.contentSize = CGSizeZero;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.contentOffset = CGPointZero;
    
    self.imageView.transform = CGAffineTransformIdentity;
    
}

#pragma mark - scrollViewDelegate

/**
 告诉系统缩放哪一个控件

 @param scrollView <#scrollView description#>
 @return <#return value description#>
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

/**
 缩放过程中不断调用

 @param scrollView <#scrollView description#>
 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    // 计算上下内边距
    CGFloat offsetY = (height - self.imageView.frame.size.height) * 0.5;
    // 计算左右内边距
    CGFloat offsetX = (width - self.imageView.frame.size.width) * 0.5;
    
    offsetY = (offsetY < 0) ? 0 : offsetY;
    offsetX = (offsetX < 0) ? 0 : offsetX;
#warning 因为cell是复用的所以加载新图片的时候要重新设置scrollView 这里调用resetView函数
    self.scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX);
    
}

#pragma mark - Lazy
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.minimumZoomScale = 0.5;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return _indicatorView;
}

#pragma mark - set
- (void)setImageURL:(NSURL *)imageURL {
    if (_imageURL != imageURL) {
        _imageURL = imageURL;
    }
    // 显示菊花提醒
    [self.indicatorView startAnimating];
    
    // 重置容器所有数据
    [self resetView];
    // 设置图片
    [self.imageView sd_setImageWithURL:_imageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 图片显示不完整
        //[self.imageView sizeToFit];
        
        // 关闭菊花提醒
        [self.indicatorView stopAnimating];
        
        // 1.计算当前图片的宽高比
        CGFloat scale = image.size.height / image.size.width;
        // 2.利用框高比乘以屏幕宽度，等比缩放图片
        CGFloat imageHeight = scale * [UIScreen mainScreen].bounds.size.width;
        // 3.设置图片frame
        self.imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, imageHeight);
        // 4.判断当前是长图还是短图
        if (imageHeight < [UIScreen mainScreen].bounds.size.height) {
            // 短图
            // 4.1.计算顶部和底部内边距
            CGFloat offsetY = ([UIScreen mainScreen].bounds.size.height - imageHeight) * 0.5;
            // 4.2.设置内边距
            self.scrollView.contentInset = UIEdgeInsetsMake(offsetY, 0, offsetY, 0);
        }else {
            // 长图
            self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, imageHeight);
        }
       
    }];
}

@end
