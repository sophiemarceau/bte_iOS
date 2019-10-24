//
//  CommontAndAnwerModel.h
//  BTE
//
//  Created by wanmeizty on 30/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommontAndAnwerModel : BTEBaseModel
// 评论
@property (copy,nonatomic) NSString * commont;
@property (copy,nonatomic) NSString * commontName;
@property (assign,nonatomic) CGFloat height;
@property (assign,nonatomic) BOOL isSpread;
@property (copy,nonatomic) NSString * comment;
@property (copy,nonatomic) NSString * content;
@property (copy,nonatomic) NSString * createTime;
@property (copy,nonatomic) NSString * icon;
@property (copy,nonatomic) NSString * replyId;
@property (copy,nonatomic) NSString * replyPostId;
@property (copy,nonatomic) NSString * postId;
@property (strong,nonatomic) NSMutableArray * postReplyItemList;
@property (copy,nonatomic) NSString * read;
@property (copy,nonatomic) NSString * status;
@property (copy,nonatomic) NSString * userId;
@property (copy,nonatomic) NSString * userName;

// 回复
@property (copy,nonatomic) NSString * sendUserName;
@property (copy,nonatomic) NSString * receiveUserName;
@property (copy,nonatomic) NSString * receiveUserId;
@property (copy,nonatomic) NSString * postReplyItemId;
@property (copy,nonatomic) NSString * postReplyId;
@property (copy,nonatomic) NSString * parentId;
@property (copy,nonatomic) NSString * lastReplyContent;

//评论
@property (assign,nonatomic) CGFloat lastReplyContentHeight;
@property (assign,nonatomic) CGFloat heightOfw32;

- (void)initWidthDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
