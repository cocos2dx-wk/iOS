//
//  QYCreditBankCardCell.m
//  QYStaging
//
//  Created by wangkai on 2017/4/7.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYCreditBankCardCell.h"

@interface QYCreditBankCardCell()

/* 图标*/
@property (weak, nonatomic) IBOutlet UIImageView *m_iconImg;


@end
@implementation QYCreditBankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
