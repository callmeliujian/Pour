//
//  LJQRCodeViewController.m
//  Pour-微博
//
//  Created by 小酸奶 on 2017/1/24.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJQRCodeViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface LJQRCodeViewController () <UITabBarDelegate, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
// 扫描二维码页面底部的tabbar
@property (weak, nonatomic) IBOutlet UITabBar *customTabbar;

// 冲击波顶部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanLineCons;

// 容器视图高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightCons;

// 冲击波视图
@property (weak, nonatomic) IBOutlet UIImageView *scanLineView;

// 输入对象
@property (nonatomic, strong) AVCaptureDeviceInput *inPut;

// 会话
@property (nonatomic, strong) AVCaptureSession *session;

// 输出对象
@property (nonatomic, strong) AVCaptureMetadataOutput *outPut;

// 预览图层

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

// 结果文本
@property (weak, nonatomic) IBOutlet UILabel *customLaber;

// 保存二维码描边的图层
@property (nonatomic, strong) CALayer *containerLayer;

// 扫描视图容器
@property (weak, nonatomic) IBOutlet UIView *costomContainerView;

@end

@implementation LJQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // tabBar默认选中第一项
    self.customTabbar.selectedItem = self.customTabbar.items[0];
    
    // tabBar工具点击
    self.customTabbar.delegate = self;
    
    // 扫描
    [self scanQRCode];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startAnimation];
}

#pragma mark - function
// 开始冲击波动画
- (void)startAnimation {
    // 设置冲击波底部和容器视图顶部对齐
    self.scanLineCons.constant = -self.containerHeightCons.constant;
    [self.view layoutIfNeeded];
    
    // 执行扫描动画
    [UIView animateWithDuration:2.0 animations:^{
        [UIView setAnimationRepeatCount:MAXFLOAT];
        self.scanLineCons.constant = self.containerHeightCons.constant;
        [self.view layoutIfNeeded];
    }];
}

- (void)scanQRCode {
    // 判断输入能否添加到会话中
    if (![self.session canAddInput:self.inPut])
        return;
    // 判断输出能否添加到会话中
    if (![self.session canAddOutput:self.outPut])
        return;
    // 添加输入输出到会话中
    [self.session addInput:self.inPut];
    [self.session addOutput:self.outPut];
    
    // 设置输出能够解析的类型
    self.outPut.metadataObjectTypes = self.outPut.availableMetadataObjectTypes;
    // 设置监听输出解析到的数据
    [self.outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 添加预览图层
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    self.previewLayer.frame = self.view.bounds;
    
    // 添加描边图层
    [self.view.layer addSublayer:self.containerLayer];
    self.containerLayer.frame = self.view.bounds;
    
    //  开始扫描
    [self.session startRunning];
    
}

// 绘制二维码描边
- (void)drawLines:(AVMetadataMachineReadableCodeObject *)objc{
    // 创建图层，保存绘制的矩形
    CAShapeLayer *shapelayer = [[CAShapeLayer alloc] init];
    shapelayer.lineWidth = 2;
    shapelayer.strokeColor = [[UIColor orangeColor] CGColor];
    shapelayer.fillColor = [[UIColor clearColor] CGColor];
    
    // 创建UIBezierPath，绘制矩形
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint point = CGPointZero;
    int index = 0;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)objc.corners[index ++], &point);
    // 将起点移动到下一个点
    [path moveToPoint:point];
    // 链接线段
    while (index < objc.corners.count) {
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)objc.corners[index ++], &point);
        [path addLineToPoint:point];
    }
    
    // 关闭路径
    [path closePath];
    shapelayer.path = path.CGPath;
    [self.containerLayer addSublayer:shapelayer];
}

// 清空二维码描边
- (void)clearLayers {
    for (CALayer *layer in self.containerLayer.sublayers) {
        [layer removeFromSuperlayer];
    }
}


#pragma mark - delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    // 根据当前选中的按钮设置二维码容器的高度
    self.containerHeightCons.constant = (item.tag == 1)? 150 : 300;
    [self.view layoutIfNeeded];
    
    // 移除冲击波动画
    [self.scanLineView.layer removeAllAnimations];
    
    // 添加动画
    [self startAnimation];
}

