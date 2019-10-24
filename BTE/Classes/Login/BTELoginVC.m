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
#import "IDFVTools.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import <VerifyCode/NTESVerifyCodeManager.h>
typedef NS_ENUM(NSInteger, LoginType) {
    LoginCodeType = 0, //验证码登录
    LoginAccountType,   //密码登录
    LoginResetpwdType,     //更新新密码登录
};

typedef NS_ENUM(NSInteger, PageType) {
    PageType1 = 0, //手机号下一步页
    PageType2,   //密码登录页
    PageType3,     //更新新密码登录
    PageType4,//免密码登录页
};

@interface BTELoginVC ()<CircularProgressDelegate,UITextFieldDelegate,NTESVerifyCodeManagerDelegate>
{
    NSString *_account;//账号
    NSString *_forgetValue;//1 忘记密码点击 0新用户
    
    
    
    NSString * sendaccount;
}
/**
 旧版登录方式
 */
@property (nonatomic, assign) LoginType loginType;
/**
 新版登录方式
 */
@property (nonatomic, assign) PageType pageType;
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
 邀请码Label
 */
@property (weak, nonatomic) IBOutlet UILabel *invteCodeLabel;
/**
 邀请码输入框
 */
@property (weak, nonatomic) IBOutlet BHTextField *invteCodeTextField;

@property (weak,nonatomic)  IBOutlet UIView *invteCodeLineView;
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
@property (weak, nonatomic) IBOutlet UILabel *adLabel;//广告文案label
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
//改版新增
@property (nonatomic, strong) UIButton *fogerButton;//忘记密码
@property (nonatomic, strong) UILabel *accountLabel;//手机号 网址
@property (weak, nonatomic) IBOutlet UIView *codeViewBg;
@property (weak, nonatomic) IBOutlet UIView *accountViewBg;

@property (nonatomic, strong) UIButton *passwordButton;//密码登录眼睛视图
@property (nonatomic, strong) UIButton *modefiyPasswordButton;//修改密码页眼睛视图

@property (nonatomic, strong) NTESVerifyCodeManager *manager;
@end

@implementation BTELoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    self.title = @"登录";
//    [self customtitleView];
    self.sendCodeBtn.titleLabel.font =  UIFontRegularOfSize(SCALE_W(12));
    self.invteCodeLabel.font = UIFontRegularOfSize(SCALE_W(12));
    self.invteCodeLabel.textColor = BHHexColorAlpha(@"626A75", 0.5);
    self.invteCodeTextField.layer.borderWidth = 0;
    self.invteCodeTextField.layer.borderColor = [UIColor clearColor].CGColor;
    self.invteCodeTextField.font = UIFontRegularOfSize(14);
    self.invteCodeTextField.textColor = BHHexColor(@"626A75");

    self.navigationItem.leftBarButtonItem = [self createLeftBarItem];
    [self changeSendCodeEnabled:NO];
    self.circularBar.delegate = self;
    [self inintLoginAction];
#pragma mark -键盘弹出添加监听事件
    // 键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    // 键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 登录
