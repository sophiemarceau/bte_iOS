//
//  ZXQuotaDataReformer.m
//  ZXKlineDemo
//
//  Created by 郑旭 on 2017/9/13.
//  Copyright © 2017年 郑旭. All rights reserved.
//

#import "ZXQuotaDataReformer.h"
#import "ZXCalculator.h"
static NSString *const kRise = @"kRise";
static NSString *const kDrop = @"kDrop";
@implementation ZXQuotaDataReformer
static id _instance;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (NSArray <ZTYChartModel *>*)initializeQuotaDataWithArray:(NSArray <ZTYChartModel *>*)dataArray
{
    
    __weak typeof(self) weakSelf = self;
    [dataArray enumerateObjectsUsingBlock:^(ZTYChartModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        if (idx % 20 == 0)
        {
            model.isDrawDate = YES;
        }
        else
        {
            model.isDrawDate = NO;
        }
        [weakSelf handleQuotaDataWithDataArr:dataArray model:model index:idx];
        
    }];
    
    return dataArray;
}
// 刷新最后一根
- (NSArray <ZTYChartModel *>*)initializeQuotarefreshLastDataWithArray:(NSArray <ZTYChartModel *>*)dataArray{
    if (dataArray.count > 0) {
        ZTYChartModel * lastModel = [dataArray lastObject];
        [self refeshLastModelDataArray:dataArray lastModel:lastModel];
    }
    return dataArray;
}

- (void)refeshLastModelDataArray:(NSArray *)dataArr lastModel:(ZTYChartModel *)lastModel{
    NSInteger idx = dataArr.count - 1;
    
    //MACD
    [self calculateMACDWithDataArr:dataArr model:lastModel index:idx];
    
    //KDJ
    [self calculateKDJWithDataArr:dataArr model:lastModel index:idx];
    
    //SAR
    [self calculateSARWithDataArr:dataArr model:lastModel index:idx];
    
    //BOLL
    [self calculateBOLLWithDataArr:dataArr model:lastModel index:idx];
    //RSI
    [self calculateRSIWithDataArr:dataArr model:lastModel index:idx];
    //VOL
    [self calculateVOLWithDataArr:dataArr model:lastModel index:idx];
    //MA
    [self calculateMAWithDataArr:dataArr model:lastModel index:idx];
}

// 计算最后一根
- (NSArray <ZTYChartModel *>*)initializeQuotaLastDataWithArray:(NSArray <ZTYChartModel *>*)dataArray{
    
    if (dataArray.count > 0) {
        ZTYChartModel * lastModel = [dataArray lastObject];
        if ((dataArray.count - 1) % 20 == 0) {
            lastModel.isDrawDate = YES;
        }else{
            lastModel.isDrawDate = NO;
        }
        
        
        ZTYChartModel *previousKlineModel = [ZTYChartModel new];
        if (dataArray.count > 2) {
            
            previousKlineModel = dataArray[dataArray.count - 2];
        }
        
        lastModel.x = dataArray.count - 1;
        lastModel.previousKlineModel = previousKlineModel;
        lastModel.preKlineModel = previousKlineModel;
        
        [self dealDataArray:dataArray lastModel:lastModel];
    }
    return dataArray;
}

- (void)dealDataArray:(NSArray *)dataArr lastModel:(ZTYChartModel *)lastModel{
    NSInteger idx = dataArr.count - 1;
    
    //MACD
    [self calculateMACDWithDataArr:dataArr model:lastModel index:idx];
    
    //KDJ
    [self calculateKDJWithDataArr:dataArr model:lastModel index:idx];
    
    //SAR
    [self calculateSARWithDataArr:dataArr model:lastModel index:idx];
    
    //BOLL
    [self calculateBOLLWithDataArr:dataArr model:lastModel index:idx];
    //RSI
    [self calculateRSIWithDataArr:dataArr model:lastModel index:idx];
    //VOL
    [self calculateVOLWithDataArr:dataArr model:lastModel index:idx];
    //MA
    [self calculateMAWithDataArr:dataArr model:lastModel index:idx];
}

