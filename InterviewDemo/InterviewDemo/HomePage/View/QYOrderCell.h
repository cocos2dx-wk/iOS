//
//  QYOrderCell.h
//  QYStaging
//
//  Created by wangkai on 2017/4/21.
//  Copyright © 2017年 wangkai. All rights reserved.
//  订单cell

#import <UIKit/UIKit.h>
#import "QYProductDetailModel.h"

@interface QYOrderCell : UITableViewCell

/*是否有灰条 */
@property(assign,nonatomic)BOOL s_isGray;

/* 商品*/
@property (weak, nonatomic) IBOutlet UIImageView *m_iconImageView;
/* 商品名字*/
@property (weak, nonatomic) IBOutlet UILabel *m_nameLabel;
/* 商品价格*/
@property (weak, nonatomic) IBOutlet UILabel *m_priceLabel;
/* 状态 订单状态：-1：全部订单、0:待审核、1：待网签、2：待面签、3：已完成、4：已取消*/
@property (weak, nonatomic) IBOutlet UILabel *m_status;
/* 数量*/
@property (weak, nonatomic) IBOutlet UILabel *m_amountLabel;

- (void)updateUI:(QYProductDetailModel *)model;

@end
