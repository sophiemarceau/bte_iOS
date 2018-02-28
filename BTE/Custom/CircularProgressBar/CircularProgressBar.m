//
//  CircularProgressBar.m
//  CircularProgressBar
//
//  Created by Timmy on 16/6/16.
//  Copyright © 2016 Timmy. All rights reserved.
//

/******相关大小设置*******/
//大圆半径
#define SW_RADIUS (self.bounds.size.width - SW_CIRCLE_WIDTH - 4)/2
//起点小圆半径
#define SW_POINT_RADIUS 3
//默认线宽
#define SW_CIRCLE_WIDTH 2
//progress线宽
#define SW_PROGRESS_WIDTH 2
//刷帧间隔
#define SW_TIMER_INTERVAL 0.05
//中间字体大小
#define SW_FontSize 15

/******相关颜色设置*******/
//中间提示语 颜色
#define SW_TextColor BHColorBlue
//进度条 颜色
#define SW_ProgressColor BHColorLightGray
//默认圆
#define SW_CircleLineColor BHColorBlue


#import "CircularProgressBar.h"

@interface CircularProgressBar()
{
    CGFloat startAngle;
    CGFloat endAngle;
    int     totalTime;
    
    NSTimer *m_timer;
    BOOL b_timerRunning;
}

@property(nonatomic)CGFloat time_left;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) UIColor *lineColor;

@end

@implementation CircularProgressBar

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initData];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initData];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


- (void)initData {
    // 圆周为 2 * pi * R, 默认起始点于正右方向为 0 度， 改为正上为起始点
    startAngle = -M_PI_2;
    endAngle = startAngle;
    
    totalTime = 0;
    
    b_timerRunning = NO;

    self.progressColor = SW_ProgressColor;
    self.lineColor = SW_CircleLineColor;
    self.textColor = SW_TextColor;
}

- (void)drawRect:(CGRect)rect {
    if (totalTime == 0) 
        endAngle = startAngle;
    else
        endAngle = (1 - self.time_left / totalTime) * 2 * M_PI + startAngle;
    
    UIBezierPath *circle = [UIBezierPath bezierPath];
    [circle addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:SW_RADIUS
                      startAngle:0
                        endAngle:2 * M_PI
                       clockwise:YES];
    circle.lineWidth = SW_CIRCLE_WIDTH;
    [self.lineColor setStroke];
    [circle stroke];

    
    UIBezierPath *progress = [UIBezierPath bezierPath];
    [progress addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:SW_RADIUS
                      startAngle:startAngle
                        endAngle:endAngle
                       clockwise:YES];
    progress.lineWidth = SW_PROGRESS_WIDTH;
    [self.progressColor set];
    [progress stroke];
    
    CGPoint pos = [self getCurrentPointAtAngle:endAngle inRect:rect];
    [self drawPointAt:pos];
    
    NSString *textContent;
    int sec = (int)ceil(self.time_left) % 60; 
    if (sec < 10) {
        textContent = [@"0" stringByAppendingString:[NSString stringWithFormat:@"%ds", sec]];
    } else {
        textContent = [NSString stringWithFormat:@"%ds", sec];
    }
    
    CGSize textSize = [textContent sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SW_FontSize]}];
    
    CGRect textRect = CGRectMake(rect.size.width / 2 - textSize.width / 2,
                                 rect.size.height / 2 - textSize.height / 2,
                                 textSize.width , textSize.height);
    
    [textContent drawInRect:textRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SW_FontSize], NSForegroundColorAttributeName:self.textColor}];
    
}

- (CGPoint)getCurrentPointAtAngle:(CGFloat)angle inRect:(CGRect)rect {
    CGFloat y = sin(angle) * SW_RADIUS;
    CGFloat x = cos(angle) * SW_RADIUS;
    
    CGPoint pos = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    pos.x += x;
    pos.y += y;
    return pos;
}

- (void)drawPointAt:(CGPoint)point {

    UIBezierPath *dot = [UIBezierPath bezierPath];
    [dot addArcWithCenter:CGPointMake(point.x, point.y)
                        radius:SW_POINT_RADIUS
                    startAngle:0
                      endAngle:2 * M_PI
                     clockwise:YES];
    dot.lineWidth = 1;
    [self.progressColor set];
    [dot fill];
    
}

- (void)setTotalSecondTime:(CGFloat)time {
    totalTime = time;
    self.time_left = totalTime;
}

- (void)setTextColor:(UIColor *)textColor
       progressColor:(UIColor *)progressColor
           lineColor:(UIColor *)lineColor {
    
    self.textColor = textColor;
    self.progressColor = progressColor;
    self.lineColor = lineColor;
}


//定时器 相关
- (void)startTimer {
    if (!b_timerRunning) {
        m_timer = [NSTimer scheduledTimerWithTimeInterval:SW_TIMER_INTERVAL target:self selector:@selector(setProgress) userInfo:nil repeats:YES];
        b_timerRunning = YES;
    }
}
- (void)setProgress {
    if (self.time_left > 0) {
        self.time_left -= SW_TIMER_INTERVAL;
        [self setNeedsDisplay];
    } else {
        [self pauseTimer];
        
        if (delegate) {
            [delegate CircularProgressEnd];
        }
    }
}

- (void)pauseTimer {
    if (b_timerRunning) {
        [m_timer invalidate];
        m_timer = nil;
        b_timerRunning = NO;
    }
}

- (void)stopTimer {
    [self pauseTimer];
    
    startAngle = - M_PI_2;
    endAngle = startAngle;
    self.time_left = totalTime;
    [self setNeedsDisplay];

}
@end
