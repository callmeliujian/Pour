//
//  LJBaseTableViewCell.h
//  Pour-微博
//
//  Created by 刘健 on 2017/2/20.
//  Copyright © 2017年 😄. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LJStatusViewModel.h"

@interface LJBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) LJStatusViewModel *viewModel;

@end
