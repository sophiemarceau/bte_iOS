//
//  ToolView.h
//  BTE
//
//  Created by sophiemarceau_qu on 2018/7/24.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectCallBack)(NSUInteger selectIndex);//回调跳转
typedef void(^CalcelCallBack)(void);//备用
@interface ToolView : UIView
- (instancetype)initToolView;
@property (nonatomic, copy) SelectCallBack selectCallBack;
@end
