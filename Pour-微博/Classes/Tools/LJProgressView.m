//
//  LJProgressView.m
//  ImageLoadingAnimation
//
//  Created by 刘健 on 2017/2/23.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "LJProgressView.h"

@interface LJProgressView ()



@end

@implementation LJProgressView

#pragma mark - LifeCycle
- (instancetype)init {
    self = [super init];
    
    self.progress = 0;
    
    return self;
}

/**
 圆心: {宽度 * 0.5, 高度 * 0.5}
 半径: min(宽度, 高度)
 开始位置: 默认位置
 结束位置: 2 * PI

 @param rect <#rect description#>
 */
- (void)drawRect:(CGRect)rect {
    // 1.判断是否需要继续绘制
    if (self.progress >= 1.0) {
        return;
    }
    
    // 2.准备数据
    CGFloat height = rect.size.height * 0.5;
    CGFloat width = rect.size.width * 0.5;
    CGPoint center = CGPointMake(width, height);
    CGFloat radius = MIN(height, width);
    CGFloat start = -M_PI_2;
    CGFloat end = 2 * M_PI * self.progress + start;
    
    // 3.设置数据
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:true];
    [path addLineToPoint:center];
    [path closePath];
    [[UIColor colorWithWhite:0.9 alpha:0.5] setFill];
    
    // 4.绘制图形
    [path fill];
}

#pragma mark - set
- (void)setProgress:(CGFloat)progress {
    if (_progress != progress) {
        _progress = progress;
    }
    [self setNeedsDisplay];
}

@end
