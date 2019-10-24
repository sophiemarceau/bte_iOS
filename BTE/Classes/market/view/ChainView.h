//
//  ChainView.h
//  BTE
//
//  Created by sophie on 2018/11/14.
//  Copyright © 2018 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChainView : UIView
@property (strong, nonatomic) NSMutableArray *buttonArray;
- (instancetype)initWithFrame:(CGRect)frame WithNameArray:(NSArray *)array;
- (void)setValueForName:(NSArray *)valueArray;
@end

NS_ASSUME_NONNULL_END
