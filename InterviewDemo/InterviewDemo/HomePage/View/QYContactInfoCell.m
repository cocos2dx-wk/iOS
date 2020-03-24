//
//  QYContactInfoCell.m
//  QYStaging
//
//  Created by Jyawei on 2017/7/27.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYContactInfoCell.h"

@interface QYContactInfoCell ()

/** 修改文字 */
@property (weak, nonatomic) IBOutlet UILabel *changeLable;

@end

@implementation QYContactInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.changeLable.layer.borderColor = [UIColor colorWithHexString:@"5E8BF8"].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
