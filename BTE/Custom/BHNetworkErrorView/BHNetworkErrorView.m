//
//  WLNetworkErrorView.m
//  WangliBank
//
//  Created by xuehan on 16/6/16.
//  Copyright © 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "BHNetworkErrorView.h"

@implementation BHNetworkErrorView

- (IBAction)didClickReloadData:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(networkErrorViewdidCLickReloadData)]){
        [self.delegate networkErrorViewdidCLickReloadData];
    }
}


+ (instancetype)networkErrorViewWithFrame:(CGRect)frame delegate:(id<BHNetworkErrorViewDelegate>)delegate {
    BHNetworkErrorView *networkErrorView = [[NSBundle mainBundle] loadNibNamed:@"BHNetworkErrorView" owner:nil options:nil].firstObject;
    networkErrorView.delegate = delegate;
    networkErrorView.frame = frame;
    
    return networkErrorView;
}

@end
