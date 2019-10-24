//
//  BTEOrderHeadView.m
//  BTE
//
//  Created by wanmeizty on 2018/7/23.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEOrderHeadView.h"

@implementation BTEOrderHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init{
    if (self = [super init]) {
        
        CGFloat height = 40;
        UILabel * timeLabel = [self createLabelFrame:CGRectMake(16, 0, 54 * SCREEN_WIDTH / 375.0 , height)];
        [self addSubview:timeLabel];
        
        UILabel * directionLabel = [self createLabelFrame:CGRectMake(70 * SCREEN_WIDTH / 375.0, 0, 75 * SCREEN_WIDTH / 375.0 , height)];
        [self addSubview:directionLabel];
        
        UILabel * priceLabel = [self createLabelFrame:CGRectMake(145 * SCREEN_WIDTH / 375.0, 0, 74 * SCREEN_WIDTH / 375.0 , height)];
        [self addSubview:priceLabel];
        
        UILabel * numLabel = [self createLabelFrame:CGRectMake(219 * SCREEN_WIDTH / 375.0, 0, 90 * SCREEN_WIDTH / 375.0 , height)];
        [self addSubview:numLabel];
        
        UILabel * statusLabel = [self createLabelFrame:CGRectMake(309 * SCREEN_WIDTH / 375.0, 0, 66 * SCREEN_WIDTH / 375.0 , height)];
        [self addSubview:statusLabel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        CGFloat height = frame.size.height;
        UILabel * timeLabel = [self createLabelFrame:CGRectMake(16, 0, 54 * SCREEN_WIDTH / 375.0 , height)];
        timeLabel.tag = 80;
        [self addSubview:timeLabel];
        
        UILabel * directionLabel = [self createLabelFrame:CGRectMake(70 * SCREEN_WIDTH / 375.0, 0, 75 * SCREEN_WIDTH / 375.0 , height)];
        directionLabel.tag = 81;
        [self addSubview:directionLabel];
        
        UILabel * priceLabel = [self createLabelFrame:CGRectMake(145 * SCREEN_WIDTH / 375.0, 0, 74 * SCREEN_WIDTH / 375.0 , height)];
        priceLabel.tag = 82;
        [self addSubview:priceLabel];
        
        UILabel * numLabel = [self createLabelFrame:CGRectMake(219 * SCREEN_WIDTH / 375.0, 0, 90 * SCREEN_WIDTH / 375.0 , height)];
        numLabel.tag = 83;
        [self addSubview:numLabel];
        
        UILabel * statusLabel = [self createLabelFrame:CGRectMake(309 * SCREEN_WIDTH / 375.0, 0, 66 * SCREEN_WIDTH / 375.0 , height)];
        statusLabel.tag = 84;
        [self addSubview:statusLabel];
    }
    return self;
}

-(void)setTitles:(NSArray *)tiles{
    int idx = 0;
    for (NSString * title in tiles) {
        UILabel * label = [self viewWithTag:(80 + idx)];
        label.text = title;
        idx ++;
    }
}

-(void)setTitlesCenter:(NSArray *)tiles{
    int idx = 0;
    CGFloat lwidth = SCREEN_WIDTH / (tiles.count * 1.0);
    for (NSString * title in tiles) {
        UILabel * label = [self viewWithTag:(80 + idx)];
        label.text = title;
        label.frame = CGRectMake(lwidth * idx, 0, lwidth, self.frame.size.height);
        label.textAlignment = NSTextAlignmentCenter;
        idx ++;
    }
}

- (void)setBigOrderTitle:(NSString *)title{
    UILabel * label = [self viewWithTag:84];
    label.text = title;
}

- (void)setBurnedOrderTitle:(NSString *)title{
    UILabel * label = [self viewWithTag:83];
    label.text = title;
}

- (UILabel *)createLabelFrame:(CGRect)frame{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColor colorWithHexString:@"525866" alpha:0.6];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    return label;
}

@end
