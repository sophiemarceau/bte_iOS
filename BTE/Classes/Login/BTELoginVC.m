//
//  BHLoginVC.m
//  BTE
//
//  Created by 张竟巍 on 2018/2/27.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTELoginVC.h"
#import "BHGradientButton.h"
#import "CircularProgressBar.h"
#import "BHBaseWebVC.h"


typedef NS_ENUM(NSInteger, LoginType) {
    LoginCodeType = 0, //验证码登录
    LoginAccountType,   //密码登录
    LoginResetpwdType,     //更新新密码登录
};

@interface BTELoginVC ()<CircularProgressDelegate,UITextFieldDelegate>
/**
 登录方式
 */
@property (nonatomic, assign) LoginType loginType;
/**
 完成回调
 */
@property(nonatomic,copy) BHLoginCompletion loginCompletion;
/**
 账号输入框
 */
@property (weak, nonatomic) IBOutlet BHTextField *accountTextField;
/**
 验证码发送
 */
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
/**
 倒计时圈
 */
@property (weak, nonatomic) IBOutlet CircularProgressBar *circularBar;
/**
 验证码输入框
 */
@property (weak, nonatomic) IBOutlet BHTextField *codeTextField;
/**
 登录按钮
 */
@property (weak, nonatomic) IBOutlet BHGradientButton *loginBtn;
/**
 更换登录方式 按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *changeLoginBtn;
/**
 是否正在验证码获取中
 */
@property (nonatomic, assign) BOOL isCountDown;
/**
 协议按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
/**
 账号输入框宽度约束  0 可显示发送验证码 -72 顶在最右端
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountWidthContrstraint;
/**
 提醒重置密码文案
 */
@property (weak, nonatomic) IBOutlet UILabel *resetPwdLabel;

@end

@implementation BTELoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customtitleView];
    self.navigationItem.leftBarButtonItem = [self createLeftBarItem];
    [self changeSendCodeEnabled:NO];
    self.circularBar.delegate = self;

}

