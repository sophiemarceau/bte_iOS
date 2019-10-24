//
//  BTECoinTableViewCell.m
//  BTE
//
//  Created by wanmeizty on 24/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTECoinTableViewCell.h"

@interface BTECoinTableViewCell (){
//    CurrencyModel * _currencyModel;
}
@property (strong,nonatomic) UILabel * baseLabel;
@property (strong,nonatomic) UILabel * exchangeLabel;
@property (strong,nonatomic) UIButton * selectBtn;
@end

@implementation BTECoinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.baseLabel = [self createlabelframe:CGRectMake(16, 16, 180, 16)];
        [self.contentView addSubview:self.baseLabel];
        
        self.exchangeLabel = [self createlabelframe:CGRectMake(16, 38, 180, 16)];
        [self.contentView addSubview:self.exchangeLabel];
        
        self.selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 10, 44, 44)];
        [self.selectBtn setImage:[UIImage imageNamed:@"currencyNol"] forState:UIControlStateNormal];
        [self.selectBtn setImage:[UIImage imageNamed:@"currencySel"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.selectBtn];
        self.selectBtn.selected = NO;
        [self.selectBtn addTarget:self action:@selector(sel:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)sel:(UIButton *)btn{
    if (btn.selected) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
//    _currencyModel.status = btn.selected;
    self.selectblock(btn.selected);
}

- (void)configwidth:(NSDictionary *)dict{
    
    NSString * base = [NSString stringWithFormat:@"%@",[dict objectForKey:@"base"]];
    NSString * baseStr = [NSString stringWithFormat:@"%@/%@",base,[dict objectForKey:@"quote"]];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:baseStr];
    NSRange range = [baseStr rangeOfString:base];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"626A75"] range:range];
    [attribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:13] range:range];
    self.baseLabel.attributedText = attribute;
    
    self.exchangeLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"exchange"]];
    self.selectBtn.selected = [[dict objectForKey:@"status"] boolValue];
}

- (void)configwidthModel:(CurrencyModel *)model{
    
//    _currencyModel = model;
    
    NSString * base = model.base;
    NSString * baseStr = [NSString stringWithFormat:@"%@/%@",base,model.quote];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:baseStr];
    NSRange range = [baseStr rangeOfString:base];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"626A75"] range:range];
    [attribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:13] range:range];
    self.baseLabel.attributedText = attribute;
    
    self.exchangeLabel.text = model.exchange;
//    self.selectBtn.selected = model.status;
}

- (void)configwidthModel:(CurrencyModel *)model optionList:(NSArray *)optionList{
    
//    _currencyModel = model;
    
    NSString * base = model.base;
    NSString * baseStr = [NSString stringWithFormat:@"%@/%@",base,model.quote];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:baseStr];
    NSRange range = [baseStr rangeOfString:base];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"626A75"] range:range];
    [attribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:13] range:range];
    self.baseLabel.attributedText = attribute;
    
    self.exchangeLabel.text = model.exchange;
    self.selectBtn.selected = model.status;
    
}

+ (CGFloat)cellHeight{
    return 64;
}

- (UILabel *)createlabelframe:(CGRect)frame{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    label.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
    return label;
}

@end
