//
//  SubDetailViewController.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/13.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "SubDetailViewController.h"
#import "HDDefine.h"
#import "SubDetailModel.h"
#import "SubDetailPicTableViewCell.h"
#import "UIView+Common.h"
#import <UIImageView+WebCache.h>
#import "HDHelper.h"
#import "SubDetailTextTableViewCell.h"
#import "CategoryClickViewController.h"
#import <SDImageCache.h>
#import "FavoriteModel.h"
#import "UMSocial.h"

@interface SubDetailViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_aryData;
    NSArray *_tags;
    UITableView *_tableView;
    NSMutableDictionary *_dicPics;
    NSMutableDictionary *_refreCellDic;
    UILabel *_titleLabel;
    UILabel *_separateLabel;
}

@end

@implementation SubDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addItemWithName:nil target:self action:@selector(leftBtnAction:) isLeft:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initAllObjs];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)initAllObjs {
    _aryData = [NSMutableArray array];
    _tags = [NSArray array];
    _dicPics = [NSMutableDictionary dictionary];
    _refreCellDic = [NSMutableDictionary dictionary];
    [self createTableView];
    [self initData];
}

- (void)leftBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:kSubClickUrl, _albumId, _album_type];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *ary = dict[@"data"];
        _tags = dict[@"tags"];
        int i = 0;
        for (NSDictionary *dic in ary) {
            SubDetailModel *model = [[SubDetailModel alloc] initWithDictionary:dic[@"block"] error:nil];
            if ([model.block_type isEqualToString:@"3"] ||[model.block_type isEqualToString:@"4"]) {
                [_aryData addObject:model];
                [_dicPics setValue:@(200) forKey:[NSString stringWithFormat:@"%d", i]];
                i ++;
            }
        }
        [self initHeaderView];
        [_tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error description]);
    }];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight() - 64) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self createHeaderView];
    _tableView.tableFooterView = [self createFooterView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delaysContentTouches = NO;
    
    [_tableView registerClass:[SubDetailPicTableViewCell class] forCellReuseIdentifier:@"mySubDetailPicCell"];
    [_tableView registerClass:[SubDetailTextTableViewCell class] forCellReuseIdentifier:@"mySubDetailTextCell"];
    
    [self.view addSubview:_tableView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(screenWidth() - 50, screenHeight() - 100 - 64, 40, 40);
    [btn setImage:[UIImage imageNamed:@"shareto"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = [UIColor colorWithRed:122/255.0 green:186/255.0 blue:58/255.0 alpha:1];
    btn.alpha = 0.7;
    [btn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(screenWidth() - 50, screenHeight() - 50 - 64, 40, 40);
    [btn2 setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"stared"] forState:UIControlStateSelected];
    btn2.layer.cornerRadius = 5;
    btn2.backgroundColor = [UIColor colorWithRed:122/255.0 green:186/255.0 blue:58/255.0 alpha:1];
    btn2.alpha = 0.7;
    [btn2 addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    if ([[DBManager sharedManager] isExistAppForAppId:_albumId recordType:@"subject"]) {
        btn2.selected = YES;
    }
}

- (void)startAction:(UIButton *)button {
    if (button.selected) {
        [button setSelected:NO];
        [[DBManager sharedManager] deleteValueWithFavorityId:_albumId];
    } else {
        [button setSelected:YES];
        FavoriteModel *model = [FavoriteModel new];
        model.favorityId = _albumId;
        model.album_type = _album_type;
        model.title = self.title;
        [[DBManager sharedManager] insertModel:model recordType:@"subject"];
    }
}

- (void)shareBtnAction:(UIButton *)button {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5620dc8c67e58ee2450007fe"
                                      shareText:self.title
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
                                       delegate:nil];
}

- (UIView *)createHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), 50)];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, screenWidth() - 20, 50 - 6)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.numberOfLines = 0;
    [view addSubview:_titleLabel];
    
    _separateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, screenWidth(), 1)];
    _separateLabel.backgroundColor = [UIColor greenColor];
    
    [view addSubview:_separateLabel];

    return view;
}

