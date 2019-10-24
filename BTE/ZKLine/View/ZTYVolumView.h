//
//  ZTYVolumView.h
//  BTE
//
//  Created by wanmeizty on 2018/5/29.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYBaseChartView.h"
#import "ZTYChartModel.h"
#import "ZTYChartProtocol.h"

@interface ZTYVolumView : ZTYBaseChartView

@property (nonatomic,strong) NSMutableArray <__kindof ZTYChartModel*>*dataArray;

@property (nonatomic,assign) CGFloat    leftPostion;
@property (nonatomic,assign) NSInteger startIndex;
@property (nonatomic,assign) NSInteger displayCount;
@property (nonatomic,assign) CGFloat    candleWidth;
@property (nonatomic,assign) CGFloat    candleSpace;
@property (nonatomic,weak) id <ZTYChartProtocol>delegate;

@property (nonatomic,assign) int showbuySell;

-(CGPoint)getTapModelPostionWithPostion:(CGPoint)postion;
- (void)stockFill;

@end
