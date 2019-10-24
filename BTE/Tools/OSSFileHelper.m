//
//  OSSFileHelper.m
//  BTE
//
//  Created by sophiemarceau_qu on 2018/9/20.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "OSSFileHelper.h"
//以下参数服务器端可提供
#define ACCKEY @"Mt5jQPnQQECHqTEST"
#define ACCSECRET @"2QgUjalQoBsdLn2iYFpqW0TEST"
#define ENDPOINT @"https://oss-cn-hangzhou.aliyuncs.com"

@implementation OSSFileHelper

+(instancetype)fileHelperShareInstance{
    static OSSFileHelper * fileHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileHelper = [[OSSFileHelper alloc] init];
//        [fileHelper initAliClient];
    });
    return fileHelper;
}

//-(void)initAliClient {
////    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:ACCKEY                                                                                                    secretKey:ACCSECRET];
//    id<OSSCredentialProvider> credential = [[OSSAuthCredentialProvider alloc] initWithAuthServerUrl:@"鉴权服务器地址，例如http://abc.com"];
//    OSSClientConfiguration * conf = [OSSClientConfiguration new];
//
//    // 网络请求遇到异常失败后的重试次数
//    conf.maxRetryCount = 3;
//
//    // 网络请求的超时时间
//    conf.timeoutIntervalForRequest =30;
//
//    // 允许资源传输的最长时间
//    conf.timeoutIntervalForResource =24 * 60 * 60;
//
//    // 你的阿里地址前面通常是这种格式 ：http://oss……
//    self.client = [[OSSClient alloc] initWithEndpoint:ENDPOINT credentialProvider:credential];
//}


#pragma 文件上传,将文件转换为NSData即可直接上传
-(void)uploadWithEndPointstr:(NSString *)endPointstr WithAuthServerUrlStr:(NSString *)authServerUrlStr WithFileData:(NSData *)amrData WithFilenName:(NSString *)amrName WithbucketName:(NSString *)bucketName callback:(void (^)(BOOL isreturnSuccessFlag,NSString *fileName))callback{
    NSMutableDictionary * pramaDic = @{}.mutableCopy;
    NSString * methodName = @"";
    if (User.userToken) {
        [pramaDic setObject:User.userToken forKey:@"bte-token"];
        [pramaDic setObject:User.userToken forKey:@"token"];
    }
    
     NSLog(@"pramaDic-------->%@",pramaDic);
    methodName = kGetOSSauthUrl;
    [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:HttpRequestTypeGet success:^(id responseObject) {
        NSLog(@"responseObject-------->%@",responseObject);
        if (IsSafeDictionary(responseObject)) {
            NSDictionary * data = [responseObject objectForKey:@"data"];
            if (data) {
                 NSLog(@"data-------->%@",data);
                
                NSString *endpoint = [NSString stringWithFormat:@"https://%@",endPointstr];
                NSLog(@"endpoint---------->%@",endPointstr);
                // 移动端建议使用STS方式初始化OSSClient。可以通过sample中STS使用说明了解更多(https://github.com/aliyun/aliyun-oss-ios-sdk/tree/master/DemoByOC)
                id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:[data objectForKey:@"accessKeyId"] secretKeyId:[data objectForKey:@"accessKeySecret"] securityToken:[data objectForKey:@"securityToken"]];
      
                OSSClientConfiguration * conf = [OSSClientConfiguration new];
                
                // 网络请求遇到异常失败后的重试次数
                conf.maxRetryCount = 3;
                
                // 网络请求的超时时间
                conf.timeoutIntervalForRequest = 30;
                
                // 允许资源传输的最长时间
                conf.timeoutIntervalForResource = 24 * 60 * 60;
                [OSSLog enableLog];
                // 你的阿里地址前面通常是这种格式 ：
                OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
                
                OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                put.bucketName = bucketName;//后台给的
                
                NSString *filelocalstr = [NSString stringWithFormat:@"user/avatar/%@",amrName];
                 NSLog(@"filelocalstr---------->%@",filelocalstr);
                put.objectKey = filelocalstr;
                put.uploadingData = amrData; // 直接上传NSData
                put.uploadProgress = ^(int64_t bytesSent,int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
//                    NSLog(@"uploadProgress---->%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
                };
                
                OSSTask * putTask = [client putObject:put];
                // 上传阿里云
                [putTask continueWithBlock:^id(OSSTask *task) {
                    if (!task.error) {
                        NSLog(@"upload object success!");
                        if (callback) {
                            NSString *picStr = [NSString stringWithFormat:@"https://%@%@%@/%@",bucketName,@".",endPointstr,filelocalstr];
                            callback(YES,picStr);
                            
                            
                        }
                    } else {
                        NSLog(@"upload object failed, error: %@" , task.error);
                        if (callback) {
                            callback(NO,@"");
                        }
                    }
                    return nil;
                }];
                // 可以等待任务完成
                [putTask waitUntilFinished];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"error-------->%@",error);
        callback(NO,@"");
    }];
}

//#pragma  文件下载
//-(void)downloadFile:(NSString *)filename callback:(void (^)(NSData *, BOOL))callback{
//    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
//    request.bucketName = @"savemoney";
//    request.objectKey = filename;
//    OSSTask * getTask = [self.client getObject:request];
//    [getTask continueWithBlock:^id(OSSTask *task) {
//        if (!task.error) {
//            NSLog(@"download object success!");
//            OSSGetObjectResult * getResult = task.result;
//            if (callback) {
//                callback(getResult.downloadedData,YES);
//            }
//        } else {
//            NSLog(@"download object failed, error: %@" ,task.error);
//            if (callback) {
//                callback(nil,NO);
//            }
//        }
//        return nil;
//    }];
//}
@end
