//
//  QYActiveVC.m
//  QYStaging
//
//  Created by wangkai on 2017/12/8.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYActiveVC.h"
#import "QYVideoAuthVC.h"
#import "QYWebViewVC.h"

@interface QYActiveVC ()

/** 审核标题 --*/
@property (weak, nonatomic) IBOutlet UILabel *m_auditStateTitleLable;
/** 驳回原因 --*/
@property (weak, nonatomic) IBOutlet UILabel *rejectedWhyLable;
/** 副标题 --*/
@property (weak, nonatomic) IBOutlet UILabel *subtitleLable;
/** 签署或认证按钮 --*/
@property (weak, nonatomic) IBOutlet UIButton *signedOrCerBtn;
/** 合约图片 --*/
@property (weak, nonatomic) IBOutlet UIImageView *contractIcon;
/** 视频认证图片 --*/
@property (weak, nonatomic) IBOutlet UIImageView *videoCerIcon;
/** 签署标题view的高（上） */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signedTopViewHeight;
/** 副标题到顶部距离 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subtitleToTop;
/** 合约图片距右距离 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signIconRight;
/** 视频认证图片距左距离 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoIconLeft;
/** selete图片距底距离 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconBottom;
/** 签约背景view的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signedViewHeight;
/** 审核大图片按钮的宽 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *auditWidth;
/** 审核大图片按钮距离顶部高 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *auditToTop;
/** 审核大图片按钮 */
@property (weak, nonatomic) IBOutlet UIButton *auditBtn;
/** 驳回原因 */
@property (nonatomic,copy) NSString *contractAuditRemarks;
/** 审核状态 */
@property (nonatomic,assign)contractAuditStatus auditStatus;

@end

@implementation QYActiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
      //set title
    self.navigationItem.title = @"";
    
    //信用评估状态
    [self requestUserAssessStatus];
}
-(void)initUI{
    if (iphone6Plus) {
        self.signedViewHeight.constant = 672;
        self.auditToTop.constant = 120;
    } else if (iphone6) {
        self.signedViewHeight.constant = 603;
    } else {
        self.signedViewHeight.constant = 580;
        self.auditWidth.constant = 150;
    }
}

#pragma mark - 获取用户评估状态请求
/**
 获取用户评估状态请求
 */
