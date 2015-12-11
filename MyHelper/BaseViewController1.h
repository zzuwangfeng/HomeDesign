//
//  BaseViewController.h
//  HDNOName
//
//  Created by qianfeng01 on 15/9/23.
//  Copyright (c) 2015年 hanzhiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)createBarButtonItemWithBackground:(NSString *)bgImgName
                                    Frame:(CGRect)frame
                                    title:(NSString *)title
                                aSelector:(SEL)aSelector
                                   isLeft:(BOOL)isLeft;
/**
 *  给导航设置 title
 *
 *  @param name 
 */
- (void)addTitleWithName:(NSString *)name;

@end
