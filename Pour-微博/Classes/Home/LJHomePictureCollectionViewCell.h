//
//  LJHomePictureCollectionViewCell.h
//  Pour-微博
//
//  Created by 刘健 on 2017/2/10.
//  Copyright © 2017年 😄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJProgressImageView.h"

@interface LJHomePictureCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) LJProgressImageView *customIconImageView;
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) UIImageView *gifImageView;

@end
