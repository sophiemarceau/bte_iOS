//
//  CommontAndAnwerModel.m
//  BTE
//
//  Created by wanmeizty on 30/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "CommontAndAnwerModel.h"
#import "FormatUtil.h"
@implementation CommontAndAnwerModel

- (void)initWidthDict:(NSDictionary *)dict{
    self.comment = [self getdict:dict key:@"comment"];
    NSString * content = [self getdict:dict key:@"content"];
    self.content = content;
    self.icon = [self getdict:dict key:@"icon"];
    self.createTime = [self getdict:dict key:@"createTime"];
    self.postId = [self getdict:dict key:@"postId"];
    
    self.read = [self getdict:dict key:@"read"];
    self.userName = [self getdict:dict key:@"userName"];
    self.status = [self getdict:dict key:@"status"];
    self.userId = [self getdict:dict key:@"userId"];
    self.userName = [self getdict:dict key:@"userName"];
    self.replyId = [self getdict:dict key:@"id"];
    self.replyPostId = [self getdict:dict key:@"replyPostId"];
    UIFont * font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    CGSize sizeToFit = [FormatUtil getsizeWithText:content font:font width:(SCREEN_WIDTH - 61 - 16)];
    self.height = sizeToFit.height;
    
    
    self.heightOfw32 = [FormatUtil getsizeWithText:content font:font width:(SCREEN_WIDTH - 32)].height;
    
    if ([dict objectForKey:@"postReplyItemList"]) {
        NSArray * postReplyItemList = [dict objectForKey:@"postReplyItemList"];
        [self.postReplyItemList removeAllObjects];
        for (NSDictionary * subdict in postReplyItemList) {
            CommontAndAnwerModel * replyModel = [[CommontAndAnwerModel alloc] init];
            [replyModel initWidthDict:subdict];
            [self.postReplyItemList addObject:replyModel];
        }
    }
    
    self.sendUserName = [self getdict:dict key:@"sendUserName"];
    self.receiveUserName = [self getdict:dict key:@"receiveUserName"];
    self.receiveUserId = [self getdict:dict key:@"receiveUserId"];
    self.postReplyItemId = [self getdict:dict key:@"postReplyItemId"];
    self.postReplyId = [self getdict:dict key:@"postReplyId"];
    self.parentId = [self getdict:dict key:@"parentId"];
    self.lastReplyContent = [self getdict:dict key:@"lastReplyContent"];
    
    UIFont * font2 = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    
    CGSize sizeToFit2 = [FormatUtil getsizeWithText:self.lastReplyContent font:font2 width:(SCREEN_WIDTH - 32)];
    self.lastReplyContentHeight = sizeToFit2.height;
}

- (NSMutableArray *)postReplyItemList{
    if (!_postReplyItemList) {
        _postReplyItemList = [NSMutableArray arrayWithCapacity:0];
    }
    return _postReplyItemList;
}

@end