- (void)handleQuotaDataWithDataArr:(NSArray *)dataArr model:(ZTYChartModel *)model index:(NSInteger)idx
{
    model.x = idx;
    ZTYChartModel *previousKlineModel = [ZTYChartModel new];
    if (idx>0&&idx<dataArr.count) {
        
        previousKlineModel = dataArr[idx-1];
    }
    ZTYChartModel *nextKlineModel = [ZTYChartModel new];
    if (idx >= 0 && idx < (dataArr.count - 1)) {
        nextKlineModel = dataArr[idx+1];
    }
    model.previousKlineModel = previousKlineModel;
    model.preKlineModel = previousKlineModel;
    model.nextKlineModel = nextKlineModel;
    //MACD
    [self calculateMACDWithDataArr:dataArr model:model index:idx];
    
    //EMA
    //    [self calculateEMAWithDataArr:dataArr model:model index:idx];
    
    //KDJ
    [self calculateKDJWithDataArr:dataArr model:model index:idx];
    
    //SAR
    [self calculateSARWithDataArr:dataArr model:model index:idx];
    
    //BOLL
    [self calculateBOLLWithDataArr:dataArr model:model index:idx];
    //RSI
    [self calculateRSIWithDataArr:dataArr model:model index:idx];
    //VOL
    [self calculateVOLWithDataArr:dataArr model:model index:idx];
    //MA
    [self calculateMAWithDataArr:dataArr model:model index:idx];
}

- (void)calculateMAWithDataArr:(NSArray *)dataArr model:(ZTYChartModel *)model index:(NSInteger)idx
{
    NSInteger MAFiveNum = 5.0;
    if (idx>=MAFiveNum-1) {
        
        model.MA5 = @([self getPreviousAverageMAWithDataArr:dataArr dayCount:MAFiveNum index:idx]);
    }
    
    NSInteger MATenNum = 10.0;
    if (idx>=MATenNum-1) {
        
        model.MA10 = @([self getPreviousAverageMAWithDataArr:dataArr dayCount:MATenNum index:idx]);
        
    }
    
    NSInteger MATwentyNum = 20.0;
    if (idx>=MATwentyNum-1) {
        
        model.MA20 = @([self getPreviousAverageMAWithDataArr:dataArr dayCount:MATwentyNum index:idx]);
        
    }
    
    NSInteger MAThirtyNum = 30.0;
    if (idx>=MAThirtyNum-1) {
        
        model.MA30 = @([self getPreviousAverageMAWithDataArr:dataArr dayCount:MAThirtyNum index:idx]);
        
    }
    
}

- (double)getPreviousAverageStandWithDataArr:(NSArray *)dataArr dayCount:(NSInteger)dayCount index:(NSInteger)idx MAValue:(double)MAValue
{
    __block double sumOfMA = 0;
    for (NSInteger i = idx-(dayCount-1); i<=idx; i++) {
        
        if (i>=0&&i<dataArr.count) {
            ZTYChartModel *model = dataArr[i];
            sumOfMA += (model.close - MAValue)*(model.close - MAValue);
        }
    }
    return sumOfMA/dayCount;
}

- (double)getPreviousAverageMAWithDataArr:(NSArray *)dataArr dayCount:(NSInteger)dayCount index:(NSInteger)idx
{
    __block double sumOfMA = 0;
    for (NSInteger i = idx-(dayCount-1); i<=idx; i++) {
        
        if (i>=0&&i<dataArr.count) {
            ZTYChartModel *model = dataArr[i];
            sumOfMA += model.close;
        }
    }
    return sumOfMA/dayCount;
}
//MACD
//- (void)calculateMACDWithDataArr:(NSArray *)dataArr model:(ZYWCandleModel *)model index:(NSInteger)idx
//{
//    
//    //    [model reInitData];
//    [model reInitDataIndex:idx];
//}

