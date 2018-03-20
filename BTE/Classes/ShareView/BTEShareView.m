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
    
    UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelbutton.frame = CGRectMake(0, 282, 50, 48);
    [cancelbutton setTitle:@"微信" forState:UIControlStateNormal];
    [cancelbutton addTarget:shareView action:@selector(cancelbuttondismiss) forControlEvents:UIControlEventTouchUpInside];
    cancelbutton.titleLabel.font = UIFontRegularOfSize(14);
    [shareView addSubview:cancelbutton];
    
    UIButton *confirmbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmbutton.frame = CGRectMake(150, 282, 50, 48);
    [confirmbutton setTitle:@"微信朋友圈" forState:UIControlStateNormal];
    [confirmbutton addTarget:shareView action:@selector(confirmbuttondismiss) forControlEvents:UIControlEventTouchUpInside];
    confirmbutton.titleLabel.font = UIFontRegularOfSize(14);
    [shareView addSubview:confirmbutton];
    
}

// 微信
- (void)cancelbuttondismiss {
    self.platform = UMSocialPlatformType_WechatSession;//微信
    [self shareWithType:_shareType];
    [self removeFromSuperview];
}
// 微信朋友圈
- (void)confirmbuttondismiss {
    //    if (self.activateNowCallBack) {
    //        self.activateNowCallBack();
    //    }
    [self removeFromSuperview];
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
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
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
