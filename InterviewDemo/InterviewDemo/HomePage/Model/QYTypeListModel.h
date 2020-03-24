//
//  QYTypeListModel.h
//  QYStaging
//
//  Created by wangkai on 2017/12/19.
//  Copyright © 2017年 wangkai. All rights reserved.
//  8大类列表主信息

#import "BaseModel.h"

@interface QYTypeListModel : BaseModel

/** 栏目id 1=新车售卖 2=维修保养 3=汽车用品 4=家装建材 5=手机数码 6=家用电器 7=住宅家具 8=电脑办公 */
@property (nonatomic, assign) int type;
/** 详细信息 */
@property (nonatomic, strong)NSArray *data;

@end
