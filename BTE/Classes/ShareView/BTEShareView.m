//
//  BTEShareView.m
//  BTE
//
//  Created by wangli on 2018/3/20.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEShareView.h"

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
    
    
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 57 - 128, SCREEN_WIDTH, 128)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [shareView addSubview:bgView1];
    
    UITapGestureRecognizer *tapBgView1 = [[UITapGestureRecognizer alloc]initWithTarget:shareView action:@selector(doTapChange1)];
    [bgView1 addGestureRecognizer:tapBgView1];
    
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 57, SCREEN_WIDTH, 57)];
    bgView2.backgroundColor = [UIColor whiteColor];
    [shareView addSubview:bgView2];
    
    UIView *bgView3 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 57, SCREEN_WIDTH, 1)];
    bgView3.backgroundColor = BHHexColor(@"E6EBF0");
    [shareView addSubview:bgView3];
    
    float width = (SCREEN_WIDTH - 23 * 2 - 48 * 4) / 3;
    
    UIButton *confirmbutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmbutton1.frame = CGRectMake(23, 30, 48, 48);
    confirmbutton1.tag = 101;
    [confirmbutton1 setImage:[UIImage imageNamed:@"share_weixin_bg"] forState:UIControlStateNormal];
    [confirmbutton1 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:confirmbutton1];
    
    UIButton *confirmbutton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmbutton2.frame = CGRectMake(confirmbutton1.right + width, 30, 48, 48);
    confirmbutton2.tag = 102;
    [confirmbutton2 setImage:[UIImage imageNamed:@"share_pengyouquan_bg"] forState:UIControlStateNormal];
    [confirmbutton2 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:confirmbutton2];
    
    UIButton *confirmbutton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmbutton3.frame = CGRectMake(confirmbutton2.right + width, 30, 48, 48);
    confirmbutton3.tag = 103;
    [confirmbutton3 setImage:[UIImage imageNamed:@"share_weibo_bg"] forState:UIControlStateNormal];
    [confirmbutton3 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:confirmbutton3];
    
    UIButton *confirmbutton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmbutton4.frame = CGRectMake(confirmbutton3.right + width, 30, 48, 48);
    confirmbutton4.tag = 104;
    [confirmbutton4 setImage:[UIImage imageNamed:@"share_copy_bg"] forState:UIControlStateNormal];
    [confirmbutton4 addTarget:shareView action:@selector(confirmbuttondismiss:) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:confirmbutton4];
    
    UILabel *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 86, 60, 13)];
    labelTitle1.text = @"微信";
    labelTitle1.font = UIFontRegularOfSize(13);
    labelTitle1.textColor = BHHexColor(@"000000");
    labelTitle1.textAlignment = NSTextAlignmentCenter;
    labelTitle1.centerX = confirmbutton1.centerX;
    [bgView1 addSubview:labelTitle1];
    
    UILabel *labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 86, 60, 13)];
    labelTitle2.text = @"朋友圈";
    labelTitle2.font = UIFontRegularOfSize(13);
    labelTitle2.textColor = BHHexColor(@"000000");
    labelTitle2.textAlignment = NSTextAlignmentCenter;
    labelTitle2.centerX = confirmbutton2.centerX;
    [bgView1 addSubview:labelTitle2];
    
    UILabel *labelTitle3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 86, 60, 13)];
    labelTitle3.text = @"微博";
    labelTitle3.font = UIFontRegularOfSize(13);
    labelTitle3.textColor = BHHexColor(@"000000");
    labelTitle3.textAlignment = NSTextAlignmentCenter;
    labelTitle3.centerX = confirmbutton3.centerX;
    [bgView1 addSubview:labelTitle3];
    
    UILabel *labelTitle4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 86, 60, 13)];
    labelTitle4.text = @"复制链接";
    labelTitle4.font = UIFontRegularOfSize(13);
    labelTitle4.textColor = BHHexColor(@"000000");
    labelTitle4.textAlignment = NSTextAlignmentCenter;
    labelTitle4.centerX = confirmbutton4.centerX;
    [bgView1 addSubview:labelTitle4];
    
    UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelbutton.frame = CGRectMake(0, 0, bgView2.width, 57);
    [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbutton setTitleColor:BHHexColor(@"292C33") forState:UIControlStateNormal];
    [cancelbutton addTarget:shareView action:@selector(cancelbuttondismiss) forControlEvents:UIControlEventTouchUpInside];
    cancelbutton.titleLabel.font = UIFontRegularOfSize(18);
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
    } else if (index == 104)//拷贝链接
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = shareView.shareUrl;
        [BHToast showMessage:@"复制成功"];
    }
    
    
    [shareView removeFromSuperview];
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
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    
    [shareObject setShareImage:[UIImage imageNamed:@"logo"]];
    
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
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.sharetitle descr:self.shareDesc thumImage:self.shareImageUrl];
    //设置网页地址
    shareObject.webpageUrl = self.shareUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.viewController completion:^(id data, NSError *error) {
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
- (void)alertWithError:(NSError *)error
{
//    NSString *result = nil;
    if (!error) {
//        result = [NSString stringWithFormat:@"Share succeed"];
        [BHToast showMessage:@"分享成功"];
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

@end
