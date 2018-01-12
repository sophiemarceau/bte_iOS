//
//  NSTimer+addition.m
//  WYHomeLoopView
//
//  Created by 王启镰 on 16/5/5.
//  Copyright © 2016年 wanglijinrong. All rights reserved.
//

#import "NSTimer+addition.h"

@implementation NSTimer (addition)

- (void)pause {
    if (!self.isValid) return;
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resume {
    if (!self.isValid) return;
    [self setFireDate:[NSDate date]];
}

- (void)resumeWithTimeInterval:(NSTimeInterval)time {
    if (!self.isValid) return;
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:time]];
}

+ (NSTimer *)wlscheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                         block:(void(^)(NSTimer *timer))block
                                       repeats:(BOOL)repeats{
    
    return [self scheduledTimerWithTimeInterval:ti
                                         target:self
                                       selector:@selector(wlblockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)wlblockInvoke:(NSTimer *)timer{
    
    void(^block)(NSTimer *) = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end
