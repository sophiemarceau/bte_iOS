//
//  BTECommontModel.h
//  BTE
//
//  Created by wanmeizty on 29/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTECommontModel : BTEBaseModel
@property (copy,nonatomic) NSString * commontId;
@property (assign,nonatomic) NSInteger commontNum;
@property (assign,nonatomic) NSInteger shareNum;
@property (assign,nonatomic) NSInteger priaseNum;
@property (copy,nonatomic) NSString * content;
@property (copy,nonatomic) NSString * title;
@property (copy,nonatomic) NSString * authorName;
@property (copy,nonatomic) NSString * auditStatusId;
@property (copy,nonatomic) NSString * commentCount;
@property (copy,nonatomic) NSString * createTime;
@property (copy,nonatomic) NSString * hasLike;
@property (copy,nonatomic) NSString * likeCount;
@property (copy,nonatomic) NSString * userName;
@property (copy,nonatomic) NSString * shareCount;
@property (copy,nonatomic) NSString * userId;
@property (copy,nonatomic) NSString * status;
@property (copy,nonatomic) NSString * type;
@property (copy,nonatomic) NSString * newcomment;
@property (copy,nonatomic) NSString * newlike;
@property (copy,nonatomic) NSString * newshare;
@property (copy,nonatomic) NSString * postTime;
@property (copy,nonatomic) NSString * icon;
@property (assign,nonatomic) CGFloat heigth;
- (void)initWidthDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
