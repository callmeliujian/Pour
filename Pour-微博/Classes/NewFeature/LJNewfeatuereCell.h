//
//  LJNewfeatuereCell.h
//  Pour-微博
//
//  Created by 刘健 on 2017/2/4.
//  Copyright © 2017年 😄. All rights reserved.
// 自定义LJNewFeatureViewController中的collectionView中的cell


#import <UIKit/UIKit.h>

@interface LJNewfeatuereCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, assign) NSInteger index;

- (void)startAniamtion;

@end
