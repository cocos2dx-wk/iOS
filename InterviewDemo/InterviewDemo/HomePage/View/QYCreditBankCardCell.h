//
//  QYCreditBankCardCell.h
//  QYStaging
//
//  Created by wangkai on 2017/4/7.
//  Copyright © 2017年 wangkai. All rights reserved.
//  银行卡信息

#import <UIKit/UIKit.h>

@interface QYCreditBankCardCell : UITableViewCell

/* 银行名字*/
@property (weak, nonatomic) IBOutlet UILabel *m_bankNameLabel;
/* 银行类别*/
@property (weak, nonatomic) IBOutlet UILabel *m_typeLabel;
/* 银行线*/
@property (weak, nonatomic) IBOutlet UIView *m_lineView;

@end
