//
//  QYOrderDetailVC.h
//  QYStaging
//
//  Created by wangkai on 2017/4/24.
//  Copyright © 2017年 wangkai. All rights reserved.
//  订单详情

#import "BaseViewController.h"
#import "QYOrderDetailModel.h"

@interface QYOrderDetailVC : BaseViewController

/* 订单model */
@property(strong,nonatomic)QYOrderDetailModel *s_orderDetailModel;
/* 控制器来源 */
@property(strong,nonatomic)UIViewController *s_fromViewController;
/* 平台类型 */
@property (nonatomic,copy) NSString *s_platForm;
// 完成订单的block
@property(nonatomic, copy) void (^backData)();
@end
