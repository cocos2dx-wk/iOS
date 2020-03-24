//
//  KYBankCardParamsModel.h
//  QYStaging
//
//  Created by 张盖 on 2018/4/9.
//  Copyright © 2018年 wangkai. All rights reserved.
//  信用卡信息

#import "BaseModel.h"

@interface KYBankCardParamsModel : BaseModel
// 审核状态，0：通过、1：不通过、2：未审核
@property (nonatomic) NSInteger auditStatus;
//
@property (nonatomic ,copy) NSString *bankName ;
// 卡片类型：0：信用卡，1：银行卡
@property (nonatomic  ) NSInteger  cardType ;
//卡号
@property (nonatomic ,copy) NSString *cardNumber ;

@end
