//
//  BTELeftImgRightlabelView.h
//  BTE
//
//  Created by wanmeizty on 29/10/18.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTELeftImgRightlabelView : UIButton
- (void)setUpImg:(NSString *)imgName title:(NSString *)title;
- (NSString *)getTextstring;
- (void)setBadgeString:(NSString *)number;
@end

NS_ASSUME_NONNULL_END