- (IBAction)loginAction:(BHGradientButton *)sender {
    [self.view endEditing:YES];
    //判断页面类型
    if (self.pageType == PageType1) {//下一步
        //判断正则
        //字条串是否包含有某字符串
        NSString * account = self.accountTextField.text.trimString;
        if ([account rangeOfString:@"@"].location == NSNotFound) {
            NSLog(@"string 不存在 @");
            if (!account.isValidateMobile) {
                [BHToast showMessage:@"账号有误，请重新输入"];
                return;
            }
        } else {
            NSLog(@"string 包含 @");
            if (!account.isValidateEmail) {
                [BHToast showMessage:@"账号有误，请重新输入"];
                return;
            }
        }
        //接口调用
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        NSString * methodName = @"";
        [pramaDic setObject:self.accountTextField.text forKey:@"loginUsername"];

        methodName = kNewOldUserPassword;

        WS(weakSelf)
        NMShowLoadIng;
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
            NMRemovLoadIng;
            if (IsSafeDictionary(responseObject)) {
                _account = account;
                if ([[[responseObject objectForKey:@"data"] objectForKey:@"result"] integerValue] == 1) {
                    //跳转密码登录界面
                    weakSelf.pageType = PageType2;
                    [weakSelf refreshUIWithPageType:PageType2];
                } else
                {
                    //设置新密码登录界面
                    weakSelf.pageType = PageType3;
                    [weakSelf refreshUIWithPageType:PageType3];
                }
            }
        } failure:^(NSError *error) {
            NMRemovLoadIng;
            RequestError(error);
            NSLog(@"error-------->%@",error);
        }];
    } else if (self.pageType == PageType2)
    {
        if (self.accountTextField.text.length < 6) {
            [BHToast showMessage:@"请输入6-12位正确密码"];
            return;
        }
//        if (![self.accountTextField.text isValidatePassword]) {
//            [BHToast showMessage:@"密码格式有误，请重新输入"];
//            return;
//        }
        NSString *idString = [[IDFVTools getIDFV] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        //接口调用
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        NSString * methodName = @"";
        [pramaDic setObject:_account forKey:@"loginUsername"];
        [pramaDic setObject:idString forKey:@"deviceId"];
        [pramaDic setObject:self.accountTextField.text forKey:@"pwd"];
        methodName = kPwdLogin;
        
        WS(weakSelf)
        NMShowLoadIng;
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
            NMRemovLoadIng;
            if (IsSafeDictionary(responseObject)) {
                //登录成功记录手机号
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:_account forKey:MobilePhoneNum];
                [defaults synchronize];
                [weakSelf succsess:responseObject];
            }
        } failure:^(NSError *error) {
            NMRemovLoadIng;
            RequestError(error);
            NSLog(@"error-------->%@",error);
        }];
    } else if (self.pageType == PageType3)
    {
        if (self.codeTextField.text.length < 6) {
            [BHToast showMessage:@"请输入6-12位正确密码"];
            return;
        }
        if (self.accountTextField.text.length < 4) {
            [BHToast showMessage:@"请输入6位验证码"];
            return;
        }
        if (![self.codeTextField.text isValidatePassword]) {
            [BHToast showMessage:@"密码格式有误，请重新输入"];
            return;
        }
        
        NSString *idString = [[IDFVTools getIDFV] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        //接口调用
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        NSString * methodName = @"";
        [pramaDic setObject:_account forKey:@"loginUsername"];
        [pramaDic setObject:idString forKey:@"deviceId"];
        [pramaDic setObject:self.codeTextField.text forKey:@"newPassword"];
        [pramaDic setObject:self.accountTextField.text forKey:@"code"];
        methodName = kNewInstallPassword;
        
        WS(weakSelf)
        NMShowLoadIng;
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
            NMRemovLoadIng;
            if (IsSafeDictionary(responseObject)) {
                //登录成功记录手机号
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:_account forKey:MobilePhoneNum];
                [defaults synchronize];
                [weakSelf succsess:responseObject];
            }
        } failure:^(NSError *error) {
            NMRemovLoadIng;
            RequestError(error);
            NSLog(@"error-------->%@",error);
        }];
    } else if (self.pageType == PageType4)
    {
        if (!self.accountTextField.text.isValidateMobile) {
            [BHToast showMessage:@"手机号有误，请重新输入"];
            return;
        }
        if (self.codeTextField.text.length < 4) {
            [BHToast showMessage:@"请输入正确的验证码"];
            return;
        }
        NSString *idString = [[IDFVTools getIDFV] stringByReplacingOccurrencesOfString:@"-" withString:@""];

        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        NSString * methodName = @"";
        [pramaDic setObject:self.accountTextField.text forKey:@"loginUsername"];
        [pramaDic setObject:idString forKey:@"deviceId"];
        [pramaDic setObject:self.codeTextField.text forKey:@"code"];
        NSString *inviteCodeStr = self.invteCodeTextField.text;
        
        if(inviteCodeStr && inviteCodeStr.length >0){
            [pramaDic setObject:inviteCodeStr forKey:@"inviteCode"];
        }
        methodName = kCodeLogin;
        NSString * account = self.accountTextField.text.trimString;
        WS(weakSelf)
        NMShowLoadIng;
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
            NMRemovLoadIng;
            //登录成功记录手机号
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:account forKey:MobilePhoneNum];
            [defaults synchronize];
            [weakSelf succsess:responseObject];
        } failure:^(NSError *error) {
            NMRemovLoadIng;
            RequestError(error);
        }];
    }
}

