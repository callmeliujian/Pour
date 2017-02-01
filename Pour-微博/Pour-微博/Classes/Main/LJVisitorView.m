//
//  VisitorView.m
//  Pour-微博
//
//  Created by 😄 on 2016/11/30.
//  Copyright © 2016年 😄. All rights reserved.
//

#import "LJVisitorView.h"
#import "Masonry.h"

@implementation LJVisitorView

- (instancetype)init
{
    self = [super init];
    
    self.backgroundColor = [UIColor colorWithWhite:203.0/255/0 alpha:1];
    
    self.visitorHouse = [[UIImageView alloc] init];
    self.visitorHouse.image = [UIImage imageNamed:@"visitordiscover_feed_image_house"];
    [self.visitorHouse sizeToFit];
    
    self.visitorImage = [[UIImageView alloc] init];
    self.visitorImage.image = [UIImage imageNamed:@"visitordiscover_feed_image_smallicon"];
    [self.visitorImage sizeToFit];
    
    self.visitorMask = [[UIImageView alloc] init];
    self.visitorMask.image = [UIImage imageNamed:@"visitordiscover_feed_mask_smallicon"];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.text = @"关注一些人，回这里看看有什么惊喜";
    self.textLabel.textColor = [UIColor grayColor];
    self.textLabel.numberOfLines = 0;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.textLabel sizeToFit];
    
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    

    
    
    [self addSubview:self.visitorImage];
    [self addSubview:self.visitorMask];
    [self addSubview:self.visitorHouse];
    [self addSubview:self.textLabel];
    [self addSubview:self.registerButton];
    [self addSubview:self.loginButton];
    
    
    
    [self.visitorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.visitorMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.mas_offset(0);
        make.left.equalTo(self).with.mas_offset(0);
        make.right.equalTo(self).with.mas_offset(0);
        make.bottom.equalTo(self.textLabel.mas_top).with.mas_offset(0);
    }];
    [self.visitorHouse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).with.mas_offset(18);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(100);
        make.width.mas_equalTo(250);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.equalTo(self.textLabel.mas_bottom).with.offset(10);
        make.width.mas_equalTo(100);
    }];
//
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textLabel);
        make.top.equalTo(self.textLabel.mas_bottom).with.offset(10);
        make.width.mas_equalTo(100);
    }];
    

    
    return self;
}

- (void)setSubView:(NSString *)imageName with:(NSString *)labelText withIson:(BOOL)boolon
{
    self.visitorHouse.image = [UIImage imageNamed:imageName];
    self.textLabel.text = labelText;
    self.visitorImage.hidden = boolon;
    
    if ([imageName isEqualToString:@"bbb"]) {
        [self startAnimation];
    }
    
}

- (void)startAnimation
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    anim.toValue = @(2 *M_PI);
    
    anim.duration = 5.0;
    anim.repeatCount = MAXFLOAT;
    
    
    [self.visitorImage.layer addAnimation:anim forKey:nil];
    
    
    
}


@end
