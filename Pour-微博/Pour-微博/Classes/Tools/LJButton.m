//
//  LJButton.m
//  Pour-微博
//
//  Created by 😄 on 2016/12/2.
//  Copyright © 2016年 😄. All rights reserved.
//

#import "LJButton.h"

@implementation LJButton



/**
 初始化按钮，设置默认状态下的默认图片和选中状态下图片

 @param frame <#frame description#>
 @return <#return value description#>
 */
-  (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    
    [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self sizeToFit];

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //交换imageView和titleLabel的位置（左右 ➡️ 右左）
    CGRect titleLabelRect = CGRectMake(0, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    
    CGRect imageViewRect = CGRectMake(self.titleLabel.frame.size.width, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
    
    self.titleLabel.frame= titleLabelRect;
    self.imageView.frame = imageViewRect;

}

@end
