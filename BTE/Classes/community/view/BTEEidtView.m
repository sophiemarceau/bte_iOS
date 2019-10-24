//
//  BTEEidtView.m
//  BTE
//
//  Created by wanmeizty on 29/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEEidtView.h"

@implementation BTEEidtView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(16, 10, SCREEN_WIDTH - 32, self.frame.size.height - 20)];
        bgview.backgroundColor = [UIColor colorWithHexString:@"626A75" alpha:0.06];
        bgview.userInteractionEnabled = NO;
        [self addSubview:bgview];
        
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, (bgview.height - 16) * 0.5, 16, 16)];
        imgView.image = [UIImage imageNamed:@"community_edit"];
        imgView.userInteractionEnabled = NO;
        [bgview addSubview:imgView];
        
        UILabel * labl = [[UILabel alloc] initWithFrame:CGRectMake(16 +12 + 16 + 9, 0, bgview.width - 53, bgview.height)];
        labl.text = @"说一说你在币圈令人奔溃的投资经历吧";
        labl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        labl.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
        labl.userInteractionEnabled = NO;
        [bgview addSubview:labl];
        
    }
    return self;
}

@end
