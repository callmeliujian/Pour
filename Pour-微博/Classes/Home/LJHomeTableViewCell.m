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


@interface LJHomeTableViewCell()<UICollectionViewDataSource>
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

@property (nonatomic, strong) LJSize *cellAndCollSize;

/**
 显示配图
 */
@property (nonatomic, strong) LJHomePictureCollectionViewCell *cell;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end


@implementation LJHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildHomeCell];
    }
    return self;
}

#pragma mark - 外部控制方法

- (CGFloat)calculateRowHeight:(LJStatusViewModel *)viewModel {
    self.viewModel = viewModel;
    [self layoutIfNeeded];
    return CGRectGetMaxY(self.containerView.frame);
}

#pragma mark - 内部控制方法
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
    self.timeLabel.backgroundColor = [UIColor purpleColor];
    self.timeLabel.textColor = [UIColor orangeColor];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.bottom.mas_equalTo(self.iconImageView);
    }];
}

- (void)buildsourceLabel {
    
    [self.sourceLabel sizeToFit];
    self.sourceLabel.backgroundColor = [UIColor greenColor];
    self.sourceLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.sourceLabel];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.timeLabel);
    }];
}

- (void)buildcontentLabel {
    
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel sizeToFit];
    self.contentLabel.backgroundColor = [UIColor grayColor];
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
    self.pictureCollectionnView.dataSource = self;
    [self.pictureCollectionnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(290, 90));
        make.left.mas_equalTo(self.contentLabel);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_equalTo(10);
    }];
    
    
    
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.viewModel.thumbnail_pic.count) {
        return self.viewModel.thumbnail_pic.count;
    }
    return 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pictureCell" forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor redColor];
    self.cell.url = self.viewModel.thumbnail_pic[indexPath.item];
    return self.cell;
    
}

#pragma mark - lazy

- (UICollectionViewFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _layout;
}

- (UICollectionView *)pictureCollectionnView {
    if (_pictureCollectionnView == nil) {
        _pictureCollectionnView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
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
        _containerView.backgroundColor = [UIColor blueColor];
    }
    return _containerView;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.backgroundColor = [UIColor blackColor];
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

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
    }
    return _contentLabel;
}

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
    self.contentLabel.text = _viewModel.status.text;
    
//    if (self.viewModel.thumbnail_pic.count <= 9 && self.viewModel.thumbnail_pic.count > 0) {
//        NSLog(@"cou--%lu",(unsigned long)self.viewModel.thumbnail_pic.count);
//        NSLog(@"hei--%f",[self calculateSize].collectionviewSize.height);
//        NSLog(@"wid--%f",[self calculateSize].collectionviewSize.width);
//    }
    
    // 8.更新配图
    [self.pictureCollectionnView reloadData];
    
    // 9.更新配图尺寸
    if (!CGSizeEqualToSize([self calculateSize].cellSize, CGSizeZero)) {
        self.layout.itemSize = [self calculateSize].cellSize;
        [self setNeedsUpdateConstraints];
    }
    
    
    
    
    
}

- (void)updateConstraints {
    
    [self.pictureCollectionnView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([self calculateSize].collectionviewSize.height);
        make.width.mas_equalTo([self calculateSize].collectionviewSize.width);
    }];
    
    [super updateConstraints];
}

/**
 计算cell和collectionview的尺寸
 
 没有配图: cell = zero, collectionview = zero
 一张配图: cell = image.size, collectionview = image.size
 四张配图: cell = {90, 90}, collectionview = {2*w+m, 2*h+m}
 其他张配图: cell = {90, 90}, collectionview =

 @return LJSize包含cell和collecionview尺寸
 */
- (LJSize *)calculateSize {
    if (_cellAndCollSize == nil) {
        _cellAndCollSize = [[LJSize alloc] init];
    }
    NSUInteger count = self.viewModel.thumbnail_pic.count;
    
    // 没有配图
    if (count == 0) {
        self.cellAndCollSize.cellSize = CGSizeZero;
        self.cellAndCollSize.collectionviewSize = CGSizeZero;
        return self.cellAndCollSize;
    }
    
    // 一张配图
    if (count == 1) {
        NSString *key = [self.viewModel.thumbnail_pic.firstObject absoluteString];
        UIImage *image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:key];
        self.cellAndCollSize.cellSize = image.size;
        self.cellAndCollSize.collectionviewSize = image.size;
        return self.cellAndCollSize;
    }
    
    // 四张配图
    CGFloat imageWidth = 90;
    CGFloat imageHeigh = 90;
    CGFloat imageMargin = 10;
    if (count == 4) {
        int col = 2;
        int row = col;
        // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
        CGFloat width = imageWidth * col + (col - 1) * imageMargin;
        // 高度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
        CGFloat height = imageHeigh * row + (row - 1) * imageMargin;
        self.cellAndCollSize.cellSize = CGSizeMake(imageWidth, imageHeigh);
        self.cellAndCollSize.collectionviewSize = CGSizeMake(width, height);
        return self.cellAndCollSize;
    }
    
    // 其他张配图
    int col = 3;
    float row = (count - 1) / 3 + 1;
    // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
    CGFloat width = imageWidth * col + (col - 1) * imageMargin;
    // 宽度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
    CGFloat height = imageHeigh * row + (row - 1) * imageMargin;
    self.cellAndCollSize.cellSize = CGSizeMake(imageWidth, imageHeigh);
    self.cellAndCollSize.collectionviewSize = CGSizeMake(width, height);
    return self.cellAndCollSize;

}

















