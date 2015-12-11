//
//  UIView+Common.h
//  HDNOName
//
//  Created by qianfeng01 on 15/9/23.
//  Copyright (c) 2015年 hanzhiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Position)


/**
 *  根据 frame 返回高
 *
 *  @return 根据 frame 返回高
 */
CGFloat heightFromFrame(CGRect rect);

/**
 *  根据 frame 返回宽
 *
 *
 *  @return 根据 frame 返回宽
 */

CGFloat widthFromFrame(CGRect rect);

/**
 *  获取屏幕的宽
 *
 *  @return 返回屏幕的款
 */
CGFloat screenWidth();

/**
 *  获取屏幕的高
 *
 *  @return 返回屏幕的高
 */
CGFloat screenHeight();

/**
 *  返回当前视图的款
 *
 *  @return 返回当前视图的款
 */
- (CGFloat)width;

/**
 *  返回当前视图的高
 *
 *  @return 返回当前视图的高
 */
- (CGFloat)height;

/**
 *  获取视图最大的 x 坐标
 *
 *  @param view
 *
 *  @return x 的坐标
 */
CGFloat maxX(UIView *view);
/**
 *  获取视图最大的 y 坐标
 *
 *  @param view
 *
 *  @return y 的坐标
 */
CGFloat maxY(UIView *view);
CGFloat minX(UIView *view);
CGFloat minY(UIView *view);
CGFloat midX(UIView *view);
CGFloat midY(UIView *view);

@end

@interface UIView (Common)

@end