- (void)requestUserAssessStatus {
    [self showLoading];
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_userAssessStatus,verison];
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    
    
    
    [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self requestUserAssessStatusSuccess:responseObject];
        } else {
            [self requestUserAssessStatusFail:responseObject];
        }
        [self dismissLoading];
        //接口监控
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        
        [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_userAssessStatus" andBusinessAlias:@"用户信用评估状态" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_userAssessStatus" buAlias:@"用户信用评估状态" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

/**
 评估状态请求成功回调方法
 0, "审核中" 1, "待激活" 2, "垫付宝领用合约已签署"  3, "已视频认证"  4, "垫付宝领用合约已签署、视频认证已完成"  5, "信用评估已完成" 6, "已拒绝" 7, "无信用评估记录" 8,"准入拒绝“，9：反欺诈拒绝，10：评分低拒绝
 
 "contractAuditStatus":0,//0 待审核 1已通过 2已驳回
 "contractAuditRemarks":驳回原因
 @param responseObject 评估状态请求回调数据
 */
- (void)requestUserAssessStatusSuccess:(id)responseObject {
    NSDictionary *dataStr = [responseObject objectForKey:@"data"];
    NSInteger resultStr = [[dataStr objectForKey:@"creditResult"] intValue];
    
    NSString *str = [NSString stringWithFormat:@"%@",[dataStr objectForKey:@"contractAuditStatus"]];
    NSString *remarksStr = [NSString stringWithFormat:@"%@",[dataStr objectForKey:@"contractAuditRemarks"]];
    
    if (![NSString isBlankString:remarksStr]) {
        self.contractAuditRemarks = remarksStr;
    }
    
    if (![NSString isBlankString:str]) {
        switch ([[dataStr objectForKey:@"contractAuditStatus"] intValue]) {
            case 0:
                self.auditStatus = contractAuditStatusAudit;
                break;
            case 1:
                self.auditStatus = activationStatusThrough;
                break;
            case 2:
                self.auditStatus = activationStatusRejected;
                break;
            case 3:
                self.auditStatus = activationStatusUploadAgain;
                break;
            default:
                break;
        }
    } else {
        self.auditStatus = contractAuditStatusNot;
    }
    
    //审核状态
    QYCreditAssessType m_assessType = QYCreditAssessType_Examine;
    switch (resultStr) {
        case 0:
            m_assessType = QYCreditAssessType_Examine;
            break;
        case 1:
            m_assessType = QYCreditAssessType_UnActive;
            break;
        case 2:
            m_assessType = QYCreditAssessType_Sign;
            break;
        case 3:
            m_assessType = QYCreditAssessType_VideoAuthed;
            break;
        case 4:
            m_assessType = QYCreditAssessType_SignAndVideoAuthed;
            break;
        case 5:
            m_assessType = QYCreditAssessType_Completed;
            break;
        case 6:
            m_assessType = QYCreditAssessType_Refused;
            break;
        case 7:
            m_assessType = QYCreditAssessType_UnAssess;
            break;
        case 8:
            m_assessType = QYCreditAssessType_AccessDenied;
            break;
        case 9:
            m_assessType = QYCreditAssessType_AntifraudRefusal;
            break;
        case 10:
            m_assessType = QYCreditAssessType_LowScoring;
            break;
            
        default:
            break;
    }
    
    [self updateUIWithAssessType:m_assessType];
}

/**
 评估状态请求失败回调方法
 
 @param responseObject 评估状态请求回调数据
 */
- (void)requestUserAssessStatusFail:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
    //update ui
    [self updateUIWithAssessType:QYCreditAssessType_UnAssess];
}

/**
 根据授权类型改变相应UI和逻辑
 //0, "审核中" 1, "待激活" 2, "垫付宝领用合约已签署"  3, "已视频认证"  4, "垫付宝领用合约已签署、视频认证已完成"  5, "信用评估已完成" 6, "已拒绝" 7, "无信用评估记录"
 @param assessType 授权类型
 */
- (void)updateUIWithAssessType:(QYCreditAssessType)assessType {
    
    switch (assessType) {
        case QYCreditAssessType_Examine://评估中
        {
            break;
        }
        case QYCreditAssessType_UnActive://待激活
        {
            
            if (self.auditStatus == activationStatusRejected) {
                [self setReviewStatus:activationStatusSignedAgain];
            } else {
                [self setReviewStatus:activationStatusSigned];
            }
            
            break;
        }
        case QYCreditAssessType_Sign://垫付宝领用合约已签署
        {
            
            if (self.auditStatus == activationStatusUploadAgain) {
                [self setReviewStatus:activationStatusVideoAgain];
            } else {
                [self setReviewStatus:activationStatusVideo];
            }
            break;
        }
        case QYCreditAssessType_VideoAuthed://已视频认证
        {
            [self setReviewStatus:activationStatusSigned];
            break;
        }
        case QYCreditAssessType_SignAndVideoAuthed://垫付宝领用合约已签署、视频认证已完成
        {
            
            break;
        }
        case QYCreditAssessType_Completed: //评估通过
        {
            if (self.auditStatus == activationStatusRejected) {
                [self setReviewStatus:activationStatusSignedAgain];
            } else if (self.auditStatus == activationStatusUploadAgain) {
                [self setReviewStatus:activationStatusVideoAgain];
            }
            break;
        }
        case QYCreditAssessType_Refused://审核失败
        case QYCreditAssessType_AccessDenied://准入拒绝
        case QYCreditAssessType_AntifraudRefusal://反欺诈拒绝
        {
            
            break;
        }
        case QYCreditAssessType_UnAssess://立即评估
        {
            
            break;
        }
        case QYCreditAssessType_LowScoring://评分低拒绝
        {
            
            break;
        }
        default:
            break;
    }
}

