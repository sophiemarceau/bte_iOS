//
//  ZTYKlineTableViewCell.m
//  BTE
//
//  Created by wanmeizty on 2018/7/24.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYKlineTableViewCell.h"
#import "ZTYCircleLayer.h"
#import "ZTYDialogTextLayer.h"

@interface ZTYKlineTableViewCell ()
@property (nonatomic,strong) CAShapeLayer * upLayer;
@property (nonatomic,strong) CAShapeLayer * downLayer;
@property (nonatomic,strong) CAShapeLayer * midLayer;

@property (nonatomic,strong) CAShapeLayer * klineLayer;
@property (nonatomic,strong) CAShapeLayer * kUplineLayer;
@property (nonatomic,strong) CAShapeLayer * kDownlineLayer;

@property (nonatomic,strong) CAShapeLayer * timerLayer;

// 短评
@property (nonatomic,strong) ZTYCircleLayer * circleLayer;
@property (nonatomic,strong) ZTYDialogTextLayer * dialogLayer;

@end

@implementation ZTYKlineTableViewCell

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
        [self createView];
    }
    return self;
}

- (void)createView{
    
    self.backgroundColor = [UIColor yellowColor];
    self.upLayer = [self lineLayer];
    [self.contentView.layer addSublayer:self.upLayer];
    
    self.midLayer = [self lineLayer];
    [self.contentView.layer addSublayer:self.midLayer];
    
    self.downLayer = [self lineLayer];
    [self.contentView.layer addSublayer:self.downLayer];
    
    self.timerLayer = [self lineLayer];
    [self.contentView.layer addSublayer:self.timerLayer];
    
    self.klineLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.klineLayer];
    
    self.kUplineLayer = [CAShapeLayer layer];
    [self.contentView.layer addSublayer:self.kUplineLayer];
    
    self.kDownlineLayer = [CAShapeLayer layer];
    [self.contentView.layer addSublayer:self.kDownlineLayer];
    
}

- (void)configWidth:(ZTYChartModel *)model scaleY:(CGFloat)scaleY topMargin:(CGFloat)topMargin maxY:(CGFloat)maxY candleWidth:(CGFloat)candleWidth candleSpace:(CGFloat)candleSpace;{
    
    CGFloat openPrice = (maxY - model.open) * scaleY + topMargin;
    CGFloat closePrice = (maxY - model.close) * scaleY + topMargin;
    CGFloat hightPrice = (maxY - model.high) * scaleY + topMargin;
    CGFloat lowPrice = (maxY - model.low) * scaleY + topMargin;
    CGFloat y = openPrice > closePrice ? (closePrice) : (openPrice);
    CGFloat height = MAX(fabs(closePrice-openPrice), 1);
    
    CGRect rect = CGRectMake(candleSpace * 0.5, y, candleWidth, height);
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:rect];
    self.klineLayer.path = path.CGPath;
    if (model.open > model.close) {
//        RoseColor
        
        self.klineLayer.strokeColor = RoseColor.CGColor;
        self.klineLayer.fillColor = RoseColor.CGColor;
    }else{
        self.klineLayer.strokeColor = DropColor.CGColor;
        self.klineLayer.fillColor = DropColor.CGColor;
    }
}

- (CAShapeLayer *)lineLayer{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.lineWidth = KLineWidth; //self.lineWidth;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.fillColor = [[UIColor clearColor] CGColor];
    layer.contentsScale = [UIScreen mainScreen].scale;
    return layer;
}

@end