#pragma mark - 登录
- (IBAction)loginAction:(BHGradientButton *)sender {
    NSString * account = self.accountTextField.text.trimString;
    NSString * code = self.codeTextField.text.trimString;
    if (self.loginType != LoginResetpwdType) {
        if (!account.isValidateMobile) {
            [BHToast showMessage:@"请输入正确的手机号!"];
            return;
        }
        if (self.loginType == LoginCodeType &&  code.length < 4) {
            [BHToast showMessage:@"请输入正确的验证码!"];
            return;
        }
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        NSString * methodName = @"";
        [pramaDic setObject:account forKey:@"mobile"];
        [pramaDic setObject:code forKey:self.loginType ? @"pwd" : @"code"];
        methodName = self.loginType ? kPwdLogin : kCodeLogin;
        
        WS(weakSelf)
        [self hudShow:self.view msg:@"请稍后"];
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
            [weakSelf hudClose];
            [weakSelf loginSuccess:responseObject];
        } failure:^(NSError *error) {
            [weakSelf hudClose];
            RequestError(error);
        }];
    }else {
        //更新密码
        if (account.length < 6 || account.length > 12 || code.length < 6 || account.length > 12) {
            [BHToast showMessage:@"请输入6-12位正确密码!"];
            return;
        }
        if (![account isValidatePassword] || ![code isValidatePassword]) {
            [BHToast showMessage:@"请输入6-12位字母和数字组合密码!"];
            return;
        }
        if (![account isEqualToString:code]) {
            [BHToast showMessage:@"两次密码不一致!"];
            return;
        }
        WS(weakSelf)
        [self hudShow:self.view msg:@"请稍后"];
        [BTERequestTools requestWithURLString:kreSetPwd parameters:@{@"pwd1": account , @"pwd2" : code} type:2 success:^(id responseObject) {
            [weakSelf hudClose];
            [weakSelf loginSuccess:responseObject];
        } failure:^(NSError *error) {
            [weakSelf hudClose];
            RequestError(error);
        }];
    }
}
- (void)loginSuccess:(id)responseObject {
    if (self.loginType == LoginCodeType) {
        [self succsess:responseObject];
    }else if (self.loginType == LoginAccountType) {
        NSString * reset = responseObject[@"data"][@"reset"];
        //reset 1 需要重置密码 0 通过
        if (reset.integerValue == 0) {
            [self succsess:responseObject];
        }else {
            //设置新密码界面
            self.loginType = LoginResetpwdType;
            [self setResetpwdType];
        }
    }else {
        //更新密码成功
        [self succsess:responseObject];
    }
}
- (void)succsess:(id)responseObject {
    BTEUserInfo * yy = [BTEUserInfo yy_modelWithDictionary:responseObject];
    [yy save];
    if (self.loginCompletion) {
        self.loginCompletion();
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUserLoginSuccess object:nil];
    [self backAction:nil];
}
#pragma mark - 切换登录方式
- (IBAction)changeLoginAction:(UIButton *)sender {
    //1 密码登录  0 验证码登录
    sender.selected = !sender.selected;
    self.loginType = sender.isSelected;
    [self changeLoginTypeStatus];
    
}
- (void)changeLoginTypeStatus {
    if (self.loginType == LoginCodeType) {
        if (self.isCountDown) {
            //正在倒计时
            self.circularBar.hidden = NO;
            self.sendCodeBtn.hidden = YES;
        }else {
            self.circularBar.hidden = YES;
            self.sendCodeBtn.hidden = NO;
        }
    }else if (self.loginType ==LoginAccountType) {
        self.circularBar.hidden = YES;
        self.sendCodeBtn.hidden = YES;
    }
    self.codeTextField.text = @"";
    self.accountTextField.text = @"";
    self.codeTextField.secureTextEntry = self.loginType;
    self.codeTextField.lengthLimit = self.loginType ? 12 : 6;
    self.codeTextField.placeholder = self.loginType ? @"请输入密码" : @"请输入验证码";
    self.codeTextField.keyboardType = self.loginType ? UIKeyboardTypeDefault : UIKeyboardTypePhonePad;
    self.accountWidthContrstraint.constant = self.loginType == LoginCodeType ? 0 : -72;
    if ([self.accountTextField canBecomeFirstResponder]) {
        [self.accountTextField becomeFirstResponder];
    }
}
- (void)setResetpwdType {
    if (self.loginType == LoginResetpwdType) {
        self.accountTextField.placeholder = @"请设置新密码（6-12位字母和数字组合）";
        self.codeTextField.placeholder = @"请确定新密码";
        self.accountTextField.text = self.codeTextField.text =  @"";
        self.accountTextField.secureTextEntry = self.codeTextField.secureTextEntry = YES;
        self.accountTextField.lengthLimit = self.codeTextField.lengthLimit = 12;
        self.accountTextField.keyboardType = self.codeTextField.keyboardType = UIKeyboardTypeDefault;
        self.changeLoginBtn.hidden = YES;
        self.protocolBtn.hidden = YES;
        [self.loginBtn setTitle:@"确定" forState:UIControlStateNormal];
        self.accountWidthContrstraint.constant = -72;
        self.resetPwdLabel.hidden = NO;
        //置灰登录按钮
        [self changeLoginEnabled:NO];
        if ([self.accountTextField canBecomeFirstResponder]) {
            [self.accountTextField becomeFirstResponder];
        }
    }
}
#pragma mark - 发送验证码
- (IBAction)sendCodeAction:(UIButton *)sender {
    NSString * account = self.accountTextField.text.trimString;
    if (!account.isValidateMobile) {
        [BHToast showMessage:@"请输入正确的手机号!"];
        return;
    }
    WS(weakSelf)
    [self hudShow:self.view msg:@"请稍后"];
    [BTERequestTools requestWithURLString:kMessageAuth parameters:@{@"mobile":account} type:2 success:^(id responseObject) {
        [weakSelf hudClose];
        [BHToast showMessage:@"验证码已发送至手机"];
        [weakSelf circleProgressStart];
    } failure:^(NSError *error) {
        [weakSelf hudClose];
        RequestError(error);
    }];
}
//点击协议
- (IBAction)protocolAction:(UIButton *)sender {
    BHBaseWebVC * webVC = [BHBaseWebVC new];
    webVC.urlString = kAppBTEProtcol;
    webVC.title = @"用户协议";
    webVC.isHiddenLeft = NO;
    webVC.isHiddenBottom = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark - textField delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * beString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString * account,*code;
    //账号
    if ([textField isEqual:self.accountTextField]){
        if (beString.length > (self.loginType != LoginResetpwdType ? 11 : 12)) {
            return NO;
        }
        account = beString;
        code = self.codeTextField.text;
    }
    //密码 验证码
    else if ([textField isEqual:self.codeTextField]) {
        //验证码最多6位
        if (beString.length > (self.loginType != LoginCodeType ? 12 : 6)) {
            return NO;
        }
        account = self.accountTextField.text;
        code = beString;
    }
    //改变按钮颜色
    [self changeSendCodeEnabled:[account isValidateMobile]];
    if (self.loginType != LoginResetpwdType) {
        if ([account isValidateMobile] &&
            (self.loginType ? code.length >= 6 : code.length > 0)) {
            [self changeLoginEnabled:YES];
        }else {
            [self changeLoginEnabled:NO];
        }
    }else {
        //密码校验
        if (account.length >= 6 && code.length >= 6) {
            [self changeLoginEnabled:YES];
        }else {
            [self changeLoginEnabled:NO];
        }
    }
    
    return YES;
}
#pragma mark - 改变按钮颜色
- (void)changeLoginEnabled:(BOOL)enabled {
    self.loginBtn.userInteractionEnabled = enabled;
    enabled ? [self.loginBtn gradientColorSetter] : [self.loginBtn grayColorSetter];
    [self.loginBtn setTitleColor:enabled ? [UIColor whiteColor] : BHHexColor(@"93A0B5") forState:UIControlStateNormal];
}
- (void)changeSendCodeEnabled:(BOOL)enabled {
    self.sendCodeBtn.backgroundColor = enabled ? BHColorBlue : [UIColor whiteColor];
    [self.sendCodeBtn setTitleColor:enabled ? [UIColor whiteColor] : BHHexColor(@"93A0B5") forState:UIControlStateNormal];
    self.sendCodeBtn.userInteractionEnabled = enabled;
    self.sendCodeBtn.layer.borderWidth = enabled ? 0.f :.5f;
    self.sendCodeBtn.layer.borderColor = BHHexColor(@"CCD4DF").CGColor;
}


