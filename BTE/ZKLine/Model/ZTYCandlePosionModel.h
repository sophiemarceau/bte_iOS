//
//  ZTYCandlePosionModel.h
//  BTE
//
//  Created by wanmeizty on 2018/7/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTYCandlePosionModel : NSObject

/**
 *  开盘点
 */
@property (nonatomic, assign) CGPoint openPoint;

/**
 *  收盘点
 */
@property (nonatomic, assign) CGPoint closePoint;

/**
 *  最高点
 */
@property (nonatomic, assign) CGPoint highPoint;

/**
 *  最低点
 */
@property (nonatomic, assign) CGPoint lowPoint;

/**
 *  压力线
 */
@property (nonatomic, assign) CGPoint strance1Point;

/**
 *  压力线
 */
@property (nonatomic, assign) CGPoint strance2Point;

///**
// *  压力线
// */
//@property (nonatomic, assign) CGPoint strance3Point;
//
///**
// *  压力线
// */
//@property (nonatomic, assign) CGPoint strance4Point;

/**
 *  托单
 */
@property (nonatomic, assign) CGPoint supportPoint;

/**
 *  压单
 */
@property (nonatomic, assign) CGPoint resitancePoint;

/**
 *  撤单
 */
@property (nonatomic, assign) CGPoint cancelPoint;

/**
 *  爆单
 */
@property (nonatomic, assign) CGPoint buyburnedPoint;
@property (nonatomic, assign) CGPoint sellburnedPoint;

/**
 *  MA7
 */
@property (nonatomic, assign) CGPoint ma7Point;

/**
 *  MA10
 */
@property (nonatomic, assign) CGPoint ma10Point;

/**
 *  MA30
 */
@property (nonatomic, assign) CGPoint ma30Point;


/**
 *  EMA7
 */
@property (nonatomic, assign) CGPoint ema7Point;

/**
 *  EMA10
 */
@property (nonatomic, assign) CGPoint ema10Point;

/**
 *  EMA30
 */
@property (nonatomic, assign) CGPoint ema30Point;


/**
 *  BOLL_MID
 */
@property (nonatomic, assign) CGPoint midPoint;

/**
 *  BOLL_UPPER
 */
@property (nonatomic, assign) CGPoint uperPoint;

/**
 *  BOLL_DOWN
 */
@property (nonatomic, assign) CGPoint downPoint;

/**
 *  SAR
 */
@property (nonatomic, assign) CGPoint sarPoint;

/**
 *  DEA
 */
@property (nonatomic, assign) CGPoint deaPoint;

/**
 *  DIFF
 */
@property (nonatomic, assign) CGPoint difPoint;

/**
 *  MACD
 */
@property (nonatomic, assign) CGPoint macdPoint;

/**
 *  MACD 开始点
 */
@property (nonatomic,assign) CGPoint startPoint;

/**
 *  MACD 结束点
 */
@property (nonatomic,assign) CGPoint endPoint;

/**
 *  KDJ_K
 */
@property (nonatomic, assign) CGPoint kPoint;

/**
 *  KDJ_D
 */
@property (nonatomic, assign) CGPoint dPoint;

/**
 *  KDJ_J
 */
@property (nonatomic, assign) CGPoint jPoint;

/**
 *  RSI6
 */
@property (nonatomic, assign) CGPoint rsi6Point;

/**
 *  RSI12
 */
@property (nonatomic, assign) CGPoint rsi12Point;

/**
 *  RSI24
 */
@property (nonatomic, assign) CGPoint rsi24Point;


/**
 *  日期
 */
@property (nonatomic, copy) NSString *date;

@property (nonatomic,assign) BOOL isDrawDate;

@property (assign, nonatomic) NSInteger localIndex;

@property (nonatomic,assign) NSInteger superArrIndex;

// 主图指标初始化
+ (ZTYCandlePosionModel *)initWithCandleModel:(ZTYChartModel *)candleModel left:(CGFloat)left maxY:(CGFloat)maxY scaleY:(CGFloat)scaleY topMagin:(CGFloat)topMagin;

// 附图指标初始化
+(instancetype)initQuotePositionWithCandleModel:(ZTYChartModel *)candleModel left:(CGFloat)left maxY:(CGFloat)maxY scaleY:(CGFloat)scaleY topMagin:(CGFloat)topMagin;
@end