/**
 设置审核状态
 */
- (void)setReviewStatus:(activationStatus)status {
    
    switch (status) {
        case activationStatusSigned: {//信用评估通过-签署合约
            self.m_auditStateTitleLable.text = @"信用评估已通过！";
            self.subtitleLable.text = @"签署《垫付宝领用合约》和“视频认证”后即可使用“轻易分期”";
            self.m_auditStateTitleLable.textColor = [UIColor colorWithHexString:@"53ac24"];
            self.rejectedWhyLable.hidden = YES;
            self.subtitleToTop.constant = -17;
            self.signedTopViewHeight.constant = 124;
            self.contractIcon.image = [UIImage imageNamed:@"HomePage_selectedCircle"];
            self.videoCerIcon.image = [UIImage imageNamed:@"HomePage_grayCircle"];
            self.signIconRight.constant = 22;
            self.videoIconLeft.constant = 18;
            self.iconBottom.constant = 16;
            [self.auditBtn setImage:[UIImage imageNamed:@"Homepage_contract"] forState:UIControlStateNormal];
            [self.signedOrCerBtn setTitle:@"签署《垫付宝领用合约》" forState:UIControlStateNormal];
            
            break;
        }
        case activationStatusVideo: {//信用评估通过-视频认证
            self.m_auditStateTitleLable.text = @"信用评估已通过！";
            self.subtitleLable.text = @"签署《垫付宝领用合约》和“视频认证”后即可使用“轻易分期”";
            self.m_auditStateTitleLable.textColor = [UIColor colorWithHexString:@"53ac24"];
            self.rejectedWhyLable.hidden = YES;
            self.subtitleToTop.constant = -17;
            self.signedTopViewHeight.constant = 124;
            self.contractIcon.image = [UIImage imageNamed:@"HomePage_grayCircle"];
            self.videoCerIcon.image = [UIImage imageNamed:@"HomePage_selectedCircle"];
            self.signIconRight.constant = 18;
            self.videoIconLeft.constant = 22;
            self.iconBottom.constant = 22;
            [self.auditBtn setImage:[UIImage imageNamed:@"Homepage_video"] forState:UIControlStateNormal];
            [self.signedOrCerBtn setTitle:@"视频认证" forState:UIControlStateNormal];
            
            break;
        }
        case activationStatusSignedAgain: {//审核驳回-签署合约
            self.m_auditStateTitleLable.text = @"合同审核被驳回";
            self.subtitleLable.text = @"重新签署《垫付宝领用合约》和“视频认证”后可扫描订单";
            self.m_auditStateTitleLable.textColor = [UIColor colorWithHexString:@"ff6a57"];
            self.rejectedWhyLable.hidden = NO;
            
            self.rejectedWhyLable.text = [NSString stringWithFormat:@"原因：%@",self.contractAuditRemarks];
            self.subtitleToTop.constant = 6;
            if (iphone5) {
                if ([self getSpaceNum] == 1) {
                    self.signedTopViewHeight.constant = 155;
                } else if ([self getSpaceNum] == 2) {
                    self.signedTopViewHeight.constant = 170;
                } else {
                    self.signedTopViewHeight.constant = 190;
                }
            } else {
                if ([self getSpaceNum] == 1) {
                    self.signedTopViewHeight.constant = 150;
                } else if ([self getSpaceNum] == 2) {
                    self.signedTopViewHeight.constant = 170;
                } else {
                    self.signedTopViewHeight.constant = 190;
                }
            }
            self.contractIcon.image = [UIImage imageNamed:@"HomePage_selectedCircle"];
            self.videoCerIcon.image = [UIImage imageNamed:@"HomePage_grayCircle"];
            self.signIconRight.constant = 22;
            self.videoIconLeft.constant = 18;
            self.iconBottom.constant = 16;
            [self.auditBtn setImage:[UIImage imageNamed:@"Homepage_contract"] forState:UIControlStateNormal];
            [self.signedOrCerBtn setTitle:@"签署《垫付宝领用合约》" forState:UIControlStateNormal];
            
            break;
        }
        case activationStatusVideoAgain: {//审核驳回-视频认证
            self.m_auditStateTitleLable.text = @"合同审核被驳回";
            self.subtitleLable.text = @"重新签署《垫付宝领用合约》和“视频认证”后可扫描订单";
            self.m_auditStateTitleLable.textColor = [UIColor colorWithHexString:@"ff6a57"];
            self.rejectedWhyLable.hidden = NO;
            self.rejectedWhyLable.text = [NSString stringWithFormat:@"原因：%@",self.contractAuditRemarks];
            if (iphone5) {
                if ([self getSpaceNum] == 1) {
                    self.signedTopViewHeight.constant = 155;
                } else if ([self getSpaceNum] == 2) {
                    self.signedTopViewHeight.constant = 170;
                } else {
                    self.signedTopViewHeight.constant = 190;
                }
            } else {
                if ([self getSpaceNum] == 1) {
                    self.signedTopViewHeight.constant = 150;
                } else if ([self getSpaceNum] == 2) {
                    self.signedTopViewHeight.constant = 170;
                } else {
                    self.signedTopViewHeight.constant = 190;
                }
            }
            self.subtitleToTop.constant = 6;
            self.contractIcon.image = [UIImage imageNamed:@"HomePage_grayCircle"];
            self.videoCerIcon.image = [UIImage imageNamed:@"HomePage_selectedCircle"];
            self.signIconRight.constant = 18;
            self.videoIconLeft.constant = 22;
            self.iconBottom.constant = 22;
            [self.auditBtn setImage:[UIImage imageNamed:@"Homepage_video"] forState:UIControlStateNormal];
            [self.signedOrCerBtn setTitle:@"视频认证" forState:UIControlStateNormal];
            
            break;
        }
        default:
            break;
    }
    [AppGlobal setLableSpacing:self.subtitleLable str:self.subtitleLable.text spacing:5];
    [AppGlobal setLableSpacing:self.rejectedWhyLable str:self.rejectedWhyLable.text spacing:5];
    
}

