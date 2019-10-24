//
//  OSSFileHelper.h
//  BTE
//
//  Created by sophiemarceau_qu on 2018/9/20.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/AliyunOSSiOS.h>


NS_ASSUME_NONNULL_BEGIN

@interface OSSFileHelper : NSObject
@property(nonatomic,strong) OSSClient * client;
+(instancetype)fileHelperShareInstance;
#pragma 文件上传,将文件转换为NSData即可直接上传
-(void)uploadWithEndPointstr:(NSString *)endPointstr WithAuthServerUrlStr:(NSString *)authServerUrlStr WithFileData:(NSData *)amrData WithFilenName:(NSString *)amrName WithbucketName:(NSString *)bucketName callback:(void (^)(BOOL isreturnSuccessFlag,NSString *fileName))callback;
@end

NS_ASSUME_NONNULL_END
