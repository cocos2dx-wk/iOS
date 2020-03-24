//
//  QYProductDetailModel.h
//  QYStaging
//
//  Created by wangkai on 2017/5/2.
//  Copyright © 2017年 wangkai. All rights reserved.
//  商品信息

#import "BaseModel.h"

@interface QYProductDetailModel : BaseModel

/** 订单id */
@property (nonatomic, copy) NSString *orderId;
/** 订单号 */
@property (nonatomic, copy) NSString *orderNum;
/** 订单总金额 */
@property (nonatomic, copy) NSString *totalAmount;
/** 商品名字 */
@property (nonatomic, copy) NSString *goodsName;
/** 商品图 */
@property (nonatomic, copy) NSString *imgUrl;
/** 订单状态 订单状态：-1：全部订单、0:待审核、1：待网签、2：待面签、3：已完成、4：已取消*/
@property (nonatomic, copy) NSString *status;
/** 商品单价 */
@property (nonatomic, copy) NSString *price;
/** 商品数量(订单详情中) */
@property (nonatomic, copy) NSString *number;
/** 平台类型 订单来源 ppw：乒乒网；chekkBusinessStag：车快快车品分期；chekkMaintainStag：车快快保养分期*/
@property (nonatomic, copy) NSString *platForm;
/** 商品数量(订单列表中,账单中) */
@property (nonatomic, copy) NSString *goodsNum;
/** 分期总金额 */
@property (nonatomic, copy) NSString *installmentAmount;
/**  订单中商品列表（只对车快快车品分期和ppw订单进行了信息补全；保养分期订单只有goodsName、goodsNum两字段） */
@property (nonatomic,strong)NSMutableArray *goodsList;
/** 商品id */
@property (nonatomic, copy) NSString *goodsId;

@end
