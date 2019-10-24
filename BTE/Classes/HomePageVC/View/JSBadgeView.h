//
//  JSBadgeView.h
//  JSBadgeView
//
//  Created by sophiemarceau_qu on 2016/12/17.
//  Copyright © 2016年 seanoshea. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum {
    JSBadgeViewAlignmentTopLeft,
    JSBadgeViewAlignmentTopRight,
    JSBadgeViewAlignmentTopCenter,
    JSBadgeViewAlignmentCenterLeft,
    JSBadgeViewAlignmentCenterRight,
    JSBadgeViewAlignmentBottomLeft,
    JSBadgeViewAlignmentBottomRight,
    JSBadgeViewAlignmentBottomCenter,
    JSBadgeViewAlignmentCenter
} JSBadgeViewAlignment;

@interface JSBadgeView : UIView

@property (nonatomic, copy) NSString *badgeText;

#pragma mark - Customization

@property (nonatomic, assign) JSBadgeViewAlignment badgeAlignment;

@property (nonatomic, strong) UIColor *badgeTextColor;
@property (nonatomic, assign) CGSize badgeTextShadowOffset;
@property (nonatomic, strong) UIColor *badgeTextShadowColor;

@property (nonatomic, strong) UIFont *badgeTextFont;

@property (nonatomic, strong) UIColor *badgeBackgroundColor;

@property (nonatomic, strong) UIColor *badgeStrokeColor;

/**
 * @discussion color of the overlay circle at the top. Default is semi-transparent white.
 */
@property (nonatomic, strong) UIColor *badgeOverlayColor;

/**
 * @discussion allows to shift the badge by x and y points.
 */
@property (nonatomic, assign) CGPoint badgePositionAdjustment;

/**
 * @discussion (optional) If not provided, the superview frame is used.
 * You can use this to position the view if you're drawing it using drawRect instead of `-addSubview:`
 */
@property (nonatomic, assign) CGRect frameToPositionInRelationWith;

/**
 * @discussion optionally init using this method to have the badge automatically added to another view.
 */
- (id)initWithParentView:(UIView *)parentView alignment:(JSBadgeViewAlignment)alignment;

@end
