//
//  CoinTableViewCell.m
//  BTE
//
//  Created by sophie on 2018/11/7.
//  Copyright © 2018 wangli. All rights reserved.
//

#import "CoinTableViewCell.h"
@interface CoinTableViewCell ()

@property (strong,nonatomic) UILabel * baseLabel;
@property (strong,nonatomic) UILabel * exchangeLabel;
@property (strong,nonatomic) UILabel * priceLabel;
@property (strong,nonatomic) UILabel * cnyLabel;
@property (strong,nonatomic) UILabel * dropLabel;


@end
@implementation CoinTableViewCell
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
        
        CGFloat cellHeight = [CoinTableViewCell cellHeight];
        
        self.baseLabel = [self createlabelframe:CGRectMake(16, 20, 80, 14)];
        [self.contentView addSubview:self.baseLabel];
        
        //        self.exchangeLabel = [self createlabelframe:CGRectMake(16, 38, 80, 10)];
        //        [self.contentView addSubview:self.exchangeLabel];
        
        self.priceLabel =  [self createlabelframe:CGRectMake(174, 18, 110, 18)];
        self.priceLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        self.priceLabel.textColor = [UIColor colorWithHexString:@"626A75"];
        [self.contentView addSubview:self.priceLabel];
        self.priceLabel.frame =  CGRectMake(SCREEN_WIDTH - 131 - 110, self.priceLabel.frame.origin.y, 110, 18);
        //        self.cnyLabel = [self createlabelframe:CGRectMake(127, 38, 110, 10)];
        //        self.cnyLabel.textAlignment = NSTextAlignmentRight;
        //        [self.contentView addSubview:self.cnyLabel];
        //        self.cnyLabel.textAlignment = NSTextAlignmentRight;
        //        self.priceLabel.textAlignment = NSTextAlignmentRight;
        
        self.dropLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 72 - 16, 14, 72, 26)];
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
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.8f",[[dict objectForKey:@"price"] doubleValue]];
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",priceStr];;
    }
    
    //1 涨幅榜 2跌幅榜 3资金流入 4资金流出 5板块 详情里面
    if ([self.flagStr isEqualToString:@"1"] ) {
        double change = [[dict objectForKey:@"change"] doubleValue];
        self.dropLabel.backgroundColor = RoseColor;
        self.dropLabel.text = [NSString stringWithFormat:@"%.2f%%",change * 100];
        if ( change > 0) {
            self.dropLabel.backgroundColor = RoseColor;
        }else{
            self.dropLabel.backgroundColor = [UIColor colorWithHexString:@"FE413F"];
            self.dropLabel.text = [NSString stringWithFormat:@"-%@",self.dropLabel.text];
        }
    }else if([self.flagStr isEqualToString:@"2"]){
        double change = [[dict objectForKey:@"change"] doubleValue];
        self.dropLabel.backgroundColor = [UIColor colorWithHexString:@"FE413F"];
        self.dropLabel.text = [NSString stringWithFormat:@"%.2f%%",change * 100];
        if ( change > 0) {
            self.dropLabel.backgroundColor = RoseColor;
        }else{
            self.dropLabel.backgroundColor = [UIColor colorWithHexString:@"FE413F"];
            self.dropLabel.text = [NSString stringWithFormat:@"-%@",self.dropLabel.text];
        }
    }else if([self.flagStr isEqualToString:@"5"]){
        double change = [[dict objectForKey:@"change"] doubleValue];
        self.dropLabel.text = [NSString stringWithFormat:@"%.2f%%",change * 100];
        if ( change > 0) {
            self.dropLabel.backgroundColor = RoseColor;
        }else{
            self.dropLabel.backgroundColor = [UIColor colorWithHexString:@"FE413F"];
            self.dropLabel.text = [NSString stringWithFormat:@"-%@",self.dropLabel.text];
        }
    }else{
        double netAmount = [[dict objectForKey:@"netAmount"] doubleValue];
        NSString *numStr = [NSString stringWithFormat:@"%.0f",[[dict objectForKey:@"netAmount"] floatValue]];
        //                        NSString *tempStr = [[[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.0f",[atmosphereModel.amount floatValue]]] decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue];
        NSMutableAttributedString *string;
        if (numStr.length > 8) {//亿
            string =  [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%.2f亿",[numStr floatValue]/100000000]];
            
        }else if (numStr.length > 4 && (numStr.length) <= 8) {//万
            string =  [[NSMutableAttributedString alloc] initWithString:  [NSString stringWithFormat:@"%.2f万",[numStr floatValue]/100000000]];

        }else {
            string =  [[NSMutableAttributedString alloc] initWithString:  [NSString stringWithFormat:@"%.2f",[numStr floatValue]]];
        }
        self.dropLabel.attributedText = string;
        if ( netAmount > 0) {
            self.dropLabel.backgroundColor = RoseColor;
        }else{
//            self.dropLabel.text = [FormatUtil formatCount:netAmount];
            self.dropLabel.backgroundColor = [UIColor colorWithHexString:@"FE413F"];
        }
    }
}

+ (CGFloat)cellHeight{
    return 54;
}

- (UILabel *)createlabelframe:(CGRect)frame{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    label.textColor = [UIColor colorWithHexString:@"626A75" alpha:0.6];
    return label;
}

@end
