//
//  MyTabBarViewController.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/4.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "MyTabBarViewController.h"
#import "HDDefine.h"
#import "AppListViewController.h"

@interface MyTabBarViewController ()

@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViewControllers];
    [self createLaunchImageAnimation];
}


#pragma mark - 启动动画效果

//自定义的启动动画  必须自己写代码 实现
- (void)createLaunchImageAnimation {
    //增加一个 程序加载时候的启动动画。下面使我们自己实现的一个 隐藏的动画效果
    UIImageView * startView = [MyControl creatImageViewWithFrame:self.view.bounds imageName:@"qidong2iPhonePortraitiOS8_375x667pt"];
    //tabr 的视图上
    [self.view addSubview:startView];
    [UIView animateWithDuration:1 animations:^{
        startView.alpha = 0;
    } completion:^(BOOL finished) {
        [startView removeFromSuperview];
    }];
    
}


#pragma mark - 创建子视图
- (void)createViewControllers {
    
    NSArray *urlArr = @[kHeadUrl,kSubUrl,kSelectionUrl,kCategoryUrl];
    NSArray *categoryArr = @[kHeadType,kSubjectType,kSelectionType,kCategoryType];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Controllers" ofType:@"plist"];
    //解析plist
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *vcArr = [[NSMutableArray alloc] init];
    //遍历数组
    for (NSInteger i = 0; i < arr.count; i++) {
        NSDictionary *dict = arr[i];
        NSString *title = dict[@"title"];
        NSString *iconName = dict[@"iconName"];
        NSString *iconSelectName = dict[@"iconNameSelected"];
        NSString *className = dict[@"className"];
        //动态创建 对象
        Class clsName = NSClassFromString(className);
        AppListViewController *app = [[clsName alloc] init];
        //传值
        app.requestUrl = urlArr[i];
        app.categoryType = categoryArr[i];
        
        //创建导航
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:app];
        
        //视图控制器的title
        app.title = title;
        
        //        app.navigationItem.title = title;
        //        nav.tabBarItem.title = title;
        [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:122/255.0 green:186/255.0 blue:58/255.0 alpha:1]} forState:UIControlStateSelected];
        nav.tabBarItem.image = [[UIImage imageNamed:iconName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:iconSelectName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [vcArr addObject:nav];
    }
    //放入tabBar的子视图控制器数组
    self.viewControllers = vcArr;
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
