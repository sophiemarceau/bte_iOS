//
//  UIButton+EnlargeEdge.h
//  WangliBank
//
//  Created by  wuhiwi on 16/10/26.
//  Copyright © 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//


/**
 扩大button的相应区域
 */

@interface UIButton (EnlargeEdge)

/**
 *  上下左右扩大相同的范围
 *
 *  @param size
 */
- (void)setEnlargeEdge:(CGFloat) size;
/**
 *
 *
 *  @param top     向上扩大范围
 *  @param right   向右扩大范围
 *  @param bottom  向下扩大范围
 *  @param left    向左扩大范围
 */
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end
