//
//  BTEShareView.m
//  BTE
//
//  Created by wangli on 2018/3/20.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEShareView.h"
#import "IDFVTools.h"
#import "UserStatistics.h"

@implementation BTEShareView
/**
 分享弹窗
 */
+ (void)popShareViewCallBack:(ShareViewCallBack)shareViewCallBack
                    imageUrl:(id)_imageUrl shareUrl:(NSString *)_shareUrl sharetitle:(NSString *)_sharetitle shareDesc:(NSString *)_shareDesc shareType:(UMS_SHARE_TYPE)_shareType currentVc:(UIViewController *)currentVc
{
    BTEShareView *shareView = [[BTEShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    shareView.shareViewCallBack = shareViewCallBack;
    shareView.shareImageUrl = _imageUrl;
    shareView.shareUrl = _shareUrl;
    shareView.sharetitle = _sharetitle;
    shareView.shareDesc = _shareDesc;
    shareView.shareType = _shareType;
    shareView.viewController = currentVc;
    shareView.backgroundColor = kColorRgba(0, 0, 0, 0.6);
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    
    UITapGestureRecognizer *tapShareView = [[UITapGestureRecognizer alloc]initWithTarget:shareView action:@selector(doTapChange)];
    [shareView addGestureRecognizer:tapShareView];
    
    
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - (154), SCREEN_WIDTH, 154-44)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [shareView addSubview:bgView1];
    
    UITapGestureRecognizer *tapBgView1 = [[UITapGestureRecognizer alloc]initWithTarget:shareView action:@selector(doTapChange1)];
    [bgView1 addGestureRecognizer:tapBgView1];
    
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    bgView2.backgroundColor = [UIColor whiteColor];
    [shareView addSubview:bgView2];
    
    UIView *bgView3 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 45, SCREEN_WIDTH, 1)];
    bgView3.backgroundColor = BHHexColor(@"E6EBF0");
    
    [shareView addSubview:bgView3];
    
    float width = (SCREEN_WIDTH - 38 * 2 - 44 * 4) / 3;
    
    UIButton *confirmbutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmbutton1.frame = CGRectMake(SCALE_W(79) , SCALE_W(17), SCALE_W(50), SCALE_W(50));
    confirmbutton1.tag = 101;
    [confirmbutton1 setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
    [confirmbutton1 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:confirmbutton1];
    
    UIButton *confirmbutton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmbutton2.frame = CGRectMake(SCALE_W(confirmbutton1.right + 118), SCALE_W(17), SCALE_W(50), SCALE_W(50));
    confirmbutton2.tag = 102;
    [confirmbutton2 setImage:[UIImage imageNamed:@"pengyouquan"] forState:UIControlStateNormal];
    [confirmbutton2 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:confirmbutton2];
    
//    UIButton *confirmbutton3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    confirmbutton3.frame = CGRectMake(confirmbutton1.left, 110, 44, 44);
//    confirmbutton3.tag = 103;
//    [confirmbutton3 setImage:[UIImage imageNamed:@"share_weibo_bg"] forState:UIControlStateNormal];
//    [confirmbutton3 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
//    [bgView1 addSubview:confirmbutton3];
//
//    UIButton *confirmbutton4 = [UIButton buttonWithType:UIButtonTypeCustom];
//    confirmbutton4.frame = CGRectMake(confirmbutton2.left, 110, 44, 44);
//    confirmbutton4.tag = 104;
//    [confirmbutton4 setImage:[UIImage imageNamed:@"share_copy_bg"] forState:UIControlStateNormal];
//    [confirmbutton4 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
//    [bgView1 addSubview:confirmbutton4];
//
//    UIButton *confirmbutton5 = [UIButton buttonWithType:UIButtonTypeCustom];
//    confirmbutton5.frame = CGRectMake(confirmbutton2.right + width, confirmbutton1.top, 44, 44);
//    confirmbutton5.tag = 105;
//    [confirmbutton5 setImage:[UIImage imageNamed:@"share_qq_bg"] forState:UIControlStateNormal];
//    [confirmbutton5 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
//    [bgView1 addSubview:confirmbutton5];
//
//    UIButton *confirmbutton6 = [UIButton buttonWithType:UIButtonTypeCustom];
//    confirmbutton6.frame = CGRectMake(confirmbutton5.right + width, confirmbutton1.top, 44, 44);
//    confirmbutton6.tag = 106;
//    [confirmbutton6 setImage:[UIImage imageNamed:@"share_qqzone_bg"] forState:UIControlStateNormal];
//    [confirmbutton6 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
//    [bgView1 addSubview:confirmbutton6];
    
    UILabel *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(SCALE_W(91), SCALE_W(75), SCALE_W(27), SCALE_W(13))];
    labelTitle1.text = @"微信";
    labelTitle1.font = UIFontRegularOfSize(SCALE_W(13));
    labelTitle1.textColor = BHHexColor(@"626A75");
    labelTitle1.textAlignment = NSTextAlignmentCenter;
    //    labelTitle1.centerX = confirmbutton1.centerX;
    [bgView1 addSubview:labelTitle1];
    
    UILabel *labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(SCALE_W(252), SCALE_W(75), SCALE_W(40), SCALE_W(13))];
    labelTitle2.text = @"朋友圈";
    labelTitle2.font = UIFontRegularOfSize(SCALE_W(13));
    labelTitle2.textColor = BHHexColor(@"626A75");
    labelTitle2.textAlignment = NSTextAlignmentCenter;
    //    labelTitle2.centerX = confirmbutton2.centerX;
    [bgView1 addSubview:labelTitle2];
    
