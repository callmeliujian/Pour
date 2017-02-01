//
//  VisitorView.h
//  Pour-微博
//
//  Created by 😄 on 2016/11/30.
//  Copyright © 2016年 😄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJVisitorView : UIView

@property(nonatomic, strong) UIImageView *visitorHouse;

@property(nonatomic, strong) UIImageView *visitorImage;

@property(nonatomic, strong) UIImageView *visitorMask;

@property(nonatomic, strong) UILabel *textLabel;

@property(nonatomic, strong) UIButton *loginButton;
@property(nonatomic, strong) UIButton *registerButton;

- (void)setSubView:(NSString *)imageName with:(NSString *)labelText withIson:(BOOL)boolon;

- (void)startAnimation;

@end
