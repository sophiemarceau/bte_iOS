//
//  PhoneInfo.m
//  BTE
//
//  Created by wanmeizty on 14/8/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "PhoneInfo.h"

#import <sys/utsname.h>
struct utsname systemInfo;
@implementation PhoneInfo
- (instancetype)init{
    if (self = [super init]) {
        self.platform = [self getPhonePlatform];
        self.phoneVersion = [[UIDevice currentDevice] systemVersion];
        self.brand = @"iphone";
        uname(&systemInfo);
        self.model = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    }
    return self;
}

- (NSString *)getPhonePlatform{
    
    uname(&systemInfo);
    NSString*phoneType = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([phoneType  isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
    
    if([phoneType  isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
    
    if([phoneType  isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
    
    if([phoneType  isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
    
    if([phoneType  isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
    
    if([phoneType  isEqualToString:@"iPhone3,3"])  return@"iPhone 4";
    
    if([phoneType  isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
    
    if([phoneType  isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    
    if([phoneType  isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    
    if([phoneType  isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    
    if([phoneType  isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    
    if([phoneType  isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    
    if([phoneType  isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    
    if([phoneType  isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    
    if([phoneType  isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    
    if([phoneType  isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    
    if([phoneType  isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    
    if([phoneType  isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([phoneType  isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([phoneType  isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([phoneType  isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([phoneType  isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([phoneType  isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([phoneType  isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([phoneType  isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([phoneType  isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    return @"iPhone";
}
@end
