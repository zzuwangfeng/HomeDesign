//
//  HeadViewController.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/4.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "HeadViewController.h"
#import "HDDefine.h"
#import "HeaderModel.h"
#import "HeadTableViewCell.h"
#import "JWCache.h"
#import "NSString+Tools.h"
#import "UIView+Common.h"
#import "HeaderPicModel.h"
#import <UIImageView+WebCache.h>
#import <MMDrawerController.h>
#import <UIViewController+MMDrawerController.h>
#import "ContentClickViewController.h"
@interface HeadViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    NSMutableArray *_dataAry;
    NSMutableArray *_picAry;
    BOOL _isCache;
    UIScrollView *_scrollView;
    UIView *_view;
    UILabel *_labelHeader1;
    UILabel *_labelHeader2;
    NSMutableArray *_imgViewAry;
    MBProgressHUD *_dataProgress;
    NSTimer *_timer;
    UILabel *_headTitleLabel;
    UITableView *_tableView;
    int _lastPosition;
}

@end

@implementation HeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置title
    [self addTitleViewWithName:@"首页"];
    [self setupLeftMenuButton];
    [self initObjs];
    [self createTableView];
}

- (void)initObjs {
//    [[SDImageCache sharedImageCache] cleanDisk];
//    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
    _dataAry = [NSMutableArray array];
    _picAry = [NSMutableArray array];
    _isCache = YES;
    _imgViewAry = [NSMutableArray array];
}

- (void)createTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerChange:) userInfo:nil repeats:YES];
    _timer.fireDate = [NSDate distantFuture];
}

- (void)timerChange:(NSTimer *)timer {
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + screenWidth(), 0) animated:YES];
}

// 创建 tableView
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 创建上拉下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        static int isOnce = 0;
        if (isOnce == 1) {
            _isCache = NO;
        }
        [self prepareLoadData:NO];
        isOnce ++;
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self prepareLoadData:YES];
    }];
    
    _tableView.header = header;
    _tableView.footer = footer;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[HeadTableViewCell class] forCellReuseIdentifier:@"headCell"];
    
    [self.view addSubview:_tableView];
    
    [self createHeader];
}

- (void)createHeader {
    _tableView.tableHeaderView = nil;
    
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthFromFrame(self.view.frame), 200)];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, widthFromFrame(self.view.frame), 200)];
    _scrollView.tag = 1000;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = YES;
    
    [_view addSubview:_scrollView];
    
    _labelHeader1 = [[UILabel alloc] initWithFrame:CGRectMake(widthFromFrame(_view.frame) - 45, heightFromFrame(_view.frame) - 55, 15, 15)];
    _labelHeader1.font = [UIFont boldSystemFontOfSize:15];
    _labelHeader1.text = @"1";
    _labelHeader1.textColor = [UIColor redColor];
    
    _labelHeader2 = [[UILabel alloc] initWithFrame:CGRectMake(widthFromFrame(_view.frame) - 33, heightFromFrame(_view.frame) - 50, 12, 12)];
    _labelHeader2.text = @"/x";
    _labelHeader2.font = [UIFont boldSystemFontOfSize:11];
    _labelHeader2.textColor = [UIColor whiteColor];
    
    [_view addSubview:_labelHeader1];
    [_view addSubview:_labelHeader2];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, heightFromFrame(_view.frame), widthFromFrame(_view.frame), 1)];
    label.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    label.layer.borderWidth = 1;
    [_view addSubview:label];
    
    _headTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 170, widthFromFrame(_view.frame), 30)];
    _headTitleLabel.textAlignment = NSTextAlignmentLeft;
    _headTitleLabel.font = [UIFont systemFontOfSize:15];
    _headTitleLabel.textColor = [UIColor blackColor];
    [_view addSubview:_headTitleLabel];
    
    _tableView.tableHeaderView = _view;
    
    [_tableView.header beginRefreshing];
    [self createTimer];
}