// 扫描到结果就会调用
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // 在扫描二维码显示视图底部标签显示结果
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            self.customLaber.text = metadataObj.stringValue;
        } else {
            NSLog(@"不是二维码");
        }
    }
    
    [self clearLayers];
    
    AVMetadataObject *avDataObject = [self.previewLayer transformedMetadataObjectForMetadataObject:metadataObjects.lastObject];
    
    [self drawLines:(AVMetadataMachineReadableCodeObject *)avDataObject];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    
 UIImage *image = info[UIImagePickerControllerOriginalImage];
//    
//    UIImage* picture = [info objectForKey:UIImagePickerControllerOriginalImage];
//    
//    picture.imageOrientation
//    
//    CIImage *ciimage = [CIImage imageWithCGImage:[picture CGImage]];
//    
//    // 创建一个探测器
//    CIDetector *QRDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyLow}];
//    // 利用探测器的到数据
//   // CIImage *ciImage = [CIImage imageWithCGImage:[image CGImage]];
//    NSArray *results = [QRDetector featuresInImage:ciimage];
//    
//    for (id result in results) {
//        NSLog(@"%@",result);
//    }
    
    
    int exifOrientation;
    switch (image.imageOrientation) {
        case UIImageOrientationUp:
            exifOrientation = 1;
            break;
        case UIImageOrientationDown:
            exifOrientation = 3;
            break;
        case UIImageOrientationLeft:
            exifOrientation = 8;
            break;
        case UIImageOrientationRight:
            exifOrientation = 6;
            break;
        case UIImageOrientationUpMirrored:
            exifOrientation = 2;
            break;
        case UIImageOrientationDownMirrored:
            exifOrientation = 4;
            break;
        case UIImageOrientationLeftMirrored:
            exifOrientation = 5;
            break;
        case UIImageOrientationRightMirrored:
            exifOrientation = 7;
            break;
        default:
            break;
    }
    
    NSDictionary *detectorOptions = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh }; // TODO: read doc for more tuneups
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:detectorOptions];
    
    NSArray *features = [faceDetector featuresInImage:[CIImage imageWithCGImage:image.CGImage]
                                              options:@{CIDetectorImageOrientation:[NSNumber numberWithInt:exifOrientation]}];
    
    for (id res in features) {
        NSLog(@"%@",res);
    }
    
    // 实现此方法后，选择图片后，系统不会自动关闭图片控制器。
    [picker dismissViewControllerAnimated:true completion:nil];
    
}

#pragma mark - IBAction
- (IBAction)closeBtnClick:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)photoBtnClick:(id)sender {
    
    // 判断相册是否能打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        return;
    UIImagePickerController *imagePicekerVC = [[UIImagePickerController alloc] init];
    
    imagePicekerVC.delegate = self;
    
    [self presentViewController:imagePicekerVC animated:true completion:nil];
    
}


#pragma mark - lazy
- (AVCaptureDeviceInput *)inPut {
    if (_inPut == nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _inPut = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    }
    return _inPut;
}

- (AVCaptureSession *)session {
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (AVCaptureMetadataOutput *)outPut {
    if (_outPut == nil) {
        _outPut = [[AVCaptureMetadataOutput alloc] init];
        
        // 设置扫描区域
        // ⚠️参照是以横屏的左上角做参照，而不是竖屏
        CGRect viewRect = self.view.frame;
        CGRect customContainerRect = self.costomContainerView.frame;
        CGFloat x = customContainerRect.origin.y / viewRect.size.height;
        CGFloat y = customContainerRect.origin.x / viewRect.size.width;
        CGFloat width = customContainerRect.size.height / viewRect.size.height;
        CGFloat height = customContainerRect.size.width / viewRect.size.width;
        _outPut.rectOfInterest = CGRectMake(x, y, width, height);
    }
    return _outPut;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (_previewLayer == nil) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    return _previewLayer;
}

- (CALayer *)containerLayer {
    if (_containerLayer == nil) {
        _containerLayer = [[CALayer alloc] init];
    }
    return _containerLayer;
}

@end
