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
    NSString *stringUTF8 = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [QRCodeFilter setValue:stringUTF8 forKeyPath:@"InPutMessage"];
    
    CIImage *ciImage = [QRCodeFilter outputImage];
    
    self.costomImageView.image = [UIImage imageWithCGImage:(__bridge CGImageRef _Nonnull)(ciImage)];
    
    
}

@end