- (int)getSpaceNum {
    CGFloat labelHeight = [self.rejectedWhyLable sizeThatFits:CGSizeMake(self.rejectedWhyLable.frame.size.width, MAXFLOAT)].height;
    NSNumber *count = @((labelHeight) / self.rejectedWhyLable.font.lineHeight);
    return [count intValue];
    
}

/**
 点击大图签署合约或视频认证
 */
- (IBAction)onSignOrVideoAuthBtnIconClicked:(UIButton *)sender {
    
    sender.enabled = NO;
    
    NSString *btnTitle = self.signedOrCerBtn.titleLabel.text;
    if ([btnTitle isEqualToString:@"签署《垫付宝领用合约》"]) {
        //网签协议初始化
        [self signInit];
        
        sender.enabled = YES;
    } else if ([btnTitle isEqualToString:@"视频认证"]) {
        // 是否开启相机
        if (![AppGlobal isCameraPermissions]) {
            [AppGlobal openCameraPermissions];
            
            sender.enabled = YES;
            return;
        }
        if(![AppGlobal canRecord]) {// 是否开启录音
            UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@""
                                                                            message:@"系统目前不允许轻易分期访问您的麦克风。您可以在“设置>隐私”中启用访问权限"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:nil]];
            [alert addAction:[UIAlertAction
                              actionWithTitle:@"去设置"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction *action) {
                                  NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                  
                                  if([[UIApplication sharedApplication] canOpenURL:url]) {
                                      
                                      NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                      [[UIApplication sharedApplication] openURL:url];
                                      
                                  }
                                  
                              }]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            sender.enabled = YES;
            return;
        }
        
        //视频认证
        QYVideoAuthVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYVideoAuthVC"];
        [self.navigationController pushViewController:vc animated:YES];
        sender.enabled = YES;
    }
    
}

