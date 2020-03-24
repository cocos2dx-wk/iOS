//
//  QYOrderDetailVC.m
//  QYStaging
//
//  Created by wangkai on 2017/4/24.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYOrderDetailVC.h"
#import "QYNetSignProtocolVC.h"
#import "QYOrderCell.h"
#import "QYWebViewVC.h"
#import "QYAllOrderListVC.h"
#import "QYHaveBillVC.h"
#import "QYNotBillVC.h"
#import "QYHistoryBillDetailVC.h"
#import "KYMonthBillVC.h"

@interface QYOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>

/* 数组 */
@property (strong, nonatomic) NSMutableArray *m_array;
/* 滚动view */
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
/* 签署协议 */
@property (weak, nonatomic) IBOutlet UIButton *m_signButton;
/* 背景高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_bgHeightConstraint;
/* 面签view */
@property (weak, nonatomic) IBOutlet UIView *m_faceToFaceView;
/* 面签描述 */
@property (weak, nonatomic) IBOutlet UILabel *m_faceToFaceLabel;
/* 状态view高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_orderViewHeightConstraint;
/* 待审核 */
@property (weak, nonatomic) IBOutlet UIView *m_onCheckView;
/* 待签约 */
@property (weak, nonatomic) IBOutlet UIView *m_onSignView;
/* 已完成 */
@property (weak, nonatomic) IBOutlet UIView *m_gotCompletedView;
/* 已取消 */
@property (weak, nonatomic) IBOutlet UIView *m_gotCanceledView;
/* 列表 */
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;
/* 左边总额 */
@property (weak, nonatomic) IBOutlet UILabel *m_leftTotalAmountLabel;
/* 右边总额 */
@property (weak, nonatomic) IBOutlet UILabel *m_rightTotalAmountLabel;
/* 供应商 */
@property (weak, nonatomic) IBOutlet UILabel *m_productNameLabel;
/* 地址 */
@property (weak, nonatomic) IBOutlet UILabel *m_addressLabel;
/* 电话 */
@property (weak, nonatomic) IBOutlet UILabel *m_phoneLabel;
/* 期数高度 2者都有192*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_dateHeightConstraint;
/* 质押期数view */
@property (weak, nonatomic) IBOutlet UIView *m_pledgeView;
/* 期数 */
@property (weak, nonatomic) IBOutlet UILabel *m_numberLabel;
/* 分期金额 */
@property (weak, nonatomic) IBOutlet UILabel *m_periodLabel;
/* 质押金额 */
@property (weak, nonatomic) IBOutlet UILabel *m_pledgeLabel;
/* 列表高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_tableViewHeightConstraint;
/* 面签高度 51*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_faceToFaceHeightConstraint;
/* 待签约取消订单按钮*/
@property (weak, nonatomic) IBOutlet UIButton *m_pendingCancelButton;
/* 待审核取消订单按钮*/
@property (weak, nonatomic) IBOutlet UIButton *m_unCheckCancelButton;
/* 是否活体检测0：未认证 1：已认证*/
@property (nonatomic,copy)NSString *m_isFaceAuthStr;
/* 人脸识别最优图片*/
@property (strong, nonatomic) UIImage *m_faceImg;

