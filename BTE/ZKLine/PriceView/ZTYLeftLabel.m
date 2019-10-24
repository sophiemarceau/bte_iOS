//
//  ZTYLeftLabel.m
//  BTE
//
//  Created by wanmeizty on 2018/6/15.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYLeftLabel.h"

@implementation ZTYLeftLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    if (self = [super init]) {
        _leftDistance = 10;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _leftDistance = 10;
    }
    return self;
}

- (void)setLeftDistance:(CGFloat)leftDistance{
    
    if (leftDistance < 0) {
        _leftDistance = 0;
    }else{
        _leftDistance = leftDistance;
    }
    [self drawTextInRect:self.bounds];
}

- (void)drawTextInRect:(CGRect)rect{
    UIEdgeInsets insets = {0, _leftDistance, 0, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
