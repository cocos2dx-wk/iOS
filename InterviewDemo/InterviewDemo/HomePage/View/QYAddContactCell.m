//
//  QYAddContactCell.m
//  QYStaging
//
//  Created by Jyawei on 2017/7/27.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYAddContactCell.h"

@interface QYAddContactCell ()

/** 副标题 */
@property (weak, nonatomic) IBOutlet UILabel *subtitleLable;
/** 图标居中 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactIconCenterY;

@end

@implementation QYAddContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 设置cell的UI
 */
- (void)setCellUiStatus:(BOOL)status {
    if (status) {
        self.subtitleLable.hidden = NO;
        self.contactIconCenterY.constant = -10;
    } else {
        self.subtitleLable.hidden = YES;
        self.contactIconCenterY.constant = 0;
    }
}

@end
