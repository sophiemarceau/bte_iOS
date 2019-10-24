//
//  ChatViewController.h
//  BTE
//
//  Created by sophie on 2018/6/27.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "EaseMessageViewController.h"
@protocol ChatDelegate <NSObject>
-(void)gotoSuperViewTop;
@end
@interface ChatViewController : EaseMessageViewController
@property(nonatomic,strong)NSString *groupName;

@property (nonatomic,copy) NSString * base;
@property (nonatomic,copy) NSString * quote;
@property (nonatomic,copy) NSString * exchange;


@property (nonatomic,strong)UIButton *topImageView;


@property(nonatomic,weak) id <ChatDelegate>chatdelegate;
- (void)startChat;
@end
