//
//  UIBezierPath+Draw.m
//  ZYWChart
//
//  Created by 张有为 on 2017/4/8.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "UIBezierPath+Draw.h"

#import "ZYWCandlePostionModel.h"
#import "ZTYCandlePosionModel.h"

@implementation UIBezierPath (Draw)

+ (UIBezierPath*)drawLine:(NSMutableArray*)linesArray
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSUInteger idx = 0;
    for (ZYWLineModel* obj in linesArray) {
        if (idx == 0)
        {
            [path moveToPoint:CGPointMake(obj.xPosition,obj.yPosition)];
        }
        
        else
        {
            [path addLineToPoint:CGPointMake(obj.xPosition,obj.yPosition)];
        }
        idx ++;
    }
    return path;
}

// key
+ (UIBezierPath*)drawcandlePosionLine:(NSMutableArray*)linesArray withKey:(NSString *)key
{
    NSUInteger idx = 0;
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (ZTYCandlePosionModel* obj in linesArray) {
        CGPoint point = [[obj valueForKey:key] CGPointValue];
        if (idx == 0)
        {
            [path moveToPoint:CGPointMake(point.x,point.y)];
        }
        
        else
        {
            [path addLineToPoint:CGPointMake(point.x,point.y)];
        }
        idx ++;
    }
    return path;
}

// key dayCount 画分时+topMargin
+ (UIBezierPath*)drawcandlePosionLine:(NSMutableArray*)linesArray withKey:(NSString *)key dayCount:(NSInteger)dayCount topmagin:(CGFloat)topmagin
{
    NSUInteger idx = 0;
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (ZTYCandlePosionModel* obj in linesArray) {
        CGPoint point = [[obj valueForKey:key] CGPointValue];
        //        NSLog(@"superArrIndex==>%ld",obj.superArrIndex);
        if (obj.superArrIndex < dayCount) {
            
        }else{
            if (idx == 0)
            {
                [path moveToPoint:CGPointMake(point.x,point.y+ topmagin)];
            }
            
            else
            {
                [path addLineToPoint:CGPointMake(point.x,point.y + topmagin)];
            }
            idx ++;
        }
        
    }
    return path;
}

// key dayCount
+ (UIBezierPath*)drawcandlePosionLine:(NSMutableArray*)linesArray withKey:(NSString *)key dayCount:(NSInteger)dayCount
{
    NSUInteger idx = 0;
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (ZTYCandlePosionModel* obj in linesArray) {
        CGPoint point = [[obj valueForKey:key] CGPointValue];
//        NSLog(@"superArrIndex==>%ld",obj.superArrIndex);
        if (obj.superArrIndex < dayCount) {
            
        }else{
            if (idx == 0)
            {
                [path moveToPoint:CGPointMake(point.x,point.y)];
            }
            
            else
            {
                [path addLineToPoint:CGPointMake(point.x,point.y)];
            }
            idx ++;
        }
        
    }
    return path;
}

// key
+ (UIBezierPath*)drawStrenceLine:(NSMutableArray*)linesArray withKey:(NSString *)key{
    {
        NSUInteger idx = 0;
        UIBezierPath *path = [UIBezierPath bezierPath];
        for (ZTYCandlePosionModel* obj in linesArray) {
            CGPoint point = [[obj valueForKey:key] CGPointValue];
            
            if (point.y > 0) {
                if (idx == 0)
                {
                    [path moveToPoint:CGPointMake(point.x,point.y)];
                }
                
                else
                {
                    [path addLineToPoint:CGPointMake(point.x,point.y)];
                }
                idx ++;
            }else{
                idx = 0;
            }
            
        }
        return path;
    }
}

+ (UIBezierPath*)drawcandlePosionLine:(NSMutableArray*)linesArray
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [linesArray enumerateObjectsUsingBlock:^(ZYWCandlePostionModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0)
        {
            [path moveToPoint:CGPointMake(obj.closePoint.x,obj.closePoint.y)];
        }
        
        else
        {
            [path addLineToPoint:CGPointMake(obj.closePoint.x,obj.closePoint.y)];
        }
    }];
    return path;
}

+ (UIBezierPath*)drawzcandlePosionLine:(NSMutableArray*)linesArray
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [linesArray enumerateObjectsUsingBlock:^(ZTYCandlePosionModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0)
        {
            [path moveToPoint:CGPointMake(obj.closePoint.x,obj.closePoint.y)];
        }
        
        else
        {
            [path addLineToPoint:CGPointMake(obj.closePoint.x,obj.closePoint.y)];
        }
    }];
    return path;
}

+ (NSMutableArray<__kindof UIBezierPath*>*)drawLines:(NSMutableArray<NSMutableArray*>*)linesArray
{
    NSAssert(0 != linesArray.count && NULL != linesArray, @"传入的数组为nil ,打印结果---->>%@",linesArray);
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSMutableArray *lineArray in linesArray)
    {
        UIBezierPath *path = [UIBezierPath drawLine:lineArray];
        [resultArray addObject:path];
    }
    return resultArray;
}

+ (UIBezierPath*)drawKLine:(CGFloat)open close:(CGFloat)close high:(CGFloat)high low:(CGFloat)low candleWidth:(CGFloat)candleWidth rect:(CGRect)rect xPostion:(CGFloat)xPostion lineWidth:(CGFloat)lineWidth
{
    UIBezierPath *candlePath = [UIBezierPath bezierPathWithRect:rect];
    candlePath.lineWidth = lineWidth;
    [candlePath moveToPoint:CGPointMake(xPostion+candleWidth/2-lineWidth/2, high)];
    [candlePath addLineToPoint:CGPointMake(xPostion+candleWidth/2-lineWidth/2, low)];
    return candlePath;
}

@end

