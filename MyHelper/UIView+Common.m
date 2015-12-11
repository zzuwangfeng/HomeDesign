//
//  UIView+Common.m
//  HDNOName
//
//  Created by qianfeng01 on 15/9/23.
//  Copyright (c) 2015年 hanzhiyuan. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Position)

CGFloat screenWidth() {
    return [[UIScreen mainScreen] bounds].size.width;
}

CGFloat screenHeight() {
    return [[UIScreen mainScreen] bounds].size.height;
}

/**
 *  根据 frame 返回高
 *
 *  @return 根据 frame 返回高
 */
CGFloat heightFromFrame(CGRect rect) {
    return CGRectGetHeight(rect);
}

/**
 *  根据 frame 返回宽
 *
 *
 *  @return 根据 frame 返回宽
 */

CGFloat widthFromFrame(CGRect rect) {
    return CGRectGetWidth(rect);
}


/**
 *  返回当前视图的款
 *
 *  @return 返回当前视图的款
 */
- (CGFloat)width {
    return self.frame.size.width;
}

/**
 *  返回当前视图的高
 *
 *  @return 返回当前视图的高
 */
- (CGFloat)height {
    return self.frame.size.height;
}


CGFloat maxX(UIView *view) {
    return CGRectGetMaxX(view.frame);
}

CGFloat maxY(UIView *view) {
    return CGRectGetMaxY(view.frame);
}

CGFloat minX(UIView *view) {
    return CGRectGetMinX(view.frame);
}

CGFloat minY(UIView *view) {
    return CGRectGetMinY(view.frame);
}

CGFloat midX(UIView *view) {
    return CGRectGetMidX(view.frame);
}

CGFloat midY(UIView *view) {
    return CGRectGetMidY(view.frame);
}

@end

@implementation UIView (Common)

@end
//





































//