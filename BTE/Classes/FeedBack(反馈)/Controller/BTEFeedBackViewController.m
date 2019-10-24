//
//  BTEFeedBackViewController.m
//  BTE
//
//  Created by wangli on 2018/5/8.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEFeedBackViewController.h"
static long Max_Count = 240;
@interface BTEFeedBackViewController ()<UITextViewDelegate>
{
    UIButton *cancelButton;
}
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *placholdLabel;
@end

@implementation BTEFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KBGColor;
    self.title = @"意见反馈";
    [self creatView];
    
}

- (void)creatView
{
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 60, 14)];
    label1.text = @"反馈内容";
    label1.textColor = BHHexColor(@"626A75");
    label1.font = UIFontRegularOfSize(14);
    [self.view addSubview:label1];
    
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, SCREEN_WIDTH, 154)];
    whiteView.backgroundColor = BHHexColor(@"fafafa");
    [self.view addSubview:whiteView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(16, 16, SCREEN_WIDTH - 32, 114 - 16)];
    _textView.font = UIFontRegularOfSize(14);
    _textView.textColor = BHHexColor(@"626A75");
    _textView.backgroundColor = BHHexColor(@"fafafa");
    _textView.delegate = self;
    _textView.text = @"";
    [whiteView addSubview:_textView];
    
    _placholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(3,11, 200, 14)];
    _placholdLabel.text = @"请输入不少于5个字的描述";
    _placholdLabel.alpha = 0.4;
    _placholdLabel.textColor = BHHexColor(@"626A75");
    _placholdLabel.font = UIFontRegularOfSize(14);
    [_textView addSubview:_placholdLabel];
    
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 - 16, _textView.bottom + 10, 60, 14)];
    _label2.text = @"0/240";
    _label2.textAlignment = NSTextAlignmentRight;
    _label2.textColor = BHHexColor(@"626A75");
    _label2.font = UIFontRegularOfSize(14);
    [whiteView addSubview:_label2];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(16, whiteView.bottom + 26, SCREEN_WIDTH - 32, 40);
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = 4;
    [cancelButton setTitle:@"提交意见" forState:UIControlStateNormal];
    cancelButton.backgroundColor = BHHexColor(@"E1E5EA");
    [cancelButton setTitleColor:BHHexColor(@"93A0B5") forState:UIControlStateNormal];
    cancelButton.enabled = NO;
    [cancelButton addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
}

- (void)cancelButton
{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    [pramaDic setObject:_textView.text forKey:@"content"];
    methodName = kGetUserFeedback;
    
    WS(weakSelf)
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            [BHToast showMessage:@"提交成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        RequestError(error);
        NSLog(@"error-------->%@",error);
    }];
}

#pragma delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView isFirstResponder]) {
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
            return NO;
        }
    }
    
    if (![text isEqualToString:@""]) {
//        NSString *regex = @"[`~!@#$%^&*()+=|{}':;',\\\\[\\\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？^a-zA-Z0-9\\u4E00-\\u9FA5_]";
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//        BOOL isValid = [predicate evaluateWithObject:text];
//        if (isValid) {
//        } else
//        {
//            return NO;
//        }
        BOOL flag=[NSString isContainsTwoEmoji:text];
        if (flag) {
            return NO;
        }
    }
    
    if ([text isEqualToString:@" "]) {
        return NO;
        
    }
    
    if ([textView.text isEqualToString:@"\n"]) {
        return NO;
    }
    if (textView.text.length >= Max_Count && ![text isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    _label2.text = [NSString stringWithFormat:@"%ld/240",textView.text.length];
    
    if (textView.text.length <= 0) {
        _placholdLabel.hidden = NO;
    } else {
        _placholdLabel.hidden = YES;
    }
    
    if (textView.text.length >= 5) {
        cancelButton.backgroundColor = BHHexColor(@"308CDD");
        [cancelButton setTitleColor:BHHexColor(@"ffffff") forState:UIControlStateNormal];
        cancelButton.enabled = YES;
    } else
    {
        cancelButton.backgroundColor = BHHexColor(@"E1E5EA");
        [cancelButton setTitleColor:BHHexColor(@"93A0B5") forState:UIControlStateNormal];
        cancelButton.enabled = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