- (void)getUserInfo{
    //接口调用
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
        [pramaDic setObject:User.userToken forKey:@"token"];
    }
    
    methodName = kGetUserInfo;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            NSDictionary * data = [responseObject objectForKey:@"data"];
            if (data) {
                
                BOOL isFutureDogUser= [[data objectForKey:@"isFutureDogUser"] boolValue];
                NSInteger point = [[data objectForKey:@"point"] integerValue];
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setBool:isFutureDogUser forKey:KisFutureDogUser];
                [defaults setInteger:point forKey:KisFutureDogUserGoal];
                [defaults synchronize];
                User.isFutureDogUser = isFutureDogUser;
                User.futureDogGoal = point;
                
            }
            
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

#pragma mark - 页面UI统一处理
- (void)refreshUIWithPageType:(PageType)pageType
{
    if (pageType == PageType1) {
        self.invteCodeLabel.hidden = YES;
        self.invteCodeTextField.hidden = YES;
        self.invteCodeLineView.hidden = YES;
        self.title = @"比特易";
        self.loginType = 1;
        self.accountTextField.keyboardType = UIKeyboardTypeDefault;
        self.accountTextField.secureTextEntry = NO;
        if (_fogerButton == nil) {
            _fogerButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _fogerButton.frame = CGRectMake(SCREEN_WIDTH - 50 -45, self.accountViewBg.bottom + 12, 50, 20);
            [_fogerButton setTitle:@"忘记密码" forState:UIControlStateNormal];
            [_fogerButton setTitleColor:BHHexColor(@"308CDD") forState:UIControlStateNormal];
            [_fogerButton addTarget:self action:@selector(fogerButtonTap) forControlEvents:UIControlEventTouchUpInside];
            _fogerButton.titleLabel.font = UIFontRegularOfSize(12);
            [self.view addSubview:_fogerButton];
        }
        _fogerButton.hidden = YES;
        _passwordButton.hidden = YES;
        self.accountTextField.lengthLimit = 100;
        [self.changeLoginBtn setTitle:@"免密码登录" forState:UIControlStateNormal];
        [self.loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
        self.protocolBtn.hidden = YES;
        self.codeViewBg.hidden = YES;
        self.changeLoginBtn.hidden = NO;
        _accountLabel.hidden = YES;
        self.accountTextField.placeholder = @"请输入手机号码/邮箱";
        [self changeLoginTypeStatus];
        [self changeLoginEnabled:NO];
    } else if (pageType == PageType2)
    {
        self.invteCodeLabel.hidden = YES;
        self.invteCodeTextField.hidden = YES;
        self.invteCodeLineView.hidden = YES;
        self.title = @"登录密码";
        self.accountTextField.lengthLimit = 100;
        self.accountTextField.keyboardType = UIKeyboardTypeDefault;
        self.accountTextField.secureTextEntry = YES;
        if (_accountLabel == nil) {
            _accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 156, SCREEN_WIDTH, 17)];
            _accountLabel.font = UIFontRegularOfSize(14);
            _accountLabel.textColor = BHHexColor(@"308CDD");
            _accountLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:_accountLabel];
        }
        if ([_account rangeOfString:@"@"].location == NSNotFound) {
            NSLog(@"string 不存在 @");
            _accountLabel.text = [NSString stringWithFormat:@"%@****%@",[_account substringWithRange:NSMakeRange(0,3)],[_account substringWithRange:NSMakeRange(_account.length - 4,4)]];
        } else {
            NSLog(@"string 包含 @ location = %ld",[_account rangeOfString:@"@"].location);
            _accountLabel.text = [NSString stringWithFormat:@"%@****%@",[_account substringWithRange:NSMakeRange(0,1)],[_account substringWithRange:NSMakeRange([_account rangeOfString:@"@"].location - 1,_account.length - [_account rangeOfString:@"@"].location + 1)]];
        }
        _accountLabel.hidden = NO;
        if (_passwordButton == nil) {
            _passwordButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _passwordButton.frame = CGRectMake(self.accountViewBg.right - 30, self.accountViewBg.top + 10, 20, 20);
            [_passwordButton setImage:[UIImage imageNamed:@"eyes_closed"] forState:UIControlStateNormal];
            [_passwordButton addTarget:self action:@selector(passwordButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_passwordButton];
        }
        _passwordButton.hidden = NO;
        self.accountTextField.clearButtonMode = UITextFieldViewModeNever;
        self.accountTextField.text = @"";
        self.accountTextField.placeholder = @"请输入登录密码";
        _fogerButton.hidden = NO;
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        //置灰登录按钮
        [self changeLoginEnabled:NO];
        self.changeLoginBtn.hidden = YES;
    } else if (pageType == PageType3)
    {
        self.invteCodeLabel.hidden = YES;
        self.invteCodeTextField.hidden = YES;
        self.invteCodeLineView.hidden = YES;
        self.title = @"设置密码";
        self.accountTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.codeTextField.keyboardType = UIKeyboardTypeDefault;
        self.changeLoginBtn.hidden = YES;
        self.codeTextField.lengthLimit = 12;
        self.accountTextField.lengthLimit = 6;
        self.accountTextField.secureTextEntry = NO;
        self.codeTextField.secureTextEntry = YES;
        
        if (_accountLabel == nil) {
            _accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 156, SCREEN_WIDTH, 17)];
            _accountLabel.font = UIFontRegularOfSize(14);
            _accountLabel.textColor = BHHexColor(@"308CDD");
            _accountLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:_accountLabel];
        }
        if ([_account rangeOfString:@"@"].location == NSNotFound) {
            NSLog(@"string 不存在 @");
            _accountLabel.text = [NSString stringWithFormat:@"%@****%@",[_account substringWithRange:NSMakeRange(0,3)],[_account substringWithRange:NSMakeRange(_account.length - 4,4)]];
        } else {
            NSLog(@"string 包含 @ location = %ld",[_account rangeOfString:@"@"].location);
            _accountLabel.text = [NSString stringWithFormat:@"%@****%@",[_account substringWithRange:NSMakeRange(0,1)],[_account substringWithRange:NSMakeRange([_account rangeOfString:@"@"].location - 1,_account.length - [_account rangeOfString:@"@"].location + 1)]];
        }
        _accountLabel.hidden = NO;
        [self.loginBtn setTitle:@"确定" forState:UIControlStateNormal];
        self.codeViewBg.hidden = NO;
        if ([_forgetValue isEqualToString:@"1"]) {
            self.protocolBtn.hidden = YES;
            _forgetValue = @"0";
        } else
        {
            self.protocolBtn.hidden = NO;
        }
        self.passwordButton.hidden = YES;
        self.fogerButton.hidden = YES;
        [self changeLoginEnabled:NO];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"点击确定即表示同意《比特易用户使用协议》"];
        NSRange range = [@"点击确定即表示同意《比特易用户使用协议》" rangeOfString:@"《比特易用户使用协议》"];
        [attributedString addAttribute:NSFontAttributeName value:UIFontRegularOfSize(12) range:NSMakeRange(0, 9)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:BHHexColorAlpha(@"525866", 0.6) range:NSMakeRange(0, 9)];
        [attributedString addAttribute:NSFontAttributeName value:UIFontRegularOfSize(12) range:range];
        [attributedString addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"626A75") range:range];
        
        [self.protocolBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
        self.accountTextField.text = @"";
        self.accountTextField.placeholder = @"请输入验证码";
        self.codeTextField.placeholder = @"请设置新密码(6-12位字母和数字组合)";
        self.codeTextField.secureTextEntry = YES;
        self.circularBar.hidden = YES;
        self.sendCodeBtn.hidden = NO;
        self.accountWidthContrstraint.constant = 0;
        [self changeSendCodeEnabled:YES];
        
        if (_modefiyPasswordButton == nil) {
            _modefiyPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _modefiyPasswordButton.frame = CGRectMake(self.codeViewBg.right - 70, 10, 20, 20);
            [_modefiyPasswordButton setImage:[UIImage imageNamed:@"eyes_closed"] forState:UIControlStateNormal];
            [_modefiyPasswordButton addTarget:self action:@selector(modefiyPasswordButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            [self.codeViewBg addSubview:_modefiyPasswordButton];
        }
        _modefiyPasswordButton.hidden = NO;
        self.codeTextField.clearButtonMode = UITextFieldViewModeNever;
    } else if (pageType == PageType4)
    {
        self.invteCodeLabel.hidden = NO;
        self.invteCodeTextField.hidden = NO;
        self.invteCodeLineView.hidden = NO;
        self.title = @"比特易";
        self.loginType = 0;
        self.accountTextField.clearButtonMode = UITextFieldViewModeNever;
        self.accountTextField.secureTextEntry = NO;
        self.accountTextField.secureTextEntry = NO;
        self.accountTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.codeTextField.clearButtonMode = UITextFieldViewModeNever;
        self.codeTextField.lengthLimit = 6;
        self.accountTextField.lengthLimit = 11;
        [self.changeLoginBtn setTitle:@"账号密码登录" forState:UIControlStateNormal];
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        self.codeViewBg.hidden = NO;
        self.protocolBtn.hidden = NO;
        self.accountTextField.placeholder = @"请输入手机号码";
        _modefiyPasswordButton.hidden = YES;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"点击登录即表示同意《比特易用户使用协议》"];
        NSRange range = [@"点击登录即表示同意《比特易用户使用协议》" rangeOfString:@"《比特易用户使用协议》"];
        [attributedString addAttribute:NSFontAttributeName value:UIFontRegularOfSize(12) range:NSMakeRange(0, 9)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:BHHexColorAlpha(@"525866", 0.6) range:NSMakeRange(0, 9)];
        [attributedString addAttribute:NSFontAttributeName value:UIFontRegularOfSize(12) range:range];
        [attributedString addAttribute:NSForegroundColorAttributeName value:BHHexColor(@"626A75") range:range];
        
        [self.protocolBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
        
        
        [self changeLoginTypeStatus];
        [self changeLoginEnabled:NO];
        //修改placeholder大小颜色
        [self.codeTextField setValue:BHHexColorAlpha(@"626A75", 0.5) forKeyPath:@"_placeholderLabel.textColor"];
        [self.codeTextField setValue:UIFontRegularOfSize(14) forKeyPath:@"_placeholderLabel.font"];
        [self.accountTextField setValue:BHHexColorAlpha(@"626A75", 0.5) forKeyPath:@"_placeholderLabel.textColor"];
        [self.accountTextField setValue:UIFontRegularOfSize(14) forKeyPath:@"_placeholderLabel.font"];
    }
}

#pragma mark - 登录成功
- (void)loginSuccess:(id)responseObject {
    if (self.loginType == LoginCodeType) {
        [self succsess:responseObject];
    }else if (self.loginType == LoginAccountType) {
        NSString * reset = responseObject[@"data"][@"reset"];
        //reset 1 需要重置密码 0 通过
        if (reset.integerValue == 0) {
            [self succsess:responseObject];
        }else {
            //设置新密码界面 其实已经登录成功 但是需要在此处保存token 因为设置新密码没有返回token
            self.loginType = LoginResetpwdType;
            [self setResetpwdType];
            BTEUserInfo * yy = [BTEUserInfo yy_modelWithDictionary:responseObject];
            yy.userToken = responseObject[@"data"][@"token"];
            [yy save];
        }
    }else {
        //更新密码成功 返回首页
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationReSetPassword object:nil];
        
        //设置新密码成功 页面dissmiss
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUserLoginSuccess object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)succsess:(id)responseObject {
//    NSSet *set;
//    set = [NSSet setWithObjects:kGlobal,kindexDogPush,kSso,nil];
//    [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//        NSLog(@"isrescode=%ld",iResCode);
//        [JPUSHService getAllTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//            NSLog(@"login------getAllTags-isrescode=%ld",iResCode);
//            NSLog(@"login------getAllTags-iTags=%@",iTags);
//            NSLog(@"login------getAllTags-seq=%ld",seq);
//        } seq:1];
//    } seq:1];
    NSString *idString = [[IDFVTools getIDFV] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [JPUSHService setAlias:idString completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"isrescode=%ld",iResCode);
    } seq:1];
    
    BTEUserInfo * yy = [BTEUserInfo yy_modelWithDictionary:responseObject];
    [yy save];
    if (self.loginCompletion) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate setHuaXinLogin];
        self.loginCompletion(YES);
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUserLoginSuccess object:nil];
     [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUpdateUserLoginStatus object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
//    self.tabBarController.selectedIndex=self.tabBarController.selectedIndex;
//    [self.tabBarController setSelectedIndex:0];
//     NSLog(@"selectedIndex=%ld",self.tabBarController.selectedIndex);
    [self getUserInfo];
}
#pragma mark - 切换登录方式
- (IBAction)changeLoginAction:(UIButton *)sender {
    //1 密码登录  0 验证码登录 免密码登录
    sender.selected = !sender.selected;
    self.loginType = sender.isSelected;

    if (self.loginType == LoginCodeType) {
        self.pageType = PageType1;
        [self refreshUIWithPageType:PageType1];
        
    } else
    {
        self.pageType = PageType4;
        [self refreshUIWithPageType:PageType4];
    }
}
#pragma mark - 初始化
-(void)inintLoginAction
{
    self.pageType = PageType4;
    [self refreshUIWithPageType:PageType4];
}

