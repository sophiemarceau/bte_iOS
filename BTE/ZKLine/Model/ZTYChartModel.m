//
//  ZTYChartModel.m
//  BTE
//
//  Created by wanmeizty on 20/8/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYChartModel.h"

@implementation ZTYChartModel
- (void)initBaseDataWithDict:(NSDictionary *)dict{
    if (self) {
        
        self.close = (long double)[[dict objectForKey:@"close"] doubleValue];
        self.open = (long double)[[dict objectForKey:@"open"] doubleValue];
        self.low = (long double)[[dict objectForKey:@"low"] doubleValue];
        self.high = (long double)[[dict objectForKey:@"high"] doubleValue];
        self.volumn = @([[dict objectForKey:@"vol"] doubleValue]);
        self.timestamp = [NSString stringWithFormat:@"%@",[dict objectForKey:@"date"]];
        NSDictionary * extraDict = [dict objectForKey:@"extra"];
        NSDictionary * resistance = [extraDict objectForKey:@"resistance"];
        if (resistance && ![resistance isEqual:[NSNull null]]) {
            
            self.sellPrice5 = [[resistance objectForKey:@"sell_price_5"] doubleValue];
            self.sellCumulativeAmount5 = [[resistance objectForKey:@"sell_cumulativeAmount_5"] doubleValue];
            self.buyPrice5 = [[resistance objectForKey:@"buy_price_5"] doubleValue];
            self.buyCumulativeAmount5 = [[resistance objectForKey:@"buy_cumulativeAmount_5"] doubleValue];
            
        }
        NSDictionary * volume = [extraDict objectForKey:@"volume"];
        if (volume && ![volume isEqual:[NSNull null]]) {
            self.sellCount = [[volume objectForKey:@"sellCount"] integerValue];
            self.buyCount = [[volume objectForKey:@"buyCount"] integerValue];
            
            self.count = self.buyCount + self.sellCount;
        }
        
        NSArray * abnormity = [extraDict objectForKey:@"abnormity"];
        if (abnormity && ![abnormity isEqual:[NSNull null]]) {
            for (NSDictionary * subDict in abnormity) {
                if ([[subDict objectForKey:@"orderType"] isEqualToString:@"sell"]) {
                    
                    self.resistance = [[subDict objectForKey:@"price"] doubleValue];
                    self.resistanceCount = [[subDict objectForKey:@"count"] integerValue];
                    self.resistanceType = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"orderType"]];
                }else if ([[subDict objectForKey:@"orderType"] isEqualToString:@"buy"]){
                    self.support = [[subDict objectForKey:@"price"] doubleValue];
                    self.supportCount = [[subDict objectForKey:@"count"] integerValue];
                    self.supportType = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"orderType"]];
                }else if ([[subDict objectForKey:@"orderType"] isEqualToString:@"cancelbuy"]){
                    self.cancelbuy = [[subDict objectForKey:@"price"] doubleValue];
                    self.cancelbuyCount = [[subDict objectForKey:@"count"] integerValue];
                    
                }else if ([[subDict objectForKey:@"orderType"] isEqualToString:@"cancelsell"]){
                    
                    self.cancelsell = [[subDict objectForKey:@"price"] doubleValue];
                    self.cancelsellCount = [[subDict objectForKey:@"count"] integerValue];
                    
                }else if ([[subDict objectForKey:@"orderType"] isEqualToString:@"tradebuy"]){
                    self.tradebuy = [[subDict objectForKey:@"price"] doubleValue];
                    self.tradebuyCount = [[subDict objectForKey:@"count"] integerValue];
                    
                }else if ([[subDict objectForKey:@"orderType"] isEqualToString:@"tradesell"]){
                    self.tradesell = [[subDict objectForKey:@"price"] doubleValue];
                    self.tradesellCount = [[subDict objectForKey:@"count"] integerValue];
                    
                }else if ([[subDict objectForKey:@"orderType"] isEqualToString:@"bigbuy"]){
                    
                    self.bigbuy = [[subDict objectForKey:@"price"] doubleValue];
                    self.bigbuyCount = [[subDict objectForKey:@"count"] integerValue];
                }else if ([[subDict objectForKey:@"orderType"] isEqualToString:@"bigsell"]){
                    
                    self.bigsell = [[subDict objectForKey:@"price"] doubleValue];
                    self.bigsellCount = [[subDict objectForKey:@"count"] integerValue];
                   
                }else if ([[subDict objectForKey:@"orderType"] isEqualToString:@"threshold"]){
                    
                    self.threshold = [[subDict objectForKey:@"price"] doubleValue];
                    self.thresholdCount = [[subDict objectForKey:@"count"] integerValue];
                   
                    
                }else if ([[subDict objectForKey:@"orderType"] isEqualToString:@"sellburned"]){
                    
                    self.sellburned = [[subDict objectForKey:@"price"] doubleValue];
                    self.sellburnedCount = [[subDict objectForKey:@"count"] integerValue];
                    self.sellburnedType = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"orderType"]];
                }else if ([[subDict objectForKey:@"orderType"] isEqualToString:@"buyburned"]){
                    self.buyburned = [[subDict objectForKey:@"price"] doubleValue];
                    self.buyburnedCount = [[subDict objectForKey:@"count"] integerValue];
                    self.buyburnedType = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"orderType"]];
                }
                
            }
        }
        //        self.SumOfLastClose = @(_close + self.preKlineModel.SumOfLastClose.floatValue);
        [self setTime:[dict objectForKey:@"date"]];
        
    }
}

