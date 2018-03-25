//
//  BTEMarketNewsView.m
//  BTE
//
//  Created by wangli on 2018/3/25.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEMarketNewsView.h"

@implementation BTEMarketNewsView
- (instancetype)initViewWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
        
    }
    return self;
}

- (void)creatUI
{
    UIView *bgview = [[UIView alloc] initWithFrame:self.bounds];
    bgview.backgroundColor = [UIColor redColor];
    [self addSubview:bgview];
}

- (void)setHomeProductModel:(HomeProductModel *)model
{
    
}

@end
