//
//  NSLayoutConstraint+IBDesignable.m
//  BTE
//
//  Created by sophie on 2018/8/17.
//  Copyright © 2018年 wangli. All rights reserved.
//

#import "NSLayoutConstraint+IBDesignable.h"

@implementation NSLayoutConstraint (IBDesignable)
- (void)setAdapterScreen:(BOOL)adapterScreen{
    adapterScreen = adapterScreen;
    if (adapterScreen){
        self.constant =  SCALE_W(self.constant);
    }
}

- (BOOL)adapterScreen{
    return YES;
}
@end
