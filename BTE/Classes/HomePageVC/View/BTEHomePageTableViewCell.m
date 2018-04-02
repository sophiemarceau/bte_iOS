//
//  BTEHomePageTableViewCell.m
//  BTE
//
//  Created by wangli on 2018/3/22.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEHomePageTableViewCell.h"

@implementation BTEHomePageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = KBGCell;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 14, 22, 22)];
        [self.contentView addSubview:_iconImage];
        
        _subTitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(44, 17, 60, 18)];
        _subTitleLabel1.text = @"BTC";
        _subTitleLabel1.font = UIFontMediumOfSize(18);
        _subTitleLabel1.textColor = BHHexColor(@"525866");
        [self.contentView addSubview:_subTitleLabel1];
        
        _subTitleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(124, 18, 100, 16)];
        _subTitleLabel2.text = @"震荡向下筑底";
        _subTitleLabel2.font = UIFontMediumOfSize(16);
        _subTitleLabel2.textColor = BHHexColor(@"308CDD");
        [self.contentView addSubview:_subTitleLabel2];
        
        _subTitleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(16, 44, 110, 14)];
        _subTitleLabel3.text = @"$2,663.24";
        _subTitleLabel3.font = UIFontRegularOfSize(14);
        _subTitleLabel3.textColor = BHHexColor(@"525866");
        [self.contentView addSubview:_subTitleLabel3];
        
        _subTitleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(124, 44, 160, 14)];
        _subTitleLabel4.text = @"附近分阶段建仓";
        _subTitleLabel4.font = UIFontRegularOfSize(12);
        _subTitleLabel4.textColor = BHHexColor(@"525866");
        [self.contentView addSubview:_subTitleLabel4];
        
        
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 21, 66, 30)];
        _buttonView.backgroundColor = [UIColor whiteColor];
        _buttonView.layer.masksToBounds = YES;
        _buttonView.layer.cornerRadius = 5;
        _buttonView.right = SCREEN_WIDTH - 16;
        [self.contentView addSubview:_buttonView];
        
        
        _subTitleLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 7.5, 66, 15)];
        _subTitleLabel5.text = @"-2.39%";
        _subTitleLabel5.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel5.font = UIFontRegularOfSize(15);
        _subTitleLabel5.textColor = BHHexColor(@"FFFFFF");
        [_buttonView addSubview:_subTitleLabel5];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 72 - 0.5, SCREEN_WIDTH, 0.5)];
        _lineView.backgroundColor = kColorRgba(0, 0, 0, 0.1);
        [self.contentView addSubview:_lineView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

//刷新数据UI
-(void)setCellWithModel:(HomeDesListModel *)model
{
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
    _subTitleLabel1.text = model.symbol;
    _subTitleLabel2.text = model.trend;
    
    NSString *price = [NSString positiveFormat:model.price];
    _subTitleLabel3.text = [NSString stringWithFormat:@"$%@",price];
    _subTitleLabel4.text = model.operation;
    if ([model.change floatValue] > 0) {
        _subTitleLabel5.text = [NSString stringWithFormat:@"+%.2f%%",[model.change floatValue]];
    } else
    {
        _subTitleLabel5.text = [NSString stringWithFormat:@"%.2f%%",[model.change floatValue]];
    }

    if ([model.change floatValue] > 0) {
        _buttonView.backgroundColor = BHHexColor(@"228B22");
    } else if ([model.change floatValue] < 0)
    {
        _buttonView.backgroundColor = BHHexColor(@"FF4040");
    } else
    {
        _buttonView.backgroundColor = BHHexColor(@"228B22");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
