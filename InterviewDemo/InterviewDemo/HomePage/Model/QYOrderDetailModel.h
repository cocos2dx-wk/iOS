//
//  QYOrderDetailModel.h
//  QYStaging
//
//  Created by wangkai on 2017/5/2.
//  Copyright © 2017年 wangkai. All rights reserved.
//  订单列表

#import "BaseModel.h"
#import "QYProductDetailModel.h"

@interface QYOrderDetailModel : BaseModel

/** 订单id */
@property (nonatomic, copy) NSString *orderId;
/** 订单号 */
@property (nonatomic, copy) NSString *orderNum;
/** 商品总名称(订单显示的商品名称) */
@property (nonatomic, copy) NSString *goodsName;
/** 订单中的商品总量*/
@property (nonatomic, copy) NSString *totalNum;
/** 订单总金额 */
@property (nonatomic, copy) NSString *totalAmount;
/** 分期总额 */
@property (nonatomic, copy) NSString *installmentAmount;
/** 订单状态，0:待审核、1：待网签、2：待面签、3：已完成、4：已取消 */
@property (nonatomic, copy) NSString *status;
/** 门店id */
@property (nonatomic, copy) NSString *shopId;
/** 门店名称 */
@property (nonatomic, copy) NSString *shopName;
/** 门店电话 */
@property (nonatomic, copy) NSString *shopPhone;
/** 门店地址 */
@property (nonatomic, copy) NSString *shopAddress;
/** 分期总期数 */
@property (nonatomic, copy) NSString *periods;
/** 首期金额 */
@property (nonatomic, copy) NSString *firstStage;
/** 除首期外每期金额（平均值） */
@property (nonatomic, copy) NSString *average;
/** 分期订单，是否已质押，1.未质押，2.已质押） */
@property (nonatomic, copy) NSString *pledged;
/** 分期订单，质押期数，当订单类型为分期订单，并且为轻易分期时有效） */
@property (nonatomic, copy) NSString *pledgePeriod;
/** 商品信息 */
@property (nonatomic,strong)NSMutableArray *goodsInfos;
/** 订单创建时间 */
@property (nonatomic,strong)NSString *createtime;
/** 订单最后更新时间 */
@property (nonatomic,strong)NSString *lastmodtime;
@end
