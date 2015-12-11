//
//  CategoryViewController.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/4.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "CategoryViewController.h"
#import "UIView+Common.h"
#import "XLPlainFlowLayout.h"
#import "HeaderCollectionReusableView.h"
#import "CategoryClickViewController.h"
#import "NSString+Tools.h"


@interface CategoryViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSArray *_catagoryDataAry;
    NSArray *_aryHeadTitle;
}

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置title
    [self addTitleViewWithName:@"分类"];
    [self setupLeftMenuButton];
    [self createCollectionView];
    [self getData];
}

- (void)getData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"categoryData" ofType:@"plist"];
    _catagoryDataAry = [[NSArray alloc] initWithContentsOfFile:path];
    
    _aryHeadTitle = @[@" 推荐", @" 风格", @" 空间"];
    
    [_collectionView reloadData];
}

- (void)createCollectionView {
    // 创建视图布局对象
    XLPlainFlowLayout *layOut = [[XLPlainFlowLayout alloc] init];
    // 设置左右之间的间隙(当间隙小于某一个值(需要),不起作用)
    layOut.minimumInteritemSpacing = 0;
    
    layOut.naviHeight = 0;
    // 设置的上下之间的间隙
    layOut.minimumLineSpacing = 0;
    
    // 指定它滚动的方向
    layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight() - 64) collectionViewLayout:layOut];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    // 测试背景颜色
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
    //注册 collectionView 头部和尾部
    [_collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    
    [self.view addSubview:_collectionView];
}

#pragma make - CollectionView 协议方法

// 返回collectionView 视图的头部的CGSize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(screenWidth(), 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

// 返回collectionView头部或尾部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //获取collectionView 的头部
        HeaderCollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];

        head.textLabel.font = [UIFont boldSystemFontOfSize:19];
        head.textLabel.textColor = [UIColor blackColor];
        head.textLabel.text = _aryHeadTitle[indexPath.section];
        
        head.backgroundColor = [UIColor colorWithRed:248/255.0 green:250/255.0 blue:213/255.0 alpha:1];
        
        return head;
    }
    
    return nil;
}

// 设置视图距边界的距离 UIEdgeInsets (通过代理设置)会覆盖掉前边设置的
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 60, 10);
}
// 返回 Item 的 size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((screenWidth() - 20) / 3, (screenWidth() - 20) / 3 + 30);
}

// 点击响应
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CategoryClickViewController *subView = [CategoryClickViewController new];
    subView.myTitle = _catagoryDataAry[indexPath.section][indexPath.row][@"title"];
    subView.categoryType = kSubjectType;
    subView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:subView animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _catagoryDataAry.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_catagoryDataAry[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    UIView *view = [[UIView alloc] initWithFrame:cell.frame];
    
    // 创建 imgView
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, widthFromFrame(view.frame) - 30, widthFromFrame(view.frame) - 30)];
    //(widthFromFrame(view.frame) - 30) / 2
    imgView.layer.cornerRadius = 7;
    imgView.layer.masksToBounds = YES;
    imgView.userInteractionEnabled = YES;
    imgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    imgView.layer.borderWidth = 1;
    
    [view addSubview:imgView];
    
    // 创建 title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(minX(imgView), maxY(imgView) + 8, widthFromFrame(imgView.frame), 24)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [view addSubview:label];
    
    // 获取图片路径
    NSString *strImg = [_catagoryDataAry[indexPath.section] objectAtIndex:indexPath.row][@"iconName"];
    NSArray *aryName = [strImg componentsSeparatedByString:@"."];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:aryName[0] ofType:aryName[1]];
    imgView.image = [UIImage imageWithContentsOfFile:path];
    
    label.text = [_catagoryDataAry[indexPath.section] objectAtIndex:indexPath.row][@"title"];
    
    cell.backgroundView = view;
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /**
     *  检测滚动方向
     */
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
//        //        [[UIApplication sharedApplication] setStatusBarHidden:YES];
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        
//    }
//    
//    else if ((_lastPosition - currentPostion > 20) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height - 20)) {
//        _lastPosition = currentPostion;
//        
//        //NSLog(@"ScrollDown now");
//        //        [[UIApplication sharedApplication] setStatusBarHidden:NO];
//        //        self.tabBarController.tabBar.hidden = NO;
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            self.tabBarController.tabBar.frame = CGRectMake(0, screenHeight() - 44, screenWidth(), 44);
//        }];
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
