//
//  AddNickHeaderView.h
//  BTE
//
//  Created by sophie on 2018/7/17.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ConfirmCallBack)(BOOL isComplete,NSString *chatRoomId);
//typedef void(^CalcelCallBack)(void);//备用
@interface AddNickHeaderView : UIView
- (instancetype)initAddNickHeadView;
@property (nonatomic,copy)NSString *roomName;
@property (nonatomic,copy)ConfirmCallBack confirmCallBack;
//@property (nonatomic,copy)CalcelCallBack calcelCallBack;
@end
