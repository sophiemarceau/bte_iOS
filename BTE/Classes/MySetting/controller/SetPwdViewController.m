//
//  SetPwdViewController.m
//  BTE
//
//  Created by sophie on 2018/9/19.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "SetPwdViewController.h"
#import "CircularProgressBar.h"
#import <VerifyCode/NTESVerifyCodeManager.h>
#import "IDFVTools.h"




@interface SetPwdViewController ()<CircularProgressDelegate,NTESVerifyCodeManagerDelegate>
@property(nonatomic,strong) UILabel *phoneLabel;
@property(nonatomic,strong) UITextField *codeTextField;
@property(nonatomic,strong) UITextField *pwdTextField;
@property(nonatomic,strong) UITextField *confirmpwdTextField;
@property(nonatomic,strong) UIButton *confirmpButton;
@property(nonatomic,strong) UIButton *messageButton;
/**
 倒计时圈
 */
@property (nonatomic,strong) CircularProgressBar *circularBar;
/**
 是否正在验证码获取中
 */
@property (nonatomic, assign) BOOL isCountDown;

@property (nonatomic, strong) NTESVerifyCodeManager *manager;
@end

@implementation SetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BHHexColor(@"F9F9FA");
    // sdk调用
    self.manager = [NTESVerifyCodeManager sharedInstance];
    self.manager.delegate = self;
    // 设置透明度
    self.manager.alpha = 0.7;
    
    // 设置frame
    self.manager.frame = CGRectNull;
    
    // captchaId从网易申请，比如@"a05f036b70ab447b87cc788af9a60974"
    NSString *captchaId = @"9040bdc428034e98ae5fd0661ca03014";
    [self.manager configureVerifyCode:captchaId timeout:5];
    self.title = @"设置登录密码";
    [self initSubViews];
}

-(void)initSubViews{
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 98)];
    messageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:messageView];
    
    [messageView addSubview:self.codeTextField];
    [messageView addSubview:self.messageButton];
    [messageView addSubview:self.phoneLabel];
    [messageView addSubview:self.circularBar];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 59, SCREEN_WIDTH -32, 0.5)];
    lineView.backgroundColor = BHHexColor(@"E6EBF0");
    [messageView addSubview:lineView];
    
    
    UIView *pwdbgView = [[UIView alloc] initWithFrame:CGRectMake(0, messageView.bottom +10, SCREEN_WIDTH, 100)];
    pwdbgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pwdbgView];
    
    [pwdbgView addSubview:self.pwdTextField];
    [pwdbgView addSubview:self.confirmpwdTextField];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(16, 50, SCREEN_WIDTH -32, 0.5)];
    lineView1.backgroundColor = BHHexColor(@"E6EBF0");
    [pwdbgView addSubview:lineView1];
    
    [self.view addSubview:self.confirmpButton];
}


#pragma mark - 进度条
// 开启圆形进度条
- (void)circleProgressStart {
    self.messageButton.hidden = YES;
    self.circularBar.hidden = NO;
    [self.circularBar setTotalSecondTime:60];
    [self.circularBar startTimer];
    self.isCountDown = YES;
}

- (void)CircularProgressEnd {
    self.messageButton.hidden = NO;
    self.circularBar.hidden = YES;
    self.isCountDown = NO;
    [self.messageButton wy_animate];
    [self.circularBar wy_animate];
}


#pragma mark - NTESVerifyCodeManagerDelegate
/**
 * 验证码组件初始化完成
 */
- (void)verifyCodeInitFinish{
//    NSLog(@"收到初始化完成的回调");
}

/**
 * 验证码组件初始化出错
 *
 * @param message 错误信息
 */
- (void)verifyCodeInitFailed:(NSString *)message{
    NSLog(@"收到初始化失败的回调:%@",message);
}

/**
 * 完成验证之后的回调
 *
 * @param result 验证结果 BOOL:YES/NO
 * @param validate 二次校验数据，如果验证结果为false，validate返回空
 * @param message 结果描述信息
 *
 */
