//
//  BTEOrderHeadView.h
//  BTE
//
//  Created by wanmeizty on 2018/7/23.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTEOrderHeadView : UIView

-(void)setTitles:(NSArray *)tiles;
-(void)setTitlesCenter:(NSArray *)tiles;
- (void)setBigOrderTitle:(NSString *)title;
- (void)setBurnedOrderTitle:(NSString *)title;
@end
