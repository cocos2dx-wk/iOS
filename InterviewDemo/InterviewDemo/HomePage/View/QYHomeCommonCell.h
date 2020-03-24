//
//  QYHomeCommonCell.h
//  QYStaging
//
//  Created by wangkai on 2017/12/18.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYTypeInfo.h"

@interface QYHomeCommonCell : UITableViewCell

/* 点击按钮*/
@property (weak, nonatomic) IBOutlet UIButton *s_infoButton;

/* 更新UI*/
-(void)updateInfo:(QYTypeInfo *)info withType:(NSInteger)type;

@end