#pragma mark - 忘记密码
- (void)fogerButtonTap {
    _forgetValue = @"1";
    self.pageType = PageType3;
    [self refreshUIWithPageType:PageType3];
}

#pragma mark - 密码显示状态
- (void)passwordButtonTap:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_passwordButton setImage:[UIImage imageNamed:@"eyes_open"] forState:UIControlStateNormal];
        self.accountTextField.secureTextEntry = NO;
    } else
    {
        [_passwordButton setImage:[UIImage imageNamed:@"eyes_closed"] forState:UIControlStateNormal];
        self.accountTextField.secureTextEntry = YES;
    }
    
}

- (void)modefiyPasswordButtonTap:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_modefiyPasswordButton setImage:[UIImage imageNamed:@"eyes_open"] forState:UIControlStateNormal];
        self.codeTextField.secureTextEntry = NO;
    } else
    {
        [_modefiyPasswordButton setImage:[UIImage imageNamed:@"eyes_closed"] forState:UIControlStateNormal];
        self.codeTextField.secureTextEntry = YES;
    }
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
    self.codeTextField.placeholder = self.loginType ? @"请输入密码" : @"请输入短信验证码";
    self.accountWidthContrstraint.constant = self.loginType == LoginCodeType ? 0 : -72;
}
- (void)setResetpwdType {
    if (self.loginType == LoginResetpwdType) {
        self.navigationItem.leftBarButtonItem = nil;
        self.accountTextField.placeholder = @"请设置新密码（6-12位字母和数字组合）";
        self.codeTextField.placeholder = @"请确定新密码";
        self.accountTextField.text = self.codeTextField.text =  @"";
        self.accountTextField.secureTextEntry = self.codeTextField.secureTextEntry = YES;
        self.changeLoginBtn.hidden = YES;
        self.protocolBtn.hidden = YES;
        [self.loginBtn setTitle:@"确定" forState:UIControlStateNormal];
        self.accountWidthContrstraint.constant = -72;
        self.resetPwdLabel.hidden = NO;
        self.adLabel.hidden = YES;
        //置灰登录按钮
        [self changeLoginEnabled:NO];
        if ([self.accountTextField canBecomeFirstResponder]) {
            [self.accountTextField becomeFirstResponder];
        }
    }
}
#pragma mark - 发送验证码
- (IBAction)sendCodeAction:(UIButton *)sender {
    if (self.pageType == PageType4) {//免密登录页
        sendaccount = self.accountTextField.text.trimString;
        if (!sendaccount.isValidateMobile) {
            [BHToast showMessage:@"手机号有误，请重新输入"];
            return;
        }
    } else if(self.pageType == PageType3)//设置新密码登录
    {
        if ([_accountLabel.text isEqualToString:@""]) {
            return;
        } else
        {
            sendaccount = _account;
        }
    }
    [self.view endEditing:YES];
    [self.manager openVerifyCodeView:nil];
}

