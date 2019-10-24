//
//  ZTYFlowRankTableViewCell.m
//  BTE
//
//  Created by wanmeizty on 15/11/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYFlowRankTableViewCell.h"
#import "FormatUtil.h"

@interface ZTYFlowRankTableViewCell ()
@property (strong,nonatomic) UILabel * baseLabel;
@property (strong,nonatomic) UILabel * exchangeLabel;
@property (strong,nonatomic) UILabel * priceLabel;
@property (strong,nonatomic) UILabel * dropLabel;
@end

@implementation ZTYFlowRankTableViewCell

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
        
        CGFloat cellHeight = [ZTYFlowRankTableViewCell cellHeigth];
        CGFloat width = (SCREEN_WIDTH - 32) / 3.0;
        self.baseLabel = [self createlabelframe:CGRectMake(16, 20, width, 14)];
        [self.contentView addSubview:self.baseLabel];
        self.baseLabel.textAlignment = NSTextAlignmentLeft;
        self.baseLabel.textColor = [UIColor colorWithHexString:@"000000"];
        
        self.exchangeLabel = [self createlabelframe:CGRectMake(16, 38, 80, 10)];
        [self.contentView addSubview:self.exchangeLabel];
        
        self.priceLabel =  [self createlabelframe:CGRectMake(127, 15, 110, 18)];
        self.priceLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        self.priceLabel.textColor = [UIColor colorWithHexString:@"626A75"];
        [self.contentView addSubview:self.priceLabel];
    
        
        self.dropLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 72 - 16, 13, 72, 26)];
        self.dropLabel.textColor = [UIColor whiteColor];
        self.dropLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:16];
        self.dropLabel.layer.cornerRadius = 5;
        self.dropLabel.layer.masksToBounds = YES;
        self.dropLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.dropLabel];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight - 0.5, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"E5E5EE"];
        [self.contentView addSubview:lineView];
    }
    return self;
}

-(void)configwithDict:(NSDictionary *)dict{
    
    NSString * amount = [FormatUtil formatCount:[[dict objectForKey:@"amount"] doubleValue]];
    NSString * base = [NSString stringWithFormat:@"%@",[dict objectForKey:@"base"]];
    NSString * baseStr = [NSString stringWithFormat:@"%@/%@",base,amount];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:baseStr];
    NSRange range = [baseStr rangeOfString:base];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"626A75"] range:range];
    [attribute addAttribute:NSFontAttributeName value: [UIFont fontWithName:@"PingFangSC-Medium" size:16] range:range];
    self.baseLabel.attributedText = attribute;
    
    NSString * priceStr = [FormatUtil dealSientificNumber:[[dict objectForKey:@"price"] doubleValue]];
    if (priceStr.length > 10) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.8f",[[dict objectForKey:@"price"] doubleValue]];
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",priceStr];
    }
    
    double netAmount = [[dict objectForKey:@"netAmount"] doubleValue];
    if ( netAmount > 0) {
        self.dropLabel.text = [FormatUtil formatCount:netAmount];
        self.dropLabel.backgroundColor = RoseColor;
    }else{
        self.dropLabel.text = [FormatUtil formatCount:netAmount];
        self.dropLabel.backgroundColor = [UIColor colorWithHexString:@"FE413F"];
    }
}

+ (CGFloat)cellHeigth{
    return 54;
}

- (UILabel *)createlabelframe:(CGRect)frame{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    label.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

@end
