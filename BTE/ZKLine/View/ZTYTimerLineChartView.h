//
//  ZTYTimerLineChartView.h
//  BTE
//
//  Created by wanmeizty on 2018/7/6.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYBaseChartView.h"

@interface ZTYTimerLineChartView : ZTYBaseChartView

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) CGFloat    leftPostion;
@property (nonatomic,assign) NSInteger startIndex;
@property (nonatomic,assign) NSInteger displayCount;
@property (nonatomic,assign) CGFloat    candleWidth;
@property (nonatomic,assign) CGFloat    candleSpace;
- (void)stockFill;

@end
