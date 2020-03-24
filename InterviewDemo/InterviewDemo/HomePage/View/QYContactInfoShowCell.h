//
//  QYContactInfoShowCell.h
//  QYStaging
//
//  Created by Jyawei on 2017/8/2.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 个人中心联系人cell
 */
@interface QYContactInfoShowCell : UITableViewCell

/** 关系 */
@property (weak, nonatomic) IBOutlet UILabel *relationshipLable;
/** 姓名 */
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
/** 电话 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;

/** 联系人模型 */
@property (nonatomic,strong) QYEmergencyModel *emergencyModel;

@end