//MACD
- (void)calculateMACDWithDataArr:(NSArray *)dataArr model:(ZTYChartModel *)model index:(NSInteger)idx
{
    
    //    [model reInitData];
    if (idx == 0) {
        model.MACD = @(0);
        model.DIF = @(0);
        model.DEA = @(0);
        
        model.EMA7 = @(0);
        model.EMA30 = @(0);
        
    }else if(idx == 1){
        model.EMA7 = @(model.previousKlineModel.close);
        model.EMA30 = @(model.previousKlineModel.close);
        
        model.EMA12 = @(model.previousKlineModel.close);
        model.EMA26 = @(model.previousKlineModel.close);
        
        model.MACD = @(0);
        model.DIF = @(0);
        model.DEA = @(0);
        
    }else{
        
        model.EMA7 = @((2.0 * model.close + 6.0 *(model.previousKlineModel.EMA7.doubleValue))/8.0);
        model.EMA30 = @((2.0 * model.close + 29.0 * model.previousKlineModel.EMA30.doubleValue)/31.0);
        
        model.EMA12 = @((2.0 * model.close + 11.0 *(model.previousKlineModel.EMA12.doubleValue))/13.0);
        model.EMA26 = @((2.0 * model.close + 25.0 * model.previousKlineModel.EMA26.doubleValue)/27.0);
        
        model.DIF = @(model.EMA12.doubleValue - model.EMA26.doubleValue);
        model.DEA = @(model.previousKlineModel.DEA.doubleValue * 0.8 + 0.2*model.DIF.doubleValue);
        model.MACD = @(2*(model.DIF.doubleValue - model.DEA.doubleValue));
    }
}

//EMA
- (void)calculateEMAWithDataArr:(NSArray *)dataArr model:(ZTYChartModel *)model index:(NSInteger)idx
{
    //    ZYWCandleModel *previousKlineModel = [ZYWCandleModel new];
    //    if (idx>0&&idx<dataArr.count) {
    //
    //        previousKlineModel = dataArr[idx-1];
    //    }
    //
    model.EMA7 = @([model calcuteEMAIndex:idx dayCount:7]);
    model.EMA30 = @([model calcuteEMAIndex:idx dayCount:30]);
}

//VOL
- (void)calculateVOLWithDataArr:(NSArray *)dataArr model:(ZTYChartModel *)model index:(NSInteger)idx
{
    NSInteger VOLFiveNum = 5.0;
    if (idx>=VOLFiveNum-1) {
        
        model.volumn_MA5 = @([self getPreviousAverageVolumnWithDataArr:dataArr dayCount:VOLFiveNum index:idx]);
    }
    
    NSInteger VOLTenNum = 10.0;
    if (idx>=VOLTenNum-1) {
        
        model.volumn_MA10 = @([self getPreviousAverageVolumnWithDataArr:dataArr dayCount:VOLTenNum index:idx]);
        
    }
    
    NSInteger VOLTwentyNum = 20.0;
    if (idx>=VOLTwentyNum-1) {
        
        model.volumn_MA20 = @([self getPreviousAverageVolumnWithDataArr:dataArr dayCount:VOLTwentyNum index:idx]);
        
    }
}
- (double)getPreviousAverageVolumnWithDataArr:(NSArray *)dataArr dayCount:(NSInteger)dayCount index:(NSInteger)idx
{
    __block double sumOfVolumn = 0;
    for (NSInteger i = idx-(dayCount-1); i<=idx; i++) {
        
        if (i>=0&&i<dataArr.count) {
            ZTYChartModel *model = dataArr[i];
            sumOfVolumn += [model.volumn doubleValue];
        }
    }
    return sumOfVolumn/dayCount;
}

