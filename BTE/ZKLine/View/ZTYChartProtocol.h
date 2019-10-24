//
//  ZTYChartProtocol.h
//  BTE
//
//  Created by wanmeizty on 21/8/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZTYChartProtocol <NSObject>

@optional

/**
 取得当前屏幕内模型数组的开始下标以及个数
 
 @param leftPostion 当前屏幕最右边的位置
 @param index 下标
 @param count 个数
 */
- (void)displayScreenleftPostion:(CGFloat)leftPostion startIndex:(NSInteger)index count:(NSInteger)count;

/**
 长按手势获得当前k线下标以及模型
 
 @param kLineModeIndex 当前k线在可视范围数组的位置下标
 @param kLineModel   k线模型
 */
- (void)longPressCandleViewWithIndex:(NSInteger)kLineModeIndex kLineModel:(ZTYChartModel *)kLineModel startIndex:(NSInteger)index;

/**
 点击手势获得当前k线下标以及模型
 
 @param kLineModeIndex 当前k线在可视范围数组的位置下标
 @param kLineModel   k线模型
 */
- (void)tapCandleViewWithIndex:(NSInteger)kLineModeIndex kLineModel:(ZTYChartModel *)kLineModel startIndex:(NSInteger)index price:(CGFloat)price;

/**
 返回当前屏幕最后一根k线模型
 
 @param kLineModel k线模型
 */
- (void)displayLastModel:(ZTYChartModel *)kLineModel;

/**
 加载更多数据
 */
- (void)displayMoreData;

/**
 返回当前屏幕最后一根k线模型指标 dict
 
 @param dict
 */
//- (void)displayQuotaLastDict:(NSDictionary *)dict;

/**
 返回当前屏幕最后一根k线模型指标 model
 
 @param model
 */
//- (void)displayQuotaLastObj:(NSObject *)model;

///**
// 返回当前屏幕更新最后一根k线模型指标 model
//
// @param model
// */
//- (void)displayLateastObj:(NSObject *)model;
@end
