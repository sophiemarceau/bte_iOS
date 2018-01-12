//
//  NSObject+JSONParse.h
//  WangliBank
//
//  Created by xiafan on 9/28/14.
//  Copyright (c) 2014 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WLBSetter(className, subfix, param) \
- (void)set##subfix:(id)param \
{ \
if ([param isKindOfClass:[NSDictionary class]]) { \
_##param = [[className alloc] initWithDict:param]; \
} else { \
_##param = param; \
} \
}

#define WLBWithDictH(prefix) \
+ (instancetype)prefix##WithDict:(NSDictionary *)dict; \
- (instancetype)initWithDict:(NSDictionary *)dict;

#define WLBWithDictM(prefix) \
- (instancetype)initWithDict:(NSDictionary *)dict \
{ \
if (self = [super init]) { \
[self setValues:dict]; \
} \
return self; \
} \
+ (instancetype)prefix##WithDict:(NSDictionary *)dict \
{ \
return [[self alloc] initWithDict:dict]; \
}


#define WLBEncodeDecodeModel \
- (id)initWithCoder:(NSCoder *)decoder \
{ \
if (self = [super init]) { \
[self decode:decoder]; \
} \
return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
[self encode:encoder]; \
}


@interface NSObject (JSONParse)

- (void)setValues:(NSDictionary *)values;
- (NSDictionary *)values;
- (void)decode:(NSCoder *)decoder;
- (void)encode:(NSCoder *)encoder;
@end
