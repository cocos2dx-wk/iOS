//
//  QYHomeCategoriesModel.h
//  QYStaging
//
//  Created by wangkai on 2017/12/18.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "BaseModel.h"

@interface QYHomeCategoriesModel : BaseModel

/** 分类名称 或 维修保养名字*/
@property (nonatomic, copy) NSString *name;
/** 分类id 1=新车售卖 2=维修保养 3=汽车用品 4=家装建材 5=手机数码 6=家用电器 7=住宅家具 8=电脑办公 */
@property (nonatomic, copy) NSString *type;
/** 维修保养id */
@property (nonatomic, copy) NSString *id;


@end
