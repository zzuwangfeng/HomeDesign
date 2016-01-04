//
//  ContentClickViewController.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/7.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "ContentClickViewController.h"
#import "PicsTableViewCell.h"
#import "TextTableViewCell.h"
#import "HDHelper.h"
#import "HeaderDetailModel.h"
#import "UIView+Common.h"
#import "HDDefine.h"
#import <UIImageView+WebCache.h>
#import "SelectionModel.h"
#import "ViewControllerScrollView.h"
#import "DBManager.h"
#import "FavoriteModel.h"
#import "UMSocial.h"

@interface ContentClickViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    HeaderDetailModel *_model;
    NSMutableDictionary *_dicPics;
    NSMutableDictionary *_refreCellDic;
    NSMutableArray *_ary;
}

@end

@implementation ContentClickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addItemWithName:nil target:self action:@selector(leftBtnClick:) isLeft:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTableView];
    [self initAllValues];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)initAllValues {
    _dicPics = [NSMutableDictionary dictionary];
    _refreCellDic = [NSMutableDictionary dictionary];
    _ary = [NSMutableArray array];
    [self initData];
}


- (void)initData {
    NSString *path = [NSString stringWithFormat:kHeadClickUrl, _caseId];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] objectForKey:@"data"];
        _model = [[HeaderDetailModel alloc] initWithDictionary:dic error:nil];
        
        for (int i = 0; i < _model.case_pics.count; i ++) {
            [_dicPics setValue:@(200) forKey:[NSString stringWithFormat:@"%d", i]];
        }
        
        
//        for (HeaderDetailPicsModel *pic in _model.pics) {
//            SelectionModel *model = [SelectionModel new];
//            model.case_image_url = pic.imgUrl;
//            [_ary addObject:model];
//        }
        
        
        [_tableView reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error description]);
    }];
}

- (void)leftBtnClick:(UIBarButtonItem *)leftBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight() - 64) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[TextTableViewCell class] forCellReuseIdentifier:@"myCellText"];
    
    [_tableView registerClass:[PicsTableViewCell class] forCellReuseIdentifier:@"myCell3"];
    
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
    
    if ([[DBManager sharedManager] isExistAppForAppId:_caseId recordType:@"header"]) {
        btn2.selected = YES;
    }
    
}

- (void)startAction:(UIButton *)button {
    if (button.selected) {
        [button setSelected:NO];
        [[DBManager sharedManager] deleteValueWithFavorityId:_caseId];
    } else {
        [button setSelected:YES];
        FavoriteModel *model = [FavoriteModel new];
        model.favorityId = _caseId;
        model.title = self.title;
        [[DBManager sharedManager] insertModel:model recordType:@"header"];
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
    

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCellText" forIndexPath:indexPath];

//        [cell setCaseModelAndUserModel:_model.caseItem userModel:_model.user readCount:_model.readCount];
        cell.model = _model;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        PicsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell3" forIndexPath:indexPath];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[_model.case_pics[indexPath.row - 1] url]] placeholderImage:[UIImage imageNamed:@"ZM_First_Page_Other_Defaut"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
//            if (!error) {
//                [_dicPics setValue:@(image.size.height * (screenWidth() - 20) / image.size.width) forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
//                
//                // 保证只刷新一次，在循环滚动的时候
//                if (![_refreCellDic objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]]) {
//                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                }
//                [_refreCellDic setValue:@"place" forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
//            }
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", (long)indexPath.row);
//    if (indexPath.row > 0) {
//        
//        ViewControllerScrollView * reuse = [ViewControllerScrollView new];
//        reuse.aryData = _ary;
//        reuse.selIndex = indexPath.row - 1;
//        reuse.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [self presentViewController:reuse animated:YES completion:^{
//            
//        }];
//    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 136 + [HDHelper textHeightFromTextString:_model.caseItem.desc width:screenWidth() - 20 fontSize:14];
    }
    else {
        CGFloat rowHeight;
        
        CGFloat rowHeightDefault = [[_dicPics objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] floatValue];
        
        if ([_dicPics objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] && rowHeightDefault / 1 > 0) {
            
            rowHeight = [[_dicPics objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] floatValue];
            return rowHeight;
        }
        
        return 250;
    }
    return 0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_model || _dicPics) {
        return _model.case_pics.count + 1;//
    }
    return 0;
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
