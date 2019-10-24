//
//  ZTYCoinTableViewCell.m
//  BTE
//
//  Created by wanmeizty on 20/11/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYCoinTableViewCell.h"
#import "FormatUtil.h"

@interface ZTYCoinTableViewCell ()
@property (strong,nonatomic) UILabel * baseLabel;
@property (strong,nonatomic) UILabel * exchangeLabel;
@property (strong,nonatomic) UILabel * priceLabel;
@property (strong,nonatomic) UILabel * cnyLabel;
@property (strong,nonatomic) UILabel * dropLabel;
@end
@implementation ZTYCoinTableViewCell

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
        CGFloat width = (SCREEN_WIDTH - 32) / 3.0;
        CGFloat cellHeight = [ZTYCoinTableViewCell cellHeight];
        
        self.baseLabel = [self createlabelframe:CGRectMake(16, 17, width, 14)];
        [self.contentView addSubview:self.baseLabel];
        
        self.exchangeLabel = [self createlabelframe:CGRectMake(16, 38, width, 10)];
        [self.contentView addSubview:self.exchangeLabel];
        
        self.priceLabel =  [self createlabelframe:CGRectMake(width + 16, 15, width, 18)];
        self.priceLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        self.priceLabel.textColor = [UIColor colorWithHexString:@"626A75"];
        [self.contentView addSubview:self.priceLabel];
        
        self.cnyLabel = [self createlabelframe:CGRectMake(16 + width, 38, width, 10)];
        self.cnyLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.cnyLabel];
        
        self.dropLabel = [self createlabelframe:CGRectMake(SCREEN_WIDTH - 72 - 16, 19, 72, 26)];
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

- (void)configwidth:(NSDictionary *)dict{
    
    NSString * base = [NSString stringWithFormat:@"%@",[dict objectForKey:@"base"]];
    NSString * baseStr = [NSString stringWithFormat:@"%@/%@",base,[dict objectForKey:@"quote"]];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:baseStr];
    NSRange range = [baseStr rangeOfString:base];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"626A75"] range:range];
    [attribute addAttribute:NSFontAttributeName value: [UIFont fontWithName:@"PingFangSC-Medium" size:16] range:range];
    self.baseLabel.attributedText = attribute;
    
    NSString * amount = [FormatUtil formatCount:[[dict objectForKey:@"cnyQuoteAmount"] doubleValue]];
    self.exchangeLabel.text = [NSString stringWithFormat:@"%@/%@",[dict objectForKey:@"exchange"],amount];
    
    NSString * priceStr = [FormatUtil dealSientificNumber:[[dict objectForKey:@"price"] doubleValue]];
    if (priceStr.length > 10) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.8f",[[dict objectForKey:@"price"] doubleValue]];
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",priceStr];
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",[FormatUtil dealSientificNumber:[[dict objectForKey:@"price"] doubleValue]]];


    self.cnyLabel.text = [NSString stringWithFormat:@"≈%.2fCNY",[[dict objectForKey:@"cnyPrice"] doubleValue]];
    
    double change = [[dict objectForKey:@"change"] doubleValue];
    if ( change > 0) {
        self.dropLabel.text = [NSString stringWithFormat:@"+%.2f%%",change * 100];
        self.dropLabel.backgroundColor = RoseColor;
    }else{
        self.dropLabel.text = [NSString stringWithFormat:@"%.2f%%",change * 100];
        self.dropLabel.backgroundColor = [UIColor colorWithHexString:@"FE413F"];
    }
    
}

+ (CGFloat)cellHeight{
    return 64;
}

- (UILabel *)createlabelframe:(CGRect)frame{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    label.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
    return label;
}

@end
