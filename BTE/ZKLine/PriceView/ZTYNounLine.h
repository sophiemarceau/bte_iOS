//
//  ZTYNounLine.h
//  ZTYNounLineView
//
//  Created by wanmeizty on 2018/6/13.
//  Copyright © 2018年 wanmeizty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTYNounLine : UIView

@property (nonatomic,strong) UIColor * strokeColor;

@property (nonatomic,assign) CGFloat lineWidth;

/**
 * points 包含的所有y坐标的点number类型
 */
- (void)setNounlinewidthNouns:(NSArray *)points;

@end
