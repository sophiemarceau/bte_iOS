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
        defaultHeight = 59;
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    bgview3 = [[UIView alloc] initWithFrame:CGRectMake(21, 0, SCREEN_WIDTH - 21 * 2, 44 + 16 + defaultHeight)];
    bgview3.backgroundColor = KBGCell;
//    bgview3.layer.masksToBounds = YES;
    bgview3.layer.cornerRadius = 4;
//    bgview3.layer.borderColor = BHHexColor(@"EDF0F2").CGColor;
////    kColorRgba(43, 58, 72, 0.1).CGColor;
//    bgview3.layer.borderWidth = 1;
    
    bgview3.layer.shadowColor = BHHexColor(@"000000").CGColor;
//    kColorRgba(43, 58, 72, 0.2).CGColor;
    bgview3.layer.shadowRadius = 4;
    bgview3.layer.shadowOpacity = 0.1;
    bgview3.layer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用

    
    
    [self addSubview:bgview3];
    
    labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 16, bgview3.width - 32, 14)];
    labelTitle.textColor = BHHexColor(@"626A75");
    labelTitle.text = @"比特币价格跌至14502美元 下跌涨幅约25%";
    labelTitle.numberOfLines = 0;
//    labelTitle.backgroundColor = [UIColor redColor];
    labelTitle.font = UIFontMediumOfSize(14);
    [bgview3 addSubview:labelTitle];
    
    
    
    labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(14, labelTitle.bottom + 12, bgview3.width - 32, 12)];
    labelTitle2.textColor = BHHexColorAlpha(@"626A75",0.8);
//    BHHexColor(@"626A75");
    labelTitle2.text = @"比特币价格跌至14502美元 下跌涨幅约25%";
    labelTitle2.font = UIFontLightOfSize(12);
    labelTitle2.alpha = 0.8;
    [bgview3 addSubview:labelTitle2];
    
    
    labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(14, labelTitle2.bottom + 6, bgview3.width - 32, defaultHeight)];
    labelTitle1.textColor = BHHexColorAlpha(@"626A75",0.8);
//    BHHexColor(@"626A75");
    labelTitle1.numberOfLines = 0;
    labelTitle1.text = @"(12月22日 星期五 11:32) 在今天的交易时段，比特币价格最低为14502美元，较12月17日创下的19,783美元历史高点共下跌了约25%。..";
    labelTitle1.font = UIFontLightOfSize(13);
    [bgview3 addSubview:labelTitle1];
}

- (void)setHomeProductModel:(HomeProductModel *)model
{
    
    float height;
    
    if ([model.title isEqualToString:@""]) {
        labelTitle.hidden = YES;
        labelTitle2.top = 16;
        labelTitle1.top = labelTitle2.bottom + 6;
        height = 38 + 16;
    } else
    {
        labelTitle.hidden = NO;
       labelTitle.text = model.title;
        
        CGRect rect = [model.title boundingRectWithSize:CGSizeMake(labelTitle.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:UIFontMediumOfSize(14)} context:nil];
        
        if (model.isShow){
            if (rect.size.height > 20) {
                labelTitle.height = rect.size.height;
            } else
            {
                labelTitle.height = 14;
            }
        } else
        {
//            if (rect.size.height > 14) {
                labelTitle.height = 14;
//            } else
//            {
//                labelTitle.height = rect.size.height;
//            }
        }
        
        labelTitle2.top = labelTitle.bottom + 12;
        labelTitle1.top = labelTitle2.bottom + 6;
        if (model.isShow){
            if (rect.size.height > 20) {
                height = 64 + 16 - 14 + rect.size.height;
            } else
            {
                height = 64 + 16;
            }
            
        } else
        {
            
//            if (rect.size.height > 14) {
                height = 64 + 16;
//            } else
//            {
//                height = 64 + 16 - 14 + rect.size.height;
//            }
        }
    }
    labelTitle2.text = model.date;
    labelTitle1.text = model.content;
    
    CGRect rect = [model.content boundingRectWithSize:CGSizeMake(labelTitle1.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:UIFontLightOfSize(13)} context:nil];

    if (model.isShow) {
        labelTitle1.height = rect.size.height;
    } else
    {
        if (rect.size.height > defaultHeight) {
            labelTitle1.height = defaultHeight;
        } else
        {
            labelTitle1.height = rect.size.height;
        }
    }
    
    if (rect.size.height > defaultHeight) {
        
        if (model.isShow) {//是否展开
            self.height = height + rect.size.height;
            bgview3.height = self.height;
            bgview1.centerY = bgview3.centerY;
            bgview.centerY = bgview1.centerY;
        }else{
            self.height = height + defaultHeight;
            bgview3.height = self.height;
            bgview1.centerY = bgview3.centerY;
            bgview.centerY = bgview1.centerY;
        }
        if (arrowImage == nil) {
            arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(bgview3.width - 10 - 16, bgview3.height - 5 - 10, 10, 5)];
            
//            [bgview3 addSubview:arrowImage];
        }
        arrowImage.top = bgview3.height - 5 - 10;
        if (model.isShow) {//是否展开
            arrowImage.image = [UIImage imageNamed:@"home_retract"];
        }else{
            arrowImage.image = [UIImage imageNamed:@"home_more"];
        }
        arrowImage.hidden = NO;
    } else
    {
        self.height = height + defaultHeight;
        bgview3.height = height + defaultHeight;
        bgview1.centerY = bgview3.centerY;
        bgview.centerY = bgview1.centerY;
        arrowImage.hidden = YES;
    }
    
}

@end
