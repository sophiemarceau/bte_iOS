//
//  HookUtility.h
//  BTE
//
//  Created by sophie on 2018/7/12.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HookUtility : NSObject
+ (void)swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
@end