//    UILabel *labelTitle3 = [[UILabel alloc] initWithFrame:CGRectMake(0, confirmbutton3.bottom + 10, 60, 13)];
//    labelTitle3.text = @"微博";
//    labelTitle3.font = UIFontRegularOfSize(12);
//    labelTitle3.textColor = BHHexColor(@"626A75");
//    labelTitle3.textAlignment = NSTextAlignmentCenter;
//    labelTitle3.centerX = confirmbutton3.centerX;
//    [bgView1 addSubview:labelTitle3];
//
//    UILabel *labelTitle4 = [[UILabel alloc] initWithFrame:CGRectMake(0, confirmbutton3.bottom + 10, 60, 13)];
//    labelTitle4.text = @"复制链接";
//    labelTitle4.font = UIFontRegularOfSize(12);
//    labelTitle4.textColor = BHHexColor(@"626A75");
//    labelTitle4.textAlignment = NSTextAlignmentCenter;
//    labelTitle4.centerX = confirmbutton4.centerX;
//    [bgView1 addSubview:labelTitle4];
//
//    UILabel *labelTitle5 = [[UILabel alloc] initWithFrame:CGRectMake(0, confirmbutton1.bottom + 10, 60, 13)];
//    labelTitle5.text = @"QQ";
//    labelTitle5.font = UIFontRegularOfSize(12);
//    labelTitle5.textColor = BHHexColor(@"626A75");
//    labelTitle5.textAlignment = NSTextAlignmentCenter;
//    labelTitle5.centerX = confirmbutton5.centerX;
//    [bgView1 addSubview:labelTitle5];
//
//    UILabel *labelTitle6 = [[UILabel alloc] initWithFrame:CGRectMake(0, confirmbutton1.bottom + 10, 60, 13)];
//    labelTitle6.text = @"QQ空间";
//    labelTitle6.font = UIFontRegularOfSize(12);
//    labelTitle6.textColor = BHHexColor(@"626A75");
//    labelTitle6.textAlignment = NSTextAlignmentCenter;
//    labelTitle6.centerX = confirmbutton6.centerX;
//    [bgView1 addSubview:labelTitle6];
    
    UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelbutton.frame = CGRectMake(0, 0, bgView2.width, 50);
    [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbutton setTitleColor:BHHexColor(@"626A75") forState:UIControlStateNormal];
    [cancelbutton addTarget:shareView action:@selector(cancelbuttondismiss) forControlEvents:UIControlEventTouchUpInside];
    cancelbutton.titleLabel.font = UIFontRegularOfSize(14);
    [bgView2 addSubview:cancelbutton];
}

/**
 截图分享弹窗
 */
