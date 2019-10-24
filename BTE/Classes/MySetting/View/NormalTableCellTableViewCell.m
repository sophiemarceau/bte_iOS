//
//  NormalTableCellTableViewCell.m
//  BTE
//
//  Created by sophiemarceau_qu on 2018/10/9.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "NormalTableCellTableViewCell.h"

@implementation NormalTableCellTableViewCell

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
    [self.contentView addSubview:self.functionLabel];
//    [self.contentView addSubview:self.lineImageView];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.ValueLabel];
    
//    [self.functionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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

-(void)setNormalTableItem:(NormalITableItem *)tableViewItem{
//    NSLog(@"functionValue----%@",tableViewItem.
//          functionValue);
    NSLog(@"%@",self.functionLabel);
    
    self.functionLabel.text = tableViewItem.functionValue;
    self.ValueLabel.text = tableViewItem.valueLabelStr;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize cellSize = self.bounds.size;
//    [self.functionLabel sizeToFit];


    [self.ValueLabel sizeToFit];
    self.ValueLabel .frame = CGRectMake(SCREEN_WIDTH - self.ValueLabel .bounds.size.width - 16 -8 -10, (44 - self.ValueLabel .bounds.size.height)/2.0, self.ValueLabel .bounds.size.width, self.ValueLabel .bounds.size.height);

    self.arrowImageView.frame =CGRectMake(SCREEN_WIDTH -8 -16, 16, 8, 14);

    self.lineImageView.frame =CGRectMake(16, cellSize.height -1 , SCREEN_WIDTH, 0.5);
}

- (UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor =  BHHexColor(@"E6EBF0");
    }
    return _lineImageView;
}

- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"centerArrow"];
    }
    return _arrowImageView;
}

-(UILabel *)functionLabel{
    if (_functionLabel == nil) {
        _functionLabel  = [[UILabel alloc] init];
        _functionLabel.frame = CGRectMake(16,0, SCREEN_WIDTH/2, 44);
        _functionLabel.textColor = BHHexColor(@"626A75");
        _functionLabel.font = UIFontRegularOfSize(16);
    }
    return _functionLabel;
}

-(UILabel *)ValueLabel{
    if (_ValueLabel == nil) {
        _ValueLabel = [[UILabel alloc] init];
        _ValueLabel.font = UIFontRegularOfSize(14);
        _ValueLabel.textColor = BHHexColor(@"626A75");
    }
    return _ValueLabel;
}

@end
