//
//  QYIdCardInfoModel.h
//  QYStaging
//
//  Created by wangkai on 2017/4/17.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "BaseModel.h"

@interface QYIdCardInfoModel : BaseModel

/** 名字 */
@property (nonatomic, copy) NSString *name;
/** 民族 */
@property (nonatomic, copy) NSString *race;
/** 地址 */
@property (nonatomic, copy) NSString *address;
/** 性别 */
@property (nonatomic, copy) NSString *gender;
/** 身份证号码 */
@property (nonatomic, copy) NSString *id_card_number;
/** 正反面 */
@property (nonatomic, copy) NSString *side;

@end
