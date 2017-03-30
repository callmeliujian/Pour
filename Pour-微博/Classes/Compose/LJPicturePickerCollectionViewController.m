//
//  LJPicturePickerCollectionViewController.m
//  Pour-微博
//
//  Created by 刘健 on 2017/3/28.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJPicturePickerCollectionViewController.h"
#import "LJPicturePickerCollectionViewLayout.h"
#import "LJPicturePickerCollectionViewCell.h"

@interface LJPicturePickerCollectionViewController () <LJPicturePickerCollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>



@end

@implementation LJPicturePickerCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mutableImagesArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LJPicturePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.image = indexPath.item >= self.mutableImagesArray.count ? nil : self.mutableImagesArray[indexPath.item];
    
    return cell;
}

#pragma mark - LJPicturePickerCollectionViewCellDelegate

- (void)picturePickerCollectionViewCellAddPictureBtnClick:(LJPicturePickerCollectionViewCell *)cell {
    // 判断相册是否能打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        return;
    UIImagePickerController *imagePicekerVC = [[UIImagePickerController alloc] init];
    imagePicekerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicekerVC.delegate = self;
    [self presentViewController:imagePicekerVC animated:true completion:nil];
}

- (void)picturePickerCollectionViewCellRemovePictureBtnClick:(LJPicturePickerCollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.mutableImagesArray removeObjectAtIndex:indexPath.item];
    [self.collectionView reloadData];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"%@",info);
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:true completion:nil];
    UIImage *newImage = [self drawImage:image Withwidth:400.0];
    [self.mutableImagesArray addObject:newImage];
    [self.collectionView reloadData];
}

#pragma mark - PrivateMethod

- (UIImage *)drawImage:(UIImage *)image Withwidth:(CGFloat)width {
    CGFloat heigth = (image.size.height / image.size.width) * width;
    CGSize size = CGSizeMake(width, heigth);
    
    // 开启图片上下文
    UIGraphicsBeginImageContext(size);
    // 将图片画到上下文
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从上下文中获取到图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Lazy

- (NSMutableArray<UIImage *> *)mutableImagesArray {
    if (_mutableImagesArray == nil) {
        _mutableImagesArray = [NSMutableArray array];
    }
    return _mutableImagesArray;
}

@end
