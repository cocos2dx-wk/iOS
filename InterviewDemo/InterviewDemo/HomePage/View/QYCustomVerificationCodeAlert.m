//
//  QYCustomVerificationCodeAlert.m
//  QYStaging
//
//  Created by MobileUser on 2017/5/1.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYCustomVerificationCodeAlert.h"

@interface QYCustomVerificationCodeAlert ()<UITextFieldDelegate>

/* 发送手机提示 */
@property (weak, nonatomic) IBOutlet UILabel *m_sendPhoneLable;
/* 验证码输入 */
@property (weak, nonatomic) IBOutlet UITextField *m_codeTextField;
/* 取消按钮 */
@property (weak, nonatomic) IBOutlet UIButton *m_cancelBtn;
/* 确定按钮 */
@property (weak, nonatomic) IBOutlet UIButton *m_sureBtn;
/* 获取验证码按钮 */
@property (weak, nonatomic) IBOutlet UIButton *m_getCodeBtn;

/* 手机号 */
@property (nonatomic,copy) NSString *m_phoneNumber;
/* token */
@property (nonatomic,copy) NSString *m_token;
/* 订单号 */
@property (nonatomic,copy) NSString *m_orderId;
/* 成功回调 */
@property (nonatomic,copy) successBlock m_successBlock;
/* 失败回调 */
@property (nonatomic,copy) failBlock m_failBlock;
/* 弹框回调 */
@property (nonatomic,copy) alertBlock m_alertBlock;
/* 计时时间 */
@property (nonatomic, assign) NSInteger m_count;
/* 计时器 */
@property (nonatomic, strong) NSTimer *m_timer;

@end

@implementation QYCustomVerificationCodeAlert

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.center = CGPointMake(appWidth/2, appHeight/2-60);
    
    self.m_codeTextField.delegate = self;
    self.m_codeTextField.layer.borderWidth = 1.0;
    self.m_codeTextField.layer.borderColor = [[UIColor colorWithMacHexString:@"E7E7E7"] CGColor];
    
    //获取验证码按钮状态
    [self.m_getCodeBtn setTitleColor:[UIColor colorWithMacHexString:@"#4C4C4C"] forState:UIControlStateDisabled];
    [self.m_getCodeBtn setTitleColor:[UIColor colorWithMacHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    
    [self.m_getCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithMacHexString:@"#575DFE"]] forState:UIControlStateNormal];
    [self.m_getCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithMacHexString:@"#E2E2E2"]] forState:UIControlStateDisabled];
}

/**
 *  初始化QYCustomVerificationCodeAlert
 */
+ (instancetype)customVerificationCodeAlert{
    
    QYCustomVerificationCodeAlert *view = [[[NSBundle mainBundle] loadNibNamed:@"QYCustomVerificationCodeAlert" owner:nil options:nil] lastObject];
    return view;
}

/**
 *  获取验证过程中各种回调处理
 */
- (void)verifyWithPhone:(NSString *)phoneNumber token:(NSString *)token orderId:(NSString *)orderId alertBlock:(alertBlock)alertBlock auccess:(successBlock)successBlock fail:(failBlock)failBlock {
    
    self.m_sendPhoneLable.text = [NSString stringWithFormat:@"验证码将发送至%@",[phoneNumber securityNumber]];
    
    self.m_phoneNumber = phoneNumber;
    self.m_token = token;
    self.m_orderId = orderId;
    self.m_successBlock = successBlock;
    self.m_failBlock = failBlock;
    self.m_alertBlock = alertBlock;
}

/**
 *  退出键盘
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

#pragma mark - 按钮活动
/**
 点击确定
 */
- (IBAction)onSureBtnClicked:(UIButton *)sender {
    self.m_sureBtn.enabled = NO;
    [self endEditing:YES];
    
    if (self.m_codeTextField.text.length <= 0) {
        [self codeCheckFail];
        [self failBlockTitle:@"请填写验证码"];
        self.m_sureBtn.enabled = YES;
        return;
    }
    
    if (self.m_codeTextField.text.length != 4 && self.m_codeTextField.text.length != 6) {
        [self failBlockTitle:@"验证码格式错误"];
        [self codeCheckFail];
        self.m_sureBtn.enabled = YES;
        return;
    }
    
    //订单合同验证
    [self requestOrderContract];
}

/**
 点击取消
 */
- (IBAction)onCancelBtnClicked:(UIButton *)sender {
    sender.enabled = NO;
    [self endEditing:YES];
//    [self timerClose];
    [self alertBlockTitle:@"dismissCover"];
    
    sender.enabled = YES;
}

