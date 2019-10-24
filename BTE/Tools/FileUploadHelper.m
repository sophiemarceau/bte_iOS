

//  FileUploadHelper.m
//  IELTS
//
//  Created by sophiemarceau_qu on 14/11/27.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "FileUploadHelper.h"
//#import "RusultManage.h"

@implementation FileUploadHelper

+(NSString *)PreUploadImagePath:(UIImage *)img AndFileName:(NSString *)fileName
{
    NSString *tmpFolder = [self GetTempSaveImagePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@",tmpFolder,fileName];
    
    BOOL ret = [self writeImage:img toFileAtPath:path];
    if (ret)
    {
        return  path;
    }
    else
    {
        return @"";
    }
}

+(NSString *)GetTempSaveImagePath
{
    NSFileManager * fileManager = nil;
    NSArray *paths = nil;
    NSString *documentsDirectory = nil;
    NSString * folerName = @"TempUploadPhotos";
    
    //Documents:
    paths
    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:folerName];
    fileManager = [[NSFileManager alloc]init];
    
    BOOL isDir = NO;
    BOOL isDirExist = [fileManager fileExistsAtPath:documentsDirectory isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        NSError *error;
        
        [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return documentsDirectory;
}

+(BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath
{
    if ((image == nil) || (aPath == nil) || ([aPath isEqualToString:@""]))
        
        return NO;
    
    @try
    
    {
        
        NSData *imageData = nil;
        
        NSString *ext = [aPath pathExtension];
        
        if ([ext isEqualToString:@"png"])
            
        {
            
            imageData = UIImagePNGRepresentation(image);
            
        }
        
        else
            
        {
            
            // the rest, we write to jpeg
            
            // 0. best, 1. lost. about compress.
            
            imageData = UIImageJPEGRepresentation(image, 0);
            
        }
        
        if ((imageData == nil) || ([imageData length] <= 0))
            
            return NO;
        
        [imageData writeToFile:aPath atomically:YES];
        
        return YES;
        
    }
    
    @catch (NSException *e)
    
    {
        
        NSLog(@"create thumbnail exception.");
        
    }
    
    return NO;
}


+(void) FileUploadWithUrl:(NSString *)url FilePath:(NSString *)path FileName:(NSString *)fileName Success:(void (^)(NSDictionary *result))success
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    [self uploadFileWithURL:[NSURL URLWithString:url] data:data FileName:fileName Success:^(NSDictionary *result)
     {
         success(result);
     }];
}

+ (NSString *)topStringWithMimeType:(NSString *)mimeType uploadFile:(NSString *)uploadFile
{
    NSString *randomIDStr = @"itcast";
    NSString *boundaryStr = @"--";
    
    NSMutableString *strM = [NSMutableString string];
    
    [strM appendFormat:@"%@%@\r\n", boundaryStr, randomIDStr];
    [strM appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", uploadFile];
    [strM appendFormat:@"Content-Type: %@\r\n\r\n", mimeType];
    
    NSLog(@"%@", strM);
    return [strM copy];
}

+ (NSString *)bottomString
{
    NSString *randomIDStr = @"itcast";
    NSString *boundaryStr = @"--";
    
    NSMutableString *strM = [NSMutableString string];
    
    //   [strM appendFormat:@"\r\n%@%@\r\n", boundaryStr, randomIDStr];
    //   [strM appendString:@"Content-Disposition: form-data; name=\"submit\"\r\n\r\n"];
    //   [strM appendString:@"Submit\r\n"];
    [strM appendFormat:@"\r\n%@%@--\r\n", boundaryStr, randomIDStr];
    
    NSLog(@"%@", strM);
    return [strM copy];
}

+(void) fileUploadMp3WithUrl:(NSString *)url FilePath:(NSString *)path FileName:(NSString *)fileName Success:(void (^)(NSDictionary *result))success
{
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    [self uploadMP3FileWithURL:[NSURL URLWithString:url] data:data FileName:fileName Success:^(NSDictionary *result)
     {
         success(result);
     }];
}
#pragma mark - 上传MP3文件
+ (void)uploadMP3FileWithURL:(NSURL *)url data:(NSData *)data FileName:(NSString *)fileName Success:(void (^)(NSDictionary *result))success
{
    NSString *topStr = [self topStringWithMimeType:@"audio/mpeg" uploadFile:fileName];
    NSString *bottomStr = [self bottomString];
    NSString *randomIDStr = @"itcast";
    
    NSMutableData *dataM = [NSMutableData data];
    [dataM appendData:[topStr dataUsingEncoding:NSUTF8StringEncoding]];
    [dataM appendData:data];
    [dataM appendData:[bottomStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 1. Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
    
    // dataM出了作用域就会被释放,因此不用copy
    request.HTTPBody = dataM;
    
    // 2> 设置Request的头属性
    request.HTTPMethod = @"POST";
    
    // 3> 设置Content-Length
    NSString *strLength = [NSString stringWithFormat:@"%ld", (long)dataM.length];
    [request setValue:strLength forHTTPHeaderField:@"Content-Length"];
    
    // 4> 设置Content-Type
    NSString *strContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", randomIDStr];
    [request setValue:strContentType forHTTPHeaderField:@"Content-Type"];
    
    //    NSString *userToken = [RusultManage shareRusultManage].userToken;
    //    NSString *userToken = @"0";
    //    [request setValue:userToken forHTTPHeaderField:@"Authentication"];
    
    // 3> 连接服务器发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data != nil) {
            NSError *error;
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"%@",error);
            NSLog(@"%@",response);
            success(resultDic);
        }
    }];
    
}

#pragma mark - 上传图片文件
+ (void)uploadFileWithURL:(NSURL *)url data:(NSData *)data FileName:(NSString *)fileName Success:(void (^)(NSDictionary *result))success
{
    // 1> 数据体
    NSString *topStr = [self topStringWithMimeType:@"image/png" uploadFile:fileName];
    NSString *bottomStr = [self bottomString];
    NSString *randomIDStr = @"itcast";
    
    NSMutableData *dataM = [NSMutableData data];
    [dataM appendData:[topStr dataUsingEncoding:NSUTF8StringEncoding]];
    [dataM appendData:data];
    [dataM appendData:[bottomStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 1. Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
    
    // dataM出了作用域就会被释放,因此不用copy
    request.HTTPBody = dataM;
    
    // 2> 设置Request的头属性
    request.HTTPMethod = @"POST";
    
    // 3> 设置Content-Length
    NSString *strLength = [NSString stringWithFormat:@"%ld", (long)dataM.length];
    [request setValue:strLength forHTTPHeaderField:@"Content-Length"];
    
    // 4> 设置Content-Type
    NSString *strContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", randomIDStr];
    [request setValue:strContentType forHTTPHeaderField:@"Content-Type"];
    
    //    NSString *userToken = [RusultManage shareRusultManage].userToken;
    //    NSString *userToken = @"3";
    //    [request setValue:userToken forHTTPHeaderField:@"Authentication"];
    
    // 3> 连接服务器发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", result);
        
        if (data != nil) {
            NSError *error;
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"%@",error);
            success(resultDic);
        }
    }];
}

@end


