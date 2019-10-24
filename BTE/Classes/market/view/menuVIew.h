//
//  menuVIew.h
//  Massage
//
//  Created by 牛先 on 15/10/31.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class menuVIew;
@protocol menuViewDelegate <NSObject>
-(void)menuViewDidSelect:(NSInteger)number;
@end
@interface menuVIew : UIView
@property (strong, nonatomic) UIButton *selectedButton;
@property (strong, nonatomic) NSArray *menuArray;
@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSMutableArray *lineArray;
//@property (assign, nonatomic) BOOL isNotification;
@property (weak, nonatomic) id<menuViewDelegate> delegate;

- (void)tapped:(UIButton *)sender;

- (instancetype)initWithFrame:(CGRect)frame WithArray:(NSArray *)array;
@end
