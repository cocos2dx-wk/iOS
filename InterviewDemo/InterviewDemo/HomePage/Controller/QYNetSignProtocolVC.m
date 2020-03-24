//
//  QYNetSignProtocolVC.m
//  QYStaging
//
//  Created by MobileUser on 2017/5/1.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYNetSignProtocolVC.h"
#import "QYCustomVerificationCodeAlert.h"
#import "QYCreditEvaluationSuccessVC.h"

@interface QYNetSignProtocolVC ()<UIWebViewDelegate>
{
    UIWebView *m_webView;
}
/* 协议背景view */
@property (weak, nonatomic) IBOutlet UIView *m_protocolBgView;
/* 签约背景view */
@property (weak, nonatomic) IBOutlet UIView *m_signBgView;
/* 签约按钮 */
@property (weak, nonatomic) IBOutlet UIButton *m_signBtn;
/* 蒙板 */
@property (nonatomic,weak)UIButton *s_cover;
@property (nonatomic,strong)QYCustomVerificationCodeAlert *m_verificationCodeAlert;
@property (nonatomic, strong) NSURLRequest *m_originRequest;
@property (nonatomic, strong) NSURLConnection *m_urlConnection;
@property (nonatomic, assign) BOOL m_authenticated;
@end

@implementation QYNetSignProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"分期订单签约";

    m_webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    m_webView.delegate = self;
    [self.m_protocolBgView addSubview:m_webView];
    m_webView.backgroundColor = [UIColor whiteColor];
    
    __weak typeof (self) weakSelf = self;
    [m_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.m_protocolBgView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
    }];
    
    [self.m_signBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithMacHexString:@"#575DFE"]] forState:UIControlStateNormal];
    
    [self requestOrderProtocol];
    
    self.m_signBgView.hidden = YES;
}

#pragma mark - 按钮活动
/**
 点击签约
 */
- (IBAction)onSigningClicked:(UIButton *)sender {
    sender.enabled = NO;

    //判断轻易贷是否实名认证
    [self showLoading];
    
    if (self.m_orderId.length > 0) {
        NSString *url = [NSString stringWithFormat:@"%@/%@",app_protocol_checkVerify,self.m_orderId];
        
        
        NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
        
        
        healder[@"traceId"] = [[NSUUID UUID] UUIDString];
        healder[@"parentId"] = [[NSUUID UUID] UUIDString];
        
        //网络监控开始时间戳和时间
        NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *startTime = [AppGlobal getCurrentTime];
     QYNetManager* manager =  [QYNetManager requestManagerWithBaseUrl:myBaseUrl header:healder accpt:@"application/vnd.staging.v2+json"];
        
        [manager get:url params:nil success:^(id  _Nullable responseObject) {
            NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
            if (statusCode == 10000) {
                self.s_cover = [UIButton showCover];
                
                if (iphone6Plus) {
                    self.m_verificationCodeAlert.bounds = CGRectMake(0, 0, 330, 190);
                } else if (iphone6) {
                    self.m_verificationCodeAlert.bounds = CGRectMake(0, 0, 322, 190);
                } else {
                    self.m_verificationCodeAlert.bounds = CGRectMake(0, 0, 300, 185);
                }
                [[UIApplication sharedApplication].keyWindow addSubview:_m_verificationCodeAlert];
                __weak  QYNetSignProtocolVC *protocolVC = self;
                
                [self.m_verificationCodeAlert verifyWithPhone:[self queryInfo].phoneNum token:[self queryInfo].token orderId:self.m_orderId alertBlock:^(NSString *alertTitle) {
                    if ([alertTitle isEqualToString:@"dismissCover"]) {
                        [protocolVC dismissAlert];
                    }
                } auccess:^(id responseObject) {
                    [protocolVC dismissLoading];
                    
                    if ([responseObject isEqualToString:@"SMSCodeSuccess"]) {
                        [protocolVC showMessageWithString:@"手机验证码已发送，请注意查收" imageName:@"Common_correct"];
                    }
                    
                    if ([responseObject isEqualToString:@"交易完成"]) {
                        [protocolVC tradComplete];
                    }
                    
                } fail:^(NSString *error) {
                    [protocolVC dismissLoading];
                    [protocolVC showMessageWithString:error];
                }];
            }else if(statusCode == 41002){
                NSString *message = [responseObject valueForKey:@"message"];
                NSDictionary *dic = [responseObject valueForKey:@"data"];
                NSString *servicePhone = [dic valueForKey:@"servicePhone"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle: message message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"电话告知商户" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",servicePhone];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }else if(statusCode == 41001){
                NSString *message = [responseObject valueForKey:@"message"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle: message message:nil preferredStyle:UIAlertControllerStyleAlert];
                
//                [alert addAction:[UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                    [self gotoQingyiDai];
                }]];
                
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                [self checkVerifyFailed:responseObject];
            }
            sender.enabled = YES;
            [self dismissLoading];
          //接口监控
          NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
          NSString *endTime = [AppGlobal getCurrentTime];
          NSUInteger period = endMillSeconds - startMillSeconds;
          NSString *periods = [NSString stringWithFormat:@"%tu", period];
          
          [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_protocol_checkVerify" andBusinessAlias:@"存管实名认证校验" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
        } failure:^(NSString * _Nullable errorString) {
            [self dismissLoading];
            [self showMessageWithString:kShowErrorMessage];
            sender.enabled = YES;
            //网络监控结束时间戳和时间
            NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
            NSString *endTime = [AppGlobal getCurrentTime];
            NSUInteger period = endMillSeconds - startMillSeconds;
            NSString *periods = [NSString stringWithFormat:@"%tu", period];
            [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_protocol_checkVerify" buAlias:@"存管实名认证校验" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
        }];
    }else{
        [self dismissLoading];
    }
    
    sender.enabled = YES;
}

