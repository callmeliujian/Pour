//
//  LJNewFeatureViewController.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/4.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJNewFeatureViewController.h"
#import "Masonry.h"
#import "LJNewfeatuereCell.h"

@implementation LJNewfeatuereLayout

/**
 设置LJNewFeatureViewController中的collectionView的布局
 */
- (void)prepareLayout {
    // 1.设置每个cell的尺寸
    self.itemSize = [UIScreen mainScreen].bounds.size;
    
    // 2.cell之间的jianxi
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    
    // 3.设置滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 4.设置分页
    self.collectionView.pagingEnabled = true;
    
    // 5.禁用回弹
    self.collectionView.bounces = false;
    
    // 6.去除滚动条
    self.collectionView.showsVerticalScrollIndicator = false;
    self.collectionView.showsHorizontalScrollIndicator = false;
}

@end




@interface LJNewFeatureViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation LJNewFeatureViewController

#pragma mark - Left cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - delegate

/**
 告诉系统有多少组

 @param collectionView collectionView description
 @return <#return value description#>
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

/**
 告诉系统每组有多少行

 @param collectionView <#collectionView description#>
 @param section <#section description#>
 @return <#return value description#>
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

/**
 每行显示的内容

 @param collectionView <#collectionView description#>
 @param indexPath <#indexPath description#>
 @return <#return value description#>
 */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 1.获取cell
    LJNewfeatuereCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"newFeatureCell" forIndexPath:indexPath];
    // 2.设置数据
    cell.index = indexPath.item + 1;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1.获取当前显示的cell对应的indexPath
    NSIndexPath *index = collectionView.indexPathsForVisibleItems.lastObject;
    // 2.根据制定的indexPath获取当前的cell
    LJNewfeatuereCell *currentCell = (LJNewfeatuereCell *)[collectionView cellForItemAtIndexPath:index];
    if (index.item == 3) {
        [currentCell startAniamtion];
    }
}

@end