+ (void)popShareViewCallBack:(ShareViewCallBack)shareViewCallBack
                    imageUrl:(id)_imageUrl
                    shareUrl:(NSString *)_shareUrl
                  sharetitle:(NSString *)_sharetitle
                   shareDesc:(NSString *)_shareDesc
                   shareType:(UMS_SHARE_TYPE)_shareType
                  captionImg:(UIImage *)catImg
                   currentVc:(UIViewController *)currentVc shareCompelete:(void(^)(BOOL isSuccess))shareCompelete{
    BTEShareView *shareView = [[BTEShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    shareView.shareViewCallBack = shareViewCallBack;
    shareView.shareImageUrl = _imageUrl;
    shareView.shareUrl = _shareUrl;
    shareView.sharetitle = _sharetitle;
    shareView.shareDesc = _shareDesc;
    shareView.shareType = _shareType;
    shareView.shareCatImage = catImg;
    shareView.viewController = currentVc;
    shareView.shareCompelete = shareCompelete;
    shareView.backgroundColor = kColorRgba(0, 0, 0, 0.6);
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    
    UITapGestureRecognizer *tapShareView = [[UITapGestureRecognizer alloc]initWithTarget:shareView action:@selector(doTapChange)];
    [shareView addGestureRecognizer:tapShareView];
    
    
    
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - (154), SCREEN_WIDTH, 154-44)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [shareView addSubview:bgView1];
    
    UITapGestureRecognizer *tapBgView1 = [[UITapGestureRecognizer alloc]initWithTarget:shareView action:@selector(doTapChange1)];
    [bgView1 addGestureRecognizer:tapBgView1];
    
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    bgView2.backgroundColor = [UIColor whiteColor];
    [shareView addSubview:bgView2];
    
    UIView *bgView3 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 45, SCREEN_WIDTH, 1)];
    bgView3.backgroundColor = BHHexColor(@"E6EBF0");
    
    [shareView addSubview:bgView3];
    
    UIImageView *qrimageView = [[UIImageView alloc] initWithImage:catImg];
    [shareView addSubview:qrimageView];
    qrimageView.frame = CGRectMake(54, (IS_IPHONEX ? 44 : 18) , SCREEN_WIDTH - 54*2, SCREEN_HEIGHT - 154 - 18 -(IS_IPHONEX ? 44 : 18));
    float width = (SCREEN_WIDTH - 38 * 2 - 44 * 4) / 3;
    
    UIButton *confirmbutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmbutton1.frame = CGRectMake(SCALE_W(79) , SCALE_W(17), SCALE_W(50), SCALE_W(50));
    confirmbutton1.tag = 101;
    [confirmbutton1 setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
    [confirmbutton1 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:confirmbutton1];
    
    UIButton *confirmbutton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmbutton2.frame = CGRectMake(SCALE_W(confirmbutton1.right + 118), SCALE_W(17), SCALE_W(50), SCALE_W(50));
    confirmbutton2.tag = 102;
    [confirmbutton2 setImage:[UIImage imageNamed:@"pengyouquan"] forState:UIControlStateNormal];
    [confirmbutton2 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:confirmbutton2];
    
    
    UILabel *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(SCALE_W(91), SCALE_W(75), SCALE_W(27), SCALE_W(13))];
    labelTitle1.text = @"微信";
    labelTitle1.font = UIFontRegularOfSize(SCALE_W(13));
    labelTitle1.textColor = BHHexColor(@"626A75");
    labelTitle1.textAlignment = NSTextAlignmentCenter;
    //    labelTitle1.centerX = confirmbutton1.centerX;
    [bgView1 addSubview:labelTitle1];
    
    UILabel *labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(SCALE_W(252), SCALE_W(75), SCALE_W(40), SCALE_W(13))];
    labelTitle2.text = @"朋友圈";
    labelTitle2.font = UIFontRegularOfSize(SCALE_W(13));
    labelTitle2.textColor = BHHexColor(@"626A75");
    labelTitle2.textAlignment = NSTextAlignmentCenter;
    //    labelTitle2.centerX = confirmbutton2.centerX;
    [bgView1 addSubview:labelTitle2];
    
    //    UILabel *labelTitle3 = [[UILabel alloc] initWithFrame:CGRectMake(0, confirmbutton3.bottom + 10, 60, 13)];
    //    labelTitle3.text = @"微博";
    //    labelTitle3.font = UIFontRegularOfSize(12);
    //    labelTitle3.textColor = BHHexColor(@"626A75");
    //    labelTitle3.textAlignment = NSTextAlignmentCenter;
    //    labelTitle3.centerX = confirmbutton3.centerX;
    //    [bgView1 addSubview:labelTitle3];
    //
    //    UILabel *labelTitle4 = [[UILabel alloc] initWithFrame:CGRectMake(0, confirmbutton3.bottom + 10, 60, 13)];
    //    labelTitle4.text = @"复制链接";
    //    labelTitle4.font = UIFontRegularOfSize(12);
    //    labelTitle4.textColor = BHHexColor(@"626A75");
    //    labelTitle4.textAlignment = NSTextAlignmentCenter;
    //    labelTitle4.centerX = confirmbutton4.centerX;
    //    [bgView1 addSubview:labelTitle4];
    //
    //    UILabel *labelTitle5 = [[UILabel alloc] initWithFrame:CGRectMake(0, confirmbutton1.bottom + 10, 60, 13)];
    //    labelTitle5.text = @"QQ";
    //    labelTitle5.font = UIFontRegularOfSize(12);
    //    labelTitle5.textColor = BHHexColor(@"626A75");
    //    labelTitle5.textAlignment = NSTextAlignmentCenter;
    //    labelTitle5.centerX = confirmbutton5.centerX;
    //    [bgView1 addSubview:labelTitle5];
    //
    //    UILabel *labelTitle6 = [[UILabel alloc] initWithFrame:CGRectMake(0, confirmbutton1.bottom + 10, 60, 13)];
    //    labelTitle6.text = @"QQ空间";
    //    labelTitle6.font = UIFontRegularOfSize(12);
    //    labelTitle6.textColor = BHHexColor(@"626A75");
    //    labelTitle6.textAlignment = NSTextAlignmentCenter;
    //    labelTitle6.centerX = confirmbutton6.centerX;
    //    [bgView1 addSubview:labelTitle6];
    
    UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelbutton.frame = CGRectMake(0, 0, bgView2.width, 50);
    [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbutton setTitleColor:BHHexColor(@"626A75") forState:UIControlStateNormal];
    [cancelbutton addTarget:shareView action:@selector(cancelbuttondismiss) forControlEvents:UIControlEventTouchUpInside];
    cancelbutton.titleLabel.font = UIFontRegularOfSize(14);
    [bgView2 addSubview:cancelbutton];
}