#pragma mark - other
//吊起登录
+(void) OpenLogin:(UIViewController *)viewController callback:(BHLoginCompletion) loginComplation {
    BTELoginVC *loginv = [[BTELoginVC alloc] init];
    if (loginComplation) {
        loginv.loginCompletion = loginComplation;
    }
    BHNavigationController *nav = [[BHNavigationController alloc]initWithRootViewController:loginv];;
    [viewController presentViewController:nav animated:YES completion:nil];
}
- (UIBarButtonItem *)createLeftBarItem{
    UIImage * image = [UIImage imageNamed:@"nav_back"];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateHighlighted];
    btn.bounds = CGRectMake(0, 0, 60, 40);
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, - btn.width + MIN(image.size.width, 14), 0, 0);
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}
//返回
-(void)backAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 进度条
// 开启圆形进度条
- (void)circleProgressStart {
    self.sendCodeBtn.hidden = YES;
    self.circularBar.hidden = NO;
    [self.circularBar setTotalSecondTime:60];
    [self.circularBar startTimer];
    self.isCountDown = YES;
}
- (void)CircularProgressEnd {
    self.sendCodeBtn.hidden = NO;
    self.circularBar.hidden = YES;
    self.isCountDown = NO;
    [self.sendCodeBtn wy_animate];
    [self.circularBar wy_animate];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
