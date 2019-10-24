//
//  WLNetworkErrorView.h
//  WangliBank
//
//  Created by xuehan on 16/6/16.
//  Copyright © 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BHNetworkErrorViewDelegate <NSObject>

@optional
- (void)networkErrorViewdidCLickReloadData;

@end

@interface BHNetworkErrorView : UIView

@property (nonatomic,weak) id<BHNetworkErrorViewDelegate> delegate;

+ (instancetype)networkErrorViewWithFrame:(CGRect)frame delegate:(id<BHNetworkErrorViewDelegate>)delegate;

@end
