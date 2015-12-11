//
//  SelectionViewController.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/4.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "SelectionViewController.h"
#import <MJRefresh.h>
#import "ViewControllerScrollView.h"
#import "SelectionModel.h"
#import "UIView+Common.h"
#import <MMDrawerController.h>
#import <MMDrawerBarButtonItem.h>
#import <UIViewController+MMDrawerController.h>
#import "SelCategoryViewController.h"

@interface SelectionViewController () {
    UIView *_viewMenu;
}

@end

@implementation SelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置title
    [self addTitleViewWithName:@"精选"];
    self.categoryId = 99;
    _isGeDiao = NO;
    self.selectionType = @"style";
    self.categoryTitle = @"精选";
    [self setupLeftMenuButton];
    [self createRightBarBtn];
    [self createCollectionView];
    [_collectionView.header beginRefreshing];
}

- (void)createRightBarBtn {

    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    [rightDrawerButton setImage:nil];
    [rightDrawerButton setTitle:@"类别"];
    [rightDrawerButton setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [rightDrawerButton setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateHighlighted];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
}


- (void)rightDrawerButtonPress:(id)sender {
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
    }];
}

// 屏幕将要消失时，去除右边视图
- (void)viewWillDisappear:(BOOL)animated {
    [self.mm_drawerController setRightDrawerViewController:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    SelCategoryViewController *selCategory = [SelCategoryViewController new];
    selCategory.selectionViewController = self;
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:selCategory];
    
    [self.mm_drawerController setRightDrawerViewController:navigation];
    [self.mm_drawerController setMaximumRightDrawerWidth:200];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ViewControllerScrollView *viewScroll = [ViewControllerScrollView new];
    viewScroll.hidesBottomBarWhenPushed = YES;
    
    viewScroll.aryData = _daraAry;
    viewScroll.selIndex = indexPath.row;
    viewScroll.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:viewScroll animated:YES completion:^{
        
    }];
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
