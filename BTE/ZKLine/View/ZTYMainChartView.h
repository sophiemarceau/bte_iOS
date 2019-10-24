//
//  ZTYMainChartView.h
//  BTE
//
//  Created by wanmeizty on 2018/5/31.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYBaseChartView.h"
#import "ZTYChartModel.h"
#import "ZTYChartProtocol.h"

@interface ZTYMainChartView : ZTYBaseChartView<ZTYChartProtocol>

/**
 主图指标
 */
@property (nonatomic,assign) MainViewQuotaName mainquotaName;

/**
 主图类型
 */
@property (nonatomic,assign) MainChartCenterViewType mainchartType;

/**
 数据源数组 在调用绘制方法之前设置
 */
@property (nonatomic,strong) NSMutableArray<__kindof ZTYChartModel*> *dataArray;

/**
 当前屏幕范围内显示的k线模型数组
 */
@property (nonatomic,strong) NSMutableArray *currentDisplayArray;

/**
 当前屏幕范围内显示的k线位置数组
 */
@property (nonatomic,strong) NSMutableArray *currentPostionArray;

/**
 当前短评
 */
@property (nonatomic,strong) NSArray *commentArr;

/**
 可视区域显示多少根k线
 */
@property (nonatomic,assign) NSInteger displayCount;

/**
 k线之间的距离
 */
@property (nonatomic,assign) CGFloat candleSpace;

/**
 k线的宽度 根据每页k线的根数和k线之间的距离动态计算得出
 */
@property (nonatomic,assign) CGFloat candleWidth;

/**
 k线最小高度
 */
@property (nonatomic,assign) CGFloat minHeight;

/**
 当前屏幕范围内绘制起点位置
 */
@property (nonatomic,assign) CGFloat leftPostion;

/**
 当前绘制的起始下标
 */
@property (nonatomic,assign) NSInteger currentStartIndex;

/**
 滑到最右侧的偏移量
 */
@property (nonatomic,assign) CGFloat previousOffsetX;

/**
 当前偏移量
 */
@property (nonatomic,assign) CGFloat contentOffset;

@property (nonatomic,assign) BOOL kvoEnable;


@property (nonatomic,assign) BOOL isNotComment;

@property (nonatomic,assign) BOOL isFreshing;

@property (nonatomic,assign) BOOL firstCommentShow;

@property (nonatomic,weak) id <ZTYChartProtocol> delegate;


@property (nonatomic,assign) int lineCount;

@property (nonatomic,assign) BOOL NoBottm;

/**
 长按手势返回对应model的相对位置
 
 @param xPostion 手指在屏幕的位置
 @return 距离手指位置最近的model位置
 */
- (CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion;

/**
 点击手势返回对应model的相对位置
 @param postion 手指在屏幕的位置
 @return 距离手指位置最近的model位置
 */
-(CGPoint)getTapModelPostionWithPostion:(CGPoint)postion;

/**
 填充
 */
- (void)stockFill;

/**
 刷新右拉加载调用
 */
- (void)reload;

// 重新更新当前值
- (void)reloadAtCurrentIndex;

/**
 宽度计算
 */
- (void)calcuteCandleWidth;

/**
 更新宽度
 */
- (void)updateWidth;

/**
 绘制主方法
 */
- (void)drawKLine;

- (void)updateWidthWithNoOffset;

/**
 根据值计算Y位置
 */
- (CGFloat)getPointYculateValue:(CGFloat)value;

- (void)showCommentBtns;
- (void)hideCommentBtns;
- (void)hideDialogs;

@end

