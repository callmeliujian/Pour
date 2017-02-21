//
//  LJBrowserViewController.m
//  Pour-微博
//
//  Created by 刘健 on 2017/2/21.
//  Copyright © 2017年 😄. All rights reserved.
//

#import "LJBrowserViewController.h"

@interface LJBrowserViewController ()

/**
 所有配图
 */
@property (nonatomic, strong) NSArray *bmiddle_pic;
/**
 当前点击索引
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation LJBrowserViewController

- (instancetype)initWithArray:(NSArray *)bmiddle_pic withIndexPath:(NSIndexPath *)indexPath {
    
    self = [super init];
    
    self.bmiddle_pic = bmiddle_pic;
    self.indexPath = indexPath;
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark -
- (NSArray *)bmiddle_pic {
    if (_bmiddle_pic == nil) {
        _bmiddle_pic = [[NSArray alloc] init];
    }
    return _bmiddle_pic;
}

- (NSIndexPath *)indexPath {
    if (_indexPath == nil) {
        _indexPath = [[NSIndexPath alloc] init];
    }
    return _indexPath;
}

@end
