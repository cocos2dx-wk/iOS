//
//  QYEmergencyModel.h
//  QYStaging
//
//  Created by wangkai on 2017/4/10.
//  Copyright © 2017年 wangkai. All rights reserved.
//  紧急联系人信息

#import "BaseModel.h"

@interface QYEmergencyModel : BaseModel<NSCoding>

/** 用户ssoId */
@property (nonatomic, copy) NSString *ssoId;
/** 紧急联系人关系： 0：配偶、1：父母、2：子女、3：其他 */
@property (nonatomic, copy) NSString *iceType;
/** 紧急联系人姓名 */
@property (nonatomic, copy) NSString *iceName;
/** 紧急联系人身份证号码 */
@property (nonatomic, copy) NSString *iceIdCard;
/** 紧急联系人电话 */
@property (nonatomic, copy) NSString *icePhone;

@end
