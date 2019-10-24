//
//  UserCacheManager.m
//  mt
//
//  Created by martin on 16/10/24.
//  Copyright © 2016 martin. All rights reserved.
//

#import "UserCacheManager.h"
#import "FMDB.h"
#import "NetWorking.h"
#import "AFHTTPSessionManager+Synchronous.h"
#import "PhoneInfo.h"

// ---------------线程----------------------------------------------
#define kBgQueue    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kMainQueue  dispatch_get_main_queue()
#define EXE_ON_MAIN_THREAD(function)\
dispatch_async(kBgQueue, ^{\
dispatch_sync(kMainQueue, ^{function;});\
});\
// ---------------线程---end-------------------------------------------

#define DBNAME @"user_cache_data.db"
static FMDatabaseQueue *_queue;

@implementation UserCacheInfo

@end

@implementation UserCacheManager

+(void)initialize{
    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:DBNAME];
    
    _queue = [FMDatabaseQueue databaseQueueWithPath:fileName];
    [_queue inDatabase:^(FMDatabase *db) {
        // userid 环信ID，username 用户昵称，userimage 用户头像完整路径
        [db executeUpdate:@"create table if not exists userinfo (userid text, username text, userimage text, expired_time text)"];
    }];
}

/**
 *  执行一个更新语句
 *
 *  @param sql 更新语句的sql
 *
 *  @return 更新语句的执行结果
 */
+(BOOL)executeUpdate:(NSString *)sql{
    
    __block BOOL updateRes = NO;
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        updateRes = [db executeUpdate:sql];
    }];
    
    return updateRes;
}


/**
 *  执行一个查询语句
 *
 *  @param sql              查询语句sql
 *  @param queryResBlock    查询语句的执行结果
 */
+(void)executeQuery:(NSString *)sql queryResBlock:(void(^)(FMResultSet *set))queryResBlock{
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:sql];
        
        if(queryResBlock != nil) queryResBlock(set);
        
    }];
}

/**
 *  用户是否存在
 *
 *  @param userId 用户环信ID
 *
 *  @return 是否存在
 */
+(BOOL)isExisted:(NSString *)userId{
    
    NSString *alias=@"count";
    
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) AS %@ FROM userinfo where userid = '%@'", alias, userId];
    
    __block NSUInteger count=0;
    
    [self executeQuery:sql queryResBlock:^(FMResultSet *set) {
        
        while ([set next]) {
            
            count = [[set stringForColumn:alias] integerValue];
        }
    }];
    
    return count > 0;
}


/**
 判断缓存中的用户是否过期
 @param userId 用户环信id
 @return 是否过期
 */
+(BOOL)isExpired:(NSString*)userId{
    BOOL isExpired = NO;
    
    UserCacheInfo *user = [self getFromCache:userId];
    if(!user) return YES;
    
    NSDate *currDate = [NSDate date];
    long long currMill = (long long)([currDate timeIntervalSince1970]);
    if (currMill > user.expiredDate) {
        isExpired = YES;
    }
    
    return  isExpired;
}


/**
 用户不存在或已过期

 @param userId 环信ID
 @return 是否存在
 */
+(BOOL)notExistedOrExpired:(NSString*)userId{
    return (![self isExisted:userId] || [self isExpired:userId]);
}

/**
 清除数据
 @return 是否成功
 */
+(BOOL)clearData{
    
    BOOL isSucc = [self executeUpdate:@"DELETE FROM userinfo"];
    [self executeUpdate:@"DELETE FROM sqlite_sequence WHERE name='userinfo';"];
    return isSucc;
}


/**
 保存（新增或更新）用户信息
 @param userId 用户环信ID
 @param avatarUrl 头像Url
 @param nickName 昵称
 */
