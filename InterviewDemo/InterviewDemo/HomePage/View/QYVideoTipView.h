//
//  QYVideoTipView.h
//  QYStaging
//
//  Created by wangkai on 2017/5/3.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYVideoTipView : UIView

/** 判断文案是否存在 */
@property(nonatomic, copy) dispatch_block_t copyExistBlock;

@end
