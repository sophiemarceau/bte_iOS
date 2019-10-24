//
//  UITableView+userStatistics.m
//  BTE
//
//  Created by sophie on 2018/7/12.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "UITableView+userStatistics.h"
#import "HookUtility.h"
#import "UserStatistics.h"
#import "BTEHomePageTableView.h"
#import "BTEStrategyFollowTableView.h"

@implementation UITableView (userStatistics)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(setDelegate:);
        SEL swizzledSelector = @selector(tracking_setDelegate:);
        [HookUtility swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
    });
}

- (void)tracking_setDelegate:(id<UITableViewDelegate>)delegate
{
    [self tracking_setDelegate:delegate];
    
    Class class = [delegate class];
    
    // 在代理人这先添加用于实现统计的方法，然后和交换原先的点击方法
    if (class_addMethod(class, NSSelectorFromString(@"tracking_didSelectRowAtIndexPath"), (IMP)tracking_didSelectRowAtIndexPath, "v@:@@")) {
        Method dis_originalMethod = class_getInstanceMethod(class, NSSelectorFromString(@"tracking_didSelectRowAtIndexPath"));
        Method dis_swizzledMethod = class_getInstanceMethod(class, @selector(tableView:didSelectRowAtIndexPath:));
        
        //交换实现
        method_exchangeImplementations(dis_originalMethod, dis_swizzledMethod);
    }
}

void tracking_didSelectRowAtIndexPath(id self, SEL _cmd, id tableView, id indexpath)
{
    SEL selector = NSSelectorFromString(@"tracking_didSelectRowAtIndexPath");
    ((void(*)(id, SEL,id, id))objc_msgSend)(self, selector, tableView, indexpath);
    
    //此处添加你想统计的打点事件
    NSLog(@"你现在正在点击的是%@页面的第%ld栏第%ld行",NSStringFromClass([self class]),((NSIndexPath *)indexpath).section,((NSIndexPath *)indexpath).row);

    NSString *eventID = nil;
    NSString *targetName = NSStringFromClass([self class]);
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GlobalUserConfig" ofType:@"plist"];
    NSDictionary *configDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
//    NSLog(@"\n***targetName:%@ \n", targetName);
    if([targetName isEqualToString:@"BTEHomePageTableView"]){
        BTEHomePageTableView *tempTableView = (BTEHomePageTableView *)self;
        NSUInteger tableCount = [tempTableView.dataSource count];
        NSUInteger rowCount = ((NSIndexPath *)indexpath).row;
         NSLog(@"tableCount--->%ld行",tableCount);
         NSLog(@"rowCount---->%ld行",rowCount);
        
        if (tableCount > 0)
        {
            NSLog(@"\n***rowCount:%ld \n", rowCount);
//            NSString *currencyName = [NSString stringWithFormat:@"%ld",rowCount];
            if(rowCount == 3){
                eventID = @"首页点击市场快讯";
            }
            if(rowCount >= 5){
                eventID = @"首页点击策略服务";
            }
           
//            if(rowCount == 1){
//                eventID = configDict[targetName][@"ControlEventIDs"][@"jumpToDetail"][currencyName];
//            }
//            if(rowCount == 2){
//                eventID = configDict[targetName][@"ControlEventIDs"][@"jumpToDetail"][currencyName];
//            }
//            if(rowCount == 3){
//                eventID = configDict[targetName][@"ControlEventIDs"][@"jumpToDetail"][currencyName];
//            }
//            if(rowCount == 4){
//                eventID = configDict[targetName][@"ControlEventIDs"][@"jumpToDetail"][currencyName];
//            }
        }

//        if (rowCount == tableCount + 2) {
//            eventID = configDict[targetName][@"ControlEventIDs"][@"jumpToDetails"];//市场分析
//        }
//
//        if (rowCount >= tableCount + 6 )
//        {
//            eventID = configDict[targetName][@"ControlEventIDs"][@"jumpToStrategyFollow"];
//        }
    }
    
    
//    if([targetName isEqualToString:@"BTEStrategyFollowTableView"]){
//
//        NSUInteger rowCount = ((NSIndexPath *)indexpath).row;
//        NSString *selectRow = [NSString stringWithFormat:@"%ld",rowCount];
//        eventID = configDict[targetName][@"ControlEventIDs"][@"jumpToStrategyDetail"];
//
//         [UserStatistics sendEventToServer:eventID WithRow:selectRow];
//        return;
//
//    }
//     NSLog(@"\n***eventID:%@ \n", eventID);
    if (eventID != nil) {
        [UserStatistics sendEventToServer:eventID];
    }
}

//- (NSDictionary *)dictionaryFromUserStatisticsConfigPlist
//{
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GlobalUserConfig" ofType:@"plist"];
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
//    return dic;
//}
@end
