//
//  StrategyFollowTableViewCell.m
//  BTE
//
//  Created by wangli on 2018/3/24.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "StrategyFollowTableViewCell.h"
@implementation StrategyFollowTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = KBGCell;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(16, 16, SCREEN_WIDTH - 36, 198 - 16)];
        _bgView.backgroundColor = BHHexColor(@"F0F8FF");
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 4;
        [self.contentView addSubview:_bgView];
        
        UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(16, 28, 32, 36)];
        [_bgView addSubview:image2];
        
        _titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(64, 24, 180, 20)];
        
        _titleLabel2.font = UIFontRegularOfSize(16);
        _titleLabel2.textColor = BHHexColor(@"292C33");
        [_bgView addSubview:_titleLabel2];
        
        _titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(64, 48, 180, 21)];
        
        _titleLabel3.numberOfLines = 0;
        _titleLabel3.font = UIFontRegularOfSize(14);
        _titleLabel3.textColor = BHHexColor(@"525866");
        [_titleLabel3 sizeToFit];
        [_bgView addSubview:_titleLabel3];
        
        UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(16, 25, 24, 24)];
        bgView1.backgroundColor = [UIColor clearColor];
        bgView1.left = _bgView.width - 24 - 16;
        bgView1.layer.masksToBounds = YES;
        bgView1.layer.cornerRadius = 4;
        bgView1.layer.borderWidth = 2;
        
        [_bgView addSubview:bgView1];
        
        _titleLabel7 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        _titleLabel7.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel7.font = UIFontRegularOfSize(20);
        
        
        [bgView1 addSubview:_titleLabel7];
        
        
        
        
        _titleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(64, 56, 60, 14)];
        _titleLabel4.left = _bgView.width - 60 - 16;
        _titleLabel4.textAlignment = NSTextAlignmentRight;
        _titleLabel4.text = @"风险";
        _titleLabel4.font = UIFontRegularOfSize(12);
        _titleLabel4.textColor = BHHexColor(@"7A8499");
        [_bgView addSubview:_titleLabel4];
        
        UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(16, 93, _bgView.width - 32, 1)];
        bgView2.backgroundColor = BHHexColor(@"E6EBF0");
        [_bgView addSubview:bgView2];
        
        
        UILabel *titleLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(16, 108, 160, 12)];
        titleLabel6.text = @"累计收益率：";
        titleLabel6.font = UIFontRegularOfSize(12);
        titleLabel6.textColor = BHHexColor(@"525866");
        [_bgView addSubview:titleLabel6];
        
        _titleLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(16, 104, 160, 20)];
        _titleLabel5.left = _bgView.width - 160 - 16;
        _titleLabel5.textAlignment = NSTextAlignmentRight;
        
        _titleLabel5.font = UIFontRegularOfSize(20);
        _titleLabel5.textColor = BHHexColor(@"525866");
        [_bgView addSubview:_titleLabel5];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

//刷新数据UI
-(void)setCellWithModel:(HomeProductInfoModel *)productInfoModel
{
    if ([productInfoModel.type isEqualToString:@"日内策略"]) {
        _image2.image = [UIImage imageNamed:@"ic_rinei"];
    } else if ([productInfoModel.type isEqualToString:@"中期策略"])
    {
        _image2.image = [UIImage imageNamed:@"ic_zhonhqi"];
    } else
    {
        _image2.image = [UIImage imageNamed:@"ic_changqi"];
    }
    
    _titleLabel2.text = productInfoModel.name;
    _titleLabel3.text = productInfoModel.desc;
    if ([productInfoModel.riskLevel integerValue] == 1) {
        _bgView1.layer.borderColor = BHHexColor(@"A3D97D").CGColor;
    } else if ([productInfoModel.riskLevel integerValue] == 2)
    {
        _bgView1.layer.borderColor = BHHexColor(@"FE413F").CGColor;
    } else
    {
        _bgView1.layer.borderColor = BHHexColor(@"FF6B28").CGColor;
    }
    
    if ([productInfoModel.riskLevel integerValue] == 1) {
        _titleLabel7.textColor = BHHexColor(@"A3D97D");
    } else if ([productInfoModel.riskLevel integerValue] == 2)
    {
        _titleLabel7.textColor = BHHexColor(@"FE413F");
    } else
    {
        _titleLabel7.textColor = BHHexColor(@"FF6B28");
    }
    
    _titleLabel7.text = productInfoModel.riskValue;
    _titleLabel5.text = [NSString stringWithFormat:@"%@%%",productInfoModel.ror];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
