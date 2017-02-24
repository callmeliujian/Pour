//
//  LJHomePictureCollectionViewCell.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/10.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJHomePictureCollectionViewCell.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation LJHomePictureCollectionViewCell
#pragma mark - LifeCycle
- (void)layoutSubviews {
    [self.contentView addSubview:self.customIconImageView];
    [self.contentView addSubview:self.gifImageView];
    
    [self.customIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.trailing.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.leading.mas_equalTo(self);
    }];
    
    [self.gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.contentView);
    }];
    
}

#pragma Lazy
- (UIImageView *)customIconImageView {
    if (_customIconImageView == nil) {
        _customIconImageView = [[LJProgressImageView alloc] init];
        _customIconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _customIconImageView.clipsToBounds = YES;
    }
    return _customIconImageView;
}

- (UIImageView *)gifImageView {
    if (_gifImageView == nil) {
        _gifImageView = [[UIImageView alloc] init];
        [_gifImageView sizeToFit];
        _gifImageView.image = [UIImage imageNamed:@"gif"];
    }
    return _gifImageView;
}

#pragma mark - set
- (void)setUrl:(NSURL *)url {
    if (_url == nil) {
        _url = [[NSURL alloc] init];
    }
    _url = url;
    // 设置图片
    [self.customIconImageView sd_setImageWithURL:_url];
    
    // 控制gif图标的显示和隐藏
    BOOL flag = [_url.absoluteString.lowercaseString hasSuffix:@"gif"];
    if (!flag)
        self.gifImageView.hidden = !flag;
}

@end
