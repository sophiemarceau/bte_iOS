//
//  AddAttentionView.m
//  BTE
//
//  Created by sophie on 2018/9/19.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "AddAttentionView.h"
#import "WXApi.h"
#import "WXApiManager.h"
@interface AddAttentionView(){
    UIImageView *bgwhiteView;
    UIButton  *confirmBtn;
    UIButton  *cancelBtn;
    
}
@end

@implementation AddAttentionView

- (instancetype)initAlertView{
    self = [super init];
    if (self) {
        self.userInteractionEnabled  = YES;
        self.backgroundColor = kColorRgba(0, 0, 0, 0.5);
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        //        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShareView:)];
        //        [self addGestureRecognizer:tap1];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
        
        bgwhiteView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -SCALE_W(270))/2, SCALE_W(151) ,SCALE_W(270),SCALE_W(244))];
        bgwhiteView.layer.masksToBounds = YES;
        bgwhiteView.layer.cornerRadius = 12;
        bgwhiteView.backgroundColor = [UIColor whiteColor];
        bgwhiteView.userInteractionEnabled = YES;
        [self addSubview:bgwhiteView];
        
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoAttention"]];
        logoImageView.frame = CGRectMake(SCALE_W(46), SCALE_W(28), SCALE_W(48), SCALE_W(48));
        [bgwhiteView addSubview:logoImageView];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AddAttentionLine"]];
        lineImageView.frame = CGRectMake(SCALE_W(118), SCALE_W(42), SCALE_W(34), SCALE_W(21));
        [bgwhiteView addSubview:lineImageView];
        
        UIImageView *wechatImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Bitmap"]];
        wechatImageView.frame = CGRectMake(SCALE_W(176), SCALE_W(28), SCALE_W(48), SCALE_W(48));
        [bgwhiteView addSubview:wechatImageView];
       
        UILabel *attentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 107, SCALE_W(270) - 54 , 55)];
        attentionLabel.textAlignment = NSTextAlignmentCenter;
        attentionLabel.numberOfLines = 2;
        attentionLabel.font = UIFontRegularOfSize(16);
        attentionLabel.textColor = [UIColor colorWithHexString:@"626A75"];
        attentionLabel.text = @"微信搜索并关注“比特易”及时获取行情及币种推荐通知";
        attentionLabel.textColor = BHHexColorAlpha(@"626A75",1);
        [bgwhiteView addSubview:attentionLabel];
        
        confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(SCALE_W(270)/2 , bgwhiteView.frame.size.height- 44 , SCALE_W(270)/2, 44);
        [confirmBtn setTitle:@"去关注" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:BHHexColor(@"308CDD") forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgwhiteView addSubview:confirmBtn];
        
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0,bgwhiteView.frame.size.height- 44 , SCALE_W(270)/2, 44);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:BHHexColor(@"626A75") forState:UIControlStateNormal];
        [bgwhiteView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0,bgwhiteView.frame.size.height- 44 , SCALE_W(270), 1)];
        lineView1.backgroundColor = [UIColor colorWithHexString:@"E6EBF0"];
        [bgwhiteView addSubview:lineView1];
        
        UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(SCALE_W(270)/2,bgwhiteView.frame.size.height- 44 , 1, 44)];
        verticalLine.backgroundColor = [UIColor colorWithHexString:@"E6EBF0"];
        [bgwhiteView addSubview:verticalLine];
    }
    return self;
}

- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)confirmButtonOnClick:(UIButton *)sender{
    if ([WXApi isWXAppInstalled]) {
//        JumpToBizWebviewReq *req = [[JumpToBizWebviewReq alloc]init];
//        req.tousrname = kWechatPublicBTEID;
////        req.username = kWechatPublicBTEID;/*公众号原始ID*/
//        req.extMsg = @"";
//        [WXApi sendReq:req];
        [BHToast showMessage:@"请您在微信粘贴搜索比特易关注微信公众号"];
        [self performSelector:@selector(gotoWechat) withObject:nil afterDelay:2];
        
        
//        JumpToBizProfileReq *req = [JumpToBizProfileReq new];
//        req.username = kWechatPublicBTEID;
//        req.extMsg = @"";
//        req.profileType =WXBizProfileType_Normal;
//        [WXApi sendReq:req];

    } else {
        [BHToast showMessage:@"请您先安装微信"];
    }
//    WS(weakSelf)
//    weakSelf.confirmCallBack(YES,nickNameTextFiled.text);
//    [self dismissShareView];
}

-(void)gotoWechat{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = @"bte-top";      //  wxString微信号 然后就是在代码里需要跳转的地方直接调用,代码如下
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"weixin://"]];
    
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    
    if (canOpen) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
    [self dismissShareView];
}

-(void)cancelClick:(UIButton *)sender{
//    if (self.confirmCallBack != nil) {
//        self.confirmCallBack(NO,@"");
//    }
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

@end