/**
 截图分享弹窗
 */
+ (void)popShareViewCallBack:(ShareViewCallBack)shareViewCallBack
                    imageUrl:(id)_imageUrl shareUrl:(NSString *)_shareUrl sharetitle:(NSString *)_sharetitle shareDesc:(NSString *)_shareDesc shareType:(UMS_SHARE_TYPE)_shareType captionImg:(UIImage *)catImg currentVc:(UIViewController *)currentVc
{
    BTEShareView *shareView = [[BTEShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    shareView.shareViewCallBack = shareViewCallBack;
    shareView.shareImageUrl = _imageUrl;
    shareView.shareUrl = _shareUrl;
    shareView.sharetitle = _sharetitle;
    shareView.shareDesc = _shareDesc;
    shareView.shareType = _shareType;
    shareView.shareCatImage = catImg;
    shareView.viewController = currentVc;
    shareView.backgroundColor = kColorRgba(0, 0, 0, 0.6);
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    
    UITapGestureRecognizer *tapShareView = [[UITapGestureRecognizer alloc]initWithTarget:shareView action:@selector(doTapChange)];
    [shareView addGestureRecognizer:tapShareView];
    
    
    
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - (154), SCREEN_WIDTH, 154-44)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [shareView addSubview:bgView1];
    
    UITapGestureRecognizer *tapBgView1 = [[UITapGestureRecognizer alloc]initWithTarget:shareView action:@selector(doTapChange1)];
    [bgView1 addGestureRecognizer:tapBgView1];
    
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    bgView2.backgroundColor = [UIColor whiteColor];
    [shareView addSubview:bgView2];
    
    UIView *bgView3 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 45, SCREEN_WIDTH, 1)];
    bgView3.backgroundColor = BHHexColor(@"E6EBF0");
    
    [shareView addSubview:bgView3];
    
    UIImageView *qrimageView = [[UIImageView alloc] initWithImage:catImg];
    [shareView addSubview:qrimageView];
    qrimageView.frame = CGRectMake(54, (IS_IPHONEX ? 44 : 18) , SCREEN_WIDTH - 54*2, SCREEN_HEIGHT - 154 - 18 -(IS_IPHONEX ? 44 : 18));
    float width = (SCREEN_WIDTH - 38 * 2 - 44 * 4) / 3;
    
    UIButton *confirmbutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmbutton1.frame = CGRectMake(SCALE_W(79) , SCALE_W(17), SCALE_W(50), SCALE_W(50));
    confirmbutton1.tag = 101;
    [confirmbutton1 setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
    [confirmbutton1 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:confirmbutton1];
    
    UIButton *confirmbutton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmbutton2.frame = CGRectMake(SCALE_W(confirmbutton1.right + 118), SCALE_W(17), SCALE_W(50), SCALE_W(50));
    confirmbutton2.tag = 102;
    [confirmbutton2 setImage:[UIImage imageNamed:@"pengyouquan"] forState:UIControlStateNormal];
    [confirmbutton2 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:confirmbutton2];
    
    //    UIButton *confirmbutton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    confirmbutton3.frame = CGRectMake(confirmbutton1.left, 110, 44, 44);
    //    confirmbutton3.tag = 103;
    //    [confirmbutton3 setImage:[UIImage imageNamed:@"share_weibo_bg"] forState:UIControlStateNormal];
    //    [confirmbutton3 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
    //    [bgView1 addSubview:confirmbutton3];
    //
    //    UIButton *confirmbutton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    confirmbutton4.frame = CGRectMake(confirmbutton2.left, 110, 44, 44);
    //    confirmbutton4.tag = 104;
    //    [confirmbutton4 setImage:[UIImage imageNamed:@"share_copy_bg"] forState:UIControlStateNormal];
    //    [confirmbutton4 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
    //    [bgView1 addSubview:confirmbutton4];
    //
    //    UIButton *confirmbutton5 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    confirmbutton5.frame = CGRectMake(confirmbutton2.right + width, confirmbutton1.top, 44, 44);
    //    confirmbutton5.tag = 105;
    //    [confirmbutton5 setImage:[UIImage imageNamed:@"share_qq_bg"] forState:UIControlStateNormal];
    //    [confirmbutton5 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
    //    [bgView1 addSubview:confirmbutton5];
    //
    //    UIButton *confirmbutton6 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    confirmbutton6.frame = CGRectMake(confirmbutton5.right + width, confirmbutton1.top, 44, 44);
    //    confirmbutton6.tag = 106;
    //    [confirmbutton6 setImage:[UIImage imageNamed:@"share_qqzone_bg"] forState:UIControlStateNormal];
    //    [confirmbutton6 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
    //    [bgView1 addSubview:confirmbutton6];
    
    UILabel *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(SCALE_W(91), SCALE_W(75), SCALE_W(27), SCALE_W(13))];
    labelTitle1.text = @"微信";
    labelTitle1.font = UIFontRegularOfSize(SCALE_W(13));
    labelTitle1.textColor = BHHexColor(@"626A75");
    labelTitle1.textAlignment = NSTextAlignmentCenter;
    //    labelTitle1.centerX = confirmbutton1.centerX;
    [bgView1 addSubview:labelTitle1];
    
    UILabel *labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(SCALE_W(252), SCALE_W(75), SCALE_W(40), SCALE_W(13))];
    labelTitle2.text = @"朋友圈";
    labelTitle2.font = UIFontRegularOfSize(SCALE_W(13));
    labelTitle2.textColor = BHHexColor(@"626A75");
    labelTitle2.textAlignment = NSTextAlignmentCenter;
    //    labelTitle2.centerX = confirmbutton2.centerX;
    [bgView1 addSubview:labelTitle2];
    
    //    UILabel *labelTitle3 = [[UILabel alloc] initWithFrame:CGRectMake(0, confirmbutton3.bottom + 10, 60, 13)];
    //    labelTitle3.text = @"微博";
    //    labelTitle3.font = UIFontRegularOfSize(12);
    //    labelTitle3.textColor = BHHexColor(@"626A75");
    //    labelTitle3.textAlignment = NSTextAlignmentCenter;
    //    labelTitle3.centerX = confirmbutton3.centerX;
    //    [bgView1 addSubview:labelTitle3];
    //
    //    UILabel *labelTitle4 = [[UILabel alloc] initWithFrame:CGRectMake(0, confirmbutton3.bottom + 10, 60, 13)];
    //    labelTitle4.text = @"复制链接";
    //    labelTitle4.font = UIFontRegularOfSize(12);
    //    labelTitle4.textColor = BHHexColor(@"626A75");
    //    labelTitle4.textAlignment = NSTextAlignmentCenter;
    //    labelTitle4.centerX = confirmbutton4.centerX;
    //    [bgView1 addSubview:labelTitle4];
    //
    //    UILabel *labelTitle5 = [[UILabel alloc] initWithFrame:CGRectMake(0, confirmbutton1.bottom + 10, 60, 13)];
    //    labelTitle5.text = @"QQ";
    //    labelTitle5.font = UIFontRegularOfSize(12);
    //    labelTitle5.textColor = BHHexColor(@"626A75");
    //    labelTitle5.textAlignment = NSTextAlignmentCenter;
    //    labelTitle5.centerX = confirmbutton5.centerX;
    //    [bgView1 addSubview:labelTitle5];
    //
    //    UILabel *labelTitle6 = [[UILabel alloc] initWithFrame:CGRectMake(0, confirmbutton1.bottom + 10, 60, 13)];
    //    labelTitle6.text = @"QQ空间";
    //    labelTitle6.font = UIFontRegularOfSize(12);
    //    labelTitle6.textColor = BHHexColor(@"626A75");
    //    labelTitle6.textAlignment = NSTextAlignmentCenter;
    //    labelTitle6.centerX = confirmbutton6.centerX;
    //    [bgView1 addSubview:labelTitle6];
    
    UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelbutton.frame = CGRectMake(0, 0, bgView2.width, 50);
    [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbutton setTitleColor:BHHexColor(@"626A75") forState:UIControlStateNormal];
    [cancelbutton addTarget:shareView action:@selector(cancelbuttondismiss) forControlEvents:UIControlEventTouchUpInside];
    cancelbutton.titleLabel.font = UIFontRegularOfSize(14);
    [bgView2 addSubview:cancelbutton];
}

