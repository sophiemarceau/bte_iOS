//
//  ZTYTradeDistrabuteView.h
//  BTE
//
//  Created by wanmeizty on 27/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTYTradeDistrabuteView : UIView
- (instancetype)initWithFrame:(CGRect)frame showCount:(int)count;
- (void)showDistrabute:(NSArray *)dataArray max:(CGFloat)maxvalue min:(CGFloat)minvalue left:(CGFloat)left;
@end
