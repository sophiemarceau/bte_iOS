//
//  ZYWPriceView.m
//  ZYWChart
//
//  Created by 张有为 on 2017/04/30.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWPriceView.h"

@implementation ZYWPriceView

-(UILabel *)maxPriceLabel
{
    if (!_maxPriceLabel)
    {
        _maxPriceLabel = [self createLabel];
        [self addSubview:_maxPriceLabel];
        [_maxPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self);
//            make.right.equalTo(self);
            make.width.equalTo(@(self.frame.size.width - 10));
            
        }];
    }
    return _maxPriceLabel;
}

-(UILabel *)maxMiddlePriceLabel
{
    if (!_maxMiddlePriceLabel)
    {
        _maxMiddlePriceLabel = [self createLabel];
        [self addSubview:_maxMiddlePriceLabel];
        [_maxMiddlePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
//            make.right.equalTo(self);
            make.width.equalTo(@(self.frame.size.width - 10));
            make.top.equalTo(@(self.frame.size.height * 0.25 -5));
            make.height.equalTo(@(10));
            
        }];
    }
    return _maxMiddlePriceLabel;
}

-(UILabel *)middlePriceLabel
{
    if (!_middlePriceLabel)
    {
        _middlePriceLabel = [self createLabel];
        [self addSubview:_middlePriceLabel];
        [_middlePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.left.equalTo(self);
//            make.right.equalTo(self);
            make.width.equalTo(@(self.frame.size.width - 10));
            
//            make.left.equalTo(self);
//            make.top.equalTo(@(self.frame.size.height * 0.5-5));
        }];
    }
    return _middlePriceLabel;
}

-(UILabel *)minMiddlePriceLabel
{
    if (!_minMiddlePriceLabel)
    {
        _minMiddlePriceLabel = [self createLabel];
        [self addSubview:_minMiddlePriceLabel];
        [_minMiddlePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(@(self.frame.size.height * 0.75 - 10));
//            make.right.equalTo(self);
            make.width.equalTo(@(self.frame.size.width - 10));

        }];
        
    }
    return _minMiddlePriceLabel;
}

-(UILabel *)minPriceLabel
{
    if (!_minPriceLabel)
    {
        _minPriceLabel = [self createLabel];
        [self addSubview:_minPriceLabel];
        [_minPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.equalTo(self);
            make.width.equalTo(@(self.frame.size.width - 10));
            
        }];
    }
    return _minPriceLabel;
}

-(UILabel*)createLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"626A75"];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    label.adjustsFontSizeToFitWidth=YES;
    label.minimumScaleFactor=0.5;
//    [label sizeToFit];
    return label;
}

@end
