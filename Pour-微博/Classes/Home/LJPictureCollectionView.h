//
//  LJPictureCollectionView.h
//  Pour-微博
//
//  Created by 刘健 on 2017/2/21.
//  Copyright © 2017年 😄. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "LJStatusViewModel.h"
#import "LJSize.h"

@interface LJPictureCollectionView : UICollectionView

@property (nonatomic, strong) LJStatusViewModel *viewModel;
/**
 配图尺寸
 */
@property (nonatomic, strong) LJSize *cellAndCollSize;

@end
