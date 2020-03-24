//
//  QYAllOrderListVC.h
//  QYStaging
//
//  Created by wangkai on 2017/4/24.
//  Copyright © 2017年 wangkai. All rights reserved.
//  我的订单列表

#import "BaseViewController.h"
#import "ZJScrollPageViewDelegate.h"

@interface QYAllOrderListVC : BaseViewController<ZJScrollPageViewChildVcDelegate>


/**
 更新状态

 @param index index description
 */
-(void)updateStatus:(NSInteger)index;
@end
