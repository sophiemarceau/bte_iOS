//
//  NSObject+entend.m
//  WangliBank
//
//  Created by xuehan on 16/1/8.
//  Copyright (c) 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "NSObject+entend.h"

@implementation NSObject (entend)
- (NSString *)formatWithValue:(double)value{
    NSString * testNumber = [NSString stringWithFormat:@"%.2f",value];
    return [self privateFormatWithValue:testNumber];
}
- (NSString *)formatWithValuetThree:(double)value{
    NSString * testNumber = [NSString stringWithFormat:@"%.3f",value];
    return [self privateFormatWithValue:testNumber];
}
// 私有
- (NSString*)privateFormatWithValue:(NSString*)testNumber{
    NSString * s = nil;
    int offset = (int)(testNumber.length - 1);
    while (offset)
    {
        s = [testNumber substringWithRange:NSMakeRange(offset, 1)];
        if([s isEqualToString:@"."]){
            offset--;
            break;
        }else{
            if ([s isEqualToString:@"0"])
            {
                offset--;
            }
            else
            {
                break;
            }
        }
    }
    NSString *outNumber = [testNumber substringToIndex:offset+1];
    return outNumber;
}
- (NSString *)formatWithValueZero:(double)value {
    if (value == 0) {
        return @"0.00";
    }
    
    return [self formatWithValue:value];
}

- (double)formatWithValueMultiple:(double)value forHundredOrThousand:(int)hundredOrThousand remainAmount:(double)remain_amount limitPerUser:(int)limit_per_user limitAmount:(double)limit_amount{
    int count = value  / hundredOrThousand;
    double def = count * hundredOrThousand;
    // 判断是否有限额
    if (limit_per_user == 1) {
        double min = limit_amount > remain_amount ?remain_amount : limit_amount;
        if (def > min) {
            def = min;
        }
    }else{
        // 判断是否大于可投金额
        if (def > remain_amount) {
            def = remain_amount;
        }
    }

    return def;
    
}
- (NSArray*)formatWithValuetotalAmount:(double)total_amount minValue:(NSString*)minValue{
    NSMutableArray *maxArray = [NSMutableArray array];
    [maxArray addObject:minValue];
    for (int i = 1; i < 6; i++) {
        NSString *str = [self formatWithValueEach:total_amount index:i talAmount:total_amount];
        [maxArray addObject:str];
    }
    return [NSArray arrayWithArray:maxArray];
}
-(NSString*)formatWithValueEach:(double)max index:(int)inde talAmount:(double)total_amount{
    double eachNum = max / 5 / 10000 * inde;
    NSString *outNumber = [self interestRatConversion:eachNum index:inde talAmount:total_amount];
    return outNumber;
}
- (NSString*)interestRatConversion:(double)rate index:(int)index talAmount:(double)total_amount{
    if (SCREEN_WIDTH < 375) {
        if (index != 5) {
            if (total_amount < 50000) {
                NSString *outNumber = [self formatWithValue:rate];
                return [NSString stringWithFormat:@"%@w",outNumber];
            }
            NSString *outNumber = [NSString stringWithFormat:@"%.0f",rate];
            return [NSString stringWithFormat:@"%@w",outNumber];
        }
    }
    NSString *outNumber = [self formatWithValue:rate];
    return [NSString stringWithFormat:@"%@w",outNumber];
    
}

- (NSUInteger)sizeAtPath:(NSString*)folderPath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

- (long long) fileSizeAtPath:(NSString*)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
- (void)setNilValueForKey:(NSString *)key{};
@end
