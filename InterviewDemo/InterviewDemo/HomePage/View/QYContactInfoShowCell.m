//
//  QYContactInfoShowCell.m
//  QYStaging
//
//  Created by Jyawei on 2017/8/2.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYContactInfoShowCell.h"

@interface QYContactInfoShowCell ()

@end

@implementation QYContactInfoShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEmergencyModel:(QYEmergencyModel *)emergencyModel {
    _emergencyModel = emergencyModel;
    
    NSString *iceType = nil;
    /** 紧急联系人关系： 0：配偶、1：父母、2：子女、3：其他 */
    if ([emergencyModel.iceType isEqualToString:@"0"]) {
        iceType = @"配偶";
    } else if ([emergencyModel.iceType isEqualToString:@"1"]) {
        iceType = @"父母";
    } else if ([emergencyModel.iceType isEqualToString:@"2"]) {
        iceType = @"子女";
    } else if ([emergencyModel.iceType isEqualToString:@"3"]) {
        iceType = @"其他";
    } else {
        iceType = @"";
    }
    self.relationshipLable.text = [NSString stringWithFormat:@"关系：%@",iceType];
    
    NSString *iceName = nil;
    if (emergencyModel.iceName.length > 0) {
        iceName = emergencyModel.iceName;
    } else {
        iceName = @"";
    }
    self.nameLable.text = [NSString stringWithFormat:@"姓名：%@",iceName];
    
    NSString *icePhone = nil;
    if (emergencyModel.icePhone.length > 0) {
        icePhone = emergencyModel.icePhone;
    } else {
        icePhone = @"";
    }
    self.phoneLable.text = [NSString stringWithFormat:@"联系电话：%@",icePhone];
}

@end
