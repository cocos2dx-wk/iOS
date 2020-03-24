//
//  KYHourseParamModel.h
//  QYStaging
//
//  Created by 张盖 on 2018/4/9.
//  Copyright © 2018年 wangkai. All rights reserved.
//  资产回显信息

#import "BaseModel.h"

@interface KYHourseParamModel : BaseModel

//贷款银行
@property (nonatomic ,copy) NSString *loanBank;
//是否贷款：0：否、1：是
@property (nonatomic ) NSInteger  isLoan;

//审核状态，0：通过、1：不通过、2：未审核
@property (nonatomic ) NSInteger  auditStatus;

//贷款金额
@property (nonatomic ,copy) NSString *loanAmount;
// 图片
@property (nonatomic ,strong) NSArray *attachments;



@end
