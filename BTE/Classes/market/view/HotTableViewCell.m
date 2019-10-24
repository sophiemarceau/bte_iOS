//
//  HotTableViewCell.m
//  BTE
//
//  Created by sophie on 2018/11/7.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "HotTableViewCell.h"

@implementation HotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = KBGColor;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    UIView *bgView = [UIView new];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    bgView.backgroundColor = KBGCell;
    [self.contentView addSubview:bgView];
    [bgView addSubview:self.coinLabel];
    [bgView addSubview:self.subNumLabel];
    [bgView addSubview:self.priceNumLabel];
    [bgView addSubview:self.percentLabel];
    [bgView addSubview:self.hotOrAtomspereLabel];
    [bgView addSubview:self.lineImageView];

    self.coinLabel.frame = CGRectMake(16, 16, 0, 0);
    self.subNumLabel.frame = CGRectMake(15, 38, 0, 0);
    self.priceNumLabel.frame = CGRectMake(0, 15, 0, 0);
    self.percentLabel.frame = CGRectMake(0, 38, 0, 0);
    self.hotOrAtomspereLabel.frame = CGRectMake(0, 23, 0, 0);
    self.lineImageView.frame =CGRectMake(0, 64 -1, SCREEN_WIDTH, 0.5f);
    //    [self.functionLabel mas_manmbv keConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
    //        make.top.equalTo(self.mas_top).offset(0*AUTO_SIZE_SCALE_X);
    //        make.size.mas_equalTo(CGSizeMake(120*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X));
    //    }];
    //
    //    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
    //        make.bottom.equalTo(self.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
    //        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X,  0.5*AUTO_SIZE_SCALE_X));
    //    }];
    //
    //    [self.ValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self.arrowImageView.mas_left).offset(-10*AUTO_SIZE_SCALE_X);
    //        make.bottom.equalTo(self.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
    //        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 50*AUTO_SIZE_SCALE_X));
    //    }];
    //
    //    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
    //        make.top.equalTo(self.mas_top).offset(17.5*AUTO_SIZE_SCALE_X);
    //        make.size.mas_equalTo(CGSizeMake(9*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    //    }];
}

-(void)setDataDiction:(NSDictionary *)itemDictionary{
    self.coinLabel.text = itemDictionary[@"coin"];
    self.subNumLabel.text = [NSString stringWithFormat:@"¥%@",itemDictionary[@"money"]]
    ;
    self.priceNumLabel.text =  [NSString stringWithFormat:@"¥%@",itemDictionary[@"price"]];
    
    self.percentLabel.text =  [NSString stringWithFormat:@"%@%@",itemDictionary[@"percent"],@"%"];
    
    self.hotOrAtomspereLabel.text = itemDictionary[@"hot"];
    [self.coinLabel sizeToFit];
    self.coinLabel.frame = CGRectMake(
                                      self.coinLabel.frame.origin.x,
                                     self.coinLabel.frame.origin.y,
                                      self.coinLabel .bounds.size.width, self.coinLabel .bounds.size.height);
    [self.subNumLabel sizeToFit];
    self.subNumLabel.frame = CGRectMake(
                                      self.subNumLabel.frame.origin.x,
                                      self.subNumLabel.frame.origin.y,
                                      self.subNumLabel .bounds.size.width, self.subNumLabel .bounds.size.height);
    [self.priceNumLabel sizeToFit];
    self.priceNumLabel.frame = CGRectMake(
                                        SCREEN_WIDTH - 131 -self.priceNumLabel.bounds.size.width,
                                        self.priceNumLabel.frame.origin.y,
                                        self.priceNumLabel .bounds.size.width, self.priceNumLabel .bounds.size.height);
    [self.percentLabel sizeToFit];
    self.percentLabel.frame = CGRectMake(
                                          SCREEN_WIDTH - 131 -self.percentLabel.bounds.size.width,
                                          self.percentLabel.frame.origin.y,
                                          self.percentLabel .bounds.size.width, self.percentLabel .bounds.size.height);
    
    [self.hotOrAtomspereLabel sizeToFit];
    self.hotOrAtomspereLabel.frame = CGRectMake(
                                         SCREEN_WIDTH - 16 -self.hotOrAtomspereLabel.bounds.size.width,
                                         self.hotOrAtomspereLabel.frame.origin.y,
                                         self.hotOrAtomspereLabel .bounds.size.width, self.hotOrAtomspereLabel .bounds.size.height);
    self.percentLabel.textColor = BHHexColor(@"FF4040");
    
    self.percentLabel.textColor = BHHexColor(@"228B22");
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

-(UILabel *)coinLabel{
    if (_coinLabel == nil) {
        _coinLabel = [[UILabel alloc] init];
        _coinLabel.font = UIFontMediumOfSize(16);
        _coinLabel.textColor = BHHexColor(@"626A75");
        _coinLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _coinLabel;
}

-(UILabel *)subNumLabel{
    if (_subNumLabel == nil) {
        _subNumLabel = [[UILabel alloc] init];
        _subNumLabel.font = UIFontRegularOfSize(10);
        _subNumLabel.textColor = BHHexColor(@"525866");
        _subNumLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _subNumLabel;
}

-(UILabel *)priceNumLabel{
    if (_priceNumLabel == nil) {
        _priceNumLabel = [[UILabel alloc] init];
        _priceNumLabel.font = UIFontDINAlternateOfSize(16);
        _priceNumLabel.textColor = BHHexColor(@"626A75");
        _priceNumLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceNumLabel;
}

-(UILabel *)percentLabel{
    if (_percentLabel == nil) {
        _percentLabel = [[UILabel alloc] init];
        _percentLabel.font = UIFontRegularOfSize(10);
        _percentLabel.textColor = BHHexColor(@"525866");
        _percentLabel.textAlignment = NSTextAlignmentRight;
    }
    return _percentLabel;
}

-(UILabel *)hotOrAtomspereLabel{
    if (_hotOrAtomspereLabel == nil) {
        _hotOrAtomspereLabel = [[UILabel alloc] init];
        _hotOrAtomspereLabel.font = UIFontDINAlternateOfSize(19);
        _hotOrAtomspereLabel.textColor = BHHexColor(@"626A75");
        _hotOrAtomspereLabel.textAlignment = NSTextAlignmentRight;
    }
    return _hotOrAtomspereLabel;
}

- (UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = BHHexColor(@"E6EBF0");
    }
    return _lineImageView;
}

@end