/**
 点击签署合约或视频认证
 */
- (IBAction)onSignOrVideoAuthBtnClicked:(UIButton *)sender {
    
    sender.enabled = NO;
    
    NSString *btnTitle = sender.titleLabel.text;
    if ([btnTitle isEqualToString:@"签署《垫付宝领用合约》"]) {
        //网签协议初始化
        [self signInit];
        
        sender.enabled = YES;
    } else if ([btnTitle isEqualToString:@"视频认证"]) {
        // 是否开启相机
        if (![AppGlobal isCameraPermissions]) {
            [AppGlobal openCameraPermissions];
            sender.enabled = YES;
            return;
        }
        if(![AppGlobal canRecord]) {// 是否开启录音
            UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@""
                                                                            message:@"系统目前不允许轻易分期访问您的麦克风。您可以在“设置>隐私”中启用访问权限"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:nil]];
            [alert addAction:[UIAlertAction
                              actionWithTitle:@"去设置"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction *action) {
                                  NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                  
                                  if([[UIApplication sharedApplication] canOpenURL:url]) {
                                      
                                      NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                      [[UIApplication sharedApplication] openURL:url];
                                      
                                  }
                                  
                              }]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            sender.enabled = YES;
            return;
        }
        
        //视频认证
        QYVideoAuthVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYVideoAuthVC"];
        [self.navigationController pushViewController:vc animated:YES];
        sender.enabled = YES;
    }
    
}

#pragma mark - 网签协议初始化
/**
 网签协议初始化
 */
- (void)signInit {
    
    [self showLoading];
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_signInit,verison];
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    
     
    [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self signInitSuccess:responseObject];
        } else {
            self.signedOrCerBtn.enabled = YES;
            self.auditBtn.enabled = YES;
            [self dismissLoading];
            [self signInitFail:responseObject];
        }
        //接口监控
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        
        [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_signInit" andBusinessAlias:@"网签协议初始化" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    } failure:^(NSString * _Nullable errorString) {
        self.signedOrCerBtn.enabled = YES;
        self.auditBtn.enabled = YES;
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_signInit" buAlias:@"网签协议初始化" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

/**
 网签协议初始化成功
 
 */
- (void)signInitSuccess:(id)responseObject {
    DLog(@"网签协议初始化成功");
    
    //请求合同
    [self sendContract];
}

/**
 网签协议初始化失败回调方法
 
 @param responseObject 网签协议初始化回调数据
 */
- (void)signInitFail:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
}

#pragma mark - 发送合同
/**
 发送合同
 */
- (void)sendContract {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_sendContract,verison];
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    
   
    [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {

        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        self.signedOrCerBtn.enabled = YES;
        self.auditBtn.enabled = YES;
        if (statusCode == 10000) {
            [self sendContractSuccess:responseObject];
        } else {
            [self sendContractFail:responseObject];
        }
        [self dismissLoading];
        //接口监控
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        
        [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_sendContract" andBusinessAlias:@"发送合同" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    } failure:^(NSString * _Nullable errorString) {
        self.signedOrCerBtn.enabled = YES;
        self.auditBtn.enabled = YES;
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_sendContract" buAlias:@"发送合同" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

/**
 发送合同成功
 
 */
- (void)sendContractSuccess:(id)responseObject {
    NSString *dataStr = [responseObject objectForKey:@"data"];
    QYWebViewVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QYWebViewVC"];
    vc.s_urlStr = dataStr;
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 发送合同失败
 */
- (void)sendContractFail:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
}

@end
