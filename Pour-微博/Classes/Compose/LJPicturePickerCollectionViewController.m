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

@property (nonatomic, strong) NSMutableArray <UIImage *> *mutableImagesArray;

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
    [self.mutableImagesArray addObject:image];
    [self.collectionView reloadData];
}

#pragma mark - Lazy

- (NSMutableArray<UIImage *> *)mutableImagesArray {
    if (_mutableImagesArray == nil) {
        _mutableImagesArray = [NSMutableArray array];
    }
    return _mutableImagesArray;
}

@end
