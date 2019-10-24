//
//  ChatUserCacheUtil.m
//  BTE
//
//  Created by sophiemarceau_qu on 2018/7/20.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ChatUserCacheUtil.h"
#import "ChatUserCacheUtil.h"
#import "FMDB.h"

#define DBNAME @"cache_data.db"
#define kChatUserId @"ChatUserId"// 环信账号
#define kChatUserNick @"ChatUserNick"
#define kChatUserPic @"ChatUserPic"
@implementation ChatUserCacheInfo

@end

@implementation ChatUserCacheUtil


+ (ChatUserCacheUtil *)shareInstance {
    static ChatUserCacheUtil *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}


-(void)createTable:(FMDatabase *)db
{
    if ([db open]) {
        if (![db tableExists :@"userinfo"]) {
            if ([db executeUpdate:@"create table userinfo (userid text, username text, userimage text)"]) {
                NSLog(@"create table success");
            }else{
                NSLog(@"fail to create table");
            }
        }else {
            NSLog(@"table is already exist");
        }
    }else{
        NSLog(@"fail to open");
    }
}

- (void)clearTableData:(FMDatabase *)db
{
    if ([db executeUpdate:@"DELETE FROM userinfo"]) {
        NSLog(@"clear successed");
    }else{
        NSLog(@"fail to clear");
    }
}

-(FMDatabase*)getDB{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath   = [docsPath stringByAppendingPathComponent:DBNAME];
    FMDatabase *db     = [FMDatabase databaseWithPath:dbPath];
    [self createTable:db];
    return db;
}

//-(void)saveModel:(BTEUserInfo *)user{
//    [self saveInfo:user.hxuserName headURLStr:user.hxuserName nickName:user.nickName];
//}

-(ChatUserCacheInfo *)saveInfo:(NSString *)userId headURLStr:(NSString*)headImage nickName:(NSString*)nickName{
    ChatUserCacheInfo *userInfo = [[ChatUserCacheInfo alloc] init];
    
    userInfo.Id = userId;
    userInfo.NickName = nickName;
    userInfo.AvatarUrl = headImage;
    
    NSMutableDictionary *extDic = [NSMutableDictionary dictionary];
    [extDic setValue:userId forKey:kChatUserId];
    [extDic setValue:headImage forKey:kChatUserPic];
    [extDic setValue:nickName forKey:kChatUserNick];
    
    [self saveDict:extDic];
    
    return userInfo;
}

-(void)saveDict:(NSDictionary *)userinfo{
    FMDatabase *db = [self getDB];
    
    NSString *userid = [userinfo objectForKey:kChatUserId];
    if ([db executeUpdate:@"DELETE FROM userinfo where userid = ?", userid]) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
    NSString *username = [userinfo objectForKey:kChatUserNick];
    NSString *userimage = [userinfo objectForKey:kChatUserPic];
    if ([db executeUpdate:@"INSERT INTO userinfo (userid, username, userimage) VALUES (?, ?, ?)", userid,username,userimage]) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }
    
    //    NSLog(@"%d: %@", [db lastErrorCode], [db lastErrorMessage]);
    FMResultSet *rs = [db executeQuery:@"SELECT userid, username, userimage FROM userinfo where userid = ?",userid];
    if ([rs next]) {
        NSString *userid = [rs stringForColumn:@"userid"];
        NSString *username = [rs stringForColumn:@"username"];
        NSString *userimage = [rs stringForColumn:@"userimage"];
        NSLog(@"查询一个 %@ %@ %@",userid,username,userimage);
    }
    
    rs = [db executeQuery:@"SELECT userid, username, userimage FROM userinfo"];
    while ([rs next]) {
        NSString *userid = [rs stringForColumn:@"userid"];
        NSString *username = [rs stringForColumn:@"username"];
        NSString *userimage = [rs stringForColumn:@"userimage"];
        NSLog(@"查询所有 %@ %@ %@",userid,username,userimage);
    }
    [rs close];
    //    NSLog(@"%d: %@", [db lastErrorCode], [db lastErrorMessage]);
    [db close];
    
}

-(ChatUserCacheInfo*)queryById:(NSString *)userid{
    FMDatabase *db  = [self getDB];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:@"SELECT userid, username, userimage FROM userinfo where userid = ?",userid];
        if ([rs next]) {
            ChatUserCacheInfo *userInfo = [[ChatUserCacheInfo alloc] init];
            
            userInfo.Id = [rs stringForColumn:@"userid"];
            userInfo.NickName = [rs stringForColumn:@"username"];
            userInfo.AvatarUrl = [rs stringForColumn:@"userimage"];
            NSLog(@"查询一个 %@",userInfo);
            return userInfo;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

//通过自己Id获取自己的用户信息
//1先查询本地 本地有 怎返回 用户信息
//2如果本地没有 去服务器去请求 如果返回成功 插入保存到本地 再最后返回 用户信息
//3 如果网络上也没有 或者网络请求失败则返回 nil
- (void)getUserInfo:(NSString *)userId completion:(void (^)(ChatUserCacheInfo *))completion{
    __block ChatUserCacheInfo *user;
    user = [[ChatUserCacheUtil shareInstance] queryById:userId];
    if (user) {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(user);
            });
        }
    }else{
        NSMutableDictionary * pramaDic = @{}.mutableCopy;
        [pramaDic setObject:userId forKey:@"username"];
        NSString * methodName = @"";
        methodName = kHXgetUserInfo;
        [BTERequestTools requestWithURLString:methodName parameters:pramaDic type:2 success:^(id responseObject) {
           
            if (IsSafeDictionary(responseObject)) {
//                ChatUserCacheInfo *responUser = [ChatUserCacheInfo yy_modelWithDictionary:responseObject[@"data"][@"result"]];
                
                NSString *hxuserName = [NSString stringWithFormat:@"%ld",[responseObject[@"data"][@"result"][@"userId"] integerValue]] ;
                NSString *nickName = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"result"][@"nickName"]];
                NSString *headImage = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"result"][@"headImage"]];
                ChatUserCacheInfo *userInfo = [[ChatUserCacheUtil shareInstance] saveInfo:hxuserName headURLStr:headImage nickName:nickName];
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         NSLog(@"getUserInfo------completion-AvatarUrl---kHXgetUserInfo---->%@",userInfo.AvatarUrl);
                        NSLog(@"getUserInfo------completion-NickName---kHXgetUserInfo---->%@",userInfo.NickName);
                        completion(userInfo);
                    });
                }
            }else{
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(user);
                    });
                }
            }
        } failure:^(NSError *error) {
            NSLog(@"failure------error----kHXgetUserInfo---->%@",error);
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(user);
                });
            }
        }];
    }
}
@end
