//
//  BTEMyAccountTableViewCell.m
//  BTE
//
//  Created by wangli on 2018/3/8.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEMyAccountTableViewCell.h"

@implementation BTEMyAccountTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 21, 2, 13)];
        lineView.backgroundColor = BHHexColor(@"44A0F1");
        [self.contentView addSubview:lineView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 20, 150, 14)];
        
        _titleLabel.font = UIFontMediumOfSize(14);
        _titleLabel.textColor = BHHexColor(@"525866");
        [self.contentView addSubview:_titleLabel];
        
        _subTitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 54, (SCREEN_WIDTH - 16 * 2) / 4, 14)];
        _subTitleLabel1.text = @"投资额";
        _subTitleLabel1.font = UIFontRegularOfSize(12);
        _subTitleLabel1.textColor = BHHexColor(@"525866");
        _subTitleLabel1.alpha = 0.6;
        [self.contentView addSubview:_subTitleLabel1];
        
        _subTitleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(16, 54, (SCREEN_WIDTH - 16 * 2) / 4, 14)];
        _subTitleLabel2.text = @"当前额";
        _subTitleLabel2.left = _subTitleLabel1.right;
        _subTitleLabel2.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel2.font = UIFontRegularOfSize(12);
        _subTitleLabel2.textColor = BHHexColor(@"525866");
        _subTitleLabel2.alpha = 0.6;
        [self.contentView addSubview:_subTitleLabel2];
        
        _subTitleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(16, 54, (SCREEN_WIDTH - 16 * 2) / 4, 14)];
        _subTitleLabel3.text = @"浮动收益";
        _subTitleLabel3.left = _subTitleLabel2.right;
        _subTitleLabel3.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel3.font = UIFontRegularOfSize(12);
        _subTitleLabel3.textColor = BHHexColor(@"525866");
        _subTitleLabel3.alpha = 0.6;
        [self.contentView addSubview:_subTitleLabel3];
        
        _subTitleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(16, 54, (SCREEN_WIDTH - 16 * 2) / 4, 14)];
        _subTitleLabel4.text = @"到期日";
        _subTitleLabel4.left = _subTitleLabel3.right;
        _subTitleLabel4.textAlignment = NSTextAlignmentRight;
        _subTitleLabel4.font = UIFontRegularOfSize(12);
        _subTitleLabel4.textColor = BHHexColor(@"525866");
        _subTitleLabel4.alpha = 0.6;
        [self.contentView addSubview:_subTitleLabel4];

        _detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 82, (SCREEN_WIDTH - 16 * 2) / 4, 14)];
        
        _detailLabel1.font = UIFontDINAlternateOfSize(14);
        _detailLabel1.textColor = BHHexColor(@"525866");
        [self.contentView addSubview:_detailLabel1];
        
        _detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(16, 82, (SCREEN_WIDTH - 16 * 2) / 4, 14)];
        
        _detailLabel2.left = _detailLabel1.right;
        _detailLabel2.textAlignment = NSTextAlignmentCenter;
        _detailLabel2.font = UIFontDINAlternateOfSize(14);
        _detailLabel2.textColor = BHHexColor(@"525866");
        [self.contentView addSubview:_detailLabel2];
        
        _detailLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(16, 82, (SCREEN_WIDTH - 16 * 2) / 4, 14)];
        
        _detailLabel3.left = _detailLabel2.right;
        _detailLabel3.textAlignment = NSTextAlignmentCenter;
        _detailLabel3.font = UIFontDINAlternateOfSize(14);
        _detailLabel3.textColor = BHHexColor(@"525866");
        [self.contentView addSubview:_detailLabel3];
        
        _detailLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(16, 82, (SCREEN_WIDTH - 16 * 2) / 4, 14)];
        
        _detailLabel4.left = _detailLabel3.right;
        _detailLabel4.textAlignment = NSTextAlignmentRight;
        _detailLabel4.font = UIFontDINAlternateOfSize(14);
        _detailLabel4.textColor = BHHexColor(@"525866");
        [self.contentView addSubview:_detailLabel4];
        
        
//        _subDetailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 92, (SCREEN_WIDTH - 16 * 2) / 4, 14)];
//
//        _subDetailLabel1.font = [UIFont systemFontOfSize:12];
//        _subDetailLabel1.textColor = BHHexColor(@"000000");
//        [self.contentView addSubview:_subDetailLabel1];
//
//        _subDetailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(16, 92, (SCREEN_WIDTH - 16 * 2) / 4, 14)];
//
//        _subDetailLabel2.left = _subDetailLabel1.right;
//        _subDetailLabel2.textAlignment = NSTextAlignmentCenter;
//        _subDetailLabel2.font = [UIFont systemFontOfSize:12];
//        _subDetailLabel2.textColor = BHHexColor(@"000000");
//        [self.contentView addSubview:_subDetailLabel2];
        
        UIButton *jumpDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        jumpDetailButton.frame = CGRectMake(SCREEN_WIDTH - 26 - 50, 113, 50, 16);
        [jumpDetailButton setTitle:@"投资详情" forState:UIControlStateNormal];
        [jumpDetailButton setTitleColor:BHHexColor(@"318CDD") forState:UIControlStateNormal];
        [jumpDetailButton addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
        jumpDetailButton.titleLabel.font = UIFontRegularOfSize(12);
        [self.contentView addSubview:jumpDetailButton];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 114, 7, 12)];
        bgImageView.image = [UIImage imageNamed:@"bte_arrow_right"];
        bgImageView.right = SCREEN_WIDTH - 16;
        [self.contentView addSubview:bgImageView];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 145, SCREEN_WIDTH - 16 * 2, 1)];
        _lineView.backgroundColor = kColorRgba(0, 0, 0, 0.1);
        [self.contentView addSubview:_lineView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)commit
{
    NSLog(@"----------跳转详情页");
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToDetail:)]) {
        [self.delegate jumpToDetail:_model.productId];
    }
}

//刷新数据UI
-(void)setCellWithModel:(BTEAccountDetailsModel *)model
{
    _model = model;
    _titleLabel.text = model.batchName;
    _detailLabel1.text = [NSString stringWithFormat:@"%@BTC",model.amount];
    _detailLabel2.text = [NSString stringWithFormat:@"%@BTC",model.currentAmount];
    
    if ([model.ror floatValue] > 0) {
        _detailLabel3.text = [NSString stringWithFormat:@"+%@%%",model.ror];
        _detailLabel3.textColor = BHHexColor(@"1BAC75");
    } else if ([model.ror floatValue] < 0)
    {
        _detailLabel3.text = [NSString stringWithFormat:@"%@%%",model.ror];
        _detailLabel3.textColor = BHHexColor(@"FF6B28");
    } else
    {
        _detailLabel3.text = [NSString stringWithFormat:@"%@%%",model.ror];
        _detailLabel3.textColor = BHHexColor(@"292C33");
    }
    
    _detailLabel4.text = [NSString stringWithFormat:@"%@",model.end];
    _subDetailLabel1.text = [NSString stringWithFormat:@"($%@)",model.legalAmount];
    _subDetailLabel2.text = [NSString stringWithFormat:@"($%@)",model.legalCurrentAmount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
