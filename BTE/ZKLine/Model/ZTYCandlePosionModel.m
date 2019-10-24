//
//  ZTYCandlePosionModel.m
//  BTE
//
//  Created by wanmeizty on 2018/7/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYCandlePosionModel.h"

@implementation ZTYCandlePosionModel

+ (ZTYCandlePosionModel *)initWithCandleModel:(ZTYChartModel *)candleModel left:(CGFloat)left maxY:(CGFloat)maxY scaleY:(CGFloat)scaleY topMagin:(CGFloat)topMagin{
   
    ZTYCandlePosionModel * model = [[ZTYCandlePosionModel alloc] init];
    
    /***************主图指标位置值************/
    model.highPoint = [self calcutePos:candleModel.high left:left maxY:maxY scaleY:scaleY];
    model.openPoint = [self calcutePos:candleModel.open left:left maxY:maxY scaleY:scaleY];
    model.lowPoint = [self calcutePos:candleModel.low left:left maxY:maxY scaleY:scaleY];
    model.closePoint = [self calcutePos:candleModel.close left:left maxY:maxY scaleY:scaleY];
    
    
    model.ma7Point = [self calcutePos:candleModel.MA5.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    model.ma10Point = [self calcutePos:candleModel.MA10.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    model.ma30Point = [self calcutePos:candleModel.MA30.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    
    
    model.ema7Point = [self calcutePos:candleModel.EMA7.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
//    model.ema10Point = [self calcutePos:candleModel.EMA12.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    model.ema30Point = [self calcutePos:candleModel.EMA30.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    
    model.midPoint = [self calcutePos:candleModel.BOLL_MB.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    model.uperPoint = [self calcutePos:candleModel.BOLL_UP.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    model.downPoint = [self calcutePos:candleModel.BOLL_DN.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    
    model.sarPoint = [self calcutePos:candleModel.ParOpen left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    
    
    
    if (candleModel.sellPrice5 > 0) {
        model.strance1Point = [self calcutePos:candleModel.sellPrice5 left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    }
    if (candleModel.buyPrice5 > 0) {
        model.strance2Point = [self calcutePos:candleModel.buyPrice5 left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    }
//    if (candleModel.strence3) {
//        model.strance3Point = [self calcutePos:candleModel.strence3 left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
//    }
//    if (candleModel.strence4) {
//        model.strance4Point = [self calcutePos:candleModel.strence4 left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
//    }
    
    model.supportPoint = [self calcutePos:candleModel.support left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    model.resitancePoint = [self calcutePos:candleModel.resistance left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
//    model.cancelPoint = [self calcutePos:candleModel.cancel left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    model.buyburnedPoint = [self calcutePos:candleModel.buyburned left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    model.sellburnedPoint = [self calcutePos:candleModel.sellburned left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    
//    /***************附图指标位置值************/
//    model.deaPoint = [self calcutePos:candleModel.DEA.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
//    model.difPoint = [self calcutePos:candleModel.DIF.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
//    model.macdPoint = [self calcutePos:candleModel.MACD.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
//
//    model.kPoint = [self calcutePos:candleModel.KDJ_K.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
//    model.dPoint = [self calcutePos:candleModel.KDJ_D.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
//    model.jPoint = [self calcutePos:candleModel.KDJ_J.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
//
//    model.rsi6Point = [self calcutePos:candleModel.RSI_6.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
//    model.rsi12Point = [self calcutePos:candleModel.RSI_12.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
//    model.rsi24Point = [self calcutePos:candleModel.RSI_24.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    
    return model;
    
}

+ (CGPoint)calcutePos:(CGFloat)value  left:(CGFloat)left maxY:(CGFloat)maxY scaleY:(CGFloat)scaleY topMagin:(CGFloat)topMagin{
    CGFloat poiontY = (maxY - value) * scaleY + topMagin;
    return CGPointMake(left, poiontY);
}

+ (CGPoint)calcutePos:(CGFloat)value  left:(CGFloat)left maxY:(CGFloat)maxY scaleY:(CGFloat)scaleY{
    CGFloat poiontY = (maxY - value) * scaleY;
    return CGPointMake(left, poiontY);
}

// 附图指标初始化
+(instancetype)initQuotePositionWithCandleModel:(ZTYChartModel *)candleModel left:(CGFloat)left maxY:(CGFloat)maxY scaleY:(CGFloat)scaleY topMagin:(CGFloat)topMagin{
    ZTYCandlePosionModel *model = [[ZTYCandlePosionModel alloc] init];
    /***************附图指标位置值************/
    model.deaPoint = [self calcutePos:candleModel.DEA.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    model.difPoint = [self calcutePos:candleModel.DIF.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    model.macdPoint = [self calcutePos:candleModel.MACD.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    
    model.kPoint = [self calcutePos:candleModel.KDJ_K.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    model.dPoint = [self calcutePos:candleModel.KDJ_D.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    model.jPoint = [self calcutePos:candleModel.KDJ_J.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    
    model.rsi6Point = [self calcutePos:candleModel.RSI_6.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    model.rsi12Point = [self calcutePos:candleModel.RSI_12.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    model.rsi24Point = [self calcutePos:candleModel.RSI_24.doubleValue left:left maxY:maxY scaleY:scaleY topMagin:topMagin];
    
    return model;
    
}

@end