//KDJ
- (void)calculateKDJWithDataArr:(NSArray *)dataArr model:(ZTYChartModel *)model index:(NSInteger)idx
{
    NSInteger num = 9;
    if (idx>=num-1) {
        NSMutableArray *previousNineKlineModelArr = [NSMutableArray array];
        for (NSInteger i = idx-(num-1); i<=idx; i++) {
            
            if (i>=0&&i<dataArr.count) {
                ZTYChartModel *model = dataArr[i];
                [previousNineKlineModelArr addObject:@(model.high)];
                [previousNineKlineModelArr addObject:@(model.low)];
            }
        }
        NSDictionary *resultDic = [[ZXCalculator sharedInstance] calculateMaxAndMinValueWithDataArr:previousNineKlineModelArr];
        model.HNinePrice = resultDic[kMaxValue];
        model.LNinePrice = resultDic[kMinValue];
        [model reInitKDJData];
    }
}

//SAR
- (void)calculateSARWithDataArr:(NSArray *)dataArr model:(ZTYChartModel *)model index:(NSInteger)idx
{
    
    double AfStep = 0.02;
    double AfLimit = 0.2;
    double oParClose = 0;
    if (idx == 0) {
        
        model.Postion = @(1);
        model.AF = AfStep;
        
        model.HHValue = @(model.high);
        model.LLValue = @(model.low);
        
        oParClose = model.LLValue.doubleValue;
        
        model.ParOpen = oParClose + model.AF * (model.HHValue.doubleValue - oParClose);
        
        if (model.ParOpen > model.low) {
            model.ParOpen = model.low;
        }
    }else{
        
        if (model.high > model.previousKlineModel.HHValue.doubleValue) {
            model.HHValue = @(model.high);
        }else{
            model.HHValue = model.previousKlineModel.HHValue;
        }
        
        
        
        if (model.low < model.previousKlineModel.LLValue.doubleValue) {
            model.LLValue = @(model.low);
        }else{
            model.LLValue = model.previousKlineModel.LLValue;
        }
        
        if (model.previousKlineModel.Postion.integerValue == 1) {
            
            if (model.low <= model.previousKlineModel.ParOpen) {
                
                model.Postion = @(-1);
                oParClose = model.HHValue.doubleValue;
                model.HHValue = @(model.high);
                model.LLValue = @(model.low);
                
                model.AF = AfStep;
                model.ParOpen = oParClose + model.AF * (model.LLValue.doubleValue - oParClose);
                if (model.ParOpen < model.high) {
                    model.ParOpen = model.high;
                }
                
                if (model.ParOpen < model.previousKlineModel.high) {
                    model.ParOpen = model.previousKlineModel.high;
                }
            }else{
                model.Postion =model.previousKlineModel.Postion;
                oParClose = model.previousKlineModel.ParOpen;
                
                if (model.HHValue.doubleValue > model.previousKlineModel.HHValue.doubleValue && model.previousKlineModel.AF < AfLimit) {
                    if (model.previousKlineModel.AF + AfStep > AfLimit) {
                        model.AF = AfLimit;
                    }else{
                        model.AF =model.previousKlineModel.AF + AfStep;
                    }
                }else{
                    model.AF = model.previousKlineModel.AF;
                }
                model.ParOpen = oParClose + model.AF * (model.HHValue.doubleValue - oParClose);
                
                if (model.ParOpen > model.low) {
                    model.ParOpen = model.low;
                }
                
                if (model.ParOpen > model.previousKlineModel.low) {
                    model.ParOpen = model.previousKlineModel.low;
                }
            }
        }else{
            
            if (model.high >= model.previousKlineModel.ParOpen) {
                
                model.Postion = @(1);
                oParClose = model.LLValue.doubleValue;
                model.HHValue = @(model.high);
                model.LLValue = @(model.low);
                
                model.AF = AfStep;
                model.ParOpen = oParClose + model.AF * (model.HHValue.doubleValue - oParClose);
                
                if (model.ParOpen > model.low) {
                    model.ParOpen = model.low;
                }
                
                if (model.ParOpen > model.previousKlineModel.low) {
                    model.ParOpen = model.previousKlineModel.low;
                }
                
            }else{
                model.Postion = model.previousKlineModel.Postion;
                oParClose = model.previousKlineModel.ParOpen;
                
                if (model.LLValue.doubleValue < model.previousKlineModel.LLValue.doubleValue && model.previousKlineModel.AF < AfLimit) {
                    if (model.previousKlineModel.AF + AfStep > AfLimit) {
                        model.AF = AfLimit;
                    }else{
                        model.AF = model.previousKlineModel.AF + AfStep;
                    }
                }else{
                    model.AF = model.previousKlineModel.AF;
                }
                model.ParOpen = oParClose + model.AF * (model.LLValue.doubleValue - oParClose);
                if (model.ParOpen < model.high) {
                    model.ParOpen = model.high;
                }
                
                if (model.ParOpen < model.previousKlineModel.high) {
                    model.ParOpen = model.previousKlineModel.high;
                }
            }
        }
    }
    
    //    }
}

