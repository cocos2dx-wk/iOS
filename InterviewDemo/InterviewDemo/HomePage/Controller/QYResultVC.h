//
//  QYResultVC.h
//  QYStaging
//
//  Created by wangkai on 2017/5/2.
//  Copyright © 2017年 wangkai. All rights reserved.
//  结果页

#import "BaseViewController.h"

@interface QYResultVC : BaseViewController

//    1:您的信用评估不符合分期产品准入资格，无法使用分期服务
//    2:补充财务信息
//    3:补充资产信息
//    4:提交成功，订单审核中
//    5:待面签
//    6:待网签
//    7:已完成
@property(nonatomic,copy)NSString *s_status;
/* 订单id*/
@property(nonatomic,copy)NSString *s_orderId;
/* 平台*/
@property(copy,nonatomic)NSString *s_platFormStr;

@end
