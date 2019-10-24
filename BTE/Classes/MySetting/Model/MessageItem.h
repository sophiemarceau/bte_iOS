//
//  MessageItem.h
//  BTE
//
//  Created by sophie on 2018/10/19.
//  Copyright © 2018 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageItem : NSObject
@property (nonatomic, copy)   NSString *id;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *createTime;
@property (nonatomic, copy)   NSString *summary;
@property (nonatomic, copy)   NSString *content;
@property (nonatomic, copy)   NSString *redirectUrl;
@property (nonatomic, assign) BOOL isShow;
-(CGFloat)heightForRowWithisShow:(BOOL)isShow;
- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;
@end

NS_ASSUME_NONNULL_END
