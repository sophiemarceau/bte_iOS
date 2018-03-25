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
    self.layer.masksToBounds = YES;
    bgview = [[UIView alloc] initWithFrame:CGRectMake(-2, 22, 10, 91)];
    bgview.backgroundColor = BHHexColor(@"DAE4F0");
    bgview.layer.masksToBounds = YES;
    bgview.layer.cornerRadius = 4;
    [self addSubview:bgview];
    
    bgview1 = [[UIView alloc] initWithFrame:CGRectMake(-2, 22, 10, 91)];
    bgview1.backgroundColor = BHHexColor(@"DAE4F0");
    bgview1.layer.masksToBounds = YES;
    bgview1.left = SCREEN_WIDTH - 8;
    bgview1.layer.cornerRadius = 4;
    [self addSubview:bgview1];
    
    bgview2 = [[UIView alloc] initWithFrame:CGRectMake(16, 0, 8, 129)];
    bgview2.backgroundColor = BHHexColor(@"5CACF3");
    bgview2.layer.masksToBounds = YES;
    bgview2.layer.cornerRadius = 6;
    [self addSubview:bgview2];
    
    bgview3 = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 32 - 2, 129)];
    bgview3.backgroundColor = KBGCell;
    bgview3.layer.masksToBounds = YES;
    bgview3.layer.cornerRadius = 6;
    bgview3.layer.borderColor = BHHexColor(@"CDD3D9").CGColor;
    bgview3.layer.borderWidth = 1;
    [self addSubview:bgview3];
    
    labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 16, bgview3.width - 32, 20)];
    labelTitle.textColor = BHHexColor(@"292C33");
    labelTitle.text = @"比特币价格跌至14502美元 下跌涨幅约25%";
    labelTitle.font = UIFontRegularOfSize(16);
    [bgview3 addSubview:labelTitle];
    
    labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(14, 44, bgview3.width - 32, 70)];
    labelTitle1.textColor = BHHexColor(@"525866");
    labelTitle1.numberOfLines = 0;
    labelTitle1.text = @"(12月22日 星期五 11:32) 在今天的交易时段，比特币价格最低为14502美元，较12月17日创下的19,783美元历史高点共下跌了约25%。..";
    labelTitle1.font = UIFontRegularOfSize(14);
    [bgview3 addSubview:labelTitle1];
}

- (void)setHomeProductModel:(HomeProductModel *)model
{
    labelTitle.text = model.title;
    labelTitle1.text = model.content;
}

@end
