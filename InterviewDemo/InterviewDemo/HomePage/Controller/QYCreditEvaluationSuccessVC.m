//
//  QYCreditEvaluationSuccessVC.m
//  QYStaging
//
//  Created by MobileUser on 2017/4/11.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYCreditEvaluationSuccessVC.h"
#import "QYOrderDetailVC.h"

@interface QYCreditEvaluationSuccessVC ()

/* 提交logo */
@property (weak, nonatomic) IBOutlet UIImageView *m_submitImg;
/* 提交状态 */
@property (weak, nonatomic) IBOutlet UILabel *m_submitStatusLable;
/* 提交标题 */
@property (weak, nonatomic) IBOutlet UILabel *m_submitTitle;
/* 提交副标题 */
@property (weak, nonatomic) IBOutlet UILabel *m_submitViceTitle;
/* 标题之间距离 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_titleSpace;

@end

@implementation QYCreditEvaluationSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClicked)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithMacHexString:@"575DFE"];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClicked)];
    
    [self setM_submitType:self.m_submitType];
    
    //自动化测试id
    [self.navigationItem.rightBarButtonItem setAccessibilityIdentifier:@"tv_title_right_text"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBarlineImageView.hidden = NO;
}

- (void)leftButtonClicked {
    //什么也不做
}

- (void)setM_submitType:(QYSubmitType)m_submitType {
    _m_submitType = m_submitType;
    
    switch (m_submitType) {
        case QYSubmitTypeSupplementInfo:
            self.navigationItem.title = @"提交结果";
            self.m_submitImg.image = kImage(@"Common_submit_after");
            self.m_submitStatusLable.text = @"提交成功，资料审核中...";
            self.m_submitTitle.text = @"审核结果我们会以短信的形式通知您，请注意查收!";
            self.m_submitViceTitle.hidden = YES;
            self.m_titleSpace.constant = 20;
            break;
        case QYSubmitTypeCreditInfo:
            self.navigationItem.title = @"提交结果";
            self.m_submitImg.image = kImage(@"Common_submit_after");
            self.m_submitViceTitle.hidden = NO;
            self.m_submitStatusLable.text = @"恭喜您，资料提交成功";
            self.m_submitTitle.text = @"请耐心等待";
            self.m_submitViceTitle.text = @"审核结果会以短信形式通知您，请注意查收。";
            self.m_titleSpace.constant = 20;
            break;
        case QYSubmitTypeTradComplete:
            self.navigationItem.title = @"交易完成";
            self.m_submitImg.image = kImage(@"Common_succeed");
            self.m_submitViceTitle.hidden = YES;
            self.m_submitStatusLable.text = @"恭喜您交易完成";
            self.m_submitTitle.hidden = YES;

            break;

        default:
            break;
    }
}

/**
 点击完成
 */
- (void)rightButtonClicked {
    if (self.m_submitType == QYSubmitTypeTradComplete) {
        [self getOrderDetailWithOrderId:self.s_orderId andPlatForm:self.s_platForm];
    }else{
        CATransition *transition  = [CATransition animation];
        transition.duration       = 0.25;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type           = kCATransitionPush;
        transition.subtype        = kCATransitionFromBottom;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        [AppGlobal gotoHomePage];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 订单详情
-(void)getOrderDetailWithOrderId:(NSString *)orderId andPlatForm:(NSString *)platForm{
    [self showLoading];
//    NSString *url = [NSString stringWithFormat:@"%@%@?orderId=%@&fromType=0&platForm=%@",app_new_orderDetail,verison,orderId,platForm];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_orderDetail,verison];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"orderId"] = orderId;
    parameters[@"fromType"] = @(0);
    parameters[@"platForm"] = platForm;
    
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] get:url params:parameters success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self orderDetailSuccess:responseObject];
        } else {
            [self orderDetailFail:responseObject];
        }
        [self dismissLoading];
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
    }];
}

/**
 成功
 
 */
- (void)orderDetailSuccess:(id)responseObject {
    
    if ([[responseObject valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
        QYOrderDetailVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYOrderDetailVC"];
        vc.s_orderDetailModel = [QYOrderDetailModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
        vc.s_fromViewController = self;
        vc.s_platForm = self.s_platForm;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 失败
 */
- (void)orderDetailFail:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
}

@end
