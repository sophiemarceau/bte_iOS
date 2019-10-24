//
//  StraegyTableViewCell.m
//  BTE
//
//  Created by sophiemarceau_qu on 2018/10/10.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "StraegyTableViewCell.h"
#import  "Details.h"
@implementation StraegyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BHHexColor(@"FAFAFA");
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(16, 27, 2, 13)];
    blueView.backgroundColor = BHHexColor(@"#168CF0");
    [self.contentView addSubview:blueView];
    [self.contentView addSubview:self.titleLabel];
   
    self.moneyLabel = [[UILabel alloc] init];
    self.moneyLabel.frame = CGRectMake(16,64, SCREEN_WIDTH/4 -20, 16);
    self.moneyLabel.textColor = BHHexColor(@"626A75"alpha:0.5);
    self.moneyLabel.font = UIFontRegularOfSize(12);
    self.moneyLabel.textAlignment = NSTextAlignmentLeft;
    
    
    self.followLabel = [[UILabel alloc] init];
    self.followLabel.frame = CGRectMake(117,64, SCREEN_WIDTH/4 -20, 12);
    self.followLabel.textColor = BHHexColor(@"626A75"alpha:0.5);
    self.followLabel.font = UIFontRegularOfSize(12);
    self.followLabel.textAlignment = NSTextAlignmentRight;
    
    
    self.getPercentLabel = [[UILabel alloc] init];
    self.getPercentLabel.frame = CGRectMake(239,64, 60, 12);
    self.getPercentLabel.textColor = BHHexColor(@"626A75"alpha:0.5);
    self.getPercentLabel.font = UIFontRegularOfSize(12);
    self.getPercentLabel.textAlignment = NSTextAlignmentLeft;
    self.getPercentLabel.text = @"收益";
    
    
    self.transactionStautsLabel = [[UILabel alloc] init];
    self.transactionStautsLabel.frame = CGRectMake(SCREEN_WIDTH - 60 -16,64, 60, 12);
    self.transactionStautsLabel.textColor = BHHexColor(@"626A75"alpha:0.5);
    self.transactionStautsLabel.font = UIFontRegularOfSize(12);
    self.transactionStautsLabel.textAlignment = NSTextAlignmentRight;
    self.transactionStautsLabel.text = @"交易状态";
    
    
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.followLabel];
    [self.contentView addSubview:self.getPercentLabel];
    [self.contentView addSubview:self.transactionStautsLabel];
    
    self.arrowImageView.frame =CGRectMake(SCREEN_WIDTH -8 -16, 26, 8, 14);
    [self.contentView addSubview:self.arrowImageView];
    
    
    
    [self.contentView addSubview:self.moneyContent];
    [self.contentView addSubview:self.followContent];
    [self.contentView addSubview:self.getPercentContent];
    [self.contentView addSubview:self.transactionStautsContent];
    
    
    [self.contentView addSubview:self.redimageView];
    self.redimageView.hidden = YES;
}


-(void)setNormalTableItem:(Details *)model{
    self.titleLabel.text = model.productName;
    
    self.moneyContent.text = model.principal;
    

    self.followContent.text = model.amount;
    self.getPercentContent.text = model.ror;
    self.transactionStautsContent.text = model.status;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"本金(%@)",model.assetType];
    self.followLabel.text =  [NSString stringWithFormat:@"净值(%@)",model.assetType];

    if ([model.ror floatValue] > 0) {
        self.getPercentContent.text = [NSString stringWithFormat:@"+%@%%",model.ror];
        self.getPercentContent.textColor = BHHexColor(@"228B22");
    } else if ([model.ror floatValue] < 0)
    {
        self.getPercentContent.text = [NSString stringWithFormat:@"%@%%",model.ror];
        self.getPercentContent.textColor = BHHexColor(@"FF4040");
    } else
    {
        self.getPercentContent.text = [NSString stringWithFormat:@"%@%%",model.ror];
        self.getPercentContent.textColor = BHHexColor(@"626A75");
    }
    
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel  = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(25,26, SCREEN_WIDTH/2, 14);
        _titleLabel.textColor = BHHexColor(@"626A75");
        _titleLabel.font = UIFontRegularOfSize(14);
        
    }
    return _titleLabel;
}

-(UILabel *)moneyContent{
    if (_moneyContent == nil) {
        _moneyContent = [[UILabel alloc] init];
        _moneyContent.frame = CGRectMake(16,92, SCREEN_WIDTH/4 -20, 16);
        _moneyContent.textColor = BHHexColor(@"626A75");
        _moneyContent.font = UIFontRegularOfSize(12);
        _moneyContent.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyContent;
}

-(UILabel *)followContent{
    if (_followContent == nil) {
        _followContent = [[UILabel alloc] init];
        _followContent.frame = CGRectMake(117,92, SCREEN_WIDTH/4 -20, 12);
        _followContent.textColor = BHHexColor(@"626A75");
        _followContent.font = UIFontRegularOfSize(12);
        _followContent.textAlignment = NSTextAlignmentRight;
    }
    return _followContent;
}

-(UILabel *)getPercentContent{
    if (_getPercentContent == nil) {
        _getPercentContent = [[UILabel alloc] init];
        _getPercentContent.frame = CGRectMake(239,92, SCREEN_WIDTH/4 -20, 12);
        _getPercentContent.textColor = BHHexColor(@"626A75");
        _getPercentContent.font = UIFontRegularOfSize(12);
        _getPercentContent.textAlignment = NSTextAlignmentLeft;
    }
    return _getPercentContent;
}

-(UILabel *)transactionStautsContent{
    if (_transactionStautsContent == nil) {
        _transactionStautsContent = [[UILabel alloc] init];
        _transactionStautsContent.frame = CGRectMake(SCREEN_WIDTH - 60 -16,92, SCREEN_WIDTH/4 -20, 12);
        _transactionStautsContent.textColor = BHHexColor(@"308CDD");
        _transactionStautsContent.font = UIFontRegularOfSize(12);
        _transactionStautsContent.textAlignment = NSTextAlignmentCenter;
    }
    return _transactionStautsContent;
}

- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"centerArrow"];
    }
    return _arrowImageView;
}

- (UIImageView *)redimageView{
    if (_redimageView == nil) {
        _redimageView = [UIImageView new];
        _redimageView.frame =  CGRectMake(0, 0, SCREEN_WIDTH, 130);
//        _redimageView.image = [UIImage imageNamed:@"bg_no_data"];
        _redimageView.backgroundColor = BHHexColor(@"fafafa");
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_no_data"]];
        imageView.frame = CGRectMake((SCREEN_WIDTH -90)/2, (130-80)/2, 90, 80);
        [_redimageView addSubview:imageView];
    }
    return _redimageView;
}
@end