- (void)doTapChange
{
    [self removeFromSuperview];
}

- (void)doTapChange1
{

}

// 取消
- (void)cancelbuttondismiss {
    [self removeFromSuperview];
}
// 按钮点击
- (void)confirmbuttondismiss:(UIButton *)sender {
    
    if (sender.tag == 101) {//微信
        self.platform = UMSocialPlatformType_WechatSession;//微信
        [self shareWithType:_shareType];
    } else if (sender.tag == 102)//朋友圈
    {
        self.platform = UMSocialPlatformType_WechatTimeLine;//朋友圈
        [self shareWithType:_shareType];
    } else if (sender.tag == 103)//新浪微博
    {
        self.platform = UMSocialPlatformType_Sina;//新浪微博
        [self shareWithType:_shareType];
    } else if (sender.tag == 104)//拷贝链接
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.shareUrl;
        [BHToast showMessage:@"复制成功"];
    } else if (sender.tag == 105)//QQ
    {
        self.platform = UMSocialPlatformType_QQ;//
        [self shareWithType:_shareType];
    } else if (sender.tag == 106)//QQ空间
    {
        self.platform = UMSocialPlatformType_Qzone;//
        [self shareWithType:_shareType];
    }
    
    
    [self removeFromSuperview];
}

//对外使用对应tag点击事件
+ (void)popShareViewCallBack:(ShareViewCallBack)shareViewCallBack
                    imageUrl:(id)_imageUrl shareUrl:(id)_shareUrl sharetitle:(NSString *)_sharetitle shareDesc:(NSString *)_shareDesc shareType:(UMS_SHARE_TYPE)_shareType currentVc:(UIViewController *)currentVc shareButtonTag:(NSInteger)index
{
    BTEShareView *shareView = [[BTEShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    shareView.shareViewCallBack = shareViewCallBack;
    shareView.shareImageUrl = _imageUrl;
    shareView.shareUrl = _shareUrl;
    shareView.sharetitle = _sharetitle;
    shareView.shareDesc = _shareDesc;
    shareView.shareType = _shareType;
    shareView.viewController = currentVc;
    shareView.backgroundColor = kColorRgba(0, 0, 0, 0.6);
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    if (index == 101) {//微信
        shareView.platform = UMSocialPlatformType_WechatSession;//微信
        [shareView shareWithType:_shareType];
    } else if (index == 102)//朋友圈
    {
        shareView.platform = UMSocialPlatformType_WechatTimeLine;//朋友圈
        [shareView shareWithType:_shareType];
    } else if (index == 103)//新浪微博
    {
        shareView.platform = UMSocialPlatformType_Sina;//新浪微博
        [shareView shareWithType:_shareType];
    } else if (index == 104)//QQ
    {
        shareView.platform = UMSocialPlatformType_QQ;//
        [shareView shareWithType:_shareType];
    } else if (index == 105)//QQ空间
    {
        shareView.platform = UMSocialPlatformType_Qzone;//
        [shareView shareWithType:_shareType];
    }
    
    
//    [shareView removeFromSuperview];
    shareView.hidden = YES;
}


- (void)shareWithType:(UMS_SHARE_TYPE)type
{
    switch (type) {
        case UMS_SHARE_TYPE_TEXT:
        {
            [self shareTextToPlatformType:self.platform];
        }
            break;
        case UMS_SHARE_TYPE_IMAGE:
        {
            [self shareImageToPlatformType:self.platform];
        }
            break;
        case UMS_SHARE_TYPE_IMAGE_URL:
        {
            [self shareImageURLToPlatformType:self.platform];
        }
            break;
        case UMS_SHARE_TYPE_TEXT_IMAGE:
        {
            [self shareImageAndTextToPlatformType:self.platform];
        }
            break;
        case UMS_SHARE_TYPE_WEB_LINK:
        {
            [self shareWebPageToPlatformType:self.platform];
        }
            break;
        default:
            break;
    }
}

#pragma mark - share type
//分享文本
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = self.shareDesc;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
        [self removeFromSuperview];
    }];
}

