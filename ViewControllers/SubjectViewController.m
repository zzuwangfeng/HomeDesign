//
//  SubjectViewController.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/4.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "SubjectViewController.h"
#import "SubDetailViewController.h"
#import "CategoryClickViewController.h"
#import "UIView+Common.h"

@interface SubjectViewController () <UISearchBarDelegate, UIScrollViewDelegate> {
    CGFloat _lastPosition;
}

@end

@implementation SubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置title
    [self addTitleViewWithName:@"格调"];
    _isGeDiao = YES;
    [self setupLeftMenuButton];
    [self createCollectionView];
    [self createRightSearchBtn];
    [_collectionView.header beginRefreshing];
}

- (void)createRightSearchBtn {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 48, 48);
    [btn setImage:[UIImage imageNamed:@"tab_search"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searChBarClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = rightBar;
}

// 搜索点击
- (void)searChBarClick:(UIBarButtonItem *)barBtn {
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    //设置代理
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索更多";
    
    [self.navigationItem setTitleView:searchBar];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 40, 50);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = item;
    
}

-(void)back:(UIButton *)btn {
    [self addTitleViewWithName:@"格调"];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 25, 25);
    [button setImage:[UIImage imageNamed:@"tab_search"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(searChBarClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - UISearcharBarDelegate
//是否可以进入编辑模式
//将要进入编辑模式调用
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //显示 cancel 按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

//将要结束编辑模式调用
//是否可以结束编辑模式
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    //隐藏cancel 按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;//可以结束编辑模式
}
//点击cancel 的时候调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    //收键盘
    [searchBar resignFirstResponder];
    searchBar.text = @"";//清空内容
}

// 点击搜索触发
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%@",searchBar.text);
    
    CategoryClickViewController *cateClickView = [CategoryClickViewController new];
    cateClickView.myTitle = searchBar.text;
    cateClickView.categoryType = kSubjectType;
    cateClickView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cateClickView animated:YES];
    
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SubDetailViewController *viewController = [SubDetailViewController new];
    viewController.album_type = [_daraAry[indexPath.row] album_type];
    viewController.albumId = [_daraAry[indexPath.row] albumId];
    viewController.title = [_daraAry[indexPath.row] title];
    viewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self back:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /**
     *  检测滚动方向
     */
    int currentPostion = scrollView.contentOffset.y;
    
    if (currentPostion - _lastPosition > 20  && currentPostion > 0) {        //这个地方加上 currentPostion > 0 即可）
        
        _lastPosition = currentPostion;
        
        //NSLog(@"ScrollUp now");
        
        [UIView animateWithDuration:0.5 animations:^{
            self.tabBarController.tabBar.frame = CGRectMake(0, screenHeight(), screenWidth(), 44);
        }];
        
        if (_daraAry.count == 0) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tip:" message:@"暂无数据，请浏览其他网页" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        } else {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
        
    }
    
    else if ((_lastPosition - currentPostion > 20) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height - 20)) {
        _lastPosition = currentPostion;
        
        //NSLog(@"ScrollDown now");
        //        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        //        self.tabBarController.tabBar.hidden = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.tabBarController.tabBar.frame = CGRectMake(0, screenHeight() - 44, screenWidth(), 44);
        }];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    }
    UIButton *btnTem = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    if ([btnTem.titleLabel.text isEqualToString:@"取消"]) {
        [self back:nil];
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