//BOLL
- (void)calculateBOLLWithDataArr:(NSArray *)dataArr model:(ZTYChartModel *)model index:(NSInteger)idx
{
    
    NSInteger MAFiveNum = 20.0;
    if (idx>=MAFiveNum-1) {
        
        model.BOLL_MA = nil;
        model.BOLL_MA = @([self getPreviousAverageMAWithDataArr:dataArr dayCount:MAFiveNum index:idx]);
        model.BOLL_MB = model.BOLL_MA;
        double standPrice = [self getPreviousAverageStandWithDataArr:dataArr dayCount:MAFiveNum index:idx MAValue:model.BOLL_MA.doubleValue];
        
        model.x = idx;
        
        double up = model.BOLL_MA.doubleValue + 2 * sqrt(standPrice);
        
        double dn = model.BOLL_MA.doubleValue -2 * sqrt(standPrice);
        
        model.BOLL_DN = @(dn);
        model.BOLL_UP = @(up);
    }
    
}
//RSI
- (void)calculateRSIWithDataArr:(NSArray *)dataArr model:(ZTYChartModel *)model index:(NSInteger)idx
{
    NSInteger RSISixNum = 6;
    if (idx>=RSISixNum) {
        model.RSI_6 = @([self getRSIWithDataArr:dataArr dayCount:RSISixNum index:idx]);
    }
    
    NSInteger RSITwelveNum = 12;
    if (idx>=RSITwelveNum) {
        model.RSI_12 = @([self getRSIWithDataArr:dataArr dayCount:RSITwelveNum index:idx]);
    }
    
    NSInteger RSITwentyfourNum = 24;
    if (idx>=RSITwentyfourNum) {
        model.RSI_24 = @([self getRSIWithDataArr:dataArr dayCount:RSITwentyfourNum index:idx]);
    }
    [model judgeRSIIsNan];
}


