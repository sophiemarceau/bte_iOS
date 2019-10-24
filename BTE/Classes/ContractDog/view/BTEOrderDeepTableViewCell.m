//
//  BTEOrderDeepTableViewCell.m
//  BTE
//
//  Created by wanmeizty on 2018/7/23.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "BTEOrderDeepTableViewCell.h"

#define riseColor @"228B22"
#define dropColor @"FF4040"
#import "FormatUtil.h"

@interface BTEOrderDeepTableViewCell ()
@property (nonatomic,strong) UIView * percentView;
@property (nonatomic,strong) UILabel * percentLabel;
@property (nonatomic,strong) UILabel * priceLabel;
@property (nonatomic,strong) UILabel * orderLabel;

@end

@implementation BTEOrderDeepTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        self.selectionStyle = UITableViewCellEditingStyleNone;
    }
    return self;
}

- (void)createUI{
    
    CGFloat height = [BTEOrderDeepTableViewCell cellHeight];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 0.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"E5E5EE"];
    [self.contentView addSubview:lineView];
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 120, height)];
    self.priceLabel.textColor = [UIColor colorWithHexString:@"FF4040"];
    self.priceLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:12];
    [self.contentView addSubview:self.priceLabel];
    
    self.orderLabel = [[UILabel alloc] init];
    self.orderLabel.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 100, 0, 100, height);
    self.orderLabel.text = @"800";
    self.orderLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    self.orderLabel.textColor = [UIColor colorWithHexString:@"525866"];
    [self.contentView addSubview:self.orderLabel];
    
    self.percentView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5 - 80, 0, 80, height)];
    self.percentView.backgroundColor = [UIColor colorWithHexString:@"FF4040" alpha:0.1f];
    [self.contentView addSubview:self.percentView];
    
//    self.percentLabel = [[UILabel alloc] init];
//    self.percentLabel.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 100, 0, 100, height);
//    self.percentLabel.text = @"+10%";
//    self.percentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
//    self.percentLabel.textColor = [UIColor colorWithHexString:@"525866"];
//    [self.contentView addSubview:self.percentLabel];
    
}

- (void)configDict:(NSDictionary *)dict maxMindict:(NSDictionary *)maxMinDict{
    
    
    if (dict) {
        double nagetiveValue = [[maxMinDict objectForKey:@"nagetiveMaxKey"] doubleValue];
        
        double maxValue = [[maxMinDict objectForKey:@"maxkey"] doubleValue];
        
        
        double depth = [[dict objectForKey:@"depth"] doubleValue];
        
        //    int depthValue = depth * 100;
        
        
        NSInteger count = [[dict objectForKey:@"count"] integerValue];
        
        
//        NSInteger count = [[dict objectForKey:@"count"] integerValue];
        
        self.priceLabel.text = [NSString stringWithFormat:@"%@",@([[dict objectForKey:@"price"] doubleValue])];
        
        self.orderLabel.text = [NSString stringWithFormat:@"%ld",count];
        
        CGFloat height = [BTEOrderDeepTableViewCell cellHeight];
        
        if (depth > 0) {
            
            //        self.percentLabel.text = [NSString stringWithFormat:@"+%d%%",depthValue];
            self.orderLabel.textAlignment = NSTextAlignmentLeft;
            self.orderLabel.frame = CGRectMake(8, 0, 120, height);//CGRectMake(SCREEN_WIDTH * 0.5 - 126, 0, 120, height);
            
            self.percentLabel.textAlignment = NSTextAlignmentLeft;
            self.percentLabel.frame = CGRectMake(SCREEN_WIDTH * 0.5 + 6 , 0, SCREEN_WIDTH * 0.5 - 6, height);
            
            self.priceLabel.textAlignment = NSTextAlignmentRight;
            self.priceLabel.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 126, 0, 120, height);
            self.priceLabel.textColor = [UIColor colorWithHexString:@"FF4040"];
            
            
            double percentWidth = (count / maxValue) * (SCREEN_WIDTH * 0.5 - 8);
            self.percentView.frame = CGRectMake(SCREEN_WIDTH * 0.5 - percentWidth, 0, percentWidth, height);
            self.percentView.backgroundColor = [UIColor colorWithHexString:@"FF4040" alpha:0.1];
        }else{
            //        self.percentLabel.text = [NSString stringWithFormat:@"%d%%",depthValue];
            self.orderLabel.textAlignment = NSTextAlignmentRight;
            self.orderLabel.frame = CGRectMake(SCREEN_WIDTH - 128, 0, 120, height); //CGRectMake(SCREEN_WIDTH * 0.5 + 6, 0, 120, height);
            
            self.percentLabel.textAlignment = NSTextAlignmentRight;
            self.percentLabel.frame = CGRectMake( 0, 0, SCREEN_WIDTH * 0.5 - 6, height);
            
            self.priceLabel.textAlignment = NSTextAlignmentLeft;
            self.priceLabel.frame = CGRectMake(SCREEN_WIDTH * 0.5 + 6, 0, 120, height);
            self.priceLabel.textColor = [UIColor colorWithHexString:@"228B22"];
            
            double percentWidth = (count / nagetiveValue) * (SCREEN_WIDTH * 0.5 - 8);
            self.percentView.frame = CGRectMake(SCREEN_WIDTH * 0.5, 0, percentWidth, height);
            self.percentView.backgroundColor = [UIColor colorWithHexString:@"228B22" alpha:0.1];
        }
    }
}

