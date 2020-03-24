//
//  QYCreditEvaluationContactVC.m
//  QYStaging
//
//  Created by MobileUser on 2017/4/10.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYCreditEvaluationContactVC.h"
#import "QYCreditEvaluationSuccessVC.h"
#import "QYContactInfoCell.h"
#import "QYAddContactCell.h"
#import "QYSetContactInfoVC.h"

@interface QYCreditEvaluationContactVC ()<UITableViewDelegate,UITableViewDataSource>


/** 联系人信息Img */
@property (weak, nonatomic) IBOutlet UIImageView *m_contactImg;
/**  提交授信按钮 */
@property (nonatomic,strong) UIButton *m_submitBtn;
/** 联系人界面高 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_contactViewHeight;
/** 联系人tableview */
@property (weak, nonatomic) IBOutlet UITableView *contactTableView;
/** 联系人数组 */
@property (nonatomic,strong) NSMutableArray *contacts;
/** 是否上传通讯录:0-未上传；1-上传 */
@property (nonatomic, copy) NSString *isHaveMailList;

@end

@implementation QYCreditEvaluationContactVC

+ (instancetype)vc {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"信用评估";
    
    if (iphone6Plus) {
        self.m_contactViewHeight.constant = 736-44;
    } else if (iphone6) {
        self.m_contactViewHeight.constant = 667-64;
    } else if (iphone5) {
        self.m_contactViewHeight.constant = 568-64;
    } else {
        self.m_contactViewHeight.constant = 568;
    }
    
    self.contactTableView.delegate = self;
    self.contactTableView.dataSource = self;
    
    [self.leftButton setAccessibilityIdentifier:@"rl_back_layout"];
    
    [self showContactsInfo];
    
    //是否上传通讯录
    [self isUploadAddress];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     [self checkSubmitBtnStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (NSMutableArray *)contacts {
    if (_contacts == nil) {
        _contacts = [NSMutableArray array];
    }
    return _contacts;
}

#pragma mark - 按钮活动
/**
 点击提交授信
 */
- (void)submitBtnClicked:(UIButton *)sender {
    sender.enabled = NO;
    //静默上传通讯录
    
    NSArray *books = [[NSUserDefaults standardUserDefaults] objectForKey:@"books"];
    if ([self.isHaveMailList isEqualToString:@"0"] && (books.count > 0)) {
        [self updateAddressBooks];
    } else {
        //提交授信
        [self saveContactInfo];
    }
    
    sender.enabled = YES;
}

/**
 点击修改联系人信息
 */
- (void)changeContactInfoBtnClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    NSInteger section = [self.contactTableView indexPathForCell:((QYContactInfoCell*)[[sender superview]superview])].section;
    QYSetContactInfoVC *vc = [QYSetContactInfoVC vc];
    vc.navigationItem.title = @"修改常用联系人";
    vc.contacts = self.contacts;
    vc.index = section;
    if (self.isHaveMailList) {
        vc.isHaveMailList = self.isHaveMailList;
    } else {
        //是否上传通讯录
        [self isUploadAddress];
    }
    vc.contactInfo = [self.contacts objectAtIndex:section];
    [self.navigationController pushViewController:vc animated:YES];
    vc.changeContactsBlock = ^(NSMutableDictionary *dict) {
        [self.contacts replaceObjectAtIndex:section withObject:dict];
        [self.contactTableView reloadData];
    };
    
    sender.enabled = YES;
}

#pragma mark - 私有方法
/**
 信息回显
 */
- (void)showContactsInfo {
    
    if ([self queryInfo].emergencyContacts.count > 0) {
        [[self queryInfo].emergencyContacts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            NSDictionary *dict = obj;
            
            NSString *iceType = [NSString stringWithFormat:@"%@",dict[@"iceType"]];
            if ([iceType isEqualToString:@"0"]) {
                dic[@"relation"] = @"配偶";
            } else if ([iceType isEqualToString:@"1"]) {
                dic[@"relation"] = @"父母";
            } else if ([iceType isEqualToString:@"2"]) {
                dic[@"relation"] = @"子女";
            } else {
               dic[@"relation"] = @"其它";
            }
            
            dic[@"name"] = dict[@"iceName"];
            dic[@"phone"] = dict[@"icePhone"];
            [self.contacts addObject:dic];
        }];
    }
}

/**
 判断提交按钮状态
 */
- (void)checkSubmitBtnStatus {
   
    if (self.contacts.count < 1) {
        self.m_submitBtn.enabled = NO;
    } else {
        self.m_submitBtn.enabled = YES;
    }
}

/**
 保存联系人信息
 */
