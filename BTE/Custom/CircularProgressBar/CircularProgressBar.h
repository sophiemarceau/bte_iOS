//
//  CircularProgressBar.h
//  CircularProgressBar
//
//  Created by du on 10/8/15.
//  Copyright © 2015 du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircularProgressDelegate

@optional

- (void)CircularProgressEnd;

@end

@interface CircularProgressBar : UIView

@property(nonatomic, weak) id<CircularProgressDelegate> delegate;

- (void)setTotalSecondTime:(CGFloat)time;

- (void)setTextColor:(UIColor *)textColor
       progressColor:(UIColor *)progressColor
           lineColor:(UIColor *)lineColor;

- (void)startTimer;
- (void)stopTimer;
- (void)pauseTimer;

@end
