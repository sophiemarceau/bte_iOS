//
//  BTEBigOrderTableViewCell.m
//  BTE
//
//  Created by wanmeizty on 2018/7/23.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEBigOrderTableViewCell.h"
#import "FormatUtil.h"
@interface BTEBigOrderTableViewCell ()

@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UILabel * directionLabel;
@property (nonatomic,strong) UILabel * priceLabel;
@property (nonatomic,strong) UILabel * numLabel;
@property (nonatomic,strong) UILabel * statusLabel;

@end

@implementation BTEBigOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        self.selectionStyle = UITableViewCellEditingStyleNone;
    }
    return self;
}

- (void)createUI{
    
    CGFloat height = [BTEBigOrderTableViewCell cellHeight];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 0.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"E5E5EE"];
    [self.contentView addSubview:lineView];
    
    self.timeLabel = [self createLabelFrame:CGRectMake(16, 0, 54 * SCREEN_WIDTH / 375.0 , height)];
    self.timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    [self.contentView addSubview:self.timeLabel];
    
    self.directionLabel = [self createLabelFrame:CGRectMake(70 * SCREEN_WIDTH / 375.0, 0, 75 * SCREEN_WIDTH / 375.0 , height)];
    [self.contentView addSubview:self.directionLabel];
    
    self.priceLabel = [self createLabelFrame:CGRectMake(145 * SCREEN_WIDTH / 375.0, 0, 74 * SCREEN_WIDTH / 375.0 , height)];
    [self.contentView addSubview:self.priceLabel];
    
    self.numLabel = [self createLabelFrame:CGRectMake(219 * SCREEN_WIDTH / 375.0, 0, 90 * SCREEN_WIDTH / 375.0 , height)];
    [self.contentView addSubview:self.numLabel];
    
    self.statusLabel = [self createLabelFrame:CGRectMake(309 * SCREEN_WIDTH / 375.0, 0, 66 * SCREEN_WIDTH / 375.0 , height)];
    [self.contentView addSubview:self.statusLabel];

//    self.totalLabel.textAlignment = NSTextAlignmentRight;
}

- (void)configHanlistWithDict:(NSDictionary*)dict{
    
//    NSString *date = [dict objectForKey:@"date"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    
    NSInteger timeval = [[dict objectForKey:@"timestamp"] integerValue] / 1000;
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeval];
    NSString *date = [formatter stringFromDate:confromTimesp];
    
    self.directionLabel.text = [dict objectForKey:@"exchange"];
    
    NSString * month = [date substringWithRange:NSMakeRange(0, 2)];
    NSString * day = [date substringWithRange:NSMakeRange(3, 2)];
    NSString * time = [date substringWithRange:NSMakeRange(6, 5)];
    
    self.timeLabel.textColor = [UIColor colorWithHexString:@"525866" alpha:0.6];
    self.timeLabel.text = [NSString stringWithFormat:@"%@\n%d/%d",time,month.intValue,day.intValue];
    self.timeLabel.numberOfLines = 2;
    self.timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    
    self.priceLabel.text = [dict objectForKey:@"directionDesc"];
    if ([[dict objectForKey:@"directionName"] isEqualToString:@"sell"]) {
        self.priceLabel.textColor = DropColor;
    }else{
        self.priceLabel.textColor = RoseColor;
    }
    
    self.statusLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"count"]];
//    self.statusLabel.textAlignment = NSTextAlignmentRight;
    
    double price = [[dict objectForKey:@"price"] doubleValue];
    self.numLabel.text = [NSString stringWithFormat:@"%@",[FormatUtil formatprice:price]];
    
    
