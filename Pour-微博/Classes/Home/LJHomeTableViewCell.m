//
//  LJHomeTableViewCell.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/6.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJHomeTableViewCell.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LJSize.h"
#import "LJHomeTableViewCell.h"
#import "LJHomePictureCollectionViewCell.h"
#import "LJKeyboardpackage.h"
#import "LJKeyboardpackage+LJRegularExpression.h"



@interface LJHomeTableViewCell()
/**
 转发按钮
 */
@property (nonatomic, strong) UIButton *forardBtn;
/**
 评论按钮
 */
@property (nonatomic, strong) UIButton *criticismBtn;
/**
 赞按钮
 */
@property (nonatomic, strong) UIButton *fabulousBtn;
/**
 容器视图
 */
@property (nonatomic, strong) UIView *containerView;

@end


@implementation LJHomeTableViewCell

#pragma mark - LifeCycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildHomeCell];
    }
    return self;
}

#pragma mark - PublicMehtod
- (CGFloat)calculateRowHeight:(LJStatusViewModel *)viewModel {
    self.viewModel = viewModel;
    [self layoutIfNeeded];
    return CGRectGetMaxY(self.containerView.frame);
}

#pragma mark - PrivateMethod
/**
 构建展示每条微博内容cell
 */
- (void)buildHomeCell {
    [self buildIconImageView];
    [self buildverifiedImageView];
    [self buildnameLabel];
    [self buildvipImageView];
    [self buildtimeLabel];
    [self buildsourceLabel];
    [self buildcontentLabel];
    [self buildpictureCollectionnView];
    [self buildcontainerView];
}

- (void)buildIconImageView {
    self.iconImageView.layer.cornerRadius = 30;
    self.iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.equalTo(self.contentView).mas_offset(10);
        make.top.equalTo(self.contentView).mas_offset(10);
    }];
}

- (void)buildverifiedImageView {
    [self.contentView addSubview:self.verifiedImageView];
    [self.verifiedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.right.equalTo(self.iconImageView);
        make.bottom.equalTo(self.iconImageView);
    }];
}

- (void)buildnameLabel {
    [self.nameLabel sizeToFit];
    self.nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView);
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(10);
    }];
}

- (void)buildvipImageView {
    [self.contentView addSubview:self.vipImageView];
    [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(14, 14));
        make.centerY.mas_equalTo(self.nameLabel);
        make.left.mas_equalTo(self.nameLabel.mas_right).mas_offset(10);
    }];
}

- (void)buildtimeLabel {
    [self.timeLabel sizeToFit];
    self.timeLabel.textColor = [UIColor orangeColor];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.bottom.mas_equalTo(self.iconImageView);
    }];
}

- (void)buildsourceLabel {
    [self.sourceLabel sizeToFit];
    self.sourceLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.sourceLabel];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.timeLabel);
    }];
}

- (void)buildcontentLabel {
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel sizeToFit];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 2 * 10;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_left);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(10);
    }];
}

- (void)buildcontainerView {
    [self.contentView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 50));
        make.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.pictureCollectionnView.mas_bottom).mas_offset(10);
    }];
    [self buildForardBtnAndCriticismBtnAndFabulousBtn];
}

- (void)buildForardBtnAndCriticismBtnAndFabulousBtn {
    [self.containerView addSubview:self.forardBtn];
    [self.containerView addSubview:self.criticismBtn];
    [self.containerView addSubview:self.fabulousBtn];
    
    [self.forardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self.containerView);
    }];
    [self.criticismBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.forardBtn.mas_right);
        make.top.width.height.mas_equalTo(self.forardBtn);
    }];
    [self.fabulousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.criticismBtn.mas_right);
        make.right.mas_equalTo(self.containerView);
        make.top.width.height.mas_equalTo(self.criticismBtn);
    }];
    
    
}

- (void)buildpictureCollectionnView {
    [self.contentView addSubview:self.pictureCollectionnView];
    [self.pictureCollectionnView registerClass:[LJHomePictureCollectionViewCell class] forCellWithReuseIdentifier:@"pictureCell"];
    [self.pictureCollectionnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(290, 90));
        make.left.mas_equalTo(self.contentLabel);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_equalTo(10);
    }];
}

#pragma mark - lazy
- (LJPictureCollectionView *)pictureCollectionnView {
    if (_pictureCollectionnView == nil) {
        _pictureCollectionnView = [[LJPictureCollectionView alloc] init];
    }
    return _pictureCollectionnView;
}

- (UIButton *)fabulousBtn {
    if (_fabulousBtn == nil) {
        _fabulousBtn = [[UIButton alloc] init];
        [_fabulousBtn setTitle:@"赞" forState:UIControlStateNormal];
        [_fabulousBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _fabulousBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [_fabulousBtn setImage:[UIImage imageNamed:@"timeline_icon_like"] forState:UIControlStateNormal];
    }
    return _fabulousBtn;
}

- (UIButton *)criticismBtn {
    if (_criticismBtn == nil) {
        _criticismBtn = [[UIButton alloc] init];
        [_criticismBtn setTitle:@"评论" forState:UIControlStateNormal];
        [_criticismBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _criticismBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [_criticismBtn setImage:[UIImage imageNamed:@"timeline_icon_comment"] forState:UIControlStateNormal];
    }
    return _criticismBtn;
}

- (UIButton *)forardBtn {
    if (_forardBtn == nil) {
        _forardBtn = [[UIButton alloc] init];
        [_forardBtn setTitle:@"转发" forState:UIControlStateNormal];
        [_forardBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _forardBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [_forardBtn setImage:[UIImage imageNamed:@"timeline_icon_retweet"] forState:UIControlStateNormal];
    }
    return _forardBtn;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UIImageView *)verifiedImageView {
    if (_verifiedImageView == nil) {
        _verifiedImageView = [[UIImageView alloc] init];
    }
    return _verifiedImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (UIImageView *)vipImageView {
    if (_vipImageView == nil) {
        _vipImageView = [[UIImageView alloc] init];
    }
    return _vipImageView;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
    }
    return _timeLabel;
}

- (UILabel *)sourceLabel {
    if (_sourceLabel == nil) {
        _sourceLabel = [[UILabel alloc] init];
    }
    return _sourceLabel;
}

- (KILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[KILabel alloc] init];
    }
    return _contentLabel;
}

#pragma mark - set
- (void)setViewModel:(LJStatusViewModel *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    // 1.设置头像
    [self.iconImageView sd_setImageWithURL:_viewModel.icon_URL];
    // 2.设置认证图标
    self.verifiedImageView.image = _viewModel.verified_image;
    // 3.设置昵称
    self.nameLabel.text = _viewModel.status.user.screen_name;
    // 4.设置会员图标
    self.vipImageView.image = nil;
    self.nameLabel.textColor = [UIColor blackColor];
    if (_viewModel.mbrankImage) {
        self.vipImageView.image = _viewModel.mbrankImage;
        self.nameLabel.textColor = [UIColor orangeColor];
    }
    // 5.设置时间
    self.timeLabel.text = _viewModel.created_Time;
    // 6.设置来源
    self.sourceLabel.text = _viewModel.source_Text;
    // 7.设置正文
    //self.contentLabel.text = _viewModel.status.text;
    self.contentLabel.attributedText = [LJKeyboardpackage creatMutableAttrString:_viewModel.status.text withFont:self.contentLabel.font];
    // 8.更新配图
    //[self.pictureCollectionnView reloadData];
    self.pictureCollectionnView.viewModel = self.viewModel;
}

@end
