//
//  ZTYDialogTextLayer.m
//  Dialog
//
//  Created by wanmeizty on 2018/6/25.
//  Copyright © 2018年 wanmeizty. All rights reserved.
//

#import "ZTYDialogTextLayer.h"

#import <UIKit/UIKit.h>

@interface ZTYDialogTextLayer ()

@property (nonatomic,strong)  UIBezierPath * bezierPath;
@property (nonatomic,strong) CATextLayer * textLayer;

@end

@implementation ZTYDialogTextLayer

- (instancetype)init{
    if (self = [super init]) {
        self.bezierPath = [UIBezierPath bezierPath];
        
        
        self.strokeColor = [UIColor whiteColor].CGColor;
        self.fillColor = [UIColor whiteColor].CGColor;
//        self.lineWidth = 1;
//        self.backgroundColor = [UIColor blueColor].CGColor;
//        self.contentsScale = [UIScreen mainScreen].scale;
//        self.strokeColor = [UIColor clearColor].CGColor;
//        self.fillColor = [UIColor clearColor].CGColor;
        self.textLayer = [CATextLayer layer];
        self.textLayer.wrapped = YES;
        self.textLayer.contentsScale = [UIScreen mainScreen].scale;
        self.textLayer.fontSize = 10.f;
        self.textLayer.alignmentMode = kCAAlignmentLeft;
        self.textLayer.foregroundColor =
        [UIColor colorWithHexString:@"525866"].CGColor;
        [self addSublayer:self.textLayer];
        
        self.shadowColor = [UIColor colorWithHexString:@"2F4769"].CGColor;
        self.shadowOpacity = 0.3;
        self.shadowOffset = CGSizeMake(1, 2);

        
    }
    return self;
}

- (void)setText:(NSString *)text{
    self.textLayer.string = text;
}

- (void)setBackFrame:(CGRect)frame contentText:(NSString *)text{
    
    CGFloat right =  7.3;
    
    [self.bezierPath moveToPoint:CGPointMake(0, 3.8)];
    
    [self.bezierPath addLineToPoint:CGPointMake(frame.size.width - 6.4 - right, 3.8)];
    
    [self.bezierPath addLineToPoint:CGPointMake(frame.size.width - 3.2 - right, 0)];
    
    [self.bezierPath addLineToPoint:CGPointMake(frame.size.width - right, 3.8)];
    [self.bezierPath addLineToPoint:CGPointMake(frame.size.width , 3.8)];
    [self.bezierPath addLineToPoint:CGPointMake(frame.size.width ,frame.size.height - 3.8)];
    
    [self.bezierPath addLineToPoint:CGPointMake(1,frame.size.height - 3.8)];
    [self.bezierPath addLineToPoint:CGPointMake(0, 3.8)];
    self.bezierPath.lineWidth = 1;
    self.path = self.bezierPath.CGPath;
    
    
    self.textLayer.frame = CGRectMake(7, 7, frame.size.width - 15, frame.size.height - 12);
//    self.textLayer.backgroundColor = [UIColor greenColor].CGColor;
    self.frame = frame;
    self.textLayer.wrapped = YES;
    self.textLayer.string = text;
    
}


@end
