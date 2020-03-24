//
//  KYOrderGoodsList.h
//  QYStaging
//
//  Created by 张盖 on 2018/4/8.
//  Copyright © 2018年 wangkai. All rights reserved.
//  每个订单项的数据

#import "BaseModel.h"

@interface KYOrderGoodsList : BaseModel

//商品id
@property (nonatomic ,copy) NSString *goodsId;
//商品名称
@property (nonatomic ,copy) NSString *goodsName;
//数量
@property (nonatomic ,copy) NSString *goodsNum;
//商品图
@property (nonatomic ,copy) NSString *imgUrl;
// 单价
@property (nonatomic ,copy) NSString *price;

@end
