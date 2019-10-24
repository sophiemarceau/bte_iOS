//
//  ZTYSortHeadView.h
//  BTE
//
//  Created by wanmeizty on 15/11/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol sortClickDelegate <NSObject>
- (void)sortClickIndex:(int)index;
@end

@interface ZTYSortHeadView : UIView
- (instancetype)initWithFrame:(CGRect)frame sortTitles:(NSArray *)titles isCanSorts:(NSArray *)canSorts aligns:(NSArray *)aligns;
@property (weak,nonatomic) id<sortClickDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
