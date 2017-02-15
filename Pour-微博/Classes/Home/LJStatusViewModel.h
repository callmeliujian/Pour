//
//  LJStatusViewModel.h
//  Pour-微博
//
//  Created by 刘健 on 2017/2/7.
//  Copyright © 2017年 😄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include "LJStatus.h"

@interface LJStatusViewModel : NSObject

/**
 用户头像URL地址
 */
@property (nonatomic, strong)NSURL *icon_URL;

/**
 用户认证图片
 */
@property (nonatomic, strong)UIImage *verified_image;
/**
 会员图片
 */
@property (nonatomic, strong)UIImage *mbrankImage;

/**
 微博格式化之后的创建时间
 */
@property (nonatomic, strong)NSString *created_Time;
/**
 微博格式化之后的来源
 */
@property (nonatomic, strong)NSString *source_Text;
/**
 保存所有配图URL
 */
@property (nonatomic, strong)NSMutableArray *thumbnail_pic;

@property (nonatomic, strong)LJStatus *status;

/**
 转发微博格式化之后的正文
 */
@property (nonatomic, strong)NSString *forwardText;

- (instancetype)initWithStatus:(LJStatus *)status;

@end
