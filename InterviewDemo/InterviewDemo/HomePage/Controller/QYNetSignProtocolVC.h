//
//  QYNetSignProtocolVC.h
//  QYStaging
//
//  Created by MobileUser on 2017/5/1.
//  Copyright © 2017年 wangkai. All rights reserved.
//  网签协议

#import "BaseViewController.h"

@interface QYNetSignProtocolVC : BaseViewController

/* 订单id */
@property (nonatomic,copy) NSString *m_orderId;
/* 平台类型 */
@property (nonatomic,copy) NSString *s_platForm;

@end
