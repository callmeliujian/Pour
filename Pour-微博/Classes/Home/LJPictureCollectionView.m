//
//  LJPictureCollectionView.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/21.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJPictureCollectionView.h"
#import "LJHomePictureCollectionViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "Masonry.h"

@interface LJPictureCollectionView ()<UICollectionViewDataSource>

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
    
    return self;
    
}

#pragma mark - delegate
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
