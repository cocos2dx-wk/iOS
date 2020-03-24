//
//  KYOrderListFooterView.h
//  QYStaging
//
//  Created by mac on 2018/4/2.
//  Copyright © 2018年 wangkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYListOrder.h"

@interface KYOrderListFooterView : UIView

//订单状态
@property (weak, nonatomic) IBOutlet UIButton *m_statusLabel;

-(void)updateUI:(KYListOrder *)model;

@end
