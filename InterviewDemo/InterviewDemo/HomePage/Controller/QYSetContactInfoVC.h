//
//  QYSetContactInfoVC.h
//  QYStaging
//
//  Created by Jyawei on 2017/7/27.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^addContacts)(NSMutableDictionary *dict);
typedef void(^changeContacts)(NSMutableDictionary *dict);

/**
 添加/修改联系人
 */
@interface QYSetContactInfoVC : BaseViewController

/**
 初始化
 */
+ (instancetype)vc;

/** 添加联系人回调 */
@property (nonatomic ,copy)addContacts addContactsBlock;
/** 修改联系人回调 */
@property (nonatomic ,copy)changeContacts changeContactsBlock;
/** 需要修改的联系人 */
@property (nonatomic,strong) NSMutableDictionary *contactInfo;
/** 联系人数组 */
@property (nonatomic,strong) NSMutableArray *contacts;
/** 标记当前修改的联系人下标 */
@property (nonatomic,assign) NSInteger index;
/** 是否上传通讯录:0-未上传；1-上传 */
@property (nonatomic, copy) NSString *isHaveMailList;

@end