- (void)verifyCodeValidateFinish:(BOOL)result validate:(NSString *)validate message:(NSString *)message{
    NSLog(@"%@",validate);
    if (result) {
        [self requestCheckApi:validate];
    }else{
        NSLog(@"收到验证结果的回调:(%d,%@,%@)", result, validate, message);
    }
}

/**
 * 关闭验证码窗口后的回调
 */
- (void)verifyCodeCloseWindow{
    //用户关闭验证后执行的方法
    NSLog(@"收到关闭验证码视图的回调");
}

/**
 * 网络错误
 *
 * @param error 网络错误信息
 */
- (void)verifyCodeNetError:(NSError *)error{
    //用户关闭验证后执行的方法
    NSLog(@"收到网络错误的回调:%@(%ld)", [error localizedDescription], (long)error.code);
}

- (void)requestCheckApi:(NSString *)sessionId{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    [pramaDic setObject:sessionId forKey:@"validate"];
    if ([self.phoneStr isEqualToString:@""]) {
        [pramaDic setObject:self.emailStr forKey:@"loginUsername"];
    }else{
        [pramaDic setObject:self.phoneStr forKey:@"loginUsername"];
    }
    
    WS(weakSelf)
    //    NMShowLoadIng;
    [BTERequestTools requestWithURLString:kMessageAuth parameters:pramaDic type:2 success:^(id responseObject) {
        //        NMRemovLoadIng;
        NSLog(@"-----responseObject--->%@",responseObject);
        if (IsSafeDictionary(responseObject)) {
            
            if ([self.phoneStr isEqualToString:@""]) {
               [BHToast showMessage:@"验证码已发送到您的邮箱"];
            }else{
                [BHToast showMessage:@"验证码已发送到您的手机"];
            }
            [weakSelf circleProgressStart];
        }
    } failure:^(NSError *error)  {
        //        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

-(void)getCode:(UIButton *)sender{
    [self.view endEditing:YES];
    [self.manager openVerifyCodeView:nil];
}

-(void)changePasswordSubmit:(UIButton *)sender{
    sender.enabled = NO;
    if (self.codeTextField.text.length < 4) {
        [BHToast showMessage:@"请输入正确的验证码"];
        sender.enabled = YES;
        return;
    }
    
    if (self.pwdTextField.text.length < 6 ||self.pwdTextField.text.length > 12) {
        [BHToast showMessage:@"请输入6-12位正确密码"];
        sender.enabled = YES;
        return;
    }
    
    if (self.confirmpwdTextField.text.length < 6 ||self.confirmpwdTextField.text.length > 12) {
        [BHToast showMessage:@"请输入6-12位正确密码"];
         sender.enabled = YES;
        return;
    }
    
    if (![self.pwdTextField.text isValidatePassword]) {
         [BHToast showMessage:@"密码格式有误，6-12位同时包含数字和字符 请重新输入"];
         sender.enabled = YES;
        return;
    }
    if (![self.confirmpwdTextField.text isValidatePassword]) {
        [BHToast showMessage:@"密码格式有误，6-12位同时包含数字和字符 请重新输入"];
         sender.enabled = YES;
        return;
    }
    
    if (![self.confirmpwdTextField.text isEqualToString:self.pwdTextField.text]) {
        [BHToast showMessage:@"两次输入的密码不相同 请重新输入密码"];
         sender.enabled = YES;
        return;
    }
    
    
    NSString *idString = [[IDFVTools getIDFV] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //接口调用
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if([self.phoneStr isEqualToString:@""]){
         [pramaDic setObject:self.emailStr forKey:@"loginUsername"];
    }else{
         [pramaDic setObject:self.phoneStr forKey:@"loginUsername"];
    }
    [pramaDic setObject:idString forKey:@"deviceId"];
    [pramaDic setObject:self.pwdTextField.text forKey:@"newPassword"];
    [pramaDic setObject:self.codeTextField.text forKey:@"code"];

    methodName = kNewInstallPassword;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NSLog(@"kupdatePassword-------->%@",responseObject);
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            [BHToast showMessage:@"登录密码设置成功"];
            [weakSelf performSelector:@selector(goBackparentVc) withObject:nil afterDelay:1];
        }else{
            sender.enabled = YES;
        }
    } failure:^(NSError *error) {
        sender.enabled = YES;
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

-(void)goBackparentVc{
    self.confirmpButton.enabled = YES;
    [self.delegate setWPwdSuccess];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UITextField *)codeTextField{
    if (_codeTextField == nil) {
        _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH/2, 59)];
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.textColor = BHHexColor(@"626A75");
        _codeTextField.font = UIFontRegularOfSize(14);
        _codeTextField.textAlignment = NSTextAlignmentLeft;
    }
    return _codeTextField;
}

-(UIButton *)messageButton{
    if (_messageButton == nil) {
        _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageButton.frame = CGRectMake(SCREEN_WIDTH - 84 -16, 16, 84, 28);
        [_messageButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _messageButton.backgroundColor = BHHexColor(@"308CDD");
        _messageButton.titleLabel.font = UIFontRegularOfSize(12);
        _messageButton.layer.masksToBounds = YES;
        _messageButton.layer.cornerRadius = 12;
        [_messageButton addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageButton;
}

-(UILabel *)phoneLabel{
    if (_phoneLabel == nil) {
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, self.codeTextField.bottom, SCREEN_WIDTH -32, 38)];
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
        if ([self.phoneStr isEqualToString:@""]) {
            NSArray *emailArray = [self.emailStr componentsSeparatedByString:@"@"];
            if (emailArray != nil && emailArray.count >0 ) {
                NSInteger length = [emailArray[0] length];
                NSString *emailStr = [NSString stringWithFormat:@"%@****%@@%@",[emailArray[0] substringToIndex:1],
                                      [emailArray[0] substringFromIndex:length - 1],emailArray[1]];
                _phoneLabel.text =  [NSString stringWithFormat:@"当前绑定的邮箱：%@",emailStr];
                
            }

        }else{
             _phoneLabel.text = [NSString stringWithFormat:@"当前绑定手机号：%@****%@",[self.phoneStr substringToIndex:4],[self.phoneStr substringFromIndex:7]];
        }
       
        _phoneLabel.textColor =  BHHexColor(@"626A75");
        _phoneLabel.font = UIFontRegularOfSize(12);
    }
    return _phoneLabel;
}

-(UITextField *)pwdTextField{
    if (_pwdTextField == nil) {
        _pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH-32, 50)];
        _pwdTextField.placeholder = @"设置登录密码";
        _pwdTextField.textColor = BHHexColor(@"626A75");
        _pwdTextField.font = UIFontRegularOfSize(14);
        _pwdTextField.textAlignment = NSTextAlignmentLeft;
    }
    return _pwdTextField;
}

-(UITextField *)confirmpwdTextField{
    if (_confirmpwdTextField == nil) {
        _confirmpwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, 50, SCREEN_WIDTH-32, 50)];
        _confirmpwdTextField.placeholder = @"确认登录密码";
        _confirmpwdTextField.textColor = BHHexColor(@"626A75");
        _confirmpwdTextField.font = UIFontRegularOfSize(14);
        _confirmpwdTextField.textAlignment = NSTextAlignmentLeft;
    }
    return _confirmpwdTextField;
}

-(CircularProgressBar *)circularBar{
    if (_circularBar == nil) {
        _circularBar = [[CircularProgressBar alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 84 -16 + 42, 12, 35, 35)];
        
        _circularBar.delegate = self;
        _circularBar.hidden = YES;
    }
    return _circularBar;
}

-(UIButton *)confirmpButton{
    if (_confirmpButton == nil) {
        _confirmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmpButton.frame = CGRectMake(16, SCALE_W(245), SCREEN_WIDTH - 32, 40);
        _confirmpButton.layer.masksToBounds = YES;
        _confirmpButton.layer.cornerRadius =  4;
        [_confirmpButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmpButton.backgroundColor = BHHexColor(@"308CDD");
        [_confirmpButton addTarget:self action:@selector(changePasswordSubmit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmpButton;
}
@end
