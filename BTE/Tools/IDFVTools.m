//
//  IDFVTools.m
//  BTE
//
//  Created by wangli on 2018/5/14.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "IDFVTools.h"

@implementation IDFVTools
+ (NSString *)getIDFV

{
    //定义存入keychain中的账号 一个标识 表示是某个app存储的内容 bundle id最好
    NSString * const KEY_USERNAME = @"com.BTE.iosapp.username";
    NSString * const KEY_PASSWORD = @"com.BTE.iosapp.password";
    
    //测试用 清除keychain中的内容
    //[IDFVTools delete:KEY_USERNAME_PASSWORD];
    
    //读取账号中保存的内容
    NSMutableDictionary *readUserDataDic = (NSMutableDictionary *)[IDFVTools load:KEY_USERNAME];
    //NSLog(@"keychain==%@",readUserDataDic);
    
    
    if (!readUserDataDic)
    {//如果是第一次 肯定获取不到 这个时候就存储一个
        
        NSString *deviceIdStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//获取IDFV
        //NSLog(@"identifierStr==%@",identifierStr);
        
        NSMutableDictionary *needSaveDataDic = [NSMutableDictionary dictionaryWithObject:deviceIdStr forKey:KEY_PASSWORD];
        //进行存储 并返回这个数据
        [IDFVTools save:KEY_USERNAME data:needSaveDataDic];
        
        return deviceIdStr;
    }
    else{return [readUserDataDic objectForKey:KEY_PASSWORD];}
}

//储存
+ (void)save:(NSString *)service data:(id)data
{
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys: (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass, service, (__bridge id)kSecAttrService, service, (__bridge id)kSecAttrAccount, (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible, nil,nil];
}

//取出
+ (id)load:(NSString *)service
{
    id ret = nil;
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    //Configure the search setting
    
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
        @try
        {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *e)
        {NSLog(@"Unarchive of %@ failed: %@", service, e);}
        @finally
        {}
    }
    
    if (keyData)
        CFRelease(keyData);
    
    return ret;
}

//删除
+ (void)delete:(NSString *)service
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}
@end