/*-----已完成-------*/
/* 订单编号 */
@property (weak, nonatomic) IBOutlet UILabel *m_completed_numberLabel;
/* 提交时间 */
@property (weak, nonatomic) IBOutlet UILabel *m_completedStarttimeLabel;
/* 取消时间 */
@property (weak, nonatomic) IBOutlet UILabel *m_completedCanceltimeLabel;
/*-----已取消-------*/
/* 订单编号 */
@property (weak, nonatomic) IBOutlet UILabel *m_cancelNumberLabel;
/* 提交时间 */
@property (weak, nonatomic) IBOutlet UILabel *m_cancelStarttimeLabel;
/* 取消时间 */
@property (weak, nonatomic) IBOutlet UILabel *m_cancelCanceltimeLabel;
/*-----待签约-------*/
/* 订单编号 */
@property (weak, nonatomic) IBOutlet UILabel *m_unSignNumberLabel;
/* 提交时间 */
@property (weak, nonatomic) IBOutlet UILabel *m_unSignStarttimeLabel;
/*-----待审核-------*/
/* 订单编号 */
@property (weak, nonatomic) IBOutlet UILabel *m_unPendingNumberLabel;
/* 提交时间 */
@property (weak, nonatomic) IBOutlet UILabel *m_unPendingStarttimeLabel;
/* 期数view */
@property (weak, nonatomic) IBOutlet UIView *m_periodNumberView;
/* 期数宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_periodWidthConstraint;
/* 质押期数view */
@property (weak, nonatomic) IBOutlet UIView *m_pledgeBlueView;
/* 质押期数宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_pledgeWidthConstraint;
/* 质押期数 */
@property (weak, nonatomic) IBOutlet UILabel *m_pledgeBlueLabel;
/* 地址信息总高度 128*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_infoHeightConstraint;
/* 地址高度 64*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_addressHeightConstraint;
/* 期数下三角显示隐藏*/
@property (weak, nonatomic) IBOutlet UIImageView *m_img1;
@property (weak, nonatomic) IBOutlet UILabel *m_label1;
/* 质押期数下三角显示隐藏*/
@property (weak, nonatomic) IBOutlet UIImageView *m_img2;
@property (weak, nonatomic) IBOutlet UILabel *m_label2;
/* 根据地址行数控制地址的位置*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_addressLocationConstraint;

@end

@implementation QYOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自动化测试id
    [self.leftButton setAccessibilityIdentifier:@"iv_title_left_icon"];
    
    [self initDefaultUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //set title
    self.navigationItem.title = @"订单详情";
}

/**
 系统返回
 
 @param sender sender description
 */
