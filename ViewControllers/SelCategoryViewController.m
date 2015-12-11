//
//  SelCategoryViewController.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/13.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "SelCategoryViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "HDDefine.h"

@interface SelCategoryViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    NSArray *_dataAry;
    NSArray *_aryTitle;
}

@end

@implementation SelCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg"] forBarMetrics:UIBarMetricsDefault];
    [self createTableView];
    [self createBackButton];
    [self initAllData];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.mm_drawerController.maximumRightDrawerWidth, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
}

- (void)createBackButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"MBLoginRightArrow"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 95, 31);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImageEdgeInsets:UIEdgeInsetsMake(1, 0, 1, 52)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(8, 7, 8, 0)];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [button setTitle:@"返回精选" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"返回精选" forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = barBtn;
}

- (void)backBtnAction:(id)sender {
    _selectionViewController.categoryId = 99;
    
    _selectionViewController.categoryTitle = @"精选";
    
    _selectionViewController.selectionType = @"style";
    
    [_selectionViewController.collectionView.header beginRefreshing];
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

- (void)initAllData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CategoryListPlist" ofType:@"plist"];
    
    _dataAry = [[NSArray alloc] initWithContentsOfFile:path];
    
    _aryTitle = @[@"空间", @"风格", @"局部"];
    
    [_tableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"   %@", _dataAry[indexPath.section][indexPath.row][@"name"]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithRed:36/255.0 green:36/255.0 blue:36/255.0 alpha:1];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 40)];
    label.text = _aryTitle[section];
    label.font = [UIFont boldSystemFontOfSize:17];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor = [UIColor colorWithRed:248/255.0 green:250/255.0 blue:213/255.0 alpha:1];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataAry.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int categoryId = [_dataAry[indexPath.section][indexPath.row][@"categoryId"] intValue];
    
    _selectionViewController.categoryId = categoryId;
    
    if (indexPath.section == 1) {
        _selectionViewController.selectionType = @"style";
    } else if (indexPath.section == 0) {
        _selectionViewController.selectionType = @"space";
    } else if (indexPath.section == 2) {
        _selectionViewController.selectionType = @"part";
    }
    _selectionViewController.isGeDiao = NO;
    _selectionViewController.categoryTitle = _dataAry[indexPath.section][indexPath.row][@"name"];
    
    [_selectionViewController.collectionView.header beginRefreshing];
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataAry[section] count];
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
