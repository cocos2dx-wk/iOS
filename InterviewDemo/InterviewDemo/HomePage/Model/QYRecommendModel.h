//
//  QYRecommendModel.h
//  QYStaging
//
//  Created by wangkai on 2017/12/18.
//  Copyright © 2017年 wangkai. All rights reserved.
//  热门推荐

#import "BaseModel.h"

@interface QYRecommendModel : BaseModel

/** 推荐id */
@property (nonatomic, copy) NSString *id;
/** 图片地址 */
@property (nonatomic, copy) NSString *img;
/** 推荐名称 */
@property (nonatomic, copy) NSString *goodsName;
/** 推荐价格 */
@property (nonatomic, copy) NSString *price;
/** PPW 或者 CKK */
@property (nonatomic, copy) NSString *source;

@end
