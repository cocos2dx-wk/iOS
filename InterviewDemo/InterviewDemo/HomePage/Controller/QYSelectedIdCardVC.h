//
//  QYSelectedIdCardVC.h
//  QYStaging
//
//  Created by wangkai on 2017/4/13.
//  Copyright © 2017年 wangkai. All rights reserved.
//  扫描身份证

#import "BaseViewController.h"

@interface QYSelectedIdCardVC : BaseViewController

/** 是否上传过身份证照片 */
@property (nonatomic,copy) NSString *photoOrFace;
/** 审核状态 */
@property (nonatomic,copy) NSString *auditStatus;
/** 传过来的控制器 */
@property (nonatomic,strong) UIViewController *vc;

@end
