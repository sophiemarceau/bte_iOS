//
//  ZTYChartModel.h
//  BTE
//
//  Created by wanmeizty on 20/8/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZTYKlineComment.h"

@interface ZTYChartModel : NSObject

@property (assign, nonatomic)  double high;
@property (assign, nonatomic)  double low;
@property (assign, nonatomic)  double open;
@property (assign, nonatomic)  double close;
@property (nonatomic,copy) NSString * timestamp;

// 压力线
@property (assign, nonatomic)  double sellPrice5;
@property (nonatomic,assign) double sellCumulativeAmount5;
@property (assign, nonatomic)  double buyPrice5;
@property (nonatomic,assign) double buyCumulativeAmount5;

// 托单
@property (nonatomic,assign) double support;
@property (nonatomic,copy) NSString * supportType;
@property (nonatomic,assign) NSInteger supportCount;

// 压单
@property (nonatomic,assign) double resistance;
@property (nonatomic,copy) NSString * resistanceType;
@property (nonatomic,assign) NSInteger resistanceCount;

// 爆单
@property (nonatomic,assign) double buyburned;
@property (nonatomic,copy) NSString * buyburnedType;
@property (nonatomic,assign) NSInteger buyburnedCount;

@property (nonatomic,assign) double sellburned;
@property (nonatomic,copy) NSString * sellburnedType;
@property (nonatomic,assign) NSInteger sellburnedCount;

@property (nonatomic,assign) double threshold;
@property (nonatomic,assign) NSInteger thresholdCount;

@property (nonatomic,assign) double bigsell;
@property (nonatomic,assign) NSInteger bigsellCount;

@property (nonatomic,assign) double bigbuy;
@property (nonatomic,assign) NSInteger bigbuyCount;

@property (nonatomic,assign) double tradesell;
@property (nonatomic,assign) NSInteger tradesellCount;

@property (nonatomic,assign) double tradebuy;
@property (nonatomic,assign) NSInteger tradebuyCount;

@property (nonatomic,assign) double cancelsell;
@property (nonatomic,assign) NSInteger cancelsellCount;

@property (nonatomic,assign) double cancelbuy;
@property (nonatomic,assign) NSInteger cancelbuyCount;

@property (copy,   nonatomic) NSString *date;
@property (assign, nonatomic) BOOL isDrawDate;
@property (assign, nonatomic) NSInteger localIndex;
@property (nonatomic,strong) ZTYChartModel *preKlineModel;
@property (nonatomic,strong) ZTYChartModel *nextKlineModel;

@property (nonatomic,strong) ZTYKlineComment * comment;

@property (nonatomic,assign) NSInteger minOrMaxIndex;
@property (nonatomic,assign) CGFloat markLeft;

/**
 *  该Model及其之前所有收盘价之和
 */
@property (nonatomic, copy) NSNumber *SumOfLastClose;

@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger buyCount;
@property (nonatomic,assign) NSInteger sellCount;
@property (nonatomic,assign) NSInteger net;
@property (nonatomic, copy) NSNumber *volumn;


@property (nonatomic,assign) BOOL isNew;


//model中应该最后处理成坐标数据
@property (nonatomic,copy)   NSString *timeStr;

//model中应该最后处理成坐标数据
@property (nonatomic,copy)   NSString *timeString;
/**
 *保存x的index，用于计算x坐标
 */
@property (nonatomic,assign) NSUInteger x;
/**
 *蜡烛矩形起点
 */
@property (nonatomic,assign) CGFloat y;
/**
 *蜡烛矩形高度
 */
@property (nonatomic,assign) CGFloat h;
/**
 *蜡烛最高点
 */
@property (nonatomic,assign) CGFloat highestPoint;
/**
 *蜡烛最低点
 */
@property (nonatomic,assign) CGFloat lowestPoint;
/**
 *填充颜色
 */
@property (nonatomic,strong) UIColor *fillColor;
/**
 *边线绘制颜色
 */
@property (nonatomic,strong) UIColor *strokeColor;
/**
 *判断是否是NSTimer推送的数据
 */
@property (nonatomic,assign) BOOL isFakeData;
/**
 *当数据不足以显示一屏的时候的判断处理
 */
@property (nonatomic,assign) BOOL isPlaceHolder;


/**
 * 设置基本参数
 */
- (void)initBaseDataWithDict:(NSDictionary *)dict;

- (void)initBaseDataWithArray:(NSArray *)array;

/**
 *
 *EMA值计算
 */

@property (nonatomic,strong) NSNumber * EMA7;
@property (nonatomic,strong) NSNumber * EMA30;
- (double)calcuteEMAIndex:(NSInteger)index dayCount:(NSInteger)dayCount;

//MACD
//这里由于是使用懒加载的，所以必须声明为对象类型才能保存在模型中
//previousKlineModel
@property (nonatomic,strong) ZTYChartModel *previousKlineModel;
@property (nonatomic,strong) NSNumber *EMA12;
@property (nonatomic,strong) NSNumber *EMA26;
@property (nonatomic,strong) NSNumber *DIF;
@property (nonatomic,strong) NSNumber *DEA;
@property (nonatomic,strong) NSNumber *MACD;
- (void)reInitData;
- (void)reInitDataIndex:(NSInteger)index;
- (void)reInitDataWithDif:(double)dif dea:(double)dea macd:(double)macd;

