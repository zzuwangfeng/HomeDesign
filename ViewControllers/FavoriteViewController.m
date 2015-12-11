//
//  FavoriteViewController.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/16.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "FavoriteViewController.h"
#import <MMDrawerBarButtonItem.h>
#import <UIViewController+MMDrawerController.h>
#import "FavoriteModel.h"
#import "DBManager.h"
#import "ContentClickViewController.h"
#import "SubDetailViewController.h"

@interface FavoriteViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_aryData;
}

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSelfView];
    [self addTitleViewWithName:@"收藏"];
    [self setupLeftMenuButton];
    [self createTableView];
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

- (void)initData {
    _aryData = [NSMutableArray arrayWithArray:[[DBManager sharedManager] readAllModels]];
    [_tableView reloadData];
}

// 设置背景图片背景色
- (void)setSelfView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigationBg@2x"] imageWithRenderingMode:UIImageRenderingModeAutomatic] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 15, 1)];
    label.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 200, 30);
    btn.center = view.center;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn setTitle:@"删除所有收藏" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [[UIColor blackColor] CGColor];
    btn.layer.cornerRadius = 6;
    btn.backgroundColor = [UIColor colorWithRed:122/255.0 green:186/255.0 blue:58/255.0 alpha:1];
    [btn addTarget:self action:@selector(deleteAllAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    _tableView.tableFooterView = view;
    
    [self.view addSubview:_tableView];
    
}


- (void)deleteAllAction:(UIButton *)button {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告！！！" message:@"是否要删除所有数据" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSLog(@"%ld", buttonIndex);
    if (buttonIndex == 1) {
        if ([[DBManager sharedManager] dropTable]) {
            UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"删除成功！" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [aler show];
            [_aryData removeAllObjects];
            [_tableView reloadData];
        } else {
            UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"删除失败！" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [aler show];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = [_aryData[indexPath.row] title];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _aryData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoriteModel *model = _aryData[indexPath.row];
    
    if ([model.recordType isEqualToString:@"header"]) {
        ContentClickViewController *contentViewController = [ContentClickViewController new];
        contentViewController.caseId = model.favorityId;
        contentViewController.hidesBottomBarWhenPushed = YES;
        
        contentViewController.title = model.title;
        [self.navigationController pushViewController:contentViewController animated:YES];
    } else {
        SubDetailViewController *viewController = [SubDetailViewController new];
        viewController.album_type = model.album_type;
        viewController.albumId = model.favorityId;
        viewController.title = model.title;
        viewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除某个分区 某一行对应的数据源元素
        [[DBManager sharedManager] deleteValueWithFavorityId:[_aryData[indexPath.row] favorityId]];
        [_aryData removeObjectAtIndex:indexPath.row];
        
        // 删除某些行
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [self initData];
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
