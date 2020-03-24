//
//  QYContactInfoCell.h
//  QYStaging
//
//  Created by Jyawei on 2017/7/27.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 联系人信息cell
 */
@interface QYContactInfoCell : UITableViewCell

/** 关系 */
@property (weak, nonatomic) IBOutlet UILabel *relationshipLable;
/** 姓名 */
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
/** 电话 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
/** 修改触发按钮 */
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;


@end
