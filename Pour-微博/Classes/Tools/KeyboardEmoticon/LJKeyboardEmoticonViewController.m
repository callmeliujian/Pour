//
//  LJKeyboardEmoticonViewController.m
//  表情键盘
//
//  Created by 刘健 on 2017/3/7.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "LJKeyboardEmoticonViewController.h"
#import "LJKeyboardFlowLayout.h"
#import "LJKeyboardEmoticonCollectionViewCell.h"

@interface LJKeyboardEmoticonViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) NSArray <LJKeyboardpackage*>*package;

@end

@implementation LJKeyboardEmoticonViewController

#pragma mark - LifeCycle

- (instancetype)initWithEmoticonBlock:(void (^)(LJKeyboardEmoticon *emoticon))block {
    self = [super init];
    
    self.emoticonBlock = block;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.toolbar];
    
    [self setupUI];
}

#pragma mark - PrivateMethod
- (void)itemClick:(UIBarButtonItem *)item {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:item.tag];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
}

- (void)setupUI {
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = false;
    self.toolbar.translatesAutoresizingMaskIntoConstraints = false;
    
    NSDictionary *dict = @{@"collectionView":self.collectionView, @"toolbar":self.toolbar};
    
    NSArray *collectionViewHCons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    NSArray *toolbarHCons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[toolbar]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    NSArray *VCons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-[toolbar(49)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    [self.view addConstraints:collectionViewHCons];
    [self.view addConstraints:toolbarHCons];
    [self.view addConstraints:VCons];
    
}

#pragma mark - PublicMethod

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LJKeyboardpackage *package = self.package[indexPath.section];
    LJKeyboardEmoticon *emoticon = package.emoticons[indexPath.item];
    
    NSLog(@"%@",emoticon.chs);
    
    emoticon.count ++;
    
    // 不是删除按钮
    if (!emoticon.isRemoveBtn) {
        [self.package[0] addFavourtEmoticon:emoticon];
    }
    self.emoticonBlock(emoticon);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.package.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.package[section].emoticons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LJKeyboardEmoticonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"keyboardCell" forIndexPath:indexPath];
    
    cell.emoticon = self.package[indexPath.section].emoticons[indexPath.item];
    
    return cell;
}

#pragma mark - Lazy
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[LJKeyboardFlowLayout alloc] init]];
        _collectionView.backgroundColor = [UIColor colorWithRed:246 green:246 blue:246 alpha:1.0];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:LJKeyboardEmoticonCollectionViewCell.self forCellWithReuseIdentifier:@"keyboardCell"];
    }
    return _collectionView;
}

- (UIToolbar *)toolbar {
    if (_toolbar == nil) {
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.tintColor = [UIColor lightGrayColor];
        NSMutableArray <UIBarButtonItem *>*items = [NSMutableArray array];
        NSInteger index = 0;
        for (id title in @[@"最近",@"默认",@"Emoji",@"浪小花"]) {
            // 创建item
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(itemClick:)];
            item.tag = index++;
            [items addObject:item];
            
            // 创建间隙
            UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [items addObject:flexibleItem];
        }
        [items removeLastObject];
        
        // 将item添加到toolbar
        _toolbar.items = items;
    }
    return _toolbar;
}

- (NSArray<LJKeyboardpackage *> *)package {
    if (_package == nil) {
        _package = [[LJKeyboardpackage alloc] loadEmotionPackages];
    }
    return _package;
}

@end
