//
//  AboutWeViewController.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/16.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "AboutWeViewController.h"
#import "UIView+Common.h"
#import <MMDrawerBarButtonItem.h>
#import <UIViewController+MMDrawerController.h>

@interface AboutWeViewController ()

@end

@implementation AboutWeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLabel];
    [self setupLeftMenuButton];
    [self setSelfView];
}

/**
 *  设置抽屉的导航左侧按钮
 */
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    leftDrawerButton.tintColor = [UIColor blackColor];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


// 设置背景图片背景色
- (void)setSelfView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigationBg@2x"] imageWithRenderingMode:UIImageRenderingModeAutomatic] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)createLabel {
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
//    imgView.backgroundColor = [UIColor greenColor];
    imgView.image = [UIImage imageNamed:@"aboutWe"];
    imgView.layer.cornerRadius = 6;
    imgView.layer.masksToBounds = YES;
    imgView.center = CGPointMake(self.view.center.x, 60);
    
    [self.view addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, maxY(imgView) + 20, screenWidth() - 20, screenHeight() - 2 * 60 - 64)];
    label.numberOfLines = 0;
//    label.backgroundColor = [UIColor greenColor];
   
    label.text = @"内容提要:\n爱家居是我们为您设计的装修辅助软件, 简洁的界面设计, 帮助您更好的获取设计灵感, 旨在帮助您设计属于您自己的家.\n\n 特点:\n* 内容清新简洁, 美观大方\n* 我们精心的优化, 让您体验更流畅\n* 支持多种设备\n* 可自动检测分辨率\n* 内容已分门别类,让您更容易查找并选择自己喜欢的内容\n* 贴心的长安保存功能, 让您存储自己喜欢的照片\n* 将您喜欢的内容添加到您的收藏\n\n爱家爱生活, 打造一款属于您自己的甜新港湾\n";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithRed:18/255.0 green:15/255.0 blue:15/255.0 alpha:1];
    [self.view addSubview:label];
    
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
