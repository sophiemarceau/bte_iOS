//
//  NetWorking.m
//  btc123
//
//  Created by jarze on 16/1/18.
//  Copyright © 2016年 btc123. All rights reserved.
//

#import "NetWorking.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager+Synchronous.h"

@implementation NetWorking
+(void)requestWithApi:(NSString *)url param:(NSMutableDictionary *)param thenSuccess:(void (^)(NSDictionary *responseObject))success fail:(void (^)(void))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //https ssl 验证。
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"mbtetop" ofType:@"cer"];//证书的路径
//    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
//
//    // AFSSLPinningModeCertificate 使用证书验证模式
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//    // 如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
//
//    //validatesDomainName 是否需要验证域名，默认为YES;
//    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//    //如置为NO，建议自己添加对应域名的校验逻辑。
//    securityPolicy.validatesDomainName = NO;
//
//    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
//
//    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !success ? : success(responseObject);
        });

    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            !fail ? : fail();
        });
    }];
    
    
}

+(void)requestSyncPOSTWithApi:(NSString *)url param:(NSMutableDictionary *)param WithSuccess:(void (^)(NSDictionary *responseObject))success Withfail:(void (^)(void))fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //https ssl 验证。
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"mbtetop" ofType:@"cer"];//证书的路径
//    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
//    
//    // AFSSLPinningModeCertificate 使用证书验证模式
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//    // 如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
//    
//    //validatesDomainName 是否需要验证域名，默认为YES;
//    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//    //如置为NO，建议自己添加对应域名的校验逻辑。
//    securityPolicy.validatesDomainName = NO;
//    
//    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
//    
//    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    NSError *error = nil;
    NSData *result = [manager syncPOST:url
                           parameters:param
                                 task:NULL
                                error:&error];
    
    NSLog(@"result------->%@",result);
}
@end