/**
 失败
 
 @param responseObject responseObject description
 */
- (void)checkVerifyFailed:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
}

#pragma mark- 跳转轻易理财
-(void)gotoQingyiDai {
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/qing-yi-dai/id1044655670?mt=8"];
    if ([[UIApplication sharedApplication]
         canOpenURL:url]) {
        [[UIApplication sharedApplication]
         openURL:url];
    }
}

/**
 初始化QYCustomVerificationCodeAlert
 */
- (QYCustomVerificationCodeAlert *)m_verificationCodeAlert {
    if (!_m_verificationCodeAlert) {
        _m_verificationCodeAlert = [QYCustomVerificationCodeAlert customVerificationCodeAlert];
    }
    return _m_verificationCodeAlert;
}

/**
 弹框消失
 */
- (void)dismissAlert {
    self.s_cover.hidden = YES;
    [self.m_verificationCodeAlert removeFromSuperview];
}

/**
 交易完成
 */
- (void)tradComplete {
    QYCreditEvaluationSuccessVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYCreditEvaluationSuccessVC"];
    vc.m_submitType = QYSubmitTypeTradComplete;
    vc.s_orderId = self.m_orderId;
    vc.s_platForm = self.s_platForm;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 获取订单协议
- (void)requestOrderProtocol {
     NSString *html = [NSString stringWithFormat:@"%@%@?orderId=%@&token=%@",myBaseUrl,app_protocol_sign,self.m_orderId, [self queryInfo].token];
    if (![html isEmpty] && html != nil) {
        self.m_originRequest =[NSURLRequest requestWithURL:[NSURL URLWithString:html]];
        [m_webView loadRequest:self.m_originRequest];
    }
}

#pragma mark UIWebViewDelegate

//即将加载某个请求的时候调用
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    DLog(@"--------%@",request.URL.absoluteString);
    if(!self.m_authenticated) {
        
        self.m_authenticated = NO;
        
        self.m_urlConnection= [[NSURLConnection alloc]initWithRequest:self.m_originRequest delegate:self];
        
        [self.m_urlConnection start];
        
        return NO;
        
    }
    
    return YES;
}

//1.开始加载网页的时候调用
-(void)webViewDidStartLoad:(UIWebView *)webView {
    [self.navigationController showSGProgressWithDuration:2];
}

//2.加载完成的时候调用
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.navigationController finishSGProgress];
    self.m_signBgView.hidden = NO;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.navigationController finishSGProgress];
    self.m_signBgView.hidden = YES;
}

#pragma mark-NURLConnectiondelegate
-(void)connection:(NSURLConnection*)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge

{
    if([challenge previousFailureCount]==0)
        
    {
        self.m_authenticated = YES;
        NSURLCredential *credential=[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    }else{
        [[challenge sender]cancelAuthenticationChallenge:challenge];
    }
    
}

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response

{
    // remake a webview call now that authentication has passed ok.
    self.m_authenticated=YES;
    [m_webView loadRequest:self.m_originRequest];
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [self.m_urlConnection cancel];
    
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.

- (BOOL)connection:(NSURLConnection*)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace*)protectionSpace

{
    return[protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self dismissAlert];
}

@end
