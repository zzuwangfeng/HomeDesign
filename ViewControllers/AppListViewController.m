//
//  AppListViewController.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/4.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "AppListViewController.h"
#import "UIView+Common.h"
#import <MMDrawerController/MMDrawerBarButtonItem.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "SelectionModel.h"
#import <UIImageView+WebCache.h>
#import "SubAndCategoryModeel.h"
#import "JWCache.h"
#import "NSString+Tools.h"

@interface AppListViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate> {
     CGFloat _lastPosition;
}

@end

@implementation AppListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initAllObjs];
    [self setSelfView];
    
}

- (void)initAllObjs {
    _daraAry = [NSMutableArray array];
    _aryPageCount = [NSMutableArray array];
    _isCache = YES;
    _isOnce = 0;
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


- (void)createCollectionView {
    // 创建视图布局对象
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    // 设置左右之间的间隙(当间隙小于某一个值(需要),不起作用)
    layOut.minimumInteritemSpacing = 0;
    
    // 设置的上下之间的间隙
    layOut.minimumLineSpacing = 0;
    //设置每个 Item 的 size (宽高)
//    layOut.itemSize = CGSizeMake(100, 100);
    //设置内容边界的距离
//    layOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    // 指定它滚动的方向
    layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight()) collectionViewLayout:layOut];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    // 测试背景颜色
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
    [self.view addSubview:_collectionView];
    
    //  添加刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_isOnce == 1) {
            _isCache = NO;
        }
        [self prepareToLoadData:NO];
        _isOnce ++;
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self prepareToLoadData:YES];
    }];
    
    _collectionView.header = header;
    _collectionView.footer = footer;
    
}

#pragma make - 解析数据
- (void)prepareToLoadData:(BOOL)isMore {
    NSInteger pageIndex = 0;
    if ([self.categoryType isEqualToString:kSelectionType]) {
        pageIndex = 1;
    } else if ([self.categoryType isEqualToString:kSubjectType]) {
        pageIndex = 0;
    }
    
    if (isMore) {
        if ([self.categoryType isEqualToString:kSelectionType]) {
            if (_daraAry.count % 10 == 0) {
                pageIndex = _daraAry.count / 10 + 1;
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
            
        } else if ([self.categoryType isEqualToString:kSubjectType]) {
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
    } else {
        if ([self.categoryType isEqualToString:kSelectionType]) {
            [self addTitleViewWithName:_categoryTitle];
        }
    }
    NSString *url;
    if (_isGeDiao == YES) {
        url = [NSString stringWithFormat:self.requestUrl, (long)pageIndex];
    } else {
        url = [NSString stringWithFormat:kSelectionCategoryNewUrl, _selectionType, (long)_categoryId, (long)pageIndex];
    }
    
    
    [self loadDataWithUrl:url isMore:isMore];
}

- (void)loadDataWithUrl:(NSString *)url isMore:(BOOL)isMore {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSData *data = [JWCache objectForKey:MD5Hash(url)];
    
    if (data && _isCache) {
        if (!isMore) {
            [_daraAry removeAllObjects];
        }
        if ([self.categoryType isEqualToString:kSelectionType]) {
            NSArray *ary = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] objectForKey:@"data"][@"data"];
            for (NSDictionary *dic in ary) {
                SelectionModel *model = [[SelectionModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_daraAry addObject:model];
            }
        } else {
            NSArray *ary = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] objectForKey:@"data"];
            for (NSDictionary *dic in ary) {
                SubAndCategoryModeel *model = [[SubAndCategoryModeel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                
                if ([model.album_type isEqualToString:@"4"] || [model.album_type isEqualToString:@"2"]) {
                    [_daraAry addObject:model];
                }
                [_aryPageCount addObject:model];
            }
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
            if ([self.categoryType isEqualToString:kSelectionType]) {
                NSArray *ary = [[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] objectForKey:@"data"][@"data"];
                for (NSDictionary *dic in ary) {
                    SelectionModel *model = [[SelectionModel alloc] init];

                    [model setValuesForKeysWithDictionary:dic];
                    [_daraAry addObject:model];
                }
            } else {
                NSArray *ary = [[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] objectForKey:@"data"];
                for (NSDictionary *dic in ary) {
                    SubAndCategoryModeel *model = [[SubAndCategoryModeel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    
                    if ([model.album_type isEqualToString:@"4"] || [model.album_type isEqualToString:@"2"] || [model.album_type isEqualToString:@"0"]) {
                        [_daraAry addObject:model];
                    }
                    [_aryPageCount addObject:model];
                }
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


#pragma make - CollectionView 协议方法

// 设置 距离边界距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

// 设置 item 的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.categoryType isEqualToString:kSelectionType]) {
        return CGSizeMake(screenWidth() / 2 - 10, 180);
    } else if ([self.categoryType isEqualToString:kSubjectType]) {
        return CGSizeMake(screenWidth() / 2 - 10, 220);
    } else {
        return CGSizeMake(0, 0);
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _daraAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath { 
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc] initWithFrame:cell.frame];
    
    if ([self.categoryType isEqualToString:kSelectionType]) {
        
        UIImageView *imgView;
        UILabel *labelLeft;
        UILabel *labelBottom;
        if (indexPath.row % 2) {
            labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, heightFromFrame(cell.frame))];
            labelLeft.layer.borderWidth = 1;
            labelLeft.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            
            labelBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, heightFromFrame(cell.frame) - 1, widthFromFrame(cell.frame), 1)];
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, widthFromFrame(view.frame) - 8, heightFromFrame(view.frame) - 8 * 2)];
            
            [view addSubview:labelLeft];
        } else {
            labelBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, heightFromFrame(cell.frame) - 1, widthFromFrame(cell.frame), 1)];
            
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, widthFromFrame(view.frame) - 8, heightFromFrame(view.frame) - 8 * 2)];
        }
        
        
        labelBottom.layer.borderWidth = 1;
        labelBottom.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