+(void)save:(NSString*)userId
  avatarUrl:(NSString*)avatarUrl
   nickName:(NSString*)nickName{
    
    if(!userId) return;
    
    NSString *sql = @"";
    
    // 过期时间
    NSDate *currDate = [NSDate date];
    static int timeOut = 24 * 60 * 60;// 缓存一天，可以根据项目需要更改缓存时间。单位：秒
    long long currMillis = ((long long)([currDate timeIntervalSince1970])) + timeOut;
    NSString *strTime = [NSString stringWithFormat:@"%lld", currMillis];
    
    BOOL isExisted = [self isExisted:userId];
    if (isExisted) {
        sql = [NSString stringWithFormat:@"update userinfo set username='%@', userimage='%@', expired_time='%@' where userid='%@'", nickName,avatarUrl, strTime,userId];
    }else{
        sql = [NSString stringWithFormat:@"INSERT INTO userinfo (userid, username, userimage, expired_time) VALUES ('%@', '%@', '%@', '%@')", userId,nickName,avatarUrl,strTime];
    }
    
    [self executeUpdate:sql];
    
#if DEBUG
//    [self queryAll];
#endif
}

/**
 保存（新增或更新）用户信息
 @param jsonStr 昵称和头像的json字符串
 */
+(void)saveWithJson:(NSString *)jsonStr{
    if(!jsonStr) return;
    
    NSData *extData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *extDic = [NSJSONSerialization JSONObjectWithData:extData options:0 error:nil];
    
    [self save:extDic];
}

/**
 保存（新增或更新）用户信息
 @param userinfo 昵称和头像
 */
+(void)save:(NSDictionary *)userinfo{
    NSString *userid = [userinfo objectForKey:kChatUserId];
    NSString *username = [userinfo objectForKey:kChatUserNick];
    NSString *userimage = [userinfo objectForKey:kChatUserPic];
    
    [self save:userid avatarUrl:userimage nickName:username];
}


/**
 列出所有用户信息
 */
+(void)queryAll{
    NSString *sql = @"SELECT userid, username, userimage FROM userinfo";
    [self executeQuery:sql queryResBlock:^(FMResultSet *rs) {
        int i=0;
        while ([rs next]) {
            NSLog(@"%d：-------",i);
            NSLog(@"id：%@",[rs stringForColumn:@"userid"]);
            NSLog(@"name：%@",[rs stringForColumn:@"username"]);
            NSLog(@"image：%@",[rs stringForColumn:@"userimage"]);
            NSLog(@"%d：---end--",i);
            i++;
        }
        [rs close];
    }];
}

/**
 更新当前用户的昵称
 @param nickName 昵称
 */
+(void)updateMyNick:(NSString*)nickName{
    UserCacheInfo *user = [self myInfo];
    if (!user)  return;
    
    [self save:user.userId avatarUrl:user.avatarUrl nickName:nickName];
}

/**
 更新当前用户的头像
 @param avatarUrl 头像Url（完成路径）
 */
+(void)updateMyAvatar:(NSString*)avatarUrl{
    UserCacheInfo *user = [self myInfo];
    if (!user)  return;
    
    [self save:user.userId avatarUrl:avatarUrl nickName:user.nickName];
}

/**
 根据环信ID获取用户信息
 从缓存里获取，如果缓存中不存在（或者过期），则同时从app服务器中获取用户信息缓存到本地，等下次显示的时候再调用
 @param userid 用户的环信ID
 @return 用户信息
 */
+(UserCacheInfo*)getUserInfo:(NSString *)userid{
    __block UserCacheInfo *userInfo = nil;
    // 如果本地缓存不存在或者过期，则从存储服务器获取
    if ([self notExistedOrExpired:userid]) {
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        [pramaDic setObject:userid forKey:@"username"];
        PhoneInfo * phone = [[PhoneInfo alloc] init];
        NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:pramaDic];
        [params setObject:kCurrentVersion forKey:@"version"];
        [params setObject:@"ios" forKey:@"channel"];
        [params setObject:phone.phoneVersion forKey:@"sdkVersionName"];
        [params setObject:phone.phoneVersion forKey:@"sdkVersionCode"];
        [params setObject:@"iphone" forKey:@"Brand"];
        [params setObject:phone.platform forKey:@"Model"];
        NSString * methodName = @"";
        methodName = kHXgetUserInfo;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                  @"text/html",
                                                                                  @"text/json",
                                                                                  @"text/plain",
                                                                                  @"text/javascript",
                                                                                  @"text/xml",
                                                                                  @"image/*"]];
        //https ssl 验证。
