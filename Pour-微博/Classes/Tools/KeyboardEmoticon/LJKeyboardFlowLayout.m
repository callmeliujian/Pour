//
//  LJKeyboardFlowLayout.m
//  表情键盘
//
//  Created by 刘健 on 2017/3/8.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "LJKeyboardFlowLayout.h"

@implementation LJKeyboardFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    // set cell
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 7.0;
    CGFloat height = self.collectionView.bounds.size.height / 3.0;
    self.itemSize = CGSizeMake(width, height);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // set collectionView
    self.collectionView.bounces = false;
    self.collectionView.pagingEnabled = true;
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.showsVerticalScrollIndicator = false;
    
    // set space
    // 在4/4s/se上写0.5计算不准确
    // 0.4999 14.925585714285717
    // 0.5    14.928571428571431
//    CGFloat multiple;
//    if ([UIScreen mainScreen].bounds.size.width > 320) {
//        multiple = 0.5;
//    } else {
//        multiple = 0.499999999;
//    }
//    CGFloat offsetY = (self.collectionView.frame.size.height - 3 * width) * multiple;
//    self.collectionView.contentInset = UIEdgeInsetsMake(offsetY, 0, offsetY, 0);
    
}

@end