- (void)saveContactInfo {
    
    UserInfo *info = [self queryInfo];
    
    NSMutableArray *emergencyContacts = [NSMutableArray array];
    
    [self.contacts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSDictionary *dict = obj;
        NSString *relation = dict[@"relation"];
        
        if ([relation isEqualToString:@"配偶"]) {
            dic[@"iceType"] = @"0";
        } else if ([relation isEqualToString:@"父母"]) {
            dic[@"iceType"] = @"1";
        } else if ([relation isEqualToString:@"子女"]) {
            dic[@"iceType"] = @"2";
        } else {
            dic[@"iceType"] = @"3";
        }
        
        dic[@"iceName"] = dict[@"name"] ? dict[@"name"] : @"";
        dic[@"icePhone"] = dict[@"phone"] ? dict[@"phone"] : @"";
        [emergencyContacts addObject:dic];
        
    }];
    
    info.emergencyContacts = emergencyContacts;

    [self updateInfo:info];
    
    [self updateLocation];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contacts.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.contacts.count) {
        QYAddContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYAddContactCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"QYAddContactCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.contacts.count < 1) {
            cell.hidden = NO;
            [cell setCellUiStatus:NO];
        } else if (self.contacts.count < 10) {
            cell.hidden = NO;
            [cell setCellUiStatus:YES];
        } else {
            cell.hidden = YES;
        }
        return cell;
    } else {
        QYContactInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYContactInfoCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"QYContactInfoCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.changeBtn addTarget:self action:@selector(changeContactInfoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        NSDictionary *dict = [self.contacts objectAtIndex:indexPath.section];
        cell.relationshipLable.text = [NSString stringWithFormat:@"关系：%@",dict[@"relation"]];
        cell.nameLable.text = [NSString stringWithFormat:@"姓名：%@",dict[@"name"]];
        cell.phoneLable.text = [NSString stringWithFormat:@"电话：%@",dict[@"phone"]];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.contacts.count) {
        
        QYSetContactInfoVC *vc = [QYSetContactInfoVC vc];
        vc.navigationItem.title = @"添加常用联系人";
        vc.contacts = self.contacts;
        if (self.isHaveMailList) {
            vc.isHaveMailList = self.isHaveMailList;
        } else {
            //是否上传通讯录
            [self isUploadAddress];
        }
        [self.navigationController pushViewController:vc animated:YES];
        vc.addContactsBlock = ^(NSMutableDictionary *dict) {
            [self.contacts addObject:dict];
            [self.contactTableView reloadData];
        };
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == self.contacts.count) {
        if (self.contacts.count < 1) {
            return 51;
        } else if (self.contacts.count < 10) {
            return 72;
        } else {
            return 0.01;
        }
    } else {
        return 134;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.contacts.count) {
        return 100;
    } else {
        if ((self.contacts.count >= 10) && (section == self.contacts.count - 1)) {
            return 0.01;
        } else {
            return 10;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == self.contacts.count) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 100)];
        view.backgroundColor = [UIColor clearColor];
        
        self.m_submitBtn = [[UIButton alloc] init];
        self.m_submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        self.m_submitBtn.layer.cornerRadius = 4;
        self.m_submitBtn.layer.masksToBounds = YES;
        [self.m_submitBtn setTitle:@"提交授信" forState:UIControlStateNormal];
        [self.m_submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.m_submitBtn];
        
        //自动化id
        [self.m_submitBtn setAccessibilityIdentifier:@"btn_submit_ok"];
        
        [self.m_submitBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithMacHexString:@"#575DFE"]] forState:UIControlStateNormal];
        [self.m_submitBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithMacHexString:@"#CCCCCC"]] forState:UIControlStateDisabled];
        
        [self checkSubmitBtnStatus];
        
        [self.m_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).offset(10);
            make.right.equalTo(view.mas_right).offset(-10);
            make.top.equalTo(view.mas_top).offset(32);
            make.height.mas_equalTo(45);
        }];
        
        return view;
    } else {
        return nil;
    }
}

#pragma mark - 是否上传通讯录
- (void)isUploadAddress {
     NSString *url = [NSString stringWithFormat:@"%@%@",app_new_getMaillistStatus,verison];
    
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {

            self.isHaveMailList = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"isHaveMailList"]];
        }
        
    } failure:^(NSString * _Nullable errorString) {

    }];
}

#pragma mark - 经纬度埋点
- (void)updateLocation {
    
    [self showLoading];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dict = [defaults objectForKey:@"locationInfo"];
    
    NSString *latitude = dict[@"latitude"];
    NSString *longitude = dict[@"longitude"];
    NSString *province = dict[@"privince"] ;
    NSString *city = dict[@"city"] ;
    
    NSString *url = [NSString stringWithFormat:@"%@%@?source=0&province=%@&city=%@&lat=%@&lng=%@",app_new_areaLatLngMsg,verison,province,city,latitude,longitude];
    
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            //提交授信请求
            [self requestCreditInfo];
        } else {
            [self dismissLoading];
            [self showMessageWithString:@"未获取到定位信息"];
        }
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
    }];
}

