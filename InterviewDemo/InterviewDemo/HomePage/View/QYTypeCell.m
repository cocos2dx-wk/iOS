//
//  QYTypeCell.m
//  QYStaging
//
//  Created by wangkai on 2017/12/13.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYTypeCell.h"

@interface QYTypeCell()

/* 商品图片宽度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_imageWidthConstraint;
/* 商品图片高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_imageHeightConstraint;


@end


@implementation QYTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (iphone6Plus) {
        self.m_imageWidthConstraint.constant = 32 + 10;
        self.m_imageHeightConstraint.constant = 27 + 10;
    }
}

@end
