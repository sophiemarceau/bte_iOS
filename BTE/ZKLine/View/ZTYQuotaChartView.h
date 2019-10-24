//
//  ZTYQuotaChartView.h
//  BTE
//
//  Created by wanmeizty on 2018/6/1.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYBaseChartView.h"
#import "ZTYChartProtocol.h"

@interface ZTYQuotaChartView : ZTYBaseChartView<ZTYChartProtocol>

/**
 附图指标
 */
@property (nonatomic,assign) FigureViewQuotaName quotaName;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) CGFloat    leftPostion;
@property (nonatomic,assign) NSInteger startIndex;
@property (nonatomic,assign) NSInteger displayCount;
@property (nonatomic,assign) CGFloat    candleWidth;
@property (nonatomic,assign) CGFloat    candleSpace;
@property (nonatomic,weak) id<ZTYChartProtocol>delegate;
- (void)stockFill;
// 获取点击的Model位置
-(CGPoint)getTapModelPostionWithPostion:(CGPoint)postion;

@end

