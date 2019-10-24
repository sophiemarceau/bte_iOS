//
//  ChatUserCacheUtil.h
//  BTE
//
//  Created by sophiemarceau_qu on 2018/7/20.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTEUserInfo.h"
@interface ChatUserCacheInfo : NSObject
@property(nonatomic,copy)NSString* Id;
@property(nonatomic,copy)NSString* NickName;
@property(nonatomic,copy)NSString* AvatarUrl;
@end
@interface ChatUserCacheUtil : NSObject

+ (ChatUserCacheUtil *)shareInstance;

-(ChatUserCacheInfo *)saveInfo:(NSString *)userId
                    headURLStr:(NSString*)headImage
                      nickName:(NSString*)nickName;

-(void)saveDict:(NSDictionary *)userinfo;

//-(void)saveModel:(BTEUserInfo *)user;

-(ChatUserCacheInfo*)queryById:(NSString *)userid;

//通过自己Id获取自己的用户信息
- (void)getUserInfo:(NSString *)userId completion:(void (^)(ChatUserCacheInfo *))completion;
@end