//分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图本地
    //    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    //
    //    [shareObject setShareImage:[UIImage imageNamed:@"logo"]];
    
    
    NSData *imgData = UIImageJPEGRepresentation(self.shareCatImage, 0.01);
    [shareObject setShareImage:imgData];
    shareObject.thumbImage = imgData;
    
    // 设置Pinterest参数
    //    if (platformType == UMSocialPlatformType_Pinterest) {
    //        [self setPinterstInfo:messageObject];
    //    }
    //
    //    // 设置Kakao参数
    //    if (platformType == UMSocialPlatformType_KakaoTalk) {
    //        messageObject.moreInfo = @{@"permission" : @1}; // @1 = KOStoryPermissionPublic
    //    }
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    if (self.shareCompelete) {
        [UserStatistics sendEventToServer:@"分享图片"];
        [UserStatistics sendEventToServer:@"分享图片成功"];


        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.viewController completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
                [self requestCancelShared:platformType];
                [UserStatistics sendEventToServer:@"分享图片失败"];
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                    UMSocialShareResponse *resp = data;
                    //分享结果消息
//                    NSLog(@"response message is %@",resp.message);
//                    //第三方原始返回的数据
//                    NSLog(@"response originalResponse data is %@",resp.originalResponse);
                    self.shareCompelete(YES);

                }else{
                    NSLog(@"response data is %@",data);
                }
            }
