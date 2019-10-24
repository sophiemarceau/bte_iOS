//
//  UIControl+userStatistics.m
//  BTE
//
//  Created by sophie on 2018/7/11.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "UIControl+userStatistics.h"
#import "HookUtility.h"
#import "UserStatistics.h"
@implementation UIControl (userStatistics)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(swiz_sendAction:to:forEvent:);
        [HookUtility swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
    });
}

#pragma mark - Method Swizzling

- (void)swiz_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event;
{
    //插入埋点代码
    [self performUserStastisticsAction:action to:target forEvent:event];
    [self swiz_sendAction:action to:target forEvent:event];
}

- (void)performUserStastisticsAction:(SEL)action to:(id)target forEvent:(UIEvent *)event;
{
//    NSLog(@"tag-------->%ld",self.tag);
//    NSLog(@"\n***hook success.\n[1]action:%@\n[2]target:%@ \n[3]event:%@", NSStringFromSelector(action), target, event);
    NSString *eventID = nil;
    //只统计触摸结束时
    if ([[[event allTouches] anyObject] phase] == UITouchPhaseEnded) {
        NSString *actionString = NSStringFromSelector(action);
        NSString *targetName = NSStringFromClass([target class]);
        NSDictionary *configDict = [self dictionaryFromUserStatisticsConfigPlist];
//        NSLog(@"actionString-------->%@",actionString);
       
        
//         NSLog(@"\n***targetName:%@ \n", targetName);
       
//         NSLog(@"\n***actionString:%@ \n", actionString);
//        NSLog(@"\n***eventID:%@ \n", eventID);
        
        if([actionString isEqualToString:@"gotoKPage:"]){
            if (self.tag == 0 ) {
                [UserStatistics sendEventToServer:@"首页点击BTC"];
            }
            if (self.tag == 1 ) {
                [UserStatistics sendEventToServer:@"首页点击ETH"];
            }
            if (self.tag == 2 ) {
                [UserStatistics sendEventToServer:@"首页点击BCH"];
            }
            if (self.tag == 3 ) {
                [UserStatistics sendEventToServer:@"首页点击EOS"];
            }
            return;
        }
        
        if([actionString isEqualToString:@"moreButton"]){
            [UserStatistics sendEventToServer:@"首页点击策略服务更多"];
            return;
        }

        if([actionString isEqualToString:@"buttonOnclick:"]){
            if (self.tag == 3001 ) {
                [UserStatistics sendEventToServer:@"首页点击签到"];
            }
            if (self.tag == 3002 ) {
                [UserStatistics sendEventToServer:@"首页点击邀请"];
            }
            if (self.tag == 3003 ) {
                 [UserStatistics sendEventToServer:@"首页点击赚积分"];
            }
            return;
        }
        
    }
    if (eventID != nil) {
        [UserStatistics sendEventToServer:eventID];
    }
}


- (NSDictionary *)dictionaryFromUserStatisticsConfigPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GlobalUserConfig" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}
@end