- (void)goBack:(UIButton *)sender {
    if ([self.s_fromViewController isKindOfClass:QYAllOrderListVC.class] || [self.s_fromViewController isKindOfClass:[QYHaveBillVC class]] || [self.s_fromViewController isKindOfClass:[QYNotBillVC class]]|| [self.s_fromViewController isKindOfClass:[KYMonthBillVC class]]) {
        if (self.backData) {
            self.backData();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UINavigationController *nav =  self.navigationController;
         if (nav && [nav isKindOfClass:[QYMainNC class]]) {
            [nav popToRootViewControllerAnimated:YES];
        }
        [AppGlobal gotoHomePage];
    }
}

/**
 默认UI
 */
-(void)initDefaultUI {
    self.m_onCheckView.hidden = YES;
    self.m_onSignView.hidden = YES;
    self.m_gotCompletedView.hidden = YES;
    self.m_gotCanceledView.hidden = YES;
    self.m_faceToFaceView.hidden = YES;
    self.m_faceToFaceHeightConstraint.constant = 0;
    self.m_signButton.hidden = YES;
    
    //订单状态
    NSString *status = self.s_orderDetailModel.status;
    float deltaF = 0;
    if ([status isEqualToString:@"2"]) {//待面签
        self.m_onSignView.hidden = NO;
        self.m_faceToFaceView.hidden = NO;
        self.m_orderViewHeightConstraint.constant = 97;
        self.m_faceToFaceHeightConstraint.constant = 51;
        
        NSString *defaultStr = [NSString stringWithFormat:@"您的订单需要当面签署协议请保持电话%@畅通，将会有业务人员与您联系",[[self queryInfo].phoneNum securityNumber]];
        NSString *currentStr = [[self queryInfo].phoneNum securityNumber];
        self.m_faceToFaceLabel.text = defaultStr;
        [AppGlobal changeRichTextColor:self.m_faceToFaceLabel defaultColor:@"9f9f9f" currentColor:@"000000" defaultText:defaultStr currentText:currentStr];
        self.m_unSignNumberLabel.text = [NSString stringWithFormat:@"订单编号: %@",self.s_orderDetailModel.orderNum];
        self.m_unSignStarttimeLabel.text = [NSString stringWithFormat:@"提交时间: %@",[AppGlobal timeWithTimeIntervalStringInDetail:self.s_orderDetailModel.createtime]];
    }else if ([status isEqualToString:@"1"]) {//待网签
        self.m_onSignView.hidden = NO;
        self.m_signButton.hidden = NO;
        self.m_orderViewHeightConstraint.constant = 97;
        self.m_unSignNumberLabel.text = [NSString stringWithFormat:@"订单编号: %@",self.s_orderDetailModel.orderNum];
        self.m_unSignStarttimeLabel.text = [NSString stringWithFormat:@"提交时间: %@",[AppGlobal timeWithTimeIntervalStringInDetail:self.s_orderDetailModel.createtime]];
    }else if ([status isEqualToString:@"3"]){//已完成
        self.m_gotCompletedView.hidden = NO;
        self.m_signButton.hidden = NO;
        [self.m_signButton setTitle:@"查看合同" forState:UIControlStateNormal];
        self.m_orderViewHeightConstraint.constant = 120;
        self.m_completed_numberLabel.text = [NSString stringWithFormat:@"订单编号: %@",self.s_orderDetailModel.orderNum];
        self.m_completedStarttimeLabel.text = [NSString stringWithFormat:@"提交时间: %@",[AppGlobal timeWithTimeIntervalStringInDetail:self.s_orderDetailModel.createtime]];
        self.m_completedCanceltimeLabel.text = [NSString stringWithFormat:@"完成时间: %@",[AppGlobal timeWithTimeIntervalStringInDetail:self.s_orderDetailModel.lastmodtime]];
        deltaF = 50;//已完成查看合同按钮高度
    }else if ([status isEqualToString:@"4"]){//已取消
        self.m_gotCanceledView.hidden = NO;
        self.m_orderViewHeightConstraint.constant = 120;
        
        self.m_cancelNumberLabel.text = [NSString stringWithFormat:@"订单编号: %@",self.s_orderDetailModel.orderNum];
        self.m_cancelStarttimeLabel.text = [NSString stringWithFormat:@"提交时间: %@",[AppGlobal timeWithTimeIntervalStringInDetail:self.s_orderDetailModel.createtime]];
        self.m_cancelCanceltimeLabel.text = [NSString stringWithFormat:@"取消时间: %@",[AppGlobal timeWithTimeIntervalStringInDetail:self.s_orderDetailModel.lastmodtime]];
        
    }else {//待审核
        self.m_onCheckView.hidden = NO;
        self.m_orderViewHeightConstraint.constant = 97;
        self.m_unPendingNumberLabel.text = [NSString stringWithFormat:@"订单编号: %@",self.s_orderDetailModel.orderNum];
        self.m_unPendingStarttimeLabel.text = [NSString stringWithFormat:@"提交时间: %@",[AppGlobal timeWithTimeIntervalStringInDetail:self.s_orderDetailModel.createtime]];
        
    }
    //分期总额
    self.m_leftTotalAmountLabel.text = [NSString stringWithFormat:@"¥%.2f",[[NSString stringWithFormat:@"%@",self.s_orderDetailModel.installmentAmount] floatValue]];
    self.m_rightTotalAmountLabel.text = [NSString stringWithFormat:@"¥%.2f",[[NSString stringWithFormat:@"%@",self.s_orderDetailModel.totalAmount] floatValue]];
    
    //期数和质押期数
    //是否质押
    NSString *tempStr = @"";//质押期数
    if ([self.s_orderDetailModel.pledged isEqualToString:@"2"]) {//已质押
        if ([self.s_orderDetailModel.pledgePeriod isEqualToString:self.s_orderDetailModel.periods]) {
            NSString *defaultStr = [NSString stringWithFormat:@"￥%.2f×1期 + ￥%.2f×%d期",[[NSString stringWithFormat:@"%@",self.s_orderDetailModel.firstStage] floatValue],[[NSString stringWithFormat:@"%@",self.s_orderDetailModel.average] floatValue],[self.s_orderDetailModel.periods intValue] - 1];
            NSString *currentStr = @"+";
            self.m_pledgeLabel.text = defaultStr;
            [AppGlobal changeRichTextColor:self.m_periodLabel defaultColor:@"575DFE" currentColor:@"ff0000" defaultText:defaultStr currentText:currentStr];
            tempStr = self.s_orderDetailModel.periods;
        }else{
            self.m_pledgeLabel.text = [NSString stringWithFormat:@"￥%.2f×%@期",[[NSString stringWithFormat:@"%@",self.s_orderDetailModel.average] floatValue],self.s_orderDetailModel.pledgePeriod];
            tempStr = self.s_orderDetailModel.pledgePeriod;
            
            self.m_img2.hidden = YES;
            self.m_label2.hidden = YES;
        }
    }else{
        self.m_pledgeView.hidden = YES;
        self.m_dateHeightConstraint.constant = 98;
    }

    //分期数
    self.m_numberLabel.text = [NSString stringWithFormat:@"%@期",self.s_orderDetailModel.periods];
    self.m_numberLabel.transform = CGAffineTransformMakeRotation(M_PI*-40/180);
    if (self.s_orderDetailModel.firstStage.length > 0) {
        NSString *defaultStr = [NSString stringWithFormat:@"￥%.2f×1期 + ￥%.2f×%d期",[[NSString stringWithFormat:@"%@",self.s_orderDetailModel.firstStage] floatValue],[self.s_orderDetailModel.average floatValue],[self.s_orderDetailModel.periods intValue] - 1];
        NSString *currentStr = @"+";
        self.m_periodLabel.text = defaultStr;
        [AppGlobal changeRichTextColor:self.m_periodLabel defaultColor:@"575DFE" currentColor:@"ff0000" defaultText:defaultStr currentText:currentStr];
        
    }else{
        self.m_periodLabel.text = [NSString stringWithFormat:@"￥%.2f×%d期",[self.s_orderDetailModel.average floatValue],[self.s_orderDetailModel.periods intValue]];
        
        self.m_img1.hidden = YES;
        self.m_label1.hidden = YES;
    }
    
    //拉长
    self.m_periodNumberView.layer.cornerRadius = 4;
    self.m_periodNumberView.layer.borderColor = [color_blueButtonColor CGColor];
    self.m_periodNumberView.layer.borderWidth = 1;
    CGSize titleSize = [self.m_periodLabel.text sizeWithFont:self.m_periodLabel.font maxSize:CGSizeMake(MAXFLOAT, 30)];
    self.m_periodWidthConstraint.constant = titleSize.width + 17 + 17;
    if(self.m_periodWidthConstraint.constant > appWidth - 23 - 10){
        self.m_periodWidthConstraint.constant = appWidth - 23 - 10;
    }
    self.m_pledgeBlueView.layer.cornerRadius = 4;
    self.m_pledgeBlueView.layer.borderColor = [color_blueButtonColor CGColor];
    self.m_pledgeBlueView.layer.borderWidth = 1;
    CGSize titleSize1 = [self.m_pledgeLabel.text sizeWithFont:self.m_pledgeLabel.font maxSize:CGSizeMake(MAXFLOAT, 30)];
    self.m_pledgeWidthConstraint.constant = titleSize1.width + 17 + 17;
    if(self.m_pledgeWidthConstraint.constant > appWidth - 23 - 10){
        self.m_pledgeWidthConstraint.constant = appWidth - 23 - 10;
    }
    self.m_pledgeBlueLabel.text = [NSString stringWithFormat:@"%@期",tempStr];
    self.m_pledgeBlueLabel.transform = CGAffineTransformMakeRotation(M_PI*-40/180);
    
    //列表
    self.m_scrollView.showsVerticalScrollIndicator = FALSE;
    self.m_scrollView.bounces = NO;
    if (self.s_orderDetailModel.goodsInfos.count > 0) {
        self.m_tableViewHeightConstraint.constant = 93 * self.s_orderDetailModel.goodsInfos.count;
        self.m_array =  [NSMutableArray mj_objectArrayWithKeyValuesArray:self.s_orderDetailModel.goodsInfos];
        self.m_bgHeightConstraint.constant = self.m_faceToFaceHeightConstraint.constant + self.m_orderViewHeightConstraint.constant + (93 * self.s_orderDetailModel.goodsInfos.count) + + 11 + 45 + self.m_dateHeightConstraint.constant + 10 + 10 + 128 + 55 + 13 + deltaF;
        if (self.m_bgHeightConstraint.constant <= appHeight) {
            self.m_bgHeightConstraint.constant = appHeight + 55;
            self.m_scrollView.scrollEnabled = NO;
        }
    }
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    [self.m_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //供应商信息
    self.m_productNameLabel.text = [NSString stringWithFormat:@"供应商: %@",self.s_orderDetailModel.shopName];
    self.m_addressLabel.text = self.s_orderDetailModel.shopAddress;
    self.m_phoneLabel.text = self.s_orderDetailModel.shopPhone;
    
    //地址适配
    CGSize addressSize = [self.m_addressLabel.text sizeWithFont:self.m_addressLabel.font maxSize:CGSizeMake(self.m_addressLabel.frame.size.width, MAXFLOAT)];
    if (!iphone6Plus) {
        if (addressSize.height > 30) {//2行
            self.m_infoHeightConstraint.constant = 128;
            self.m_addressHeightConstraint.constant = 64;
            self.m_addressLocationConstraint.constant = -7;
        }
    }
    if (iphone6Plus) {
        if (addressSize.height > 34) {//2行
            self.m_infoHeightConstraint.constant = 128;
            self.m_addressHeightConstraint.constant = 64;
            self.m_addressLocationConstraint.constant = -7;
        }
    }
    
    //取消订单描边
    self.m_pendingCancelButton.layer.cornerRadius = 4;
    self.m_pendingCancelButton.layer.borderWidth = 0.5;
    self.m_pendingCancelButton.layer.borderColor = [UIColor colorWithHexString:@"BBBBBB"].CGColor;
    self.m_unCheckCancelButton.layer.cornerRadius = 4;
    self.m_unCheckCancelButton.layer.borderWidth = 0.5;
    self.m_unCheckCancelButton.layer.borderColor = [UIColor colorWithHexString:@"BBBBBB"].CGColor;
    
    //查看是否活体检测
    [self faceAuthCheck];
}


/**
 订单取消

 @param sender sender description
 */
- (IBAction)onCancelClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    //取消订单
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确定要取消订单吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self cancelOrderWithOrderId:self.s_orderDetailModel.orderId];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
    sender.enabled = YES;
}

