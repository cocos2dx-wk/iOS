//
//  KYOrderListHeaderView.m
//  QYStaging
//
//  Created by mac on 2018/4/2.
//  Copyright © 2018年 wangkai. All rights reserved.
//

#import "KYOrderListHeaderView.h"


@interface KYOrderListHeaderView()

//订单号
@property (weak, nonatomic) IBOutlet UILabel *m_titleNumberLabel;


@end

@implementation KYOrderListHeaderView


-(void)updateUI:(KYListOrder *)model{
    //订单号
    self.m_titleNumberLabel.text = [NSString stringWithFormat:@"订单号：%@",model.orderNum];
}

@end
