//
//  WXApiManager.m
//  BTE
//
//  Created by sophie on 2018/9/25.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "WXApiManager.h"

@implementation WXApiManager


#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}


#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *sendAuthResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:sendAuthResp];
        }
    }
//    else if ([resp isKindOfClass:[SendAuthResp class]]) {
//        if (_delegate
//            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
//            SendAuthResp *authResp = (SendAuthResp *)resp;
//            [_delegate managerDidRecvAuthResponse:authResp];
//        }
//    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
//        if (_delegate
//            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
//            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
//            [_delegate managerDidRecvAddCardResponse:addCardResp];
//        }
//    } else if ([resp isKindOfClass:[WXChooseCardResp class]]) {
//        if (_delegate
//            && [_delegate respondsToSelector:@selector(managerDidRecvChooseCardResponse:)]) {
//            WXChooseCardResp *chooseCardResp = (WXChooseCardResp *)resp;
//            [_delegate managerDidRecvChooseCardResponse:chooseCardResp];
//        }
//    }else if ([resp isKindOfClass:[WXChooseInvoiceResp class]]){
//        if (_delegate
//            && [_delegate respondsToSelector:@selector(managerDidRecvChooseInvoiceResponse:)]) {
//            WXChooseInvoiceResp *chooseInvoiceResp = (WXChooseInvoiceResp *)resp;
//            [_delegate managerDidRecvChooseInvoiceResponse:chooseInvoiceResp];
//        }
//    }else if ([resp isKindOfClass:[WXSubscribeMsgResp class]]){
//        if ([_delegate respondsToSelector:@selector(managerDidRecvSubscribeMsgResponse:)])
//        {
//            [_delegate managerDidRecvSubscribeMsgResponse:(WXSubscribeMsgResp *)resp];
//        }
//    }else if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]){
//        if ([_delegate respondsToSelector:@selector(managerDidRecvLaunchMiniProgram:)]) {
//            [_delegate managerDidRecvLaunchMiniProgram:(WXLaunchMiniProgramResp *)resp];
//        }
//    }else if([resp isKindOfClass:[WXInvoiceAuthInsertResp class]]){
//        if ([_delegate respondsToSelector:@selector(managerDidRecvInvoiceAuthInsertResponse:)]) {
//            [_delegate managerDidRecvInvoiceAuthInsertResponse:(WXInvoiceAuthInsertResp *) resp];
//        }
//    }else if([resp isKindOfClass:[WXNontaxPayResp class]]){
//        if ([_delegate respondsToSelector:@selector(managerDidRecvNonTaxpayResponse:)]) {
//            [_delegate managerDidRecvNonTaxpayResponse:(WXNontaxPayResp *)resp];
//        }
//    }else if ([resp isKindOfClass:[WXPayInsuranceResp class]]){
//        if ([_delegate respondsToSelector:@selector(managerDidRecvPayInsuranceResponse:)]) {
//            [_delegate managerDidRecvPayInsuranceResponse:(WXPayInsuranceResp *)resp];
//        }
//    }
}


@end