- (void)initBaseDataWithArray:(NSArray *)array{
    if (self) {
        
        self.close = (long double)[[array objectAtIndex:1] doubleValue];
        self.open = (long double)[[array objectAtIndex:2] doubleValue];
        self.high = (long double)[[array objectAtIndex:3] doubleValue];
        self.low = (long double)[[array objectAtIndex:4] doubleValue];
//        self.volumn = @([[dict objectForKey:@"vol"] doubleValue]);
//        self.timestamp = [NSString stringWithFormat:@"%@",[dict objectForKey:@"date"]];
        
        self.date = array[0];
        
    }
}

- (double)formatte:(double)number{
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = kCFNumberFormatterNoStyle;
    NSString * string = [formatter stringFromNumber:[NSNumber numberWithDouble:number]];
    return string.doubleValue;
}

- (void)setTime:(NSString *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"];
    
    NSInteger timeval = [time integerValue] / 1000;
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeval];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    self.date = confromTimespStr;
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *confromTimeStr = [formatter stringFromDate:confromTimesp];
    self.timeStr = confromTimeStr;
    
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    NSString *confromTimeStr2 = [formatter stringFromDate:confromTimesp];
    self.timeString = confromTimeStr2;
}

- (void)initData
{
    [self EMA12];
    [self EMA26];
    [self DIF];
    [self DEA];
    [self MACD];
    //    [self initBOLLData];
}

//在最新的蜡烛数据来的时候需要重新每次计算
- (void)reInitData
{
    
    self.EMA12 = @((2.0 * self.close + 11 *(self.previousKlineModel.EMA12.doubleValue))/13.0);
    self.EMA26 = @((2 * self.close + 25 * self.previousKlineModel.EMA26.doubleValue)/27);
    self.DIF = @(self.EMA12.doubleValue - self.EMA26.doubleValue);
    self.DEA = @(self.previousKlineModel.DEA.doubleValue * 0.8 + 0.2*self.DIF.doubleValue);
    self.MACD = @(2*(self.DIF.doubleValue - self.DEA.doubleValue));
    
}

- (double)calcuteEMAIndex:(NSInteger)index dayCount:(NSInteger)dayCount{
    if (index == 0) {
        return 0;
    }else if (index == 1){
        return self.previousKlineModel.close;
    }else{
        return ((2.0 * self.close + (dayCount - 1.0) *(self.previousKlineModel.EMA12.doubleValue))/(dayCount + 1.0));
    }
}

