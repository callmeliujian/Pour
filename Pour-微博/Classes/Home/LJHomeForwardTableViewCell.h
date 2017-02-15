//
//  LJHomeForwardTableViewCell.h
//  Pour-微博
//
//  Created by 刘健 on 2017/2/15.
//  Copyright © 2017年 😄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJStatus.h"
#import "LJStatusViewModel.h"

@interface LJHomeForwardTableViewCell : UITableViewCell

/**
 头像
 */
@property (nonatomic, strong) UIImageView *iconImageView;

/**
 认证图标
 */
@property (nonatomic, strong) UIImageView *verifiedImageView;
/**
 昵称
 */
@property (nonatomic, strong) UILabel *nameLabel;
/**
 会员图标
 */
@property (nonatomic, strong) UIImageView *vipImageView;
/**
 时间
 */
@property (nonatomic, strong) UILabel *timeLabel;
/**
 来源
 */
@property (nonatomic, strong) UILabel *sourceLabel;
/**
 正文
 */
@property (nonatomic, strong) UILabel *contentLabel;
/**
 数据模型
 */
@property (nonatomic, strong) LJStatus *status;
/**
 显示图片
 */
@property (nonatomic, strong) UICollectionView *pictureCollectionnView;

@property (nonatomic, strong) LJStatusViewModel *viewModel;

/**
 返回每个cell最大的y值
 
 @param viewModel <#viewModel description#>
 @return <#return value description#>
 */
- (CGFloat)calculateRowHeight:(LJStatusViewModel *)viewModel;

@end
