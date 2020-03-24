//
//  QYCustomCameraVC.h
//  QYStaging
//
//  Created by Jyawei on 2017/8/21.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^photoBlock)(UIImage *image);

/**
 相机
 */
@interface QYCustomCameraVC : BaseViewController

/** 回调block */
@property (nonatomic ,copy)photoBlock photoBlock;

@end