//            [self alertWithError:error];
        }];

    }else{
        [self requestCreateShared:platformType];
        [UserStatistics sendEventToServer:@"分享图片"];
        [UserStatistics sendEventToServer:@"分享图片成功"];
        
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.viewController completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
                [self requestCancelShared:platformType];
                [UserStatistics sendEventToServer:@"分享图片失败"];
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    NSLog(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    NSLog(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    NSLog(@"response data is %@",data);
                }
            }
            [self alertWithError:error];
        }];
    }
    
    
}

//分享网络图片
- (void)shareImageURLToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    //            shareObject.thumbImage = UMS_THUMB_IMAGE;
    //
    //            [shareObject setShareImage:UMS_IMAGE];
    
    // 设置Pinterest参数
    if (platformType == UMSocialPlatformType_Pinterest) {
        [self setPinterstInfo:messageObject];
    }
    
    // 设置Kakao参数
    if (platformType == UMSocialPlatformType_KakaoTalk) {
        messageObject.moreInfo = @{@"permission" : @1}; // @1 = KOStoryPermissionPublic
    }
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}
//分享图片和文字
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //设置文本
    messageObject.text = self.shareDesc;
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    if (platformType == UMSocialPlatformType_Linkedin) {
        // linkedin仅支持URL图片
        //                    shareObject.thumbImage = UMS_THUMB_IMAGE;
        //                    [shareObject setShareImage:UMS_IMAGE];
    } else {
        shareObject.thumbImage = [UIImage imageNamed:@"icon"];
        shareObject.shareImage = [UIImage imageNamed:@"logo"];
    }
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    //                    NSString* thumbURL =  UMS_THUMB_IMAGE;
    
    NSLog(@"shareImageUrl---->%@",self.shareImageUrl);
    NSLog(@"shareUrl---->%@",self.shareUrl);
    NSLog(@"shareDesc---->%@",self.shareDesc);
    NSLog(@"sharetitle---->%@",self.sharetitle);
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.sharetitle descr:self.shareDesc thumImage:self.shareImageUrl];
    //设置网页地址
    shareObject.webpageUrl = self.shareUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [self requestCreateShared:platformType];
    [UserStatistics sendEventToServer:@"分享链接"];
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.viewController completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
             NSLog(@"************Share fail with error %@*********",error);
            [self requestCancelShared:platformType];
            [UserStatistics sendEventToServer:@"分享链接失败"];
            
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                NSLog(@"response message is %@",resp.message);
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);

            }else{
                UMSocialLogInfo(@"response data is %@",data);
                NSLog(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}
- (void)alertWithError:(NSError *)error
{
//    NSString *result = nil;
    if (!error) {
        [BHToast showMessage:@"分享成功 已添加积分"];
//        if ([self.shareUrl rangeOfString:@"/wechat/researchReport"].location != NSNotFound){
////             [self requestsharedSuccess];
//        }else{
//            [BHToast showMessage:@"分享成功"];
//        }
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
//            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
            if (error.code == 2009) {
                [BHToast showMessage:@"取消分享"];
            } else
            {
               [BHToast showMessage:@"分享失败"];
            }
        }
        else{
//            result = [NSString stringWithFormat:@"Share fail"];
            [BHToast showMessage:@"分享失败"];
        }
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
//                                                    message:result
//                                                   delegate:nil
//                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
//                                          otherButtonTitles:nil];
//    [alert show];
}
- (void)setPinterstInfo:(UMSocialMessageObject *)messageObj
{
    messageObj.moreInfo = @{@"source_url": @"http://www.umeng.com",
                            @"app_name": @"U-Share",
                            @"suggested_board_name": @"UShareProduce",
                            @"description": @"U-Share: best social bridge"};
}
- (void)dealloc
{
    
}


-(void)requestsharedSuccess{
    
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }
    
    methodName = kaddSharePoint;
    
    
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            [BHToast showMessage:@"已添加积分"];
           
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
//        RequestError(error);
    }];
}