//        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"mbtetop" ofType:@"cer"];//证书的路径
//        NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
//
//        // AFSSLPinningModeCertificate 使用证书验证模式
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//        // 如果是需要验证自建证书，需要设置为YES
//        securityPolicy.allowInvalidCertificates = YES;
//
//        //validatesDomainName 是否需要验证域名，默认为YES;
//        //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//        //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//        //如置为NO，建议自己添加对应域名的校验逻辑。
//        securityPolicy.validatesDomainName = NO;
//
//        securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
//
//        [manager setSecurityPolicy:securityPolicy];
        dispatch_async(dispatch_queue_create(0, 0), ^{
            // 子线程执行任务（比如获取较大数据）
            NSError *error = nil;
            id responseObject = [manager syncPOST:methodName
                                       parameters:pramaDic
                                             task:NULL
                                            error:&error];
            NSLog(@"syncPOST=>%@",responseObject);
            if (IsSafeDictionary(responseObject)) {
                
                NSString *nickName = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"result"][@"nickName"]];
                NSString *headImage = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"result"][@"headImage"]];
                
                NSDictionary *userDic = @{
                                          kChatUserId:userid,
                                          kChatUserNick:nickName,
                                          kChatUserPic:headImage
                                          };
                [self save:userDic];
            }
        });
    }
    // 从本地缓存中获取用户数据
    userInfo = [self getFromCache:userid];
    return userInfo;
}

/*
 *根据环信ID获取用户信息
 *userId 用户的环信ID
 */
+(UserCacheInfo*)getFromCache:(NSString *)userid{
    
    __block UserCacheInfo *userInfo = nil;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT userid, username, userimage,expired_time FROM userinfo where userid = '%@'",userid];
    [self executeQuery:sql queryResBlock:^(FMResultSet *rs) {
        if ([rs next]) {
            
            userInfo = [[UserCacheInfo alloc] init];
            
            userInfo.userId = [rs stringForColumn:@"userid"];
            userInfo.nickName = [rs stringForColumn:@"username"];
            userInfo.avatarUrl = [rs stringForColumn:@"userimage"];
            userInfo.expiredDate = [[rs stringForColumn:@"expired_time"] longLongValue];
        }
        [rs close];
    }];
    
    return userInfo;
}

/*!
 获取用户信息
 @param userId                  用户环信ID
 @param completed               获取用户信息完成之后需要执行的Block
 @param userInfo(in completed) 该用户ID对应的用户信息。
 */