/**
 签署协议

 @param sender sender description
 */
#pragma mark 签署协议
- (IBAction)onSignClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    //已完成不判断活体检测，从微信过来的
    if ([self.s_orderDetailModel.status isEqualToString:@"3"]) {//已完成
        
        [self viewerContract:self.s_orderDetailModel.orderId];
        
        sender.enabled = YES;
        return;
    }
    
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
        //    0:待审核、1：待网签、2：待面签、3：已完成、4：已取消
        if ([self.s_orderDetailModel.status isEqualToString:@"1"]) {//网签
            //签名
            QYNetSignProtocolVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYNetSignProtocolVC"];
            vc.m_orderId = self.s_orderDetailModel.orderId;
            vc.s_platForm = self.s_platForm;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
     sender.enabled = YES;
}


#pragma mark- 查看合同
-(void)viewerContract:(NSString *)orderId{
//  NSString *htmlUrl = [NSString stringWithFormat:@"%@%@%@?orderId=%@",base,app_protocol_sign,verison,orderId];
    NSString *html = [NSString stringWithFormat:@"%@%@?orderId=%@&token=%@",myBaseUrl,app_protocol_sign, orderId, [self queryInfo].token];
    QYWebViewVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QYWebViewVC"];
            vc.s_urlStr=html ;
            [self.navigationController pushViewController:vc animated:YES];
}


