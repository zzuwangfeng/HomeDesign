//
//  CategoryClickViewController.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/14.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "CategoryClickViewController.h"
#import "SubDetailViewController.h"
#import "NSString+Tools.h"
#import "JWCache.h"
#import "SubAndCategoryModeel.h"

@interface CategoryClickViewController ()

@end

@implementation CategoryClickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置title
    [self addTitleViewWithName:_myTitle];
    self.isGeDiao = YES;
    [self createCollectionView];
    [self createBackButton];
    [_collectionView.header beginRefreshing];
}

- (void)createBackButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"MBLoginRightArrow"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 80, 31);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImageEdgeInsets:UIEdgeInsetsMake(1, 0, 1, 52)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(8, 7, 8, 0)];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [button setTitle:@"返回首页" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"返回首页" forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = barBtn;
}

- (void)backBtnAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SubDetailViewController *viewController = [SubDetailViewController new];
    viewController.album_type = [_daraAry[indexPath.row] album_type];
    viewController.albumId = [_daraAry[indexPath.row] albumId];
    viewController.title = [_daraAry[indexPath.row] title];
    viewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma make - 解析数据
- (void)prepareToLoadData:(BOOL)isMore {
    NSInteger pageIndex = 0;
    
    if (isMore) {
        if (_aryPageCount.count % 10 == 0) {
            pageIndex = _aryPageCount.count / 10;
        }else {
            [_collectionView.footer endRefreshing];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message:@"没有更多"
                                  delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
        
        
    }
    NSString *url = [NSString stringWithFormat:kSearchUrl, URLEncodedString(_myTitle), (long)pageIndex];
    
    [self loadDataWithUrl:url isMore:isMore];
}

- (void)loadDataWithUrl:(NSString *)url isMore:(BOOL)isMore {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSData *data = [JWCache objectForKey:MD5Hash(url)];
    
    if (data && _isCache) {
        if (!isMore) {
            [_daraAry removeAllObjects];
        }
        
        NSArray *ary = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] objectForKey:@"data"];
        for (NSDictionary *dic in ary) {
            SubAndCategoryModeel *model = [[SubAndCategoryModeel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            
            if ([model.album_type isEqualToString:@"4"] || [model.album_type isEqualToString:@"2"] || [model.album_type isEqualToString:@"0"]) {
                [_daraAry addObject:model];
            }
            [_aryPageCount addObject:model];
        }
        
        [_collectionView reloadData];
        // 停止刷新指示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        isMore ? [_collectionView.footer endRefreshing] : [_collectionView.header endRefreshing];
    } else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (!isMore) {
                [_daraAry removeAllObjects];
                [_aryPageCount removeAllObjects];
            }
            
            NSArray *ary = [[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] objectForKey:@"data"];
            for (NSDictionary *dic in ary) {
                SubAndCategoryModeel *model = [[SubAndCategoryModeel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                
                if ([model.album_type isEqualToString:@"4"] || [model.album_type isEqualToString:@"2"] || [model.album_type isEqualToString:@"0"]) {
                    [_daraAry addObject:model];
                }
                [_aryPageCount addObject:model];
            }
            
            
            // 添加到缓存
            [JWCache setObject:responseObject forKey:MD5Hash(url)];
            
            [_collectionView reloadData];
            // 停止刷新指示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            isMore ? [_collectionView.footer endRefreshing] : [_collectionView.header endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", [error description]);
            // 停止刷新指示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            isMore ? [_collectionView.footer endRefreshing] : [_collectionView.header endRefreshing];
        }];
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