+ (void)getUserInfo:(NSString *)userId
          completed:(void (^)(UserCacheInfo *userInfo))completed{
    
    __block UserCacheInfo *userInfo = nil;
    
    // 如果本地缓存存在，且数据没有过期，则从缓存获取
    if (![self notExistedOrExpired:userId]) {
        
        // 从本地缓存中获取用户数据
        dispatch_async(kBgQueue, ^{
            userInfo = [self getFromCache:userId];
            dispatch_async(kMainQueue, ^{
                completed(userInfo);
            });
        });
        
    }else{// 否则从APP服务器获取信息
        dispatch_async(dispatch_queue_create(0, 0), ^{
            NSMutableDictionary * pramaDic = @{}.mutableCopy;
            [pramaDic setObject:userId forKey:@"username"];
            NSString * methodName = @"";
            methodName = kHXgetUserInfo;
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                      @"text/html",
                                                                                      @"text/json",
                                                                                      @"text/plain",
                                                                                      @"text/javascript",
                                                                                      @"text/xml",
                                                                                      @"image/*"]];
            //https ssl 验证。
//            NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"mbtetop" ofType:@"cer"];//证书的路径
//            NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
//            
//            // AFSSLPinningModeCertificate 使用证书验证模式
//            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//            // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//            // 如果是需要验证自建证书，需要设置为YES
//            securityPolicy.allowInvalidCertificates = YES;
//            
//            //validatesDomainName 是否需要验证域名，默认为YES;
//            //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//            //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//            //如置为NO，建议自己添加对应域名的校验逻辑。
//            securityPolicy.validatesDomainName = NO;
//            
//            securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
//            
//            [manager setSecurityPolicy:securityPolicy];
            // 子线程执行任务（比如获取较大数据）
            NSError *error = nil;
            id responseObject = [manager syncPOST:methodName
                                       parameters:pramaDic
                                             task:NULL
                                            error:&error];
            NSLog(@"syncPOST=>%@",responseObject);
            if (IsSafeDictionary(responseObject)) {
                
                NSString *nickName = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"result"][@"nickName"]];
                NSString *headImage = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"result"][@"headImage"]];
                // 缓存到本地
                
                NSDictionary *userDic = @{
                                          kChatUserId:userId,
                                          kChatUserNick:nickName,
                                          kChatUserPic:headImage
                                          };
                [self save:userDic];
                
                userInfo = [[UserCacheInfo alloc] init];
                
                userInfo.userId =userId;
                userInfo.nickName = nickName;
                userInfo.avatarUrl = headImage;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completed(userInfo);
            });
            
        });
    }
}

/**
 根据环信ID获取昵称
 @param userId 用户的环信ID
 @return 昵称
 */
+(NSString*)getNickName:(NSString*)userId{
    UserCacheInfo *user = [UserCacheManager getUserInfo:userId];
    if(user == nil || [user  isEqual: @""]) return userId;// 没有昵称就返回用户环信ID
    
    return user.nickName;
}

/**
 获取当前环信用户信息
 @return 头像昵称
 */
+(UserCacheInfo*)myInfo{
    return [UserCacheManager getFromCache:kCurrEaseUserId];
}

/**
 获取当前环信用户的昵称
 @return 昵称
 */
+(NSString*)myNickName{
    return [UserCacheManager getNickName:kCurrEaseUserId];
}

/**
获取登录用户的消息扩展属性
 
 @param msgExt 消息原有的扩展属性
 @return 重新组合的扩展属性
 */
+(NSMutableDictionary*)getMyMsgExt{
    return [self getMyMsgExt:@{}];
}

/**
重新设置登录用户的消息扩展属性

 @param msgExt 消息原有的扩展属性
 @return 重新组合的扩展属性
 */
+(NSMutableDictionary*)getMyMsgExt:(NSDictionary *)msgExt{
    UserCacheInfo *user = [UserCacheManager myInfo];
    NSMutableDictionary *extDic = [NSMutableDictionary dictionaryWithDictionary:msgExt];
    [extDic setValue:user.userId forKey:kChatUserId];
    [extDic setValue:user.avatarUrl forKey:kChatUserPic];
    [extDic setValue:user.nickName forKey:kChatUserNick];
    return extDic;
}

// 设置头像控件
+(void)setUserAvatar:(NSString*)userId
           imageView:(UIImageView*)imageView{
    [self setUserView:userId nickLabel:nil imageView:imageView];
}

// 设置昵称控件
+(void)setUserNick:(NSString*)userId
          nickLabel:(UILabel*)nameLabel{
    [self setUserView:userId nickLabel:nameLabel imageView:nil];
}


// 设置头像昵称控件
+(void)setUserView:(NSString*)userId
               nickLabel:(UILabel*)nameLabel
               imageView:(UIImageView*)imageView{
    
    [self getUserInfo:userId completed:^(UserCacheInfo *userInfo) {
        if (userInfo) {
            [nameLabel setText:userInfo.nickName];
            [imageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatarUrl]
                         placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
        } else {
            [nameLabel setText:userId];
            imageView.image = [UIImage imageNamed:@"chatListCellHead"];
        }
    }];
}

@end