- (UIView *)createFooterView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), 120)];
    view.backgroundColor = [UIColor whiteColor];
    
    
    return view;
}

- (void)initHeaderView {
    _titleLabel.text = self.title;
    
    UIView *view = _tableView.tableFooterView;
//    view.frame = CGRectMake(0, 0, screenWidth(), 40 * [self maxRows:_tags.count]);
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, screenWidth(), 1)];
    label.backgroundColor = [UIColor greenColor];
    [view addSubview:label];
    
    UILabel *labelTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 200, 30)];
    labelTip.text = @"点击标签加载更多:";
    labelTip.font = [UIFont systemFontOfSize:14];
    [view addSubview:labelTip];

    
    CGFloat btnWidth = (screenWidth() - 50) / 4;
    CGFloat btnSpace = 10;
    
    for (int i = 0; i < _tags.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 6;
        btn.layer.borderColor = [[UIColor blackColor] CGColor];
        btn.layer.borderWidth = 1;
        btn.backgroundColor = [UIColor colorWithRed:122/255.0 green:186/255.0 blue:58/255.0 alpha:1];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitle:_tags[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:_tags[i] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake((i % 4) * (btnWidth + btnSpace) + btnSpace, (i / 4) * (btnSpace + 30) + btnSpace + 25, btnWidth, 30);
        [view addSubview:btn];
    }
}

// 标签点击跳转
- (void)buttonClick:(UIButton *)button {
    NSLog(@"%@", button.titleLabel.text);
    
    CategoryClickViewController *cateView = [CategoryClickViewController new];
    cateView.myTitle = button.titleLabel.text;
    cateView.categoryType = kSubjectType;
    cateView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cateView animated:YES];
}

- (NSInteger)maxRows:(NSInteger)count {
    int chushu = (int)count / 4;
    int yushu = count % 4;
    if (yushu > 0) {
        return chushu + 1;
    } else {
        return chushu;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubDetailModel *modal = _aryData[indexPath.row];
    if ([modal.block_type isEqualToString:@"3"]) {
        SubDetailPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mySubDetailPicCell" forIndexPath:indexPath];
        NSString *strUrl = [_aryData[indexPath.row] article];
        if ([[_aryData[indexPath.row] block_type] isEqualToString:@"3"]) {
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[strUrl substringToIndex:strUrl.length - 1]] placeholderImage:[UIImage imageNamed:@"sub"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
//                if (!error) {
//                    [_dicPics setValue:@(image.size.height * (screenWidth() - 20) / image.size.width) forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
//                    
//                    // 保证只刷新一次，在循环滚动的时候
//                    if (![_refreCellDic objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]]) {
//                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                    }
//                    [_refreCellDic setValue:@"place" forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
//                }
            }];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if ([modal.block_type isEqualToString:@"4"]) {
        SubDetailTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mySubDetailTextCell" forIndexPath:indexPath];
        cell.model = _aryData[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        
        return [UITableViewCell new];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubDetailModel *modal = _aryData[indexPath.row];
    if ([modal.block_type isEqualToString:@"3"]) {
//        CGFloat rowHeight;
//        
//        CGFloat rowHeightDefault = [[_dicPics objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] floatValue];
//        
//        if ([_dicPics objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] && rowHeightDefault / 1 > 0) {
//            
//            rowHeight = [[_dicPics objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] floatValue];
//            return rowHeight;
//        }
        
//        rowHeight = 150;
        return 300;
    } else if ([modal.block_type isEqualToString:@"4"]) {
        if ([modal.article isEqualToString:@""]) {
            return [HDHelper textHeightFromTextString:[_aryData[indexPath.row] title] width:screenWidth() - 20 fontSize:14];
        } else {
            return [HDHelper textHeightFromTextString:[_aryData[indexPath.row] article] width:screenWidth() - 20 fontSize:14];
        }
        
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _aryData.count;
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
