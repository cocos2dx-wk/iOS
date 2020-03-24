//
//  QYTypeInfo.h
//  QYStaging
//
//  Created by wangkai on 2017/12/13.
//  Copyright © 2017年 wangkai. All rights reserved.
//  8大类列表信息

#import "BaseModel.h"

@interface QYTypeInfo : BaseModel

/** 车系、套餐、商品id */
@property (nonatomic, assign) NSString* id;
/** data下级数据 车系、套餐、商品名称 */
@property (nonatomic, copy) NSString *name;
/** data下级数据 车系、套餐、商品名称 type4 之后取goodsname */
@property (nonatomic, copy) NSString *goodsName;
/** data下级数据 车系、套餐、商品价格 */
@property (nonatomic, copy) NSString *price;
/** data下级数据 车系、套餐、商品图片 */
@property (nonatomic, copy) NSString *img;
/** PPW 或者 CKK */
@property (nonatomic, copy) NSString *source;
@end