//    CGRect tempframe = self.statusLabel.frame;
//    tempframe.origin.y = 9;
//    tempframe.size.height = 12;
//
//    self.statusLabel.frame = tempframe;
    double totalPrice = [[dict objectForKey:@"totalPrice"] doubleValue];
    self.statusLabel.text = [NSString stringWithFormat:@"%@",[FormatUtil formatCount:totalPrice]];
    
    CGFloat height = [BTEBigOrderTableViewCell cellHeight];
    CGFloat lwidth = SCREEN_WIDTH / 5.0;
    self.timeLabel.frame = CGRectMake(0, 0, lwidth, height);
    
    self.directionLabel.frame = CGRectMake(lwidth * 1, 0, lwidth, height);
    
    self.priceLabel.frame = CGRectMake(lwidth * 2, 0, lwidth, height);
    self.numLabel.frame = CGRectMake(lwidth * 3, 0, lwidth, height);
    self.statusLabel.frame = CGRectMake(lwidth * 4, 0, lwidth, height);
    
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.directionLabel.textAlignment = NSTextAlignmentCenter;
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)configWithDict:(NSDictionary*)dict isBurnedOrder:(BOOL)isBurnedOrder  base:(NSString *)base{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];

    NSInteger timeval = [[dict objectForKey:@"datetime"] integerValue] / 1000;
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeval];
    NSString *date = [formatter stringFromDate:confromTimesp];
    
    
    
    
    self.directionLabel.text = [dict objectForKey:@"directionDesc"];
    
    if (isBurnedOrder) {
        
        NSString * month = [date substringWithRange:NSMakeRange(0, 2)];
        NSString * day = [date substringWithRange:NSMakeRange(3, 2)];
        NSString * time = [date substringWithRange:NSMakeRange(6, 5)];
        
        self.timeLabel.text = [NSString stringWithFormat:@"%@\n%d/%d",time,month.intValue,day.intValue];
        self.timeLabel.numberOfLines = 2;
        
        if ([[dict objectForKey:@"direction"] isEqualToString:@"sell"]) {
            self.directionLabel.textColor = DropColor;
        }else{
            self.directionLabel.textColor = RoseColor;
        }
        if ([base isEqualToString:@"EOS"]) {
            self.priceLabel.text = [NSString stringWithFormat:@"%.3f",[[dict objectForKey:@"price"] doubleValue]];
        }else{
            self.priceLabel.text = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"price"] doubleValue]];
        }
        self.numLabel.text = [NSString stringWithFormat:@"%@张",[self caculateValue:[[dict objectForKey:@"count"] doubleValue]]];
        
        self.statusLabel.text = [dict objectForKey:@"statusDesc"];
    }else{
        
        NSString * month = [date substringWithRange:NSMakeRange(0, 2)];
        NSString * day = [date substringWithRange:NSMakeRange(3, 2)];
        NSString * time = [date substringWithRange:NSMakeRange(6, 5)];
        
        self.timeLabel.text = [NSString stringWithFormat:@"%@\n%d/%d",time,month.intValue,day.intValue];
        self.timeLabel.numberOfLines = 2;
//        NSString * time = [date substringWithRange:NSMakeRange(6, 5)];
//        self.timeLabel.text = [NSString stringWithFormat:@"%@",time];
//        self.timeLabel.numberOfLines = 1;
        
        if ([[dict objectForKey:@"statusDesc"] isEqualToString:@"撤单"]) {
            self.backgroundColor = [UIColor colorWithHexString:@"f0f0f0" alpha:1];
        }else if([[dict objectForKey:@"statusDesc"] isEqualToString:@"成交"]){
            if ([[dict objectForKey:@"direction"] integerValue] == 1) {
                
                self.backgroundColor = [UIColor colorWithHexString:@"228B22" alpha:0.1];
                
            }else{
                self.backgroundColor = [UIColor colorWithHexString:@"FF4040" alpha:0.1];
                //        空单 sellburned
                
                
            }
        }else{
            self.backgroundColor = [UIColor whiteColor];
        }
        
        
        
        if ([[dict objectForKey:@"direction"] integerValue] == 1) {
            
            self.directionLabel.textColor = RoseColor;
            self.priceLabel.textColor = RoseColor;
            
        }else{
            //        空单 sellburned
            self.directionLabel.textColor = DropColor;
            self.priceLabel.textColor = DropColor;
            
        }
        
        self.priceLabel.text = [dict objectForKey:@"statusDesc"];
        if ([base isEqualToString:@"EOS"]){
            self.numLabel.text = [NSString stringWithFormat:@"%.3f",[[dict objectForKey:@"price"] doubleValue]];
        }else{
            self.numLabel.text = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"price"] doubleValue]];
        }
        
        self.statusLabel.text = [NSString stringWithFormat:@"%@张",[self caculateValue:[[dict objectForKey:@"count"] doubleValue]]];
        
    }
}

- (NSString *)caculateValue:(double)value{
    if (value > 100000000) {
        return [NSString stringWithFormat:@"%.2lf亿",(value / 100000000.0)];
    }else if (value > 10000){
        return [NSString stringWithFormat:@"%.2lf万",(value / 10000.0)];
    }else{
        return [NSString stringWithFormat:@"%.2lf",value];
    }
}

- (UILabel *)createLabelFrame:(CGRect)frame{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColor colorWithHexString:@"626A75"];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    return label;
}

+ (CGFloat )cellHeight{
    return 42;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
