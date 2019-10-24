//
//  AlertView.m
//  BTE
//
//  Created by sophie on 2018/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "AlertView.h"

@interface AlertView()<UITextFieldDelegate>{
    UIImageView *bgwhiteView;
    UIButton  *confirmBtn;
    UIButton  *cancelBtn;
    UITextField *nickNameTextFiled;
    NSString *nickNameStr;
    UILabel *nickLabel;
}
@end

@implementation AlertView

- (instancetype)initAlertView{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled  = YES;
        self.backgroundColor = kColorRgba(0, 0, 0, 0.5);
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        //        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShareView:)];
        //        [self addGestureRecognizer:tap1];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
        
        bgwhiteView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -SCALE_W(270))/2, SCALE_W(197) ,SCALE_W(270),SCALE_W(178))];
        bgwhiteView.layer.masksToBounds = YES;
        bgwhiteView.layer.cornerRadius = 12;
        bgwhiteView.backgroundColor = [UIColor whiteColor];
        bgwhiteView.userInteractionEnabled = YES;
        [self addSubview:bgwhiteView];
        
        nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, 48 , 20)];
        nickLabel.textAlignment = NSTextAlignmentCenter;
        nickLabel.font = UIFontRegularOfSize(14);
        nickLabel.textColor = [UIColor colorWithHexString:@"626A75"];
        nickLabel.text = @"昵称:";
        [bgwhiteView addSubview:nickLabel];
        
        nickNameTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(nickLabel.right, 40, SCALE_W(270)-nickLabel.right, 20)];
        nickNameTextFiled.borderStyle = UITextBorderStyleNone;
        nickNameTextFiled.clearButtonMode =UITextFieldViewModeWhileEditing;
        nickNameTextFiled.returnKeyType = UIReturnKeyDone;
        nickNameTextFiled.delegate = self;
        [nickNameTextFiled.subviews[0] removeFromSuperview];

        nickNameTextFiled.textAlignment = NSTextAlignmentLeft;
        nickNameTextFiled.font = UIFontRegularOfSize(14);
        nickNameTextFiled.placeholder = @"请输入您的昵称";
        nickNameTextFiled.textColor = BHHexColor(@"626A75");
        
        [bgwhiteView addSubview:nickNameTextFiled];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(16,71.5, SCALE_W(270) - 32, 1)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"E6EBF0"];
        [bgwhiteView addSubview:lineView];
        
        UILabel *attentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 80, SCALE_W(270) - 32 , 12)];
        attentionLabel.textAlignment = NSTextAlignmentRight;
        attentionLabel.font = UIFontRegularOfSize(12);
        attentionLabel.textColor = [UIColor colorWithHexString:@"626A75"];
        attentionLabel.text = @"不超过十个字符";
        attentionLabel.textColor = BHHexColorAlpha(@"626A75",0.5);
        [bgwhiteView addSubview:attentionLabel];
        
        confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(SCALE_W(270)/2 , bgwhiteView.frame.size.height - SCALE_W(44), SCALE_W(270)/2, SCALE_W(44));
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:BHHexColor(@"308CDD") forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgwhiteView addSubview:confirmBtn];
        
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0,bgwhiteView.frame.size.height - SCALE_W(44), SCALE_W(270)/2, SCALE_W(44));
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:BHHexColor(@"626A75") forState:UIControlStateNormal];
        [bgwhiteView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0,bgwhiteView.frame.size.height - SCALE_W(44)-1, SCALE_W(270), 0.5)];
        lineView1.backgroundColor = [UIColor colorWithHexString:@"E6EBF0"];
        [bgwhiteView addSubview:lineView1];
       
        UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(SCALE_W(270)/2,bgwhiteView.frame.size.height - SCALE_W(44), 1, 44)];
        verticalLine.backgroundColor = [UIColor colorWithHexString:@"E6EBF0"];
        [bgwhiteView addSubview:verticalLine];
    
        // 键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        // 键盘消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)confirmButtonOnClick:(UIButton *)sender{
    sender.enabled = NO;
    if (nickNameTextFiled.text.length == 0) {
        [BHToast showMessage:@"昵称不能为空"];
        sender.enabled = YES;
        return;
    }
    if (nickNameTextFiled.text.length > 10) {
        [BHToast showMessage:@"昵称字数不得超出10个字"];
        sender.enabled = YES;
        return;
    }
    if ([self stringContainsEmoji:nickNameTextFiled.text]) {
        [BHToast showMessage:@"昵称不得Emoji含有表情"];
        sender.enabled = YES;
        return;
    }
    WS(weakSelf)
    weakSelf.confirmCallBack(YES,nickNameTextFiled.text);
    [self dismissShareView];
}

-(void)cancelClick:(UIButton *)sender{
    if (self.confirmCallBack != nil) {
        self.confirmCallBack(NO,@"");
    }
    [self dismissShareView];
}

- (void)dismissShareView{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        CGRect blackFrame = [self frame];
        blackFrame.origin.y = SCREEN_HEIGHT;
        self.frame = blackFrame;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -键盘监听方法
- (void)keyboardWasShown:(NSNotification *)notification{
    [UIView animateWithDuration:0.2 animations:^{
        self.top = -100;
        
        
    }];
}
- (void)keyboardWillBeHiden:(NSNotification *)notification{
    [UIView animateWithDuration:0.3 animations:^{
        self.top = 0;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    return [textField resignFirstResponder];
}

//是否含有表情
-(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
@end
