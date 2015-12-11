//
//  BaseViewController.h
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/4.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//导航的标题视图
- (void)addTitleViewWithName:(NSString *)name;
//增加左右按钮
- (void)addItemWithName:(NSString *)name
                 target:(id)target
                 action:(SEL)action
                 isLeft:(BOOL)isLeft;

@end
