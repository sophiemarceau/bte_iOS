//
//  BTECommontModel.m
//  BTE
//
//  Created by wanmeizty on 29/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTECommontModel.h"
#import "FormatUtil.h"

@implementation BTECommontModel

- (void)initWidthDict:(NSDictionary *)dict{
    self.commontId = [self getdict:dict key:@"id"];
    self.icon = [self getdict:dict key:@"icon"];
    self.auditStatusId = [self getdict:dict key:@"auditStatusId"];
    self.content = [self getdict:dict key:@"content"];
    self.createTime = [self getdict:dict key:@"createTime"];
    self.hasLike = [self getdict:dict key:@"hasLike"];
    self.commentCount = [self getdict:dict key:@"commentCount"];
    self.likeCount = [self getdict:dict key:@"likeCount"];
    self.userName = [self getdict:dict key:@"userName"];
    self.shareCount = [self getdict:dict key:@"shareCount"];
    self.title = [self getdict:dict key:@"title"];
    self.newcomment = [self getdict:dict key:@"newComment"];
    self.newlike = [self getdict:dict key:@"newLike"];
    self.newshare = [self getdict:dict key:@"newShare"];
    self.userId = [self getdict:dict key:@"userId"];
    self.status = [self getdict:dict key:@"status"];
    self.type = [self getdict:dict key:@"type"];
    self.postTime = [self getdict:dict key:@"postTime"];
    
    UIFont * font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    CGSize sizeToFit = [FormatUtil getsizeWithText:self.content font:font width:(SCREEN_WIDTH - 32)];
    if (sizeToFit.height > 75) {
        self.heigth = 75;
    }else{
        self.heigth = sizeToFit.height;
    }
}

@end