//KDJ
//KDJ(9,3.3),下面以该参数为例说明计算方法。
//9，3，3代表指标分析周期为9天，K值D值为3天
//RSV(9)=（今日收盘价－9日内最低价）÷（9日内最高价－9日内最低价）×100
//K(3日)=（当日RSV值+2*前一日K值）÷3
//D(3日)=（当日K值+2*前一日D值）÷3
//J=3K－2D
@property (nonatomic,strong) NSNumber *HNinePrice;
@property (nonatomic,strong) NSNumber *LNinePrice;
@property (nonatomic, copy) NSNumber *RSV_9;
@property (nonatomic, copy) NSNumber *KDJ_K;
@property (nonatomic, copy) NSNumber *KDJ_D;
@property (nonatomic, copy) NSNumber *KDJ_J;
- (void)reInitKDJData;
- (void)reInitDataWithk:(double)k d:(double)d j:(double)j;

// SAR
@property (nonatomic,strong) NSNumber * Postion;
@property (nonatomic,assign) double ParOpen;
@property (nonatomic,assign) double AF;
@property (nonatomic,strong) NSNumber * HHValue;
@property (nonatomic,strong) NSNumber * LLValue;
- (void)reinitSARdata;

//BOLL
/*
 20日BOLL指标的计算过程
 　　（1）计算MA
 　　MA=N日内的收盘价之和÷N
 　　（2）计算标准差MD
 　　MD=平方根(N日的（C－MA）的两次方之和除以N)
 　　（3）计算MB、UP、DN线
 　　MB=（N－1）日的MA
 　　UP=MB＋2×MD
 　　DN=MB－2×MD
 　　在股市分析软件中，BOLL指标一共由四条线组成，即上轨线UP 、中轨线MB、下轨线DN和价格线。其中上轨线UP是UP数值的连线，用黄色线表示；中轨线MB是MB数值的连线，用白色线表示；下轨线DN是DN数值的连线，用紫色线表示；价格线是以美国线表示，颜色为浅蓝色。和其他技术指标一样，在实战中，投资者不需要进行BOLL指标的计算，主要是了解BOLL的计算方法和过程，以便更加深入地掌握BOLL指标的实质，为运用指标打下基础。
 
 */
//@property (nonatomic, copy) NSNumber *BOLL_MA;
//@property (nonatomic, copy) NSNumber *BOLL_MD;
//@property (nonatomic, copy) NSNumber *BOLL_MB;
//@property (nonatomic, copy) NSNumber *BOLL_UP;
//@property (nonatomic, copy) NSNumber *BOLL_DN;
//- (void)reInitBOLLData;

#pragma BOLL线


//@property (nonatomic,copy) NSNumber * BOLL_Standard;
@property (nonatomic, copy) NSNumber *BOLL_MA;

// 标准差 二次方根【 下的 (n-1)天的 C-MA二次方 和】
//@property (nonatomic, copy) NSNumber *BOLL_MD;

// n-1 天的 MA
@property (nonatomic, copy) NSNumber *BOLL_MB;

// MB + k * MD
@property (nonatomic, copy) NSNumber *BOLL_UP;

// MB - k * MD
@property (nonatomic, copy) NSNumber *BOLL_DN;

//  n 个 ( Cn - MA20)的平方和
//@property (nonatomic, copy) NSNumber *BOLL_SUBMD_SUM;
//
//// 当前的 ( Cn - MA20)的平方
//@property (nonatomic, copy) NSNumber *BOLL_SUBMD;
//
//@property (nonatomic,strong) NSArray * currentArray;
//
//- (void)initBOLLData;
//
//- (void)initReinitBOLL;



//RSI
/*
 RSI的计算公式
 RSI=100×RS/(1+RS) 或者，RSI=100－100÷（1+RS）
 其中 RS=14天内收市价上涨数之和的平均值/14天内收市价下跌数之和的平均值
 举例说明：
 如果最近14天涨跌情形是:第一天升2元，第二天跌2元，第三至第五天各升3元；第六天跌4元 第七天升2元，第八天跌5元；第九天跌6元，第十至十二天各升1元；第十三至十四天各跌3元。
 那么，计算RSI的步骤如下：
 (一)将14天上升的数目相加，除以14，上例中总共上升16元除以14得1.143(精确到小数点后三位)；
 (二)将14天下跌的数目相加，除以14，上例中总共下跌23元除以14得1.643(精确到小数点后三位)；
 (三)求出相对强度RS，即RS=1.143/1.643=0.696(精确到小数点后三位)；
 (四)1+RS=1+0.696=1.696；
 (五)以100除以1+RS，即100/1.696=58.962；
 (六)100-58.962=41.038。    结果14天的强弱指标RS1为41.038。    不同日期的14天RSI值当然是不同的，连接不同的点，即成RSI的轨迹。
 
 */


@property (nonatomic, copy) NSNumber *RSI_6;
@property (nonatomic, copy) NSNumber *RSI_12;
@property (nonatomic, copy) NSNumber *RSI_24;

@property (nonatomic, copy) NSNumber *RSIDropSum_6;
@property (nonatomic, copy) NSNumber *RSIDropSum_12;
@property (nonatomic, copy) NSNumber *RSIDropSum_24;
@property (nonatomic, copy) NSNumber *RSIRisSum_6;
@property (nonatomic, copy) NSNumber *RSIRisSum_12;
@property (nonatomic, copy) NSNumber *RSIRisSum_24;
- (void)judgeRSIIsNan;


//VOL
@property (nonatomic, copy) NSNumber *volumn_MA5;
@property (nonatomic, copy) NSNumber *volumn_MA10;
@property (nonatomic, copy) NSNumber *volumn_MA20;



//MA
@property (nonatomic, copy) NSNumber *MA5;
@property (nonatomic, copy) NSNumber *MA10;
@property (nonatomic, copy) NSNumber *MA20;
@property (nonatomic, copy) NSNumber *MA30;

//wr
@property (nonatomic, copy) NSNumber *WR;

@end