//在最新的蜡烛数据来的时候需要重新每次计算
- (void)reInitDataIndex:(NSInteger)index
{
    if (index == 0) {
        self.MACD = @(0);
        self.DIF = @(0);
        self.DEA = @(0);
        
        self.EMA7 = @(0);
        self.EMA30 = @(0);
        
    }else if(index == 1){
        self.EMA7 = @(self.previousKlineModel.close);
        self.EMA30 = @(self.previousKlineModel.close);
        
        self.EMA12 = @(self.previousKlineModel.close);
        self.EMA26 = @(self.previousKlineModel.close);
        
        self.MACD = @(0);
        self.DIF = @(0);
        self.DEA = @(0);
        
    }else{
        
        self.EMA7 = @((2.0 * self.close + 6.0 *(self.previousKlineModel.EMA7.doubleValue))/8.0);
        self.EMA30 = @((2.0 * self.close + 29.0 * self.previousKlineModel.EMA30.doubleValue)/31.0);
        
        self.EMA12 = @((2.0 * self.close + 11.0 *(self.previousKlineModel.EMA12.doubleValue))/13.0);
        self.EMA26 = @((2.0 * self.close + 25.0 * self.previousKlineModel.EMA26.doubleValue)/27.0);
        
        self.DIF = @(self.EMA12.doubleValue - self.EMA26.doubleValue);
        self.DEA = @(self.previousKlineModel.DEA.doubleValue * 0.8 + 0.2*self.DIF.doubleValue);
        self.MACD = @(2*(self.DIF.doubleValue - self.DEA.doubleValue));
    }
    
    
}

- (void)reInitDataWithDif:(double)dif dea:(double)dea macd:(double)macd{
    self.DIF = nil;
    self.DEA = nil;
    self.MACD = nil;
    self.DIF = @(dif);
    self.DEA = @(dea);
    self.MACD = @(macd);
}
- (NSNumber *)EMA12
{
    if (_EMA12==nil) {
        
        if (self.x==0) {
            
            _EMA12 = @(self.close);
            
        }else{
            
            _EMA12 = @((2.0 * self.close + 11 *(_previousKlineModel.EMA12.doubleValue))/13.0);
        }
    }
    return _EMA12;
}
- (NSNumber *)EMA26
{
    if (self.x==0) {
        
        _EMA26 = @(self.close);
    }else{
        _EMA26 = @((2 * self.close + 25 * self.previousKlineModel.EMA26.doubleValue)/27);
    }
    return _EMA26;
}
- (NSNumber *)DIF
{
    if (_DIF==nil) {
        
        _DIF = @(self.EMA12.doubleValue - self.EMA26.doubleValue);
    }
    return _DIF;
}
- (NSNumber *)DEA
{
    if (_DEA==nil) {
        
        _DEA = @(self.previousKlineModel.DEA.doubleValue * 0.8 + 0.2*self.DIF.doubleValue);
    }
    return _DEA;
}
- (NSNumber *)MACD
{
    if (_MACD==nil) {
        _MACD = @(2*(self.DIF.doubleValue - self.DEA.doubleValue));
    }
    return _MACD;
}


//KDJ
- (void)reInitKDJData
{
    
    self.RSV_9 = @((self.close - self.LNinePrice.doubleValue)/(self.HNinePrice.doubleValue-self.LNinePrice.doubleValue)*100);
    
    
    double previousK = 0;
    if (self.x==8) {
        
        previousK = 50;
    }else{
        previousK = self.previousKlineModel.KDJ_K.doubleValue;
    }
    self.KDJ_K = @(previousK*2/3.0+1/3.0*self.RSV_9.doubleValue);
    
    
    double previousD = 0;
    if (self.x==8) {
        
        previousD = 50;
    }else{
        previousD = self.previousKlineModel.KDJ_D.doubleValue;
    }
    self.KDJ_D = @(previousD*2/3.0+1/3.0*self.KDJ_K.doubleValue);
    
    
    self.KDJ_J = @(3*self.KDJ_K.doubleValue-2*self.KDJ_D.doubleValue);
    
    if (isnan(self.KDJ_K.doubleValue)) {
        self.KDJ_K = self.previousKlineModel.KDJ_K;
        
    }
    if (isnan(self.KDJ_D.doubleValue)) {
        
        self.KDJ_D = self.previousKlineModel.KDJ_D;
    }
    if (isnan(self.KDJ_J.doubleValue)) {
        
        self.KDJ_J = self.previousKlineModel.KDJ_J;
    }
}

