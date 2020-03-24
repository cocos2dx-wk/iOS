//
//  QYOrderCell.m
//  QYStaging
//
//  Created by wangkai on 2017/4/21.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYOrderCell.h"
#import <UIImageView+WebCache.h>
@interface QYOrderCell()

/* 灰色条高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_grayHeightConstraing;

/* 边线*/
@property (weak, nonatomic) IBOutlet UIView *m_lineView;
@property (weak, nonatomic) IBOutlet UIView *m_line1View;

@end

@implementation QYOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.m_lineView.layer.borderColor = [[UIColor colorWithMacHexString:@"e7e7e7"] CGColor];
    self.m_lineView.layer.borderWidth = 0.5;
}

-(void)updateUI:(QYProductDetailModel *)model{
    if (!self.s_isGray) {//订单详情
        self.m_grayHeightConstraing.constant = 0;
        self.m_priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[[NSString stringWithFormat:@"%@",model.price] floatValue]];
        self.m_amountLabel.text = [NSString stringWithFormat:@"X%@",model.number];
        self.self.m_status.hidden = YES;
    }else{
        self.m_line1View.hidden = YES;
        self.m_amountLabel.hidden = YES;
        self.m_priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[[NSString stringWithFormat:@"%@",model.totalAmount] floatValue]];
    }
    if (model.imgUrl.length > 0) {
        [self.m_iconImageView sd_setImageWithURL: [NSURL URLWithString:model.imgUrl]] ;
    }
//    -1：全部订单、0:待审核、1：待网签、2：待面签、3：已完成、4：已取消
    self.m_nameLabel.text = [AppGlobal orderTitleSubString:model.goodsName andCount:[[NSString stringWithFormat:@"%@",model.goodsNum] integerValue]];
    if ([model.status isEqualToString:@"1"] || [model.status isEqualToString:@"2"]) {
        self.m_status.text = @"待签约";
        self.m_status.textColor = color_blueButtonColor;
    }else if ([model.status isEqualToString:@"3"]) {
        self.m_status.text = @"已完成";
        self.m_status.textColor = [UIColor colorWithHexString:@"bbbbbb"];
    }else if ([model.status isEqualToString:@"4"]) {
        self.m_status.text = @"已取消";
        self.m_status.textColor = [UIColor colorWithHexString:@"bbbbbb"];
    }else{
        self.m_status.text = @"待审核";
        self.m_status.textColor = [UIColor colorWithHexString:@"30cea3"];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
