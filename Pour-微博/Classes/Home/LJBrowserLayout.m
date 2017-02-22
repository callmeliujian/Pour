//
//  LJBrowserLayout.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/22.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJBrowserLayout.h"

@implementation LJBrowserLayout

- (void)prepareLayout {
    self.itemSize = [UIScreen mainScreen].bounds.size;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.pagingEnabled = true;
    self.collectionView.bounces = true;
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.showsVerticalScrollIndicator = false;
}

@end
