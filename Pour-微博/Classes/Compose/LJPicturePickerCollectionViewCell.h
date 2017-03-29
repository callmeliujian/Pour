//
//  LJPicturePickerCollectionViewCell.h
//  Pour-微博
//
//  Created by 刘健 on 2017/3/28.
//  Copyright © 2017年 😄. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJPicturePickerCollectionViewCell;

@protocol LJPicturePickerCollectionViewCellDelegate <NSObject>

@optional

- (void)picturePickerCollectionViewCellAddPictureBtnClick:(LJPicturePickerCollectionViewCell *)cell;
- (void)picturePickerCollectionViewCellRemovePictureBtnClick:(LJPicturePickerCollectionViewCell *)cell;

@end

@interface LJPicturePickerCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<LJPicturePickerCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) UIImage *image;

@end
