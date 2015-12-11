//
//  HDDefine.h
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/4.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#ifndef HDLoveHomeAndLife_HDDefine_h
#define HDLoveHomeAndLife_HDDefine_h

#import "MyControl.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import "DBManager.h"

//声明 三个 全局变量 (声明的是外部其他文件所定义的)
//extern 表示连接外部其他文件的全局变量

extern NSString * const kLZXFavorite;
extern NSString * const kLZXDownloads;
extern NSString * const kLZXBrowses;

/*
 界面类型
 */
#define kHeadType    @"head"
#define kSubjectType   @"subject"
#define kCategoryType     @"category"
#define kSelectionType      @"selection"


//首页接口,pageCount 从1开始, pageSize = 10
#define kHeadUrl @"http://focus_pinge_inf.sohusce.com/v1.1.0/fragment/getOrderListByStatus?type=3&access_token=7f4afb873d52bd1fd4f1c6849a8c0c68&pageNo=%ld"
// 首页点击接口
#define kHeadClickUrl @"http://focus_pinge_inf.sohusce.com/v1.1.0/cases/getCaseInfo?access_token=7f4afb873d52bd1fd4f1c6849a8c0c68&caseId=%@"
// 滚动首部接口
#define kScrollHeaderUrl @"http://focus_pinge_inf.sohusce.com/v1.1.0/fragment/getOrderListByStatus?type=7&pageSize=4&pageNo=1&access_token=7f4afb873d52bd1fd4f1c6849a8c0c68"
// 滚动首部点击接口
#define kScrollClickUrl @"http://focus_pinge_inf.sohusce.com/v1.1.0/cases/getCaseInfo?access_token=7f4afb873d52bd1fd4f1c6849a8c0c68&caseId=%@"


// 专题格调接口、 源24
#define kSubUrl @"http://rm.app.hongniujia.com/json_rm.php?action=list&ver=10&category=jiaju&category2=&pageSize=10&page=%ld"
// 专题格调点击接口
#define kSubClickUrl @"http://rm.app.hongniujia.com/json_rm.php?action=detail&albumId=%@&album_type=%@"

// 搜索接口
#define kSearchUrl @"http://rm.app.hongniujia.com/json_rm.php?action=list&ver=10&category=jiaju&pageSize=10&keyword=%@&page=%ld"


// 精选首页接口, page 从1开始
#define kSelectionUrl @"http://focus_pinge_inf.sohusce.com/v1.1.0/picture/category?access_token=7f4afb873d52bd1fd4f1c6849a8c0c68&tagId=3&pageSize=18&pageNo=%ld"
// 精选首页点击接口、一个参数
#define kSelectionClickUrl @"http://focus_pinge_inf.sohusce.com/v1.1.0/cases/getCaseInfo?access_token=7f4afb873d52bd1fd4f1c6849a8c0c68&caseId=%@"
//// 精选分类接口、两个参数、page 从1开始
//#define kSelectionCategoryUrl @"http://focus_pinge_inf.sohusce.com/v1.1.0/picture/category?access_token=7f4afb873d52bd1fd4f1c6849a8c0c68&tagId=3&pageSize=18&categoryId=%d&pageNo=%ld"
#define kSelectionCategoryNewUrl @"http://api.pinge.focus.cn/case/list?access_token=&app_id=31022&app_type=iOS&device_token=&os_version=7.1.2&push_token=wkqxqflslyvunvfc834un64vy8pbkdem&version=2.0.1&category=%@&category_id=%ld&page=%ld"

//
/*
 空间
 categoryId:   28–38阳光房，庭院661 — 665露台， 儿童房667 – 668
 风格
 categoryId:   现代59， 中式76， 新中式78 — 83, 地中海670 — 676
 局部
 categoryId:   85 — 93墙面， 门窗 680 — 682地面， 壁炉 684
 */


// 分类接口/源24
#define kCategoryUrl @"http://rm.app.hongniujia.com/json_rm.php?action=list&ver=10&page=0&category=jiaju&pageSize=10&keyword=%@"
// 分类点击接口
#define kCategoryClickUrl @"http://rm.app.hongniujia.com/json_rm.php?action=detail&albumId=%@&album_type=%@"


#endif




























