//
//  QYDatePickerView.h
//  QYStaging
//
//  Created by wangkai on 2017/4/15.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^dateOkBlock)(NSString *yearStr,NSString *monthStr);
typedef void(^cancelBlock)(NSString *content);

@interface QYDatePickerView : UIView

/* 确定按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

/**
 *  点击事件
 */
- (void)onOkClicked:(dateOkBlock)okClicked andCancelClicked:(cancelBlock)cancelClicked;

@end