//share-api : 分享API
-(void)requestCreateShared:(UMSocialPlatformType)platformType{
     NSLog(@"requestCreateShared----->%@",self.shareUrl);
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }else{
         [pramaDic setObject:@"" forKey:@"bte-token"];
    }
    [pramaDic setObject:@"IOS" forKey:@"channel"];
    NSString *idString = [[IDFVTools getIDFV] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [pramaDic setObject:idString forKey:@"deviceId"];
    [pramaDic setObject:[self returnShareType:platformType] forKey:@"shareType"];
    [pramaDic setObject:@"Page" forKey:@"pageType"];
    [pramaDic setObject:self.shareUrl forKey:@"url"];
    [pramaDic setObject:[self getNowTimeTimestamp3] forKey:@"timestamp"];
    [pramaDic setObject:@"0" forKey:@"checkCode"];

    methodName = kcreateShare;

     NSLog(@"pramaDic----->%@",pramaDic);
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        [UserStatistics sendEventToServer:@"分享链接成功"];
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;

    }];
}

//share-api : 分享API
-(void)requestCancelShared:(UMSocialPlatformType)platformType{
    
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
    }else{
        [pramaDic setObject:@"" forKey:@"bte-token"];
    }
    [pramaDic setObject:@"IOS" forKey:@"channel"];
    NSString *idString = [[IDFVTools getIDFV] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [pramaDic setObject:idString forKey:@"deviceId"];
    [pramaDic setObject:[self returnShareType:platformType] forKey:@"shareType"];
    [pramaDic setObject:@"Page" forKey:@"pageType"];
    [pramaDic setObject:self.shareUrl forKey:@"url"];
    [pramaDic setObject:[self getNowTimeTimestamp3] forKey:@"timestamp"];
    [pramaDic setObject:@"0" forKey:@"checkCode"];
    
    methodName = kcancelShare;
    NSLog(@"pramaDic----->%@",pramaDic);
    NMShowLoadIng;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
        NSLog(@"responseOjbect--kcancelShare---->%@",responseObject);
        NMRemovLoadIng;
        if (IsSafeDictionary(responseObject)) {
            
        }
    } failure:^(NSError *error) {
        NMRemovLoadIng;
        //        RequestError(error);
    }];
}

-(NSString *)returnShareType:(UMSocialPlatformType)platformType{
    NSString *backShareStrin ;
    if (platformType == UMSocialPlatformType_WechatSession) {
        backShareStrin = @"wechat";
    }else
    if (platformType == UMSocialPlatformType_WechatTimeLine) {
        backShareStrin = @"wxcircle";
    }else
    if (platformType == UMSocialPlatformType_QQ) {
         backShareStrin = @"qq";
    }else
    if (platformType == UMSocialPlatformType_Qzone) {
         backShareStrin = @"qqkj";
    }else
    if (platformType == UMSocialPlatformType_Sina) {
        backShareStrin = @"weibo";
    }
    return backShareStrin;
}


-(NSString *)getNowTimeTimestamp3{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    return timeString;
}
@end
