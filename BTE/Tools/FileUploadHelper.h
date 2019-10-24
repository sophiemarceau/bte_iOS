//
//  FileUploadHelper.h
//  BTE
//
//  Created by sophiemarceau_qu on 2018/9/19.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileUploadHelper : NSObject
+(NSString *)PreUploadImagePath:(UIImage *)img AndFileName:(NSString *)fileName;
+(NSString *)GetTempSaveImagePath;
+(BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath;
+(void) FileUploadWithUrl:(NSString *)url FilePath:(NSString *)path FileName:(NSString *)fileName Success:(void (^)(NSDictionary *result))success;
+(void) fileUploadMp3WithUrl:(NSString *)url FilePath:(NSString *)path FileName:(NSString *)fileName Success:(void (^)(NSDictionary *result))success;
@property (nonatomic,assign)BOOL isMp3;
@end

NS_ASSUME_NONNULL_END
