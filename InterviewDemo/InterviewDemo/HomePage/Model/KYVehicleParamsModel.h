//
//  KYVehicleParamsModel.h
//  QYStaging
//
//  Created by 张盖 on 2018/4/9.
//  Copyright © 2018年 wangkai. All rights reserved.
//  行驶证信息

#import "BaseModel.h"

@interface KYVehicleParamsModel : BaseModel
//  审核状态，0：通过、1：不通过、2：未审核
@property (nonatomic) NSInteger  auditStatus ;
//车架号（车辆识别号）
@property (nonatomic ,copy) NSString *frameNumber ;
// 图片
@property (nonatomic ,strong) NSArray* attachments;

@end
