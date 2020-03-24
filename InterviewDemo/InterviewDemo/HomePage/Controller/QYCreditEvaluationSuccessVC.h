//
//  QYCreditEvaluationSuccessVC.h
//  QYStaging
//
//  Created by MobileUser on 2017/4/11.
//  Copyright © 2017年 wangkai. All rights reserved.
//  提交资料成功(可以作为公共页)

#import "BaseViewController.h"

@interface QYCreditEvaluationSuccessVC : BaseViewController

/* 提交结果种类 */
@property (nonatomic,assign) QYSubmitType m_submitType;
/* 订单id*/
@property(nonatomic,copy)NSString *s_orderId;
/* 平台*/
@property(nonatomic,copy)NSString *s_platForm;

@end
