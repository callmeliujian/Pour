//
//  UIBarButtonItem+LJ.h
//  Pour-微博
//
//  Created by 😄 on 2016/12/2.
//  Copyright © 2016年 😄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LJ)

//UIBarButtonItem添加默认图片和点击后的高亮图片并绑定点击事件
+ (instancetype)initBarButtonitemWithImage:(NSString *)imageName withHighImage:(NSString *)highImageName WithTarget:(id)target WithAction:(SEL)sel;

@end