#pragma mark - 点击协议
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
    
    if ([string isEqualToString:@" "]) {
        return NO;
        
    }
    
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
        return NO;
    }
    
    if (![string isEqualToString:@""]) {
        BOOL flag=[NSString isContainsTwoEmoji:string];
        if (flag) {
            return NO;
        }
    }
    
    
    
    if (self.pageType == PageType1) {
        if ([textField isEqual:self.accountTextField]){
            if ([string isEqualToString:@""] && textField.text.length == 1) {
                [self changeLoginEnabled:NO];
            }
            else
            {
                [self changeLoginEnabled:YES];
            }
        }
    } else if (self.pageType == PageType2)
    {
        if ([textField isEqual:self.accountTextField]){
            if ([string isEqualToString:@""] && textField.text.length == 1) {
                [self changeLoginEnabled:NO];
            }
            else
            {
                [self changeLoginEnabled:YES];
            }
        }
    } else if (self.pageType == PageType3)
    {
        //账号
        if ([textField isEqual:self.accountTextField]){
            account = beString;
            code = self.codeTextField.text;
        }//密码
        else if ([textField isEqual:self.codeTextField]) {
            account = self.accountTextField.text;
            code = beString;
        }
        if (account.length > 0 && code.length > 0) {
            [self changeLoginEnabled:YES];
        } else
        {
            [self changeLoginEnabled:NO];
        }
    } else if (self.pageType == PageType4)
    {
        
        //账号
        if ([textField isEqual:self.accountTextField]){
            if (self.accountTextField.text.length == 11 && ![string isEqualToString:@""]) {
                return NO;
            }
            account = beString;
            code = self.codeTextField.text;
        }//密码
        else if ([textField isEqual:self.codeTextField]) {
            account = self.accountTextField.text;
            code = beString;
        }
        //改变发送验证按钮颜色
        [self changeSendCodeEnabled:account.length == 11];
        if (self.loginType != LoginResetpwdType) {
            if (account.length == 11 &&
                (self.loginType ? code.length > 0 : code.length > 0)) {
                if (!self.loginBtn.userInteractionEnabled) {
                    [self changeLoginEnabled:YES];
                }
            }else {
                if (self.loginBtn.userInteractionEnabled) {
                    [self changeLoginEnabled:NO];
                }
            }
        }else {
            //密码校验 密码确认都大于0的时候再亮起
            if (account.length > 0 && code.length > 0) {
                [self changeLoginEnabled:YES];
            }else {
                [self changeLoginEnabled:NO];
            }
        }
    }

    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
