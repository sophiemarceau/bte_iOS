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
        
        self.backgroundColor = KBGColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(16, 16, SCREEN_WIDTH - 36, 198 - 16)];
        _bgView.backgroundColor = KBGCell;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 4;
        [self.contentView addSubview:_bgView];
        
        _image2 = [[UIImageView alloc] initWithFrame:CGRectMake(16, 28, 32, 36)];
        [_bgView addSubview:_image2];
        
        _titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(64, 24, 180, 20)];
        
        _titleLabel2.font = UIFontMediumOfSize(16);
        _titleLabel2.textColor = BHHexColor(@"626A75");
        [_bgView addSubview:_titleLabel2];
        
        _titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(64, 48, SCREEN_WIDTH - 160, 21)];
        _titleLabel3.numberOfLines = 0;
        _titleLabel3.font = UIFontLightOfSize(13);
        _titleLabel3.textColor = BHHexColorAlpha(@"626A75", 0.8);
//        BHHexColor(@"626A75");
        _titleLabel3.alpha = 0.8;
        [_bgView addSubview:_titleLabel3];
        
        _bgView1 = [[UIView alloc] initWithFrame:CGRectMake(16, 25, 24, 24)];
        _bgView1.backgroundColor = [UIColor clearColor];
        _bgView1.left = _bgView.width - 24 - 16;
        _bgView1.layer.masksToBounds = YES;
        _bgView1.layer.cornerRadius = 4;
        _bgView1.layer.borderWidth = 2;
        
        [_bgView addSubview:_bgView1];
        
        _titleLabel7 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        _titleLabel7.textAlignment = NSTextAlignmentCenter;
        _titleLabel7.font = UIFontRegularOfSize(20);
        [_bgView1 addSubview:_titleLabel7];
        
        
        
        
        _titleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(64, 56, 60, 14)];
        _titleLabel4.left = _bgView.width - 60 - 16;
        _titleLabel4.textAlignment = NSTextAlignmentRight;
        _titleLabel4.text = @"风险";
        _titleLabel4.font = UIFontRegularOfSize(12);
        _titleLabel4.textColor = BHHexColor(@"7A8499");
        [_bgView addSubview:_titleLabel4];
        
        _bgView2 = [[UIView alloc] initWithFrame:CGRectMake(16, 93, _bgView.width - 32, 1)];
        _bgView2.backgroundColor = BHHexColor(@"E6EBF0");
        [_bgView addSubview:_bgView2];
        
        
        _titleLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(16, 108, 160, 12)];
        _titleLabel6.text = @"累计收益率";
        _titleLabel6.font = UIFontRegularOfSize(12);
        _titleLabel6.textColor = BHHexColor(@"626A75");
        [_bgView addSubview:_titleLabel6];
        
        _titleLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(16, 104, 160, 20)];
        _titleLabel5.left = _bgView.width - 160 - 16;
        _titleLabel5.textAlignment = NSTextAlignmentRight;
        
        _titleLabel5.font = UIFontRegularOfSize(20);
//        _titleLabel5.textColor = BHHexColor(@"525866");
        [_bgView addSubview:_titleLabel5];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _bgView.height = self.frame.size.height - 16;
    CGRect rect = [_titleLabel3.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 160, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:UIFontLightOfSize(13)} context:nil];
    _titleLabel3.height = rect.size.height;
    _bgView2.top = _titleLabel3.bottom + 16;
    _titleLabel6.top = _bgView2.bottom + 14;
    _titleLabel5.top = _bgView2.bottom + 10;
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
        _bgView1.layer.borderColor = BHHexColor(@"FF7C08").CGColor;
    } else
    {
        _bgView1.layer.borderColor = BHHexColor(@"FE413F").CGColor;
    }
    
    if ([productInfoModel.riskLevel integerValue] == 1) {
        _titleLabel7.textColor = BHHexColor(@"A3D97D");
    } else if ([productInfoModel.riskLevel integerValue] == 2)
    {
        _titleLabel7.textColor = BHHexColor(@"FF7C08");
    } else
    {
        _titleLabel7.textColor = BHHexColor(@"FE413F");
    }
    
    _titleLabel7.text = productInfoModel.riskValue;
    
    if ([productInfoModel.ror floatValue] > 0) {
        _titleLabel5.text = [NSString stringWithFormat:@"+%@%%",@(productInfoModel.ror.floatValue)];
        _titleLabel5.textColor = BHHexColor(@"228B22");
    } else if ([productInfoModel.ror floatValue] < 0)
    {
        _titleLabel5.text = [NSString stringWithFormat:@"%@%%",@(productInfoModel.ror.floatValue)];
        _titleLabel5.textColor = BHHexColor(@"FF4040");
    } else
    {
        _titleLabel5.text = [NSString stringWithFormat:@"%@%%",@(productInfoModel.ror.floatValue)];
        _titleLabel5.textColor = BHHexColor(@"626A75");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
