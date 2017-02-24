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


- (void)layoutSubviews {
    [self.contentView addSubview:self.customIconImageView];
    [self.customIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.trailing.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.leading.mas_equalTo(self);
    }];
    
}

- (UIImageView *)customIconImageView {
    if (_customIconImageView == nil) {
        _customIconImageView = [[LJProgressImageView alloc] init];
        _customIconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _customIconImageView.clipsToBounds = YES;
    }
    return _customIconImageView;
}

- (void)setUrl:(NSURL *)url {
    if (_url == nil) {
        _url = [[NSURL alloc] init];
    }
    _url = url;
    [self.customIconImageView sd_setImageWithURL:_url];
}

@end