- (void)initHeader {
    
    for (int i = 0; i < _imgViewAry.count; i ++) {
        [_imgViewAry[i] removeFromSuperview];
    }
    [_imgViewAry removeAllObjects];
    
    _labelHeader1.text = @"1";
    _labelHeader2.text = [NSString stringWithFormat:@"/%ld", (unsigned long)_picAry.count];
    [MBProgressHUD showHUDAddedTo:_view animated:YES];
    for (int i = 0; i < _picAry.count + 2; i ++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * screenWidth(), 0, screenWidth(), 170)];
        if (i == _picAry.count + 1) {
            imgView.tag = 5000;
        }
        HeaderPicModel *model = nil;
        if (i == 0) {
            model = _picAry.lastObject;
        } else if (i == _picAry.count + 1) {
            model = _picAry.firstObject;
        } else {
            model = _picAry[i - 1];
        }
        [imgView sd_setImageWithURL:[NSURL URLWithString:model.jsonContent.img_url]placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (imgView.tag == 5000) {
                [MBProgressHUD hideHUDForView:_view animated:YES];
                _timer.fireDate = [NSDate distantPast];
            }
        }];
        imgView.userInteractionEnabled = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * screenWidth(), 0, screenWidth(), heightFromFrame(_scrollView.frame));
        btn.tag = 1500 + i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
        [_scrollView addSubview:imgView];
        [_scrollView addSubview:btn];
        [_imgViewAry addObject:imgView];
    }
    
    _scrollView.contentSize = CGSizeMake((_picAry.count + 2) * screenWidth(), 160);
    _scrollView.contentOffset = CGPointMake(screenWidth(), 0);
}

// 头部滚动 scrollView 点击事件
- (void)buttonClick:(UIButton *)button {
    NSLog(@"%ld", (long)button.tag); // 1501 ~ 1504
    
    ContentClickViewController *contentViewController = [ContentClickViewController new];
    contentViewController.caseId = [NSString stringWithFormat:@"%ld", (long)[[_picAry[button.tag - 1501] jsonContent] caseId]];
    contentViewController.title = [[_picAry[button.tag - 1501] jsonContent] title];
    contentViewController.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:contentViewController animated:YES];
    
}

- (void)prepareLoadData:(BOOL)isMore {
    NSInteger pageIndex = 1;
    if (isMore) {
        if (_dataAry.count % 10 == 0) {
            pageIndex = _dataAry.count / 10 + 1;
        } else {
            [_tableView.footer endRefreshing];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message:@"没有更多"
                                  delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
    } else {
        [self loadHeaderDataWithUrl:kScrollHeaderUrl];
    }
    
    NSString *url = [NSString stringWithFormat:self.requestUrl, pageIndex];
    
    [self loadDataWithUrl:url isMore:isMore];
}

- (void)loadHeaderDataWithUrl:(NSString *)url {
    NSData *data = [JWCache objectForKey:MD5Hash(url)];
    
    if (data && _isCache) {
        NSArray *ary = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] objectForKey:@"data"];
        [_picAry removeAllObjects];
        
        for (NSDictionary *dic in ary) {
            HeaderPicModel *model = [[HeaderPicModel alloc] initWithDictionary:dic error:nil];
            [_picAry addObject:model];
        }
        
        // 刷新表
        [self initHeader];
    } else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *ary = [[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] objectForKey:@"data"];
            [_picAry removeAllObjects];
            for (NSDictionary *dic in ary) {
                HeaderPicModel *model = [[HeaderPicModel alloc] initWithDictionary:dic error:nil];
                [_picAry addObject:model];
                
            }
            
            [self initHeader];
            // 添加到缓存
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [JWCache setObject:responseObject forKey:MD5Hash(url)];
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", [error description]);
        
        }];
    }
}

