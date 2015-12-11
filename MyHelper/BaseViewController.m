//
//  BaseViewController.m
//  HDNOName
//
//  Created by qianfeng01 on 15/9/23.
//  Copyright (c) 2015年 hanzhiyuan. All rights reserved.
//

#import "BaseViewController.h"
#import "UIView+Common.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTitleWithName:self.title];
}

/**
 *  给导航设置title
 *
 */
- (void)addTitleWithName:(NSString *)name {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.text = name;
    titleLabel.textColor = [UIColor colorWithRed:30/255.f green:160/255.f blue:230/255.f alpha:1];
    titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:22];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = titleLabel;
}

/**
 *  创建导航 按钮
 *
 *  @param bgImgName 背景图片名字
 *  @param frame     button frame
 *  @param title     button title
 *  @param aSelector button action
 *  @param isLeft    是否是左边按钮
 */
- (void)createBarButtonItemWithBackground:(NSString *)bgImgName
                                    Frame:(CGRect)frame
                                    title:(NSString *)title
                                aSelector:(SEL)aSelector
                                   isLeft:(BOOL)isLeft {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, widthFromFrame(frame),heightFromFrame(frame));
    [btn setBackgroundImage:[UIImage imageNamed:bgImgName] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    if (aSelector && [self respondsToSelector:aSelector]) {
        [btn addTarget:self action:aSelector forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = barBtnItem;
    } else {
        self.navigationItem.rightBarButtonItem = barBtnItem;
    }
}

- (void)targetAction:(UIButton *)button {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
