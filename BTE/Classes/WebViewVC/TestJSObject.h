//
//  TestJSObject.h
//  BTE
//
//  Created by sophie on 2018/8/14.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

//首先创建一个实现了JSExport协议的协议
@protocol TestJSObjectProtocol <JSExport>
//此处我们测试几种参数的情况
//-(void)TestNOParameter;
//-(void)TestOneParameter:(NSString *)message;
//-(void)TestTowParameter:(NSString *)message1 SecondParameter:(NSString *)message2;
- (NSString *)getUserToken;
- (void)invoke:(NSString *)atr :(id)jsonStr;
@end

@protocol RetrunFormJsFunctionDelegate <NSObject>
-(void)go2PageVc:(NSDictionary *)obj;
@end

@interface TestJSObject : NSObject<TestJSObjectProtocol>
@property(nonatomic,weak) id <RetrunFormJsFunctionDelegate>delegate;

@end