- (void)reInitDataWithk:(double)k d:(double)d j:(double)j{
    self.KDJ_K = nil;
    self.KDJ_D = nil;
    self.KDJ_J = nil;
    self.KDJ_K = @(k);
    self.KDJ_D = @(d);
    self.KDJ_J = @(j);
}

//BOLL

//- (void)reInitBOLLData
//{
//
//    if (self.x<=19) {
//
//        self.BOLL_MB = self.BOLL_MA;
//    }else{
//
//        self.BOLL_MB = self.previousKlineModel.BOLL_MA;
//    }
//
//    self.BOLL_UP = @(self.BOLL_MB.doubleValue + 2*self.BOLL_MD.doubleValue);
//
//    self.BOLL_DN = @(self.BOLL_MB.doubleValue - 2*self.BOLL_MD.doubleValue);
//}

#pragma mark BOLL线

//- (NSNumber *)SumOfLastClose
//{
//    if(!_SumOfLastClose) {
//        _SumOfLastClose = @(self.preKlineModel.SumOfLastClose.floatValue + self.close);
//    }
//    return _SumOfLastClose;
//}
//
//- (NSNumber *)BOLL_MA{
//
//    if (!_BOLL_MA) {
//
//        NSInteger index = [self.currentArray indexOfObject:self];
//
//        if (index >= 19) {
//            if (index > 19) {
//
//                ZYWCandleModel * model = self.currentArray[index - 20];
//                _BOLL_MA = @((self.SumOfLastClose.floatValue - model.SumOfLastClose.floatValue) / 20);
//            } else {
//                _BOLL_MA = @(self.SumOfLastClose.floatValue / 20);
//            }
//        }
//    }
//    return _BOLL_MA;
//
//}
//
//- (NSNumber *)BOLL_MB {
//
//    if(!_BOLL_MB) {
//
////        NSInteger index = [self.currentArray indexOfObject:self];
//
////        if (index >= 19) {
////
////
////        }
//
////        if (index > 19) {
//            _BOLL_MB = self.BOLL_MA;
//            //                ZYWCandleModel * model = self.currentArray[index - 19];
//            //                _BOLL_MB = @((self.SumOfLastClose.floatValue - model.SumOfLastClose.floatValue) / 19);
//
////        } else {
////            _BOLL_MB = self.preKlineModel.BOLL_MA;
////            //                _BOLL_MB = @(self.SumOfLastClose.floatValue / index);
////
////        }
////        _BOLL_MB = _BOLL_MA;
//        // NSLog(@"lazyMB:\n _BOLL_MB: %@", _BOLL_MB);
//
//    }
//
//    return _BOLL_MB;
//}
//
////- (NSNumber *)BOLL_MD {
////
////    if (!_BOLL_MD) {
////
////        NSInteger index = [self.currentArray indexOfObject:self];
////
////        if (index >= 20) {
////            ZYWCandleModel * model = self.currentArray[index - 20];
////            _BOLL_MD = @(sqrt((self.preKlineModel.BOLL_SUBMD_SUM.floatValue - model.BOLL_SUBMD_SUM.floatValue)/ 20));
////
////        }
////
////    }
////
////    // NSLog(@"lazy:\n_BOLL_MD:%@ -- BOLL_SUBMD:%@",_BOLL_MD,_BOLL_SUBMD);
////
////    return _BOLL_MD;
////}
//
//- (NSNumber *)BOLL_UP {
//    if (!_BOLL_UP) {
////        NSInteger index = [self.currentArray indexOfObject:self];
////        if (index >= 20) {
////            _BOLL_UP = @(self.BOLL_MB.floatValue + 2 * self.BOLL_Standard.floatValue);
////        }
//        _BOLL_UP = @(self.BOLL_MB.floatValue + 2 * self.BOLL_Standard.floatValue);
//    }
//
//    // NSLog(@"lazy:\n_BOLL_UP:%@ -- BOLL_MD:%@",_BOLL_UP,_BOLL_MD);
//
//    return _BOLL_UP;
//}
//
//- (NSNumber *)BOLL_DN {
//    if (!_BOLL_DN) {
////        NSInteger index = [self.currentArray indexOfObject:self];
////        if (index >= 20) {
////            _BOLL_DN = @(self.BOLL_MB.floatValue - 2 * self.BOLL_Standard.floatValue);
////        }
//        _BOLL_DN = @(self.BOLL_MB.floatValue - 2 * self.BOLL_Standard.floatValue);
//    }
//
//    // NSLog(@"lazy:\n_BOLL_DN:%@ -- BOLL_MD:%@",_BOLL_DN,_BOLL_MD);
//
//    return _BOLL_DN;
//}
//
////- (NSNumber *)BOLL_SUBMD_SUM {
////
////    if (!_BOLL_SUBMD_SUM) {
////
////        NSInteger index = [self.currentArray indexOfObject:self];
////        if (index >= 20) {
////
////            _BOLL_SUBMD_SUM = @(self.preKlineModel.BOLL_SUBMD_SUM.floatValue + self.BOLL_SUBMD.floatValue);
////
////        }
////    }
////
////    // NSLog(@"lazy:\n_BOLL_SUBMD_SUM:%@ -- BOLL_SUBMD:%@",_BOLL_SUBMD_SUM,_BOLL_SUBMD);
////
////    return _BOLL_SUBMD_SUM;
////}
////
////- (NSNumber *)BOLL_SUBMD{
////
////    if (!_BOLL_SUBMD) {
////
////        NSInteger index = [self.currentArray indexOfObject:self];
////
////        if (index >= 20) {
////
////            _BOLL_SUBMD = @((self.close - self.BOLL_MA.floatValue) * ( self.close - self.BOLL_MA.floatValue));
////
////        }
////    }
////
////    // NSLog(@"lazy_BOLL_SUBMD: \n MA20: %@ \n Close: %@ \n subNum: %f", _MA20, _Close, self.Close.floatValue - self.MA20.floatValue);
////
////    return _BOLL_SUBMD;
////}
//
//- (void)initBOLLData{
////    [self BOLL_MA];
////    [self BOLL_MD];
//    [self BOLL_MB];
//    [self BOLL_UP];
//    [self BOLL_DN];
//    [self BOLL_SUBMD];
//    [self BOLL_SUBMD_SUM];
//}
//
//- (void)initReinitBOLL{
//
////    self.BOLL_MB = nil;
//    self.BOLL_UP = nil;
//    self.BOLL_DN = nil;
//
////    [self BOLL_MA];
////    [self BOLL_MD];
////    [self BOLL_MB];
//    [self BOLL_UP];
//    [self BOLL_DN];
////    [self BOLL_SUBMD];
////    [self BOLL_SUBMD_SUM];
//}
//
//- (void)initBOLLData:(NSArray *)array{
//    self.currentArray = array.copy;
//    [self BOLL_MA];
//    [self BOLL_MD];
//    [self BOLL_MB];
//    [self BOLL_UP];
//    [self BOLL_DN];
//    [self BOLL_SUBMD];
//    [self BOLL_SUBMD_SUM];
//}


//RSI
- (void)judgeRSIIsNan
{
    if (isnan(self.RSI_6.doubleValue)) {
        
        self.RSI_6 = self.previousKlineModel.RSI_6;
    }
    if (isnan(self.RSI_12.doubleValue)) {
        
        self.RSI_12 = self.previousKlineModel.RSI_12;
    }
    if (isnan(self.RSI_24.doubleValue)) {
        
        self.RSI_24 = self.previousKlineModel.RSI_24;
    }
}

//VOL

//WR
- (NSNumber *)WR {
    if (!_WR) {
        _WR = @(0);
    }
    // NSLog(@"lazy:\n_BOLL_DN:%@ -- BOLL_MD:%@",_BOLL_DN,_BOLL_MD);
    return _WR;
}

- (void)initWR:(double)WR{
    self.WR = nil;
    self.WR = @(WR);
}
@end