/**
 获取验证码按钮点击
 */
- (IBAction)onGetCodeClicked:(UIButton *)sender {
    sender.enabled = NO;
    [self requestOrderSmsCode];
    
    //开始计时
    [self timerBegin];
    sender.enabled = YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([string length] != 0) {
        // 点击了非删除键
    } else {
        return YES;// 删除键
    }
    
    // 不能输入空格
    NSString *str = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([str length] == 0) {
        [self failBlockTitle:@"不能输入空格"];
        return NO;
    }
    
    //最多6位字符
    if (textField.text.length >= 6) {
        return NO;
    }
    
    if (![string isNumberOrLetter]) {
        [self failBlockTitle:@"只能输入数字和字母"];
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.m_codeTextField.layer.borderColor = [[UIColor colorWithMacHexString:@"C9C9C9"] CGColor];
}

#pragma mark - 获取验证码-计时器
/**
 计时器开始
 */
- (void)timerBegin {
    
    self.m_count = 60.0;
    self.m_getCodeBtn.enabled = NO;
    [self.m_getCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%lds)", (long)self.m_count] forState:UIControlStateDisabled];
    // 加1个计时器
    self.m_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.m_timer forMode:NSDefaultRunLoopMode];
}

/**
 计时器关闭
 */
- (void)timerClose {
    
    if (!self.m_getCodeBtn.isEnabled) {
        self.m_getCodeBtn.enabled = YES;
    }
    [self.m_timer invalidate];
    self.m_timer = nil;
}

/**
 计时中
 */
- (void)timerFired {
    if (self.m_count != 1) {
        self.m_count -= 1;
        self.m_getCodeBtn.enabled = NO;
        [self.m_getCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%lds)", (long)self.m_count] forState:UIControlStateDisabled];
    } else {
        [self.m_getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [self timerClose];
    }
}

#pragma mark - 获取合同短信验证码
/**
 获取合同短信验证码
 */
- (void)requestOrderSmsCode {
    
    [self alertBlockTitle:@"showLoading"];
    NSString *url = [NSString stringWithFormat:@"%@%@?type=1",app_new_orderSendSms,verison];
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:(BaseViewController *)[AppGlobal getCurrentViewConttoller]];
        if (statusCode == 10000) {
            [self successBlockTitle:@"SMSCodeSuccess"];
        } else {   
            [self failBlockTitle:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSString * _Nullable errorString) {
        [self failBlockTitle:errorString];
    }];
}

/**
 订单合同验证
 */
- (void)requestOrderContract {
    [self alertBlockTitle:@"showLoading"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@?code=%@&orderId=%@&token=%@",app_new_signContract,verison,self.m_codeTextField.text,self.m_orderId,self.m_token];
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:(BaseViewController *)[AppGlobal getCurrentViewConttoller]];
        if (statusCode == 10000) {
            [self timerClose];
            [self alertBlockTitle:@"dismissCover"];
            [self successBlockTitle:@"交易完成"];
        } else if (statusCode == 50997) {
            [self alertBlockTitle:@"dismissCover"];
            NSString *message = [responseObject valueForKey:@"message"];
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
            [[AppGlobal getCurrentViewConttoller] presentViewController:alert animated:YES completion:nil];
        
        } else if (statusCode == 50998) {
            [self alertBlockTitle:@"dismissCover"];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[responseObject valueForKey:@"message"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
            [[AppGlobal getCurrentViewConttoller] presentViewController:alert animated:YES completion:nil];
        } else {
            [self codeCheckFail];
            [self failBlockTitle:[responseObject objectForKey:@"message"]];
        }
        self.m_sureBtn.enabled = YES;
    } failure:^(NSString * _Nullable errorString) {
        self.m_sureBtn.enabled = YES;
        [self failBlockTitle:errorString];
    }];
    
}

#pragma mark - Block回调处理
- (void)failBlockTitle:(NSString *)title {
    if (self.m_failBlock) {
        self.m_failBlock(title);
    }
}

- (void)alertBlockTitle:(NSString *)title {
    if (self.m_alertBlock) {
        self.m_alertBlock(title);
    }
}

- (void)successBlockTitle:(NSString *)title {
    if (self.m_successBlock) {
        self.m_successBlock(title);
    }
}

/**
 验证码有误是输入框处理
 */
- (void)codeCheckFail {
    
    self.m_codeTextField.layer.borderColor = [[UIColor colorWithMacHexString:@"FE6B6B"] CGColor];
    [self.m_codeTextField setText:@""];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