//        imgView.layer.cornerRadius = 6;
//        imgView.layer.masksToBounds = YES;
//        imgView.layer.borderColor = [[UIColor whiteColor] CGColor];
//        imgView.layer.borderWidth = 1;
        [imgView sd_setImageWithURL:[NSURL URLWithString:[_daraAry[indexPath.row] case_image_url]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        [view addSubview:imgView];
        [view addSubview:labelBottom];
        
    } else {
        UIImageView *imgView;
        UILabel *labelLeft;
        UILabel *labelBottom;
        if (indexPath.row % 2) {
            labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, heightFromFrame(cell.frame))];
            labelLeft.layer.borderWidth = 1;
            labelLeft.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            
            labelBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, heightFromFrame(cell.frame) - 1, widthFromFrame(cell.frame), 1)];
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, widthFromFrame(view.frame) - 8, heightFromFrame(view.frame) - 8 * 2 - 40)];
            
            [view addSubview:labelLeft];
        } else {
            labelBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, heightFromFrame(cell.frame) - 1, widthFromFrame(cell.frame), 1)];
            
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, widthFromFrame(view.frame) - 8, heightFromFrame(view.frame) - 8 * 2 - 40)];
        }
        
        
        labelBottom.layer.borderWidth = 1;
        labelBottom.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:[_daraAry[indexPath.row] img]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(minX(imgView), maxY(imgView) + 5, widthFromFrame(imgView.frame), 35)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1];
        titleLabel.numberOfLines = 2;
        titleLabel.text = [_daraAry[indexPath.row] title];
        
        [view addSubview:titleLabel];
        [view addSubview:imgView];
        [view addSubview:labelBottom];
    }
    
    
    cell.backgroundView = view;
    
    return cell;
}
//
//#pragma mark -
//#pragma mark scrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    /**
//     *  检测滚动方向
//     */
//    int currentPostion = scrollView.contentOffset.y;
//    
//    if (currentPostion - _lastPosition > 20  && currentPostion > 0) {        //这个地方加上 currentPostion > 0 即可）
//        
//        _lastPosition = currentPostion;
//        
//        //NSLog(@"ScrollUp now");
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            self.tabBarController.tabBar.frame = CGRectMake(0, screenHeight(), screenWidth(), 44);
//        }];
//        
//        if (_daraAry.count == 0) {
//            
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tip:" message:@"暂无数据，请浏览其他网页" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//            [alertView show];
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
//        } else {
//            [self.navigationController setNavigationBarHidden:YES animated:YES];
//        }
//        
//    }
//    
//    else if ((_lastPosition - currentPostion > 20) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height - 20)) {
//        _lastPosition = currentPostion;
//        
//        //NSLog(@"ScrollDown now");
////        [[UIApplication sharedApplication] setStatusBarHidden:NO];
////        self.tabBarController.tabBar.hidden = NO;
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            self.tabBarController.tabBar.frame = CGRectMake(0, screenHeight() - 44, screenWidth(), 44);
//        }];
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        
//    }
//}

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
//





































//
