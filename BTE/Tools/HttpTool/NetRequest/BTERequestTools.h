//
//  BTERequestTools.h
//  BTE
//
//  Created by wangli on 2018/1/12.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  网络请求类型
 */
typedef NS_ENUM(NSUInteger,HttpRequestType) {
    /**
     *  get请求
     */
    HttpRequestTypeGet = 1,
    /**
     *  post请求
     */
    HttpRequestTypePost = 2,
    /**
     *  post请求 错误码正常返回
     */
    HttpRequestTypeNormalPost = 3,
    
    /**
     *  get请求 错误码正常返回
     */
    HttpRequestTypeNormalGet = 4,
    
    HttpRequestSyncGET = 5,
};

@interface BTERequestTools : NSObject

/**
 *  发送网络请求
 *
 *  @param URLString   请求的网址字符串
 *  @param parameters  请求的参数
 *  @param type        请求的类型
 *  @param success     请求的结果
 */
+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(NSDictionary *)parameters
                        type:(HttpRequestType)type
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

@end

