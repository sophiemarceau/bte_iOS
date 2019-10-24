//
//  ZXQuotaDataReformer.h
//  ZXKlineDemo
//
//  Created by 郑旭 on 2017/9/13.
//  Copyright © 2017年 郑旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZTYChartModel.h"
@interface ZXQuotaDataReformer : NSObject
+ (instancetype)sharedInstance;
- (void)handleQuotaDataWithDataArr:(NSArray *)dataArr model:(ZTYChartModel *)model index:(NSInteger)idx;
- (NSArray <ZTYChartModel *>*)initializeQuotaDataWithArray:(NSArray <ZTYChartModel *>*)dataArray;

// 刷新最后一根
- (NSArray <ZTYChartModel *>*)initializeQuotarefreshLastDataWithArray:(NSArray <ZTYChartModel *>*)dataArray;
// 计算最后一根
- (NSArray <ZTYChartModel *>*)initializeQuotaLastDataWithArray:(NSArray <ZTYChartModel *>*)dataArray;
@end