- (void)loadDataWithUrl:(NSString *)url isMore:(BOOL)isMore {
    
    // 添加刷新指示
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    NSData *data = [JWCache objectForKey:MD5Hash(url)];
    
    if (data && _isCache) {
        NSArray *ary = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] objectForKey:@"data"];
        if (!isMore) {
            [_dataAry removeAllObjects];
        }
        
        for (NSDictionary *dic in ary) {
            HeaderModel *model = [[HeaderModel alloc] initWithDictionary:dic error:nil];
            [_dataAry addObject:model];
            
        }
        
        // 刷新表
        [_tableView reloadData];
        // 停止刷新指示
        isMore ? [_tableView.footer endRefreshing] : [_tableView.header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *ary = [[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] objectForKey:@"data"];
            if (!isMore) {
                [_dataAry removeAllObjects];
            }
            
            for (NSDictionary *dic in ary) {
                HeaderModel *model = [[HeaderModel alloc] initWithDictionary:dic error:nil];
                [_dataAry addObject:model];
                
            }
            
            // 添加到缓存
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [JWCache setObject:responseObject forKey:MD5Hash(url)];
            });
            
            // 刷新表
            [_tableView reloadData];
            // 停止刷新指示
            isMore ? [_tableView.footer endRefreshing] : [_tableView.header endRefreshing];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", [error description]);
            isMore ? [_tableView.footer endRefreshing] : [_tableView.header endRefreshing];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    
}


#pragma mark -
#pragma mark tableView 协议
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataAry[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 216;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataAry.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ContentClickViewController *contentViewController = [ContentClickViewController new];
    contentViewController.caseId = [NSString stringWithFormat:@"%ld", (long)[[_dataAry[indexPath.row] jsonContent] caseId]];
    contentViewController.hidesBottomBarWhenPushed = YES;
    
    contentViewController.title = [[_dataAry[indexPath.row] jsonContent] title];
    [self.navigationController pushViewController:contentViewController animated:YES];
    
}


#pragma mark -
#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 1000) {
        NSInteger index = scrollView.contentOffset.x / screenWidth() + 0.5;
        
        if (scrollView.contentOffset.x <= 0) {
            [scrollView setContentOffset:CGPointMake((_picAry.count) * screenWidth(), 0) animated:NO];
        } else if (scrollView.contentOffset.x >= (_picAry.count + 1) * screenWidth()) {
            [scrollView setContentOffset:CGPointMake(screenWidth(), 0) animated:NO];
        }
        if (index > _picAry.count) {
            _labelHeader1.text = [NSString stringWithFormat:@"%ld", 1l];
            _headTitleLabel.text = [[_picAry[0] jsonContent] title];
        } else if (index < 1) {
            _labelHeader1.text = [NSString stringWithFormat:@"%ld", (unsigned long)_picAry.count];
            _headTitleLabel.text = [[_picAry[_picAry.count - 3] jsonContent] title];
        } else {
            _labelHeader1.text = [NSString stringWithFormat:@"%ld", (long)index];
            _headTitleLabel.text = [[_picAry[index - 1] jsonContent] title];
        }
    }
    
    
    /**
     *  检测滚动方向
     */
    int currentPostion = scrollView.contentOffset.y;
    
    if (currentPostion - _lastPosition > 20  && currentPostion > 0) {        //这个地方加上 currentPostion > 0 即可）
        
        _lastPosition = currentPostion;
        
        //NSLog(@"ScrollUp now");
        
        [UIView animateWithDuration:0.5 animations:^{
            self.tabBarController.tabBar.frame = CGRectMake(0, screenHeight(), screenWidth(), 44);
            self.navigationController.navigationBar.frame = CGRectMake(0, -44, screenWidth(), 44);
            _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        
    }
    
    else if ((_lastPosition - currentPostion > 20) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height - 20)) {
        _lastPosition = currentPostion;
        
        //NSLog(@"ScrollDown now");
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
//        self.tabBarController.tabBar.hidden = NO;
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsCompact];
        [UIView animateWithDuration:0.5 animations:^{
            self.tabBarController.tabBar.frame = CGRectMake(0, screenHeight() - 44, screenWidth(), 44);
//            self.navigationController.navigationBar.frame = CGRectMake(0, 20, screenWidth(), 44);
        } completion:^(BOOL finished) {
            
        }];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