- (double)getRSIWithDataArr:(NSArray *)dataArr dayCount:(NSInteger)dayCount index:(NSInteger)idx
{
    //    NSMutableArray *previousPriceArr = [NSMutableArray array];
    double riseSum = 0;
    double dropSum = 0;
    
    for (NSInteger i = 0; i< dayCount; i++) {
        
        if (i>=0&&i<dataArr.count) {
            ZTYChartModel *model = dataArr[i];
            double close = model.close;
            double preclose = model.preKlineModel.close;
            if (i == 0) {
                preclose = model.open;
            }
            
            //            [previousPriceArr addObject:@(close-open)];
            double changeValue = close - preclose;
            if (changeValue > 0) {
                riseSum += changeValue;
            }else{
                dropSum += -changeValue;
            }
            
            model = nil;
        }
    }
    
    if (idx > dayCount && idx < dataArr.count) {
        
        float upval = 0.0f;
        float downval = 0.0f;
        ZTYChartModel *model = dataArr[idx];
        double close = model.close;
        double preclose = model.preKlineModel.close;
        double changeValue = close - preclose;
        if (changeValue > 0) {
            upval = changeValue;
            downval = 0.f;
        } else {
            upval = 0.f;
            downval = -changeValue;
        }
        
        //        riseSum = (riseSum*(dayCount-1) + upval)/(dayCount * 1.0);
        //        dropSum = (dropSum*(dayCount-1) + downval)/(dayCount * 1.0);
        
        if (dayCount == 6) {
            
            riseSum = (model.preKlineModel.RSIRisSum_6.doubleValue * (dayCount-1) + upval)/(dayCount * 1.0);
            dropSum = (model.preKlineModel.RSIDropSum_6.doubleValue *(dayCount-1) + downval)/(dayCount * 1.0);
            
            model.RSIRisSum_6 =@(riseSum);
            model.RSIDropSum_6 =@(dropSum);
        }
        
        if (dayCount == 12) {
            
            riseSum = (model.preKlineModel.RSIRisSum_12.doubleValue * (dayCount-1) + upval)/(dayCount * 1.0);
            dropSum = (model.preKlineModel.RSIDropSum_12.doubleValue *(dayCount-1) + downval)/(dayCount * 1.0);
            
            model.RSIRisSum_12 =@(riseSum);
            model.RSIDropSum_12 =@(dropSum);
        }
        
        if (dayCount == 24) {
            
            riseSum = (model.preKlineModel.RSIRisSum_24.doubleValue * (dayCount-1) + upval)/(dayCount * 1.0);
            dropSum = (model.preKlineModel.RSIDropSum_24.doubleValue *(dayCount-1) + downval)/(dayCount * 1.0);
            
            model.RSIRisSum_24 =@(riseSum);
            model.RSIDropSum_24 =@(dropSum);
        }
    }
    
    double riseRate = riseSum;
    double dropRate = dropSum;
    
    
    //    double riseRate = riseSum/(riseCount* 1.0);
    //    double dropRate = dropSum/(dropCount*(-1.0));
    double RS       = riseRate/dropRate;
    double RSI      = (100-(100/(1+RS)));
    return RSI;
    
}

//- (double)getRSIWithDataArr:(NSArray *)dataArr dayCount:(NSInteger)dayCount index:(NSInteger)idx
//{
//    NSMutableArray *previousPriceArr = [NSMutableArray array];
//    for (NSInteger i = idx-(dayCount-1); i<=idx; i++) {
//
//        if (i>=0&&i<dataArr.count) {
//            ZYWCandleModel *model = dataArr[i];
//            double close = model.close;
//            double open = model.open;
//            [previousPriceArr addObject:@(close-open)];
//            model = nil;
//        }
//    }
//    return [self getRSIWithPreviousPriceOfChangeArr:previousPriceArr dayCount:dayCount];
//
//}

- (double)getRSIWithPreviousPriceOfChangeArr:(NSArray *)previousPriceOfChangeArr dayCount:(double)dayCount
{
    
    NSDictionary *sumDic = [self getSumOfRiseAndDropWithPreviousPriceOfChangeArr:previousPriceOfChangeArr];
    double riseSum  = [sumDic[kRise] doubleValue];
    double dropSum  = [sumDic[kDrop] doubleValue];
    double riseRate = riseSum/dayCount;
    double dropRate = dropSum/dayCount*(-1);
    double RS       = riseRate/dropRate;
    double RSI      = (100-(100/(1+RS)));
    return RSI;
}

- (NSDictionary *)getSumOfRiseAndDropWithPreviousPriceOfChangeArr:(NSArray *)previousPriceOfChangeArr
{
    __block double sumOfRise = 0;
    __block double sumOfDrop = 0;
    
    [previousPriceOfChangeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        double changeValue = [obj doubleValue];
        if (changeValue>=0) {
            
            sumOfRise +=changeValue;
        }else
        {
            sumOfDrop += changeValue;
        }
        
    }];
    NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:@(sumOfRise),kRise,@(sumOfDrop),kDrop,nil];
    return resultDic;
}
@end

