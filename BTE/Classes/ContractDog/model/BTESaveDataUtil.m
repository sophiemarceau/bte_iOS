//
//  BTESaveDataUtil.m
//  BTE
//
//  Created by wanmeizty on 21/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTESaveDataUtil.h"

@implementation BTESaveDataUtil
//+ (void)saveKlineData:(NSDictionary *)dataDict key:(NSString *)dataKey{
////    //获取Library/Caches目录路径
////    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
//    //获取Library/Caches目录下的fileName文件路径
//    //    NSString *filePath = [path stringByAppendingPathComponent:fileName];
//    NSString * fileName = [self gotFilename];
//    NSMutableDictionary * saveDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    
//
//    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:fileName];
//    
//    if (dict) {
//        [saveDict setDictionary:dict];
//    }
//    [saveDict setObject:dataDict forKey:dataKey];
//    
//    NSLog(@"写入数据:%@--%@",fileName,@"");
//    BOOL write = [dataDict writeToFile:fileName atomically:YES];
//    NSLog(@"write===>%d",write);
//    
//    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chatRoom.plist"];
//    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//    //下边if判断很重要，不然会写入失败.
//    if (!userDict) {
//        userDict = [[NSMutableDictionary alloc] init];
//    }
//    //设置属性值
//    [userDict setObject:dataDict forKey:dataKey];
//    //写入文件
//    BOOL write2 = [userDict writeToFile:plistPath atomically:YES];
//    NSLog(@"write2==>%d",write2);
//}
//
//
//+ (NSDictionary *)gotDataDictKey:(NSString *)dataKey{
//    NSString * fileName = [self gotFilename];
//    NSDictionary * dict = [[NSDictionary alloc] initWithContentsOfFile:fileName];
//    
//    NSDictionary *dataDict = [dict objectForKey:dataKey];
//    NSLog(@"读取数据:fileName==%@--%@",fileName,dataDict);
//    return dataDict;
//}
//
//+ (NSString *)gotFilename{
//    
////    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
////    // 得到Document目录下的fileName文件的路径
////    NSString * fileName = [documentPath stringByAppendingPathComponent:@"kline"];
//    NSFileManager* fm = [NSFileManager defaultManager];
////    NSString * filePathName = [fileName stringByAppendingPathComponent:@"KdataKey.plist"];
//    //1.获取路径
//    NSString *filePathName=[NSString stringWithFormat:@"%@/Documents/dict.plist",NSHomeDirectory()];
//    
//    if (![fm fileExistsAtPath:filePathName]) {
//        BOOL create = [fm createFileAtPath:filePathName contents:nil attributes:nil];
//        NSLog(@"create==>%d",create);
//    }
//    return filePathName;
//}
//
+ (void)save:(NSDictionary *)personInfo key:(NSString *)dataKey{
    NSString * fileName = [self createPathWithKey:dataKey];
    BOOL writeSuccess = [personInfo writeToFile:fileName atomically:YES];
    if (writeSuccess) {
        NSLog(@"写入成功");
    }
}
+ (NSDictionary *)read:(NSString *)dataKey{
    NSString * fileName = [self createPathWithKey:dataKey];
    NSDictionary * dict = [[NSDictionary alloc] initWithContentsOfFile:fileName];
    return dict;
}

// 创建根路径
+ (NSString *)rootPath{
    NSString * root = [NSString stringWithFormat:@"%@/Documents/klinedata",NSHomeDirectory()];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:root isDirectory:&isDir];
    if (!(isDir && existed)) {
        // 在Document目录下创建一个archiver目录
        BOOL dis = [fileManager createDirectoryAtPath:root withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"dis===%d",dis);
    }
    return root;
}
// 创建文件
+ (NSString *)createPathWithKey:(NSString *)key{
    NSString * root = [self rootPath];
    NSString * filePathName = [root stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data",key]];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filePathName]) {
        BOOL create = [fm createFileAtPath:filePathName contents:nil attributes:nil];
        NSLog(@"create==>%d",create);
    }
    return filePathName;
}
// 归档数据
+ (void)achiveKlineDataDict:(NSDictionary *)dataDict key:(NSString *)dataKey{
    NSString * fileName = [self createPathWithKey:dataKey];
    
    CGFloat fileSize = [self folderSizeAtPath:[self rootPath]];
    NSLog(@"fileSize=======>%f",fileSize);
    if (fileSize > 10) {
        [self removeFileAtFilePath:[self rootPath]];
    }
    BOOL achive = [NSKeyedArchiver archiveRootObject:dataDict toFile:fileName];
    NSLog(@"achive==>%d",achive);
}
// 解档数据
+ (NSDictionary *)unachiverKlineDataKey:(NSString *)dataKey{
    
    NSString * fileName = [self createPathWithKey:dataKey];//[self gotFileName];
    NSDictionary * rootdict = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
//    NSDictionary * dataDict = [rootdict objectForKey:dataKey];
    return rootdict;
}

// 计算文件夹的大小
+ (float )folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    //从前向后枚举器
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

// 计算文件大小
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

// 移除文件
+ (void )removeFileAtFilePath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return ;
    //从前向后枚举器
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        [manager removeItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
    }
}

@end