//- (void)setStatus:(LJStatus *)status {
//    if (_status == nil) {
//        _status = [[LJStatus alloc] init];
//        _status = status;
//    }
////    // 1.设置头像
////    NSURL *url = [NSURL URLWithString:self.status.user.profile_image_url];
////    [_iconImageView sd_setImageWithURL:url];
//    // 2.设置认证图标
////    int type = _status.user.verified_type;
////    NSString *name = @"";
////    switch (type) {
////        case 0:
////            name = @"avatar_vip";
////            break;
////        case 2:
////        case 3:
////        case 5:
////            name = @"avatar_enterprise_vip";
////            break;
////        case 220:
////            name = @"avatar_grassroot";
////        default:
////            break;
////    }
////    _verifiedImageView.image = [UIImage imageNamed:name];
//    // 3.设置昵称
//    _nameLabel.text = _status.user.screen_name;
//    
//    
//    // 4.设置会员图标
//    if (_status.user.mbrank >=1 && _status.user.mbrank <=6) {
//        NSString *string = @"common_icon_membership_level";
//        NSString *stringInt = [NSString stringWithFormat:@"%d",_status.user.mbrank];
//        NSString *string2 = [string stringByAppendingString:stringInt];
//        _vipImageView.image = [UIImage imageNamed:string2];
//        _nameLabel.textColor = [UIColor orangeColor];
//    }else {
//        // cell会重用，需要恢复到原来的文字颜色
//        _nameLabel.textColor = [UIColor blackColor];
//    }
//    
//    // 5.设置时间
//    /**
//     刚刚(一分钟内)
//     X分钟前(一小时内)
//     X小时前(当天)
//     
//     昨天 HH:mm(昨天)
//     
//     MM-dd HH:mm(一年内)
//     yyyy-MM-dd HH:mm(更早期)
//     */
//    // "Sun Dec 06 11:10:41 +0800 2015"
//    _timeLabel.text = @"刚刚";
////    if (_status.created_at != nil) {
////        // 1.将服务器返回的时间转换为NSDate
////        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
////        formatter.dateFormat = @"EE MM dd HH:mm:ss Z yyyy";
////        // 不指定以下代码在真机中可能无法转换
////        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
////        NSDate *createDate = [formatter dateFromString:_status.created_at];
////        
////        // 创建一个日历类
////        NSCalendar *calendar = [NSCalendar currentCalendar];
////        NSString *result = @"";
////        NSString *formatterStr = @"HH:mm";
////        if ([calendar isDateInToday:createDate]) {
////            //今天
////            // 3.比较两个时间之间的差值
////            NSTimeInterval interval = [createDate timeIntervalSinceNow];
////            if ((-interval) < 60 ) {
////                result = @"刚刚";
////            }else if((-interval) < 60 *60){
////                NSString *stringInterbal = [NSString stringWithFormat:@"%d",(int)(-interval) / 60 ];
////                result = [stringInterbal stringByAppendingString:@"分钟前"];
////            }else if ([calendar isDateInYesterday:createDate]){
////                formatterStr = [@"昨天" stringByAppendingString:formatterStr];
////                formatter.dateFormat = formatterStr;
////                result = [formatter stringFromDate:createDate];
////            }else{
////                NSDateComponents *comps = [calendar components:NSCalendarUnitYear fromDate:createDate toDate:[NSDate init] options:NSCalendarWrapComponents];
////                if (comps.year >= 1) {
////                    formatterStr = [@"yyyy-MM-dd" stringByAppendingString:formatterStr];
////                }else{
////                    formatterStr = [@"MM-dd" stringByAppendingString:formatterStr];
////                }
////                formatter.dateFormat = formatterStr;
////                result = [formatter stringFromDate:createDate];
////            }
////            
////
//             _timeLabel.text = result;
//            
//            
//            
//            
//            
//        }
//    }
//
//    // 6.设置来源
//    if (![_status.source isEqualToString:@""] || _status.source != nil) {
//        NSString *sourceStr = _status.source;
//        NSUInteger startIndex = [sourceStr rangeOfString:@">"].location + 1;
//        NSUInteger length = [sourceStr rangeOfString:@"<" options:NSBackwardsSearch].location - startIndex;
//        NSString *string3 = @"来自: ";
//        _sourceLabel.text = [string3 stringByAppendingString:[sourceStr substringWithRange:NSMakeRange(startIndex, length)]];
//    }
//
//    // 7.设置正文
//    _contentLabel.text = _status.text;
//    
//}

@end
