//
//  ZTYKlineComment.m
//  BTE
//
//  Created by wanmeizty on 2018/6/22.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "ZTYKlineComment.h"

@implementation ZTYKlineComment
- (instancetype)initWidthDict:(NSDictionary *)dict{
    if (self = [super init]) {
        
        self.symbol = [dict objectForKey:@"symbol"];
        self.content = [dict objectForKey:@"content"];
        self.status = [dict objectForKey:@"status"];
        self.id = [dict objectForKey:@"id"];
        self.exchange = [dict objectForKey:@"exchange"];
        self.klineDateTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"klineDateTime"]];
        self.klineDate = [dict objectForKey:@"klineDate"];
        self.createrId = [dict objectForKey:@"createrId"];
        self.createTime = [dict objectForKey:@"createTime"];
        self.pair = [dict objectForKey:@"pair"];
        self.markerPlace = [[dict objectForKey:@"markerPlace"] boolValue];
        self.isShow = NO;
        
        
        
//        self.klineDateTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"newKlineDateTime"]]; //[self timeSwitchTimestamp:[dict objectForKey:@"createTime"] andFormatter:@"YYYY-MM-dd hh:mm:ss"];
    }
    return self;
}

- (NSComparisonResult)compare:(ZTYKlineComment *)other{
    return [self.klineDateTime compare:other.klineDateTime];
}

//-(NSString *)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
//    
////    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
////
////    [formatter setDateStyle:NSDateFormatterMediumStyle];
////
////    [formatter setTimeStyle:NSDateFormatterShortStyle];
////
////    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
////
////
////
////    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
////
////    [formatter setTimeZone:timeZone];
////
////
////
////    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
////
////    //时间转时间戳的方法:
////
////    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
////
////    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld",(long)timeSp); //时间戳的值
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    //指定时间显示样式: HH表示24小时制 hh表示12小时制
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
////    NSString *lastTime = @"2017-01-23 17:22:00";
//    NSDate *lastDate = [formatter dateFromString:formatTime];
//    //以 1970/01/01 GMT为基准，得到lastDate的时间戳
//    NSInteger firstStamp = [lastDate timeIntervalSince1970];
//    
// 
//    return [NSString stringWithFormat:@"%ld",firstStamp];
//    
//}
@end
