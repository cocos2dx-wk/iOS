//
//  KYOrderListFooterView.m
//  QYStaging
//
//  Created by mac on 2018/4/2.
//  Copyright © 2018年 wangkai. All rights reserved.
//

#import "KYOrderListFooterView.h"

@interface KYOrderListFooterView()

//订单总额
@property (weak, nonatomic) IBOutlet UILabel *m_totalAmountLabel;

@end

@implementation KYOrderListFooterView

-(void)updateUI:(KYListOrder *)model{
    self.m_totalAmountLabel.text = model.totalAmount;
    //    -1：全部订单、0:待审核、1：待网签、2：待面签、3：已完成、4：已取消
    if ([model.status isEqualToString:@"1"] ) {
         [self.m_statusLabel setTitle:@"待签约" forState:UIControlStateNormal]  ;
        self.m_statusLabel.layer.cornerRadius = 4 ;
          [self.m_statusLabel setTitleColor:color_purseButtonColor forState:UIControlStateNormal]  ;
        self.m_statusLabel.layer.borderWidth = 1;
        self.m_statusLabel.layer.borderColor = color_purseHeaveButtonColor.CGColor;
    }else if ([model.status isEqualToString:@"2"]) {
        [self.m_statusLabel setTitle:@"待签约" forState:UIControlStateNormal]  ;
        [self.m_statusLabel setTitleColor:color_purseButtonColor forState:UIControlStateNormal]  ;
    }else if ([model.status isEqualToString:@"3"]) {
        [self.m_statusLabel setTitle:@"已完成" forState:UIControlStateNormal]  ;
        [self.m_statusLabel setTitleColor:[UIColor colorWithHexString:@"bbbbbb"] forState:UIControlStateNormal]  ;
    }else if ([model.status isEqualToString:@"4"]) {
         [self.m_statusLabel setTitle:@"已取消" forState:UIControlStateNormal]  ;
         [self.m_statusLabel setTitleColor:[UIColor colorWithHexString:@"bbbbbb"] forState:UIControlStateNormal]  ;
        
    }else{
         [self.m_statusLabel setTitle:@"待审核" forState:UIControlStateNormal]  ;
       
          [self.m_statusLabel setTitleColor:[UIColor colorWithHexString:@"30cea3"] forState:UIControlStateNormal]  ;
    }
}


@end
