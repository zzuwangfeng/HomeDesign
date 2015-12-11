//
//  AppListViewController.h
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/4.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "BaseViewController.h"
#import "HelpHeader.h"
#import "HDDefine.h"

@interface AppListViewController : BaseViewController {
    UICollectionView *_collectionView;
    NSMutableArray *_daraAry;
    BOOL _isCache;
    int _isOnce;
    NSInteger _categoryId;
    NSString *_selectionType;
    NSMutableArray *_aryPageCount;
    BOOL _isGeDiao;
}

@property (nonatomic, assign) BOOL isCache;
@property (nonatomic, assign) int isOnce;
@property (nonatomic, strong) NSMutableArray *aryPageCount;
@property (nonatomic, copy) NSString *selectionType;
@property (nonatomic, assign) BOOL isGeDiao;

@property (nonatomic, copy) NSString *categoryType;
@property (nonatomic, copy) NSString *requestUrl;

@property (nonatomic, copy) NSString *categoryUrl;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, copy) NSString *categoryTitle;
@property (nonatomic, strong) NSMutableArray *daraAry;

@property (nonatomic, strong) UICollectionView *collectionView;

- (void)createCollectionView;
-(void)setupLeftMenuButton;

@end
