//
//  QYResultVC.m
//  QYStaging
//
//  Created by wangkai on 2017/5/2.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYResultVC.h"
#import "QYAddAssetsInfoVC.h"
#import "QYAddFinancialInfoVC.h"
#import "QYAllOrderMainVC.h"
#import "QYNetSignProtocolVC.h"

@interface QYResultVC ()

/* 正常页*/
@property (weak, nonatomic) IBOutlet UIView *m_normalView;
/* 异常页*/
@property (weak, nonatomic) IBOutlet UIView *m_unNormalView;
/* 提交成功*/
@property (weak, nonatomic) IBOutlet UILabel *m_succeddLabel;
/* 描述信息*/
@property (weak, nonatomic) IBOutlet UITextView *m_textView;
/* 查看按钮*/
@property (weak, nonatomic) IBOutlet UIButton *m_button;
/* 是否活体检测0：未认证 1：已认证*/
@property (nonatomic,copy)NSString *m_isFaceAuthStr;
/* 人脸识别最优图片*/
@property (strong, nonatomic) UIImage *m_faceImg;
/* 异常提示信息*/
@property (weak, nonatomic) IBOutlet UITextView *m_unNormalTextView;
/* 网签时间*/
@property (copy, nonatomic)NSString *m_netSignTimeStr;
/* 补充资料时间*/
@property (copy, nonatomic)NSString *m_supplementaryTimeStr;

@end

@implementation QYResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUIWithStatus:self.s_status andOrderId:self.s_orderId];
    
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.m_unNormalTextView.attributedText = [[NSAttributedString alloc] initWithString:@"由于您的信用评估不符合产品分期准入资格,暂时无法使用分期服务" attributes:attributes];
    self.m_unNormalTextView.textColor = [UIColor colorWithHexString:@"9F9F9F"];
    self.m_unNormalTextView.textAlignment = NSTextAlignmentCenter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //set title
    self.navigationItem.title = @"订单分期";
    
    //完成按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClicked)];
    self.navigationItem.rightBarButtonItem.tintColor = color_blueButtonColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    //自动化测试id
    [self.navigationItem.rightBarButtonItem setAccessibilityIdentifier:@"tv_title_right_text"];
    
    //隐藏系统返回
    self.leftButton.hidden = YES;
    
    //查看是否活体检测
    [self faceAuthCheck];
}


/**
 初始化UI
 */
-(void)updateUIWithStatus:(NSString *)status andOrderId:(NSString *)orderId{
    self.m_normalView.hidden = YES;
    self.m_unNormalView.hidden = YES;
    self.s_status = [NSString stringWithFormat:@"%@",status];
    self.s_orderId = [NSString stringWithFormat:@"%@",orderId];
    
    //    1:您的信用评估不符合分期产品准入资格，无法使用分期服务
    //    2:补充财务信息
    //    3:补充资产信息
    //    4:提交成功，订单审核中
    //    5:待面签
    //    6:待网签
    //    7:已完成
    if ([self.s_status isEqualToString:@"1"]) {
        self.m_unNormalView.hidden = NO;
    }else{
        self.m_normalView.hidden = NO;
        if ([self.s_status isEqualToString:@"2"] || [self.s_status isEqualToString:@"3"]) {
            self.m_succeddLabel.text = @"提交成功，订单审核中...";
            self.m_textView.text = [NSString stringWithFormat:@"您的订单金额较大，需要提供更多的资料提高您的信用。请在%@内提交资料，若不提交系统将自动取消订单。",self.m_supplementaryTimeStr];
            self.m_textView.textColor = [UIColor colorWithHexString:@"ff4A4A"];
            [self.m_button setTitle:@"补充资料" forState:UIControlStateNormal];
        }else if([self.s_status isEqualToString:@"4"]){
            self.m_succeddLabel.text = @"提交成功，订单审核中...";
            self.m_textView.text = @"请注意您的订单状态，审核结果会以短信形式通知您,如需查询订单状态，可进入“我的订单“查看";
            self.m_textView.textColor = [UIColor colorWithHexString:@"9f9f9f"];
            [self.m_button setTitle:@"我的订单" forState:UIControlStateNormal];
        }else if([self.s_status isEqualToString:@"5"]){
            self.m_succeddLabel.text = @"提交成功，待签约";
            self.m_textView.text = [NSString stringWithFormat:@"您的订单需要当面签署协议请保持电话%@畅通，将会有业务人员与您联系",[[self queryInfo].phoneNum securityNumber]];
            self.m_textView.textColor = [UIColor colorWithHexString:@"9f9f9f"];
            self.m_button.hidden = YES;
            
        }else if([self.s_status isEqualToString:@"6"]){
            self.m_succeddLabel.text = @"提交成功，待签约";
            self.m_textView.text = [NSString stringWithFormat:@"请在%@内完成签约，否则订单将自动取消",self.m_netSignTimeStr];
            self.m_textView.textAlignment = NSTextAlignmentCenter;
            self.m_textView.textColor = [UIColor colorWithHexString:@"9f9f9f"];
            [self.m_button setTitle:@"签约完成交易" forState:UIControlStateNormal];
        }
    }
    
}

