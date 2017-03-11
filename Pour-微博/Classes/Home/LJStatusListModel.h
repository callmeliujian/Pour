//
//  LJStatusListModel.h
//  Pour-微博
//
//  Created by 刘健 on 2017/2/21.
//  Copyright © 2017年 😄. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "LJStatusViewModel.h"

@interface LJStatusListModel : NSObject

/**
 保存所有的微博数据
 */
@property (nonatomic, strong)NSMutableArray <LJStatusViewModel *>*statuses;

/**
 调用LJNetworkTools的loadStatuses获取主页微博数据
 */
- (void)loadData:(BOOL)lastStatus finished:(void(^)(NSMutableArray*,NSError*))finishedBlock;

@end
