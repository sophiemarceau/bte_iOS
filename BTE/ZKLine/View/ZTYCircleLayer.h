//
//  ZTYCircleLayer.h
//  BTE
//
//  Created by wanmeizty on 2018/6/25.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface ZTYCircleLayer : CAShapeLayer

@property (nonatomic,assign) NSInteger tag;

@property (nonatomic,assign) NSInteger timestanp;

- (void)setCirleFrame:(CGRect)frame;

@end

