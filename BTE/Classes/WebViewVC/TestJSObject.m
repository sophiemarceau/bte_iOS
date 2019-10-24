//
//  TestJSObject.m
//  BTE
//
//  Created by sophie on 2018/8/14.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "TestJSObject.h"

@implementation TestJSObject
////一下方法都是只是打了个log 等会看log 以及参数能对上就说明js调用了此处的iOS 原生方法
//-(void)TestNOParameter
//{
//    NSLog(@"this is ios TestNOParameter");
//}
//-(void)TestOneParameter:(NSString *)message
//{
//    NSLog(@"this is ios TestOneParameter=%@",message);
//}
//-(void)TestTowParameter:(NSString *)message1 SecondParameter:(NSString *)message2
//{
//    NSLog(@"this is ios TestTowParameter=%@  Second=%@",message1,message2);
//}


-(NSString *)getUserToken{
    if (User.userToken) {
        return User.userToken;
    }else{
        return @"";
    }
}

-(void)invoke:(NSString *)atr :(id)jsonStr{
    NSDictionary *postDic = @{
                              @"action":atr,
                              @"paramDic":[self convertjsonStringToDict:jsonStr],
                              };
    if ([self convertjsonStringToDict:jsonStr] == nil) {
        NSDictionary *param = @{
                                  @"action":atr,
                                  @"jsonStr":jsonStr,
                                  };
        if ([self.delegate respondsToSelector:@selector(go2PageVc:)]) {
            [self.delegate go2PageVc:param];
        }
    }else{
        [self.delegate go2PageVc:postDic];
    }
    
    
}


-(NSDictionary *)convertjsonStringToDict:(NSString *)jsonString{
    NSDictionary *retDict = nil;
    if ([jsonString isKindOfClass:[NSString class]]) {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        retDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        return  retDict;
    }else{
        return retDict;
    }
}
@end
