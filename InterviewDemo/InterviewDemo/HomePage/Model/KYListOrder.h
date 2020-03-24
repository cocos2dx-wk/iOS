//
//  KYListOrder.h
//  QYStaging
//
//  Created by 张盖 on 2018/4/8.
//  Copyright © 2018年 wangkai. All rights reserved.
//

#import "BaseModel.h"
#import "KYOrderGoodsList.h"

@interface KYListOrder : BaseModel
// 分期总金额
@property (nonatomic ,copy) NSString *totalAmount;
// 订单id
@property (nonatomic ,copy) NSString *orderId;
// 订单号
@property (nonatomic ,copy) NSString *orderNum;
// 订单来源 ppw：乒乒网；chekkBusinessStag：车快快车品分期；chekkMaintainStag：车快快保养分期
@property (nonatomic ,copy) NSString *platForm;

// 订单状态：-1：全部订单、0:待审核、1：待网签、2：待面签、3：已完成、4：已取消
@property (nonatomic , copy) NSString *status;
// 商品列表 实体
@property (nonatomic , strong) NSMutableArray<KYOrderGoodsList*> *goodsList;

@end
