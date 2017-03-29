//
//  LJPicturePickerCollectionViewLayout.m
//  Pour-微博
//
//  Created by 刘健 on 2017/3/28.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJPicturePickerCollectionViewLayout.h"

#define MARGIN 20
#define COL 3

@implementation LJPicturePickerCollectionViewLayout

- (void)prepareLayout {
    CGFloat itemHW = (self.collectionView.bounds.size.width - MARGIN * (COL + 1)) / 3;
    self.itemSize = CGSizeMake(itemHW, itemHW);
    self.minimumLineSpacing = MARGIN;
    self.minimumInteritemSpacing = MARGIN;
    self.sectionInset = UIEdgeInsetsMake(MARGIN, MARGIN, 0, MARGIN);
}

@end
