//
//  LeftViewController.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/4.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "LeftViewController.h"
#import <UIViewController+MMDrawerController.h>
#import <SDImageCache.h>
#import "MyControl.h"
#import "JWCache.h"
#import "FavoriteViewController.h"
#import "MyTabBarViewController.h"
#import "AboutWeViewController.h"

@interface LeftViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    UITableView *_tableView;
    NSArray *_aryData;
    MyTabBarViewController *tabBarCV;
}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg"] forBarMetrics:UIBarMetricsDefault];
    [self addTitleViewWithName:@"设置"];
    tabBarCV = (MyTabBarViewController *)self.mm_drawerController.centerViewController;
    [self createTableView];
}

- (void)addTitleViewWithName:(NSString *)name {
    UILabel *titleLabel = [MyControl creatLabelWithFrame:CGRectMake(0, 0, 200, 30) text:name];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:1];
    titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:22];
    self.navigationItem.titleView = titleLabel;
}

- (void)initData {
    _aryData = @[@[@"  首页                        >", @"  收藏                        >", @"  清理缓存                 >"], @[@"  关于我们                 >"]];
    
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, [self.mm_drawerController maximumLeftDrawerWidth], 240) style:UITableViewStylePlain];
    _tableView.center = CGPointMake([self.mm_drawerController maximumLeftDrawerWidth] / 2, self.view.center.y - 64);
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorColor = [UIColor blackColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.mm_drawerController maximumLeftDrawerWidth], self.view.frame.size.height - 64)];
    imgView.image = [UIImage imageNamed:@"leftBackground"];
    imgView.userInteractionEnabled = YES;
    [self.view addSubview:imgView];
    
    
    [self.view addSubview:_tableView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, cell.frame.size.height - 1, [self.mm_drawerController maximumLeftDrawerWidth] - 40, 1)];
    label.backgroundColor = [UIColor blackColor];
    [cell addSubview:label];
    
    cell.textLabel.text = _aryData[indexPath.section][indexPath.row];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _aryData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_aryData[section] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.mm_drawerController setCenterViewController:tabBarCV];
            [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
            
        } else if (indexPath.row == 2){
//            NSLog(@"%f", [JWCache getCacheLength]);
            
            UIAlertView *laertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"您有%.1fMb缓存，确定清理吗？", [JWCache getCacheLength]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [laertView show];
            
        } else {
            FavoriteViewController *faVC = [FavoriteViewController new];
            UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:faVC];
            
            [self.mm_drawerController setCenterViewController:navigation];
            
            [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        }
    } else {
        AboutWeViewController *vieC = [AboutWeViewController new];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vieC];
        
        [self.mm_drawerController setCenterViewController:navi];
        
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        
        
    }
}

#pragma make - alert代理协议
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        [JWCache resetCache];
        [[SDImageCache sharedImageCache] cleanDisk];
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"清理成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alertView show];
    }
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil]; 
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
//- (void)alertViewCancel:(UIAlertView *)alertView;


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
