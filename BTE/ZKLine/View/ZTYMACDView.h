//
//  ZTYMACDView.h
//  BTE
//
//  Created by wanmeizty on 2018/6/9.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYBaseChartView.h"
#import "ZTYChartModel.h"

@interface ZTYMACDView : ZTYBaseChartView

@property (nonatomic,strong) NSMutableArray <__kindof ZTYChartModel*>*dataArray;

@property (nonatomic,assign) CGFloat    leftPostion;
@property (nonatomic,assign) NSInteger startIndex;
@property (nonatomic,assign) NSInteger displayCount;
@property (nonatomic,assign) CGFloat    candleWidth;
@property (nonatomic,assign) CGFloat    candleSpace;

- (void)stockFill;

@end
