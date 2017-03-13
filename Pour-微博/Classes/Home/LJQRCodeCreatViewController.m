//
//  LJQRCodeCreatViewController.m
//  Pour-微博
//
//  Created by 小酸奶 on 2017/1/31.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJQRCodeCreatViewController.h"

@interface LJQRCodeCreatViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *costomImageView;

@end

@implementation LJQRCodeCreatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.创建滤镜
    CIFilter *QRCodeFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.还原滤镜默认属性
    [QRCodeFilter setDefaults];
    // 3.设置需要生成二维码的数据到滤镜中
    NSString *string = @"123456";
//    NSString *stringUTF8 = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [QRCodeFilter setValue:data forKeyPath:@"inputMessage"];
    
    CIImage *ciImage = [QRCodeFilter outputImage];
    
    self.costomImageView.image = [self createNonInterpolatedUIImageFormCIImage:ciImage withSize:500];
    
    
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage*)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    
    // 1.创建bitmap
    CGFloat width = CGRectGetWidth(extent) * scale;
    CGFloat height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, 0);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, CGContextGetInterpolationQuality(nil));
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    return [UIImage imageWithCGImage:scaledImage];
}

@end