//    [self checkButtonStatus:textField];
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField {
//    [self changeLoginEnabled:NO];
//    if (self.loginType == LoginCodeType && [textField isEqual:self.accountTextField]){
//        [self changeSendCodeEnabled:NO];
//    }
    return YES;
}
- (void)checkButtonStatus:(UITextField *)textField {
    NSString * account,*code;
    //账号
    if ([textField isEqual:self.accountTextField]){
        account = textField.text;
        code = self.codeTextField.text;
    }
    //密码 验证码
    else if ([textField isEqual:self.codeTextField]) {
        //验证码最多6位
        account = self.accountTextField.text;
        code = textField.text;
    }
    //改变发送验证按钮颜色
    [self changeSendCodeEnabled:account.length == 11];
    if (self.loginType != LoginResetpwdType) {
        if (account.length == 11 &&
            (self.loginType ? code.length > 0 : code.length > 0)) {
            [self changeLoginEnabled:YES];
        }else {
            [self changeLoginEnabled:NO];
        }
    }else {
        //密码校验 密码确认都大于0的时候再亮起
        if (account.length > 0 && code.length > 0) {
            [self changeLoginEnabled:YES];
        }else {
            [self changeLoginEnabled:NO];
        }
    }
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
    [viewController presentViewController:nav animated:NO completion:nil];
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
    
    if (self.pageType == PageType1) {
        if (self.loginCompletion) {
            self.loginCompletion(NO);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (self.pageType == PageType2)
    {
        self.pageType = PageType1;
        [self refreshUIWithPageType:PageType1];
    } else if (self.pageType == PageType3)
    {
        self.pageType = PageType1;
        [self refreshUIWithPageType:PageType1];
    } else if (self.pageType == PageType4)
    {
        if (self.loginCompletion) {
            self.loginCompletion(NO);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPhone"]) {
        
    } else
    {
        self.bottomImageView.hidden = YES;
    }
    //光标颜色
    self.accountTextField.tintColor= BHHexColor(@"308CDD");
    self.codeTextField.tintColor= BHHexColor(@"308CDD");
}

#pragma mark -键盘监听方法
- (void)keyboardWasShown:(NSNotification *)notification
{
    // 获取键盘的高度
    //    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"-------初始位置%f",self.view.top);
    [UIView animateWithDuration:0.0 animations:^{
        self.view.top = -30;
    }];
}
- (void)keyboardWillBeHiden:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.top = NAVIGATION_HEIGHT;
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - NTESVerifyCodeManagerDelegate
/**
 * 验证码组件初始化完成
 */
- (void)verifyCodeInitFinish{
    NSLog(@"收到初始化完成的回调");
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
    [pramaDic setObject:sendaccount forKey:@"loginUsername"];
    WS(weakSelf)
//    NMShowLoadIng;
    [BTERequestTools requestWithURLString:kMessageAuth parameters:pramaDic type:2 success:^(id responseObject) {
//        NMRemovLoadIng;
        NSLog(@"-----responseObject--->%@",responseObject);
        if (IsSafeDictionary(responseObject)) {
            [BHToast showMessage:@"验证码已发送"];
            [weakSelf circleProgressStart];
        }
    } failure:^(NSError *error)  {
//        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}
@end