#pragma mark - 上传用户通讯录（偷偷的）
- (void)updateAddressBooks {
    NSArray *books = [[NSUserDefaults standardUserDefaults] objectForKey:@"books"];
    [self showLoading];

    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_maillistUpload,verison];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"isNew"] = [NSNumber numberWithInteger:1];
    params[@"mailList"] = books;
    params[@"phone"] = [self queryInfo].phoneNum;
    params[@"submitld"] = @"";
    params[@"totalCount"] = [NSNumber numberWithInteger:books.count];
    params[@"uploadType"] = [NSNumber numberWithInteger:0];
    
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] post:url params:params success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        [self dismissLoading];
        //清空本地存储通讯录
        [AppGlobal clearBooks];
        
        if (statusCode == 10000) {
            [self isUploadAddress];
            //提交授信
            [self saveContactInfo];
        } else {//提交授信
            [self saveContactInfo];
        }
        
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        //提交授信
        [self saveContactInfo];
        
    }];
}

#pragma mark - 授信请求及处理
/**
 授信请求
 */
- (void)requestCreditInfo {

    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_addCreditInfo,verison];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *assetDict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *jobDict = [[NSMutableDictionary alloc]init];
    
    //个人信息
    userDict[@"address"] =  [self queryInfo].user.address ? [self queryInfo].user.address : @"";
    userDict[@"education"] =  [self queryInfo].user.education ? [self queryInfo].user.education : @"";
    userDict[@"province"] =  [self queryInfo].user.province ? [self queryInfo].user.province : @"";
    userDict[@"city"] =  [self queryInfo].user.city ? [self queryInfo].user.city : @"";
    userDict[@"district"] =  [self queryInfo].user.district ? [self queryInfo].user.district : @"";
    userDict[@"married"] =  [self queryInfo].user.married ? [self queryInfo].user.married : @"";
    
    //财务信息
    assetDict[@"monthlyRent"] = [self queryInfo].asset.monthlyRent ? [self queryInfo].asset.monthlyRent : @"";
    assetDict[@"monthlyPay"] = [self queryInfo].asset.monthlyPay ? [self queryInfo].asset.monthlyPay : @"";
    assetDict[@"debt"] = [self queryInfo].asset.debt ? [self queryInfo].asset.debt : @"";
    assetDict[@"monthlyHouseCost"] = [self queryInfo].asset.monthlyHouseCost ? [self queryInfo].asset.monthlyHouseCost : @"";
    
    //工作信息
    jobDict[@"entryTime"] = [self queryInfo].job.entryTime ? [self queryInfo].job.entryTime : @"";
    jobDict[@"province"] = [self queryInfo].user.province ? [self queryInfo].user.province : @"";
    jobDict[@"city"] = [self queryInfo].user.city ? [self queryInfo].user.city : @"";;
    jobDict[@"district"] = [self queryInfo].user.district ? [self queryInfo].user.district : @"";;
    jobDict[@"address"] = [self queryInfo].job.address ? [self queryInfo].job.address : @"";
    jobDict[@"companyPhone"] = [self queryInfo].job.companyPhone ? [self queryInfo].job.companyPhone : @"";
    jobDict[@"companyType"] = [self queryInfo].job.companyType ? [self queryInfo].job.companyType : @"";
    jobDict[@"companyName"] = [self queryInfo].job.companyName ? [self queryInfo].job.companyName : @"";
    jobDict[@"businessLicenseNum"] = [self queryInfo].job.businessLicenseNum ? [self queryInfo].job.businessLicenseNum : @"";
    jobDict[@"industry"] = [self queryInfo].job.industry ? [self queryInfo].job.industry : @"";
    jobDict[@"jobType"] = [self queryInfo].job.jobType ? [self queryInfo].job.jobType : @"";
    
    if ([[self queryInfo].job.jobType isEqualToString:@"1"]) {//个体经营
        jobDict[@"salary"] = [self queryInfo].job.salary ? [self queryInfo].job.salary : @"";
        jobDict[@"companyName"] = [self queryInfo].job.ManagementName ? [self queryInfo].job.ManagementName : @"";
    }
    
    NSMutableArray *incomeInfo = [NSMutableArray array];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"type"] = @"1";
    dict[@"income"] = [self queryInfo].asset.userIncomesAll ? [self queryInfo].asset.userIncomesAll : @"";
    [incomeInfo addObject:dict];
    
    parameters[@"users"] = userDict;
    parameters[@"emergencyContacts"] = [self queryInfo].emergencyContacts;
    parameters[@"job"] = jobDict;
    parameters[@"asset"] = assetDict;
    parameters[@"incomeInfo"] = incomeInfo;
    
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] post:url params:parameters success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        
        if (statusCode == 10000) {
            [self requestCreditSuccess:responseObject];
        } else {
            [self requestCreditFail:responseObject];
        }
        
        [self dismissLoading];
    } failure:^(NSString * _Nullable errorString) {
        
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
        
    }];
}

/**
 授信成功回调
 */
- (void)requestCreditSuccess:(id)responseObject {
    
    QYCreditEvaluationSuccessVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYCreditEvaluationSuccessVC"];
    vc.m_submitType = QYSubmitTypeCreditInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 授信失败回调
 */
- (void)requestCreditFail:(id)responseObject {
    
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
}




@end
