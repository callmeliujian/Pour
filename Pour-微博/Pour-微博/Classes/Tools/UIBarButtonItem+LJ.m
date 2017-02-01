//
//  UIBarButtonItem+LJ.m
//  Pour-微博
//
//  Created by 😄 on 2016/12/2.
//  Copyright © 2016年 😄. All rights reserved.
//

#import "UIBarButtonItem+LJ.h"

@implementation UIBarButtonItem (LJ)

+ (instancetype)initBarButtonitemWithImage:(NSString *)imageName withHighImage:(NSString *)highImageName WithTarget:(id)target WithAction:(SEL)sel
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    [button sizeToFit];
    
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    
    return [item initWithCustomView:button];
}

@end
