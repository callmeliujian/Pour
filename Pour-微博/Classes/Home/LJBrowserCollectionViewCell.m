//
//  LJBrowserCollectionViewCell.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/22.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJBrowserCollectionViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface LJBrowserCollectionViewCell ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

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
    
    // 2.布局子控件
    self.scrollView.frame = [UIScreen mainScreen].bounds;
    self.scrollView.backgroundColor = [UIColor darkGrayColor];
    
}

#pragma mark - Lazy
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

#pragma mark - set
- (void)setImageURL:(NSURL *)imageURL {
    if (_imageURL != imageURL) {
        _imageURL = imageURL;
    }
    [self.imageView sd_setImageWithURL:_imageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 图片显示不完整
        //[self.imageView sizeToFit];
        
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