- (void)configDict:(NSDictionary *)dict maxMindict:(NSDictionary *)maxMinDict base:(NSString *)base{
    if (dict) {
        double nagetiveValue = [[maxMinDict objectForKey:@"nagetiveMaxKey"] doubleValue];
        
        double maxValue = [[maxMinDict objectForKey:@"maxkey"] doubleValue];
        
        
        double depth = [[dict objectForKey:@"depth"] doubleValue];
        
        //    int depthValue = depth * 100;
        
        
        NSInteger count = [[dict objectForKey:@"count"] integerValue];
        
        
        //        NSInteger count = [[dict objectForKey:@"count"] integerValue];
        self.priceLabel.text = [NSString stringWithFormat:@"%@",@([[dict objectForKey:@"price"] doubleValue])];
        
//        if ([base isEqualToString:@"EOS"]) {
//            self.priceLabel.text = [NSString stringWithFormat:@"%.3f",[[dict objectForKey:@"price"] doubleValue]];
//        }else{
//            self.priceLabel.text = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"price"] doubleValue]];
//        }
        
        self.orderLabel.text = [NSString stringWithFormat:@"%ld",count];
        
        CGFloat height = [BTEOrderDeepTableViewCell cellHeight];
        
        if (depth > 0) {
            
            //        self.percentLabel.text = [NSString stringWithFormat:@"+%d%%",depthValue];
            self.orderLabel.textAlignment = NSTextAlignmentLeft;
            self.orderLabel.frame = CGRectMake(8, 0, 120, height);//CGRectMake(SCREEN_WIDTH * 0.5 - 126, 0, 120, height);
            
            self.percentLabel.textAlignment = NSTextAlignmentLeft;
            self.percentLabel.frame = CGRectMake(SCREEN_WIDTH * 0.5 + 6 , 0, SCREEN_WIDTH * 0.5 - 6, height);
            
            self.priceLabel.textAlignment = NSTextAlignmentRight;
            self.priceLabel.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 126, 0, 120, height);
            self.priceLabel.textColor = [UIColor colorWithHexString:@"FF4040"];
            
            
            double percentWidth = (count / maxValue) * (SCREEN_WIDTH * 0.5 - 8);
            self.percentView.frame = CGRectMake(SCREEN_WIDTH * 0.5 - percentWidth, 0, percentWidth, height);
            self.percentView.backgroundColor = [UIColor colorWithHexString:@"FF4040" alpha:0.1];
        }else{
            //        self.percentLabel.text = [NSString stringWithFormat:@"%d%%",depthValue];
            self.orderLabel.textAlignment = NSTextAlignmentRight;
            self.orderLabel.frame = CGRectMake(SCREEN_WIDTH - 128, 0, 120, height); //CGRectMake(SCREEN_WIDTH * 0.5 + 6, 0, 120, height);
            
            self.percentLabel.textAlignment = NSTextAlignmentRight;
            self.percentLabel.frame = CGRectMake( 0, 0, SCREEN_WIDTH * 0.5 - 6, height);
            
            self.priceLabel.textAlignment = NSTextAlignmentLeft;
            self.priceLabel.frame = CGRectMake(SCREEN_WIDTH * 0.5 + 6, 0, 120, height);
            self.priceLabel.textColor = [UIColor colorWithHexString:@"228B22"];
            
            double percentWidth = (count / nagetiveValue) * (SCREEN_WIDTH * 0.5 - 8);
            self.percentView.frame = CGRectMake(SCREEN_WIDTH * 0.5, 0, percentWidth, height);
            self.percentView.backgroundColor = [UIColor colorWithHexString:@"228B22" alpha:0.1];
        }
    }
}

+ (CGFloat )cellHeight{
    return 24;
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
