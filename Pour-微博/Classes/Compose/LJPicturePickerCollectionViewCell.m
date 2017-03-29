//
//  LJPicturePickerCollectionViewCell.m
//  Pour-微博
//
//  Created by 刘健 on 2017/3/28.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJPicturePickerCollectionViewCell.h"

@interface LJPicturePickerCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *addPhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *removePhotoBtn;

- (IBAction)addPhotoBtnClick;
- (IBAction)removePhotoBtnClick:(id)sender;

@end

@implementation LJPicturePickerCollectionViewCell

- (IBAction)addPhotoBtnClick {
    if ([self.delegate respondsToSelector:@selector(picturePickerCollectionViewCellAddPictureBtnClick:)]) {
        [self.delegate picturePickerCollectionViewCellAddPictureBtnClick:self];
    }
}

- (IBAction)removePhotoBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(picturePickerCollectionViewCellRemovePictureBtnClick:)]) {
        [self.delegate picturePickerCollectionViewCellRemovePictureBtnClick:self];
    }
}

- (void)setImage:(UIImage *)image {
    if (image == nil) {
        [self.addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"compose_pic_add"] forState:UIControlStateNormal];
        [self.addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"compose_pic_add_highlighted"] forState:UIControlStateHighlighted];
        self.addPhotoBtn.userInteractionEnabled = true;
        self.removePhotoBtn.hidden = true;
    } else {
        [self.addPhotoBtn setBackgroundImage:image forState:UIControlStateNormal];
        self.addPhotoBtn.userInteractionEnabled = false;
        self.removePhotoBtn.hidden = false;
    }
}

@end
