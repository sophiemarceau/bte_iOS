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
        
        
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 15, 17, 17)];
        [self.contentView addSubview:_iconImage];
        
        _subTitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(39, 15, 60, 16)];
        _subTitleLabel1.text = @"BTC";
        _subTitleLabel1.font = UIFontMediumOfSize(16);
        _subTitleLabel1.textColor = BHHexColor(@"626A75");
        [self.contentView addSubview:_subTitleLabel1];
        
        _subTitleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(147, 15, 100, 16)];
        _subTitleLabel2.text = @"震荡向下筑底";
        _subTitleLabel2.font = UIFontDINAlternateOfSize(16);
//        UIFontMediumOfSize(16);
        _subTitleLabel2.textColor = BHHexColor(@"525866");
        [self.contentView addSubview:_subTitleLabel2];
        
//        _subTitleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(16, 38, 110, 14)];
//        _subTitleLabel3.text = @"$2,663.24";
//        _subTitleLabel3.font = UIFontRegularOfSize(14);
//        _subTitleLabel3.textColor = BHHexColor(@"525866");
//        _subTitleLabel3.alpha = 0.8;
//        [self.contentView addSubview:_subTitleLabel3];
        
//        _subTitleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(124, 38, 160, 13)];
//        _subTitleLabel4.text = @"附近分阶段建仓";
//        _subTitleLabel4.font = UIFontRegularOfSize(13);
//        _subTitleLabel4.textColor = BHHexColor(@"525866");
//        _subTitleLabel4.alpha = 0.8;
//        [self.contentView addSubview:_subTitleLabel4];
        
        
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 12, 56, 22)];
        _buttonView.backgroundColor = [UIColor whiteColor];
        _buttonView.layer.masksToBounds = YES;
        _buttonView.layer.cornerRadius = 5;
        _buttonView.right = SCREEN_WIDTH - 16;
        [self.contentView addSubview:_buttonView];
        
        
        _subTitleLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 56, 14)];
        _subTitleLabel5.text = @"-2.39%";
        _subTitleLabel5.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel5.font = UIFontRegularOfSize(14);
        _subTitleLabel5.textColor = BHHexColor(@"FFFFFF");
        [_buttonView addSubview:_subTitleLabel5];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 46 - 0.5, SCREEN_WIDTH, 0.5)];
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
//    _subTitleLabel2.text = model.trend;
    
    NSString *price = [NSString positiveFormat:model.price];
    _subTitleLabel2.text = [NSString stringWithFormat:@"$%@",price];
//    _subTitleLabel4.text = model.operation;
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
