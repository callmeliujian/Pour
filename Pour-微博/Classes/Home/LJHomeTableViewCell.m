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


@implementation LJHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildHomeCell];
    }
    return self;
}

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
    //self.nameLabel.backgroundColor = [UIColor redColor];
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

#pragma mark - lazy
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

- (void)setStatus:(LJStatus *)status {
    if (_status == nil) {
        _status = [[LJStatus alloc] init];
        _status = status;
    }
    // 1.设置头像
    NSURL *url = [NSURL URLWithString:self.status.user.profile_image_url];
    [_iconImageView sd_setImageWithURL:url];
    // 2.设置认证图标
    int type = _status.user.verified_type;
    NSString *name = @"";
    switch (type) {
        case 0:
            name = @"avatar_vip";
            break;
        case 2:
        case 3:
        case 5:
            name = @"avatar_enterprise_vip";
            break;
        case 220:
            name = @"avatar_grassroot";
        default:
            break;
    }
    _verifiedImageView.image = [UIImage imageNamed:name];
    // 3.设置昵称
    _nameLabel.text = _status.user.screen_name;
    
    
    // 4.设置会员图标
    if (_status.user.mbrank >=1 && _status.user.mbrank <=6) {
        NSString *string = @"common_icon_membership_level";
        NSString *stringInt = [NSString stringWithFormat:@"%d",_status.user.mbrank];
        NSString *string2 = [string stringByAppendingString:stringInt];
        _vipImageView.image = [UIImage imageNamed:string2];
        _nameLabel.textColor = [UIColor orangeColor];
    }else {
        // cell会重用，需要恢复到原来的文字颜色
        _nameLabel.textColor = [UIColor blackColor];
    }
    
    // 5.设置时间
    /**
     刚刚(一分钟内)
     X分钟前(一小时内)
     X小时前(当天)
     
     昨天 HH:mm(昨天)
     
     MM-dd HH:mm(一年内)
     yyyy-MM-dd HH:mm(更早期)
     */
    // "Sun Dec 06 11:10:41 +0800 2015"
    _timeLabel.text = @"刚刚";
    if (_status.created_at != nil) {
        // 1.将服务器返回的时间转换为NSDate
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EE MM dd HH:mm:ss Z yyyy";
        // 不指定以下代码在真机中可能无法转换
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
        NSDate *createDate = [formatter dateFromString:_status.created_at];
        
        // 创建一个日历类
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSString *result = @"";
        NSString *formatterStr = @"HH:mm";
        if ([calendar isDateInToday:createDate]) {
            //今天
            // 3.比较两个时间之间的差值
//            NSTimeInterval interval = [createDate timeIntervalSince1970];
//             [[NSDate dateWithTimeIntervalSinceReferenceDate:interval] ];
        }
    }
    _timeLabel.text = _status.created_at;
    // 6.设置来源
    if (![_status.source isEqualToString:@""] || _status.source != nil) {
        NSString *sourceStr = _status.source;
        NSUInteger startIndex = [sourceStr rangeOfString:@">"].location + 1;
        NSUInteger length = [sourceStr rangeOfString:@"<" options:NSBackwardsSearch].location - startIndex;
        NSString *string3 = @"来自: ";
        _sourceLabel.text = [string3 stringByAppendingString:[sourceStr substringWithRange:NSMakeRange(startIndex, length)]];
    }

    // 7.设置正文
    _contentLabel.text = _status.text;
    
}

@end
