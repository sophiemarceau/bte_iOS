//
//  ZTYDistrabuteView.m
//  BTE
//
//  Created by wanmeizty on 17/9/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYDistrabuteView.h"

@interface ZTYDistrabuteView ()
@property (strong,nonatomic) UIView * redLine;
@end

@implementation ZTYDistrabuteView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"DEE1FF"];

        _currentWidth = 0;        
        UIView * redLine = [[UIView alloc] initWithFrame:CGRectMake(0, (frame.size.height - 2) * 0.5, SCREEN_WIDTH - 57, 2)];
        redLine.backgroundColor = [UIColor colorWithHexString:@"A2ABFF"];
        self.redLine = redLine;
        redLine.hidden = YES;
        self.userInteractionEnabled = NO;
        [self addSubview:redLine];
    }
    return self;
}

- (void)setRedLineWidth:(CGFloat)width{
    self.redLine.width = width;
}

- (void)hideLine:(BOOL)isHidden{
    self.redLine.hidden = isHidden;
}

@end
