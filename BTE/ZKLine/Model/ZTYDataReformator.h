//
//  ZTYDataReformator.h
//  BTE
//
//  Created by wanmeizty on 20/8/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTYDataReformator : NSObject
+ (NSArray <ZTYChartModel *>*)initializeQuotaDataWithArray:(NSArray <ZTYChartModel *>*)dataArray;
+ (void)handleQuotaDataWithDataArr:(NSArray *)dataArr model:(ZTYChartModel *)model index:(NSInteger)idx;
// 刷新最后一根
+ (NSArray <ZTYChartModel *>*)initializeQuotarefreshLastDataWithArray:(NSArray <ZTYChartModel *>*)dataArray;
// 计算最后一根
+ (NSArray <ZTYChartModel *>*)initializeQuotaLastDataWithArray:(NSArray <ZTYChartModel *>*)dataArray;
@end
