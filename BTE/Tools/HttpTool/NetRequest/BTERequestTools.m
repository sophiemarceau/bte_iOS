//
//  BTERequestTools.m
//  BTE
//
//  Created by wangli on 2018/1/12.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTERequestTools.h"
#import "YQNetworking.h"
#import "PhoneInfo.h"

@implementation BTERequestTools

#pragma mark 封装的请求方法
+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(NSDictionary *)parameters
                        type:(HttpRequestType)type
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.requestSerializer.timeoutInterval = 30.0f;
    //vType为参数名，1为参数的值
    //    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"vType"];
    PhoneInfo * phone = [[PhoneInfo alloc] init];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [params setObject:kCurrentVersion forKey:@"version"];
    [params setObject:@"ios" forKey:@"channel"];
    [params setObject:phone.phoneVersion forKey:@"sdkVersionName"];
    [params setObject:phone.phoneVersion forKey:@"sdkVersionCode"];
    [params setObject:@"iphone" forKey:@"Brand"];
    [params setObject:phone.platform forKey:@"Model"];
    
    switch (type) {
        case HttpRequestTypeGet:
        {
            [YQNetworking getWithUrl:URLString refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
                NSError * error = [BTERequestTools checkIsSuccess:response];
                if (!error) {
                    if (success) {
                        success(response);
                    }
                }else {
                    if (failure) {
                        failure(error);
                    }
                }
            } failBlock:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        case HttpRequestTypePost:
        {
            [YQNetworking postWithUrl:URLString refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
                NSError * error = [BTERequestTools checkIsSuccess:response];
                if (!error) {
                    if (success) {
                        success(response);
                    }
                }else {
                    if (failure) {
                        failure(error);
                    }
                }
            } failBlock:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
            
        case HttpRequestTypeNormalPost:
        {
            [YQNetworking postWithUrl:URLString refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
//                NSError * error = [BTERequestTools checkIsSuccess:response];
                //                if (!error) {
                //                    if (success) {
                //                        success(response);
                //                    }
                //                }else {
                //                    if (failure) {
                //                        failure(error);
                //                    }
                //                }
                if (success) {
                    success(response);
                }
            } failBlock:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        case HttpRequestTypeNormalGet:
        {
            [YQNetworking getWithUrl:URLString refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
                if (success) {
                    success(response);
                }
            } failBlock:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        default:
            break;
    }
}

//检查是否有是正确参数返回
+ (id) checkIsSuccess:(id)responseObject
{
    if(responseObject==nil) {
        NSString *str = [NSString stringWithFormat:@"返回数据为空"];
        return [NSError errorWithDomain:str code:0 userInfo:responseObject];
    }
    NSString * code = [responseObject objectForKey:@"code"];
    if (code == nil) {
        NSString *str = [NSString stringWithFormat:@"%@ 没有返回正常标识！", responseObject];
        return [NSError errorWithDomain:str code:0 userInfo:responseObject];
    }
    //失败
    if (![code isEqualToString:@"0000"]) {
        NSString * error = [responseObject objectForKey:@"message"];
        if (error == nil) {
            return [NSError errorWithDomain:@"暂无错误数据" code:0 userInfo:responseObject];
        }
        return [NSError errorWithDomain:error code:code.integerValue userInfo:responseObject];
    }
    return nil;
}

@end