/**
 点击完成
 */
- (void)rightButtonClicked {
    CATransition *transition  = [CATransition animation];
    transition.duration       = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type           = kCATransitionPush;
    transition.subtype        = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];

    [AppGlobal gotoHomePage];
}


- (IBAction)onTelePhonoeClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4001008899"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    sender.enabled = YES;
}

#pragma mark 删除本地所有数据
-(void)deleteAllLocalData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"carInfos"];
    [defaults removeObjectForKey:@"houseInfos"];
    [defaults removeObjectForKey:@"banks"];
    [defaults removeObjectForKey:@"otherInfos"];
    
    [defaults synchronize];
}

/**
 查看按钮

 @param sender sender description
 */
- (IBAction)onCheckClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    //    1:您的信用评估不符合分期产品准入资格，无法使用分期服务
    //    2:补充财务信息
    //    3:补充资产信息
    //    4:提交成功，订单审核中
    //    5:待面签
    //    6:待网签
    //    7:已完成
    if ([self.s_status isEqualToString:@"2"]) {
        QYAddFinancialInfoVC *vc = [[UIStoryboard storyboardWithName:@"QYMyBill" bundle:nil] instantiateViewControllerWithIdentifier:@"QYAddFinancialInfoVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([self.s_status isEqualToString:@"3"]){
        QYAddAssetsInfoVC *vc = [[UIStoryboard storyboardWithName:@"QYMyBill" bundle:nil] instantiateViewControllerWithIdentifier:@"QYAddAssetsInfoVC"];
        [self deleteAllLocalData];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([self.s_status isEqualToString:@"4"]){
        [self headerLoadOrderList];
    }else if([self.s_status isEqualToString:@"6"]){
        if([self.m_isFaceAuthStr isEqualToString:@"0"]){
            // 是否开启相机
            if ([AppGlobal isCameraPermissions]) {
                //启用授权
                [MGLicenseManager licenseForNetWokrFinish:^(bool License) {
                    if (License) {
                        DLog(@"授权成功");
                    }else{
                        DLog(@"授权失败");
                    }
                    
                    //活体检测
                    if (![MGLiveManager getLicense]) {
                        DLog(@"SDK授权失败，请检查");
                        sender.enabled = YES;
                        return;
                    }
                    
                    MGLiveManager *manager = [[MGLiveManager alloc] init];
                    manager.detectionWithMovier = NO;
                    manager.actionCount = 3;
                    
                    [manager startFaceDecetionViewController:self finish:^(FaceIDData *finishDic, UIViewController *viewController) {
                        [viewController dismissViewControllerAnimated:YES completion:nil];
                        
                        NSData *header = [[finishDic images] valueForKey:@"image_best"];
                        self.m_faceImg = [UIImage imageWithData:header];
                        
                        //活体检测成功后人脸识别
                        [self faceRecognition];
                        
                    } error:^(MGLivenessDetectionFailedType errorType, UIViewController *viewController) {
                        [viewController dismissViewControllerAnimated:YES completion:nil];
                        
                        [self showErrorString:errorType];
                    }];
                }];
            } else {
                [AppGlobal openCameraPermissions];
            }
        }else{
            QYNetSignProtocolVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYNetSignProtocolVC"];
            vc.m_orderId = self.s_orderId;
            vc.s_platForm = self.s_platFormStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    sender.enabled = YES;
}

- (void)showErrorString:(MGLivenessDetectionFailedType)errorType{
    switch (errorType) {
        case DETECTION_FAILED_TYPE_ACTIONBLEND:
        {
            [self showMessageWithString:@"    活体检测未成功\n请按照提示完成动作"];
        }
            break;
        case DETECTION_FAILED_TYPE_NOTVIDEO:
        {
            [self showMessageWithString:@"活体检测未成功"];
        }
            break;
        case DETECTION_FAILED_TYPE_TIMEOUT:
        {
            [self showMessageWithString:@"    活体检测未成功\n请在规定时间内完成动作"];
        }
            break;
        default:
        {
            [self showMessageWithString:@"检测失败"];
        }
            break;
    }
}

/**
 人脸识别
 */
-(void)faceRecognition {
    
    [self showLoading];
    NSString* name = [[self queryInfo].personfullname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?idCardName=%@&idCardNo=%@",app_new_faceRecognition,verison,name,[self queryInfo].personIdCardCode];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    param[@"idCardName"] = name ;
    param[@"idCardNo"] = [self queryInfo].personIdCardCode  ;
    
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    
    
 
    [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] uploadImage:self.m_faceImg withUrl:myBaseUrl withPicUrl:urlStr andParameters:nil success:^(NSString * _Nullable imageIDString) {
        
        [self dismissLoading];
        
        //人脸成功后
        [self showMessageWithString:@"活体检测成功" imageName:@"Common_correct"];
        [self faceAuthCheck];
        
        
        //接口监控
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        
        [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:param andResult:nil andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_faceRecognition" andBusinessAlias:@"人脸识别" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSString * _Nullable errorString) {
        [self dismissLoading];
        
        [self showMessageWithString:errorString];
        
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:param msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_faceRecognition" buAlias:@"人脸识别" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
        
    }];
}

#pragma mark - 订单列表
/**
 获取订单列表
 */
- (void)headerLoadOrderList {
    //我的订单列表
    QYAllOrderMainVC *vc = [[QYAllOrderMainVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- 验证会员是否已经做了实名认证和人脸识别
-(void)faceAuthCheck{
    [self showLoading];
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_faceAuthCheck,verison];
    
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    
    [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self faceAuthCheckSuccess:responseObject];
        } else {
            [self faceAuthCheckFail:responseObject];
        }
        [self dismissLoading];
        
        //接口监控
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        
        [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_faceAuthCheck" andBusinessAlias:@"验证会员是否已经做了实名认证和人脸识别" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_faceAuthCheck" buAlias:@"验证会员是否已经做了实名认证和人脸识别" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

/**
 成功
 
 */
- (void)faceAuthCheckSuccess:(id)responseObject {
    if([responseObject isKindOfClass:NSDictionary.class]){
        NSDictionary *dic =  [responseObject valueForKey:@"data"];
        NSInteger result = [[dic objectForKey:@"isFaceAuth"] intValue];
        self.m_isFaceAuthStr = [NSString stringWithFormat:@"%ld",(long)result];
    }
    
    //取时间
    [self getLiveField];
}

/**
 失败
 */
- (void)faceAuthCheckFail:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
}

#pragma mark- 超时时长活字段设置
-(void)getLiveField{
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_getLiveField,verison];
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    [self showLoading];
    
    [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self getLiveFieldSuccess:responseObject];
        } else {
            [self getLiveFieldFail:responseObject];
        }
        [self dismissLoading];
        //接口监控
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        
        [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_getLiveField" andBusinessAlias:@"超时时长活字段设置" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
        
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_getLiveField" buAlias:@"超时时长活字段设置" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

/**
 成功
 
 */
- (void)getLiveFieldSuccess:(id)responseObject {
    if ([[responseObject valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
        //发数据
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = [responseObject objectForKey:@"data"];
        
        //取时间
        self.m_netSignTimeStr = [dic valueForKey:@"netSignTimeConfig"];
        self.m_supplementaryTimeStr = [dic valueForKey:@"supMaterialsTimeConfig"];
        [self updateUIWithStatus:self.s_status andOrderId:self.s_orderId];
    }
}

/**
 失败
 */
- (void)getLiveFieldFail:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
}

@end