/**
 协议请求
 */
-(void)getProtocolInfo {
    [self showLoading];
    NSString *url = [NSString stringWithFormat:@"%@%@",app_protocol_sign,verison];
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    
    
      [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        [self dismissLoading];
        //成功
        if (statusCode == 10000) {
            
        }else{
           
        }
          //接口监控
          NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
          NSString *endTime = [AppGlobal getCurrentTime];
          NSUInteger period = endMillSeconds - startMillSeconds;
          NSString *periods = [NSString stringWithFormat:@"%tu", period];
          
          [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_protocol_sign" andBusinessAlias:@"签约" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_protocol_sign" buAlias:@"签约" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
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
    if ([self queryInfo].personIdCardCode.length > 0 && [self queryInfo].personfullname.length > 0) {
        [self faceRecognitionRequest];
    } else {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",app_new_auth,verison];
        
        NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
        
        
        healder[@"traceId"] = [[NSUUID UUID] UUIDString];
        healder[@"parentId"] = [[NSUUID UUID] UUIDString];
        
        //网络监控开始时间戳和时间
        NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *startTime = [AppGlobal getCurrentTime];
        
        
      
        
        
          [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {

            NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
            if (statusCode == 10000) {
                if([responseObject isKindOfClass:NSDictionary.class]){
                    
                    NSDictionary *dic = [responseObject valueForKey:@"data"];
                    
                    //取得会员名字和证件号, 认证状态
                    UserInfo *info = [self queryInfo];
                    if (dic) {
                        info.personfullname = [dic valueForKey:@"personfullname"];
                        info.personIdCardCode = [dic valueForKey:@"personIdCardCode"];
                        info.isAuth = @"1";
                    }else{
                        info.isAuth = @"0";
                    }
                    [self updateInfo:info];
                    [self faceRecognitionRequest];
                    
                    
                }
            } else {
                //取得会员名字和证件号, 认证状态
                UserInfo *info = [self queryInfo];
                info.isAuth = @"0";
                info.personfullname = @"";
                info.personIdCardCode = @"";
                [self updateInfo:info];
                [self dismissLoading];
                [self showMessageWithString:[responseObject valueForKey:@"message"]];
            }
              //接口监控
              NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
              NSString *endTime = [AppGlobal getCurrentTime];
              NSUInteger period = endMillSeconds - startMillSeconds;
              NSString *periods = [NSString stringWithFormat:@"%tu", period];
              
              [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_auth" andBusinessAlias:@"获取用户已实名认证信息" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
        } failure:^(NSString * _Nullable errorString) {
            [self dismissLoading];
            [self showMessageWithString:kShowErrorMessage];
            //网络监控结束时间戳和时间
            NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
            NSString *endTime = [AppGlobal getCurrentTime];
            NSUInteger period = endMillSeconds - startMillSeconds;
            NSString *periods = [NSString stringWithFormat:@"%tu", period];
            [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_auth" buAlias:@"获取用户已实名认证信息"  statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
        }];
    }
}

/**
 人脸识别请求
 */
- (void)faceRecognitionRequest {
    
    NSString* name = [[self queryInfo].personfullname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?idCardName=%@&idCardNo=%@",app_new_faceRecognition,verison,name,[self queryInfo].personIdCardCode];
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] uploadImage:self.m_faceImg withUrl:myBaseUrl withPicUrl:urlStr andParameters:nil success:^(NSString * _Nullable imageIDString) {
        [self dismissLoading];
        
        //人脸成功后
        [self showMessageWithString:@"活体检测成功" imageName:@"Common_correct"];
        [self faceAuthCheck];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:errorString];
    }];
}

#pragma mark- tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.m_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QYOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYOrderCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QYOrderCell" owner:nil options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.s_isGray = NO;
    QYProductDetailModel *detailModel = [QYProductDetailModel mj_objectWithKeyValues:[self.m_array objectAtIndex:indexPath.row]];
    [cell updateUI:detailModel];
    
    //自动化测试id
    [cell.m_iconImageView setAccessibilityIdentifier:@"iv_product"];
    [cell.m_nameLabel setAccessibilityIdentifier:@"tv_name"];
    [cell.m_priceLabel setAccessibilityIdentifier:@"tv_price"];
    [cell.m_amountLabel setAccessibilityIdentifier:@"tv_num"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 93;
}

#pragma mark- 取消订单
-(void)cancelOrderWithOrderId:(NSString *)orderId{
    [self showLoading];
    
    NSString *url = [NSString stringWithFormat:@"%@%@?orderId=%@",app_new_cancelOrder,verison,orderId];
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    
    
    
    
    [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self cancelOrderSuccess:responseObject];
        } else {
            [self cancelOrderFail:responseObject];
        }
        [self dismissLoading];
        //接口监控
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        
        [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_cancelOrder" andBusinessAlias:@"取消订单" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_cancelOrder" buAlias:@"取消订单" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

/**
 成功
 
 */
- (void)cancelOrderSuccess:(id)responseObject {
    [self showMessageWithString:@"取消订单成功！"];
    
    //更新首页状态
    [NotificationCenter postNotificationName:kREFRESHHOMENotification object:nil];
    
    //重新请求订单详情
    [self getOrderDetailWithOrderId:self.s_orderDetailModel.orderId andPlatForm:self.s_platForm];
}

/**
 失败
 */
- (void)cancelOrderFail:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
}

#pragma mark- 订单详情
-(void)getOrderDetailWithOrderId:(NSString *)orderId andPlatForm:(NSString *)platForm{
    [self showLoading];
//    NSString *url = [NSString stringWithFormat:@"%@%@&orderId=%@&fromType=0&platForm=%@",app_new_orderDetail,verison,orderId,platForm];
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_orderDetail,verison];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"orderId"] = orderId;
    parameters[@"fromType"] = @(0);
    parameters[@"platForm"] = platForm;
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    
     [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] get:url params:parameters success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self orderDetailSuccess:responseObject];
        } else {
            [self orderDetailFail:responseObject];
        }
        [self dismissLoading];
         //接口监控
         NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
         NSString *endTime = [AppGlobal getCurrentTime];
         NSUInteger period = endMillSeconds - startMillSeconds;
         NSString *periods = [NSString stringWithFormat:@"%tu", period];
         
         [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:parameters andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_orderDetail" andBusinessAlias:@"订单详情" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:parameters msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_orderDetail" buAlias:@"订单详情" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

/**
 成功
 */
- (void)orderDetailSuccess:(id)responseObject {
       self.s_orderDetailModel = [QYOrderDetailModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
        //刷新UI
        [self initDefaultUI];
    
}

/**
 失败
 */
- (void)orderDetailFail:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
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
}

/**
 失败
 */
- (void)faceAuthCheckFail:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
}

@end
