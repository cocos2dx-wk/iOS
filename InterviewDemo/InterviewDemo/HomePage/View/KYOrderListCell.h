//
//  KYOrderListCell.h
//  QYStaging
//
//  Created by mac on 2018/3/30.
//  Copyright © 2018年 wangkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYProductDetailModel.h"
#import "KYOrderGoodsList.h"
@interface KYOrderListCell : UITableViewCell

-(void)updateUI:(KYOrderGoodsList *)model;

@end
