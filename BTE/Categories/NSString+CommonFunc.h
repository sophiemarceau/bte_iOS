//
//  NSString+CommonFunc.h
//  WangliBank
//
//  Created by xiafan on 9/25/14.
//  Copyright (c) 2014 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CommonFunc)

/**
 *eg. 10,000,000.0
 */
- (NSString *)addColons;


/**
 *eg. 155*******89
 */
- (NSString *)encryptString;
/**
 *eg. 6225*******8888
 */
- (NSString *)encryptString2;
@end
