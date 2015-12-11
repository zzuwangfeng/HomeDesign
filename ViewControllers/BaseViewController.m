//
//  BaseViewController.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/4.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "BaseViewController.h"
#import "MyControl.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)addTitleViewWithName:(NSString *)name {
    UILabel *titleLabel = [MyControl creatLabelWithFrame:CGRectMake(0, 0, 200, 30) text:name];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:1];
    titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:22];
    self.navigationItem.titleView = titleLabel;
}
- (void)addItemWithName:(NSString *)name
                 target:(id)target
                 action:(SEL)action
                 isLeft:(BOOL)isLeft {
    
    UIButton *button = [MyControl creatButtonWithFrame:CGRectMake(0, 0, 20, 20) target:target sel:action tag:0 image:@"back_icon" title:name];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = item;
    }else {
        self.navigationItem.rightBarButtonItem = item;
    }
    
    
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
