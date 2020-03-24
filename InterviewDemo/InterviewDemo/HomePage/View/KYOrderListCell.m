//
//  KYOrderListCell.m
//  QYStaging
//
//  Created by mac on 2018/3/30.
//  Copyright © 2018年 wangkai. All rights reserved.
//

#import "KYOrderListCell.h"

@interface KYOrderListCell()

//图片
@property (weak, nonatomic) IBOutlet UIImageView *m_imageUrl;
//商品名
@property (weak, nonatomic) IBOutlet UILabel *m_goodNameLabel;
//价格
@property (weak, nonatomic) IBOutlet UILabel *m_priceLabel;
//数量
@property (weak, nonatomic) IBOutlet UILabel *m_amountLabel;

@end

@implementation KYOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)updateUI:(KYOrderGoodsList *)model{
    //图片
    if (model.imgUrl.length > 0) {
        [self.m_imageUrl sd_setImageWithURL: [NSURL URLWithString:model.imgUrl]] ;
    }
    
    //商品名字
    self.m_goodNameLabel.text = model.goodsName;
    
    //金额
    if(model.price){
         self.m_priceLabel.text = model.price;
    }else {
        self.m_priceLabel.text = @"0.00";
    }
   
    
    //数量
    self.m_amountLabel.text =[NSString stringWithFormat:@"x %@",model.goodsNum] ;
}


@end
