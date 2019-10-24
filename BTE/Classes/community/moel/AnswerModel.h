//
//  AnswerModel.h
//  BTE
//
//  Created by wanmeizty on 30/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnswerModel : NSObject
@property (copy,nonatomic) NSString * authorName;
@property (copy,nonatomic) NSString * commontName;
@property (copy,nonatomic) NSString * commont;
@property (assign,nonatomic) CGFloat heigth;
@property (assign,nonatomic) CGFloat commontHeight;
@end

NS_ASSUME_NONNULL_END
