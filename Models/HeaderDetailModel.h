//
//  HeaderDetailModel.h
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/7.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "JSONModel.h"

@interface HeaderDetailCaseModel : JSONModel
@property (nonatomic, assign) NSUInteger createTime;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, assign) NSUInteger updateTime;
@property (nonatomic, assign) NSInteger userId;
@end


@protocol HeaderDetailPicsModel
@end
@interface HeaderDetailPicsModel : JSONModel
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger imageId;
@property (nonatomic, copy) NSString<Optional> *imgUrl;
@property (nonatomic, assign) NSInteger sort;
@end


@interface HeaderDetailUserModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *headImg;
@property (nonatomic, copy) NSString<Optional> *nickName;
@end


@interface HeaderDetailModel : JSONModel
@property (nonatomic, strong)HeaderDetailCaseModel<Optional>  *caseItem;
@property (nonatomic, assign) NSInteger readCount;
@property (nonatomic, strong) NSArray<HeaderDetailPicsModel, Optional> *pics;
@property (nonatomic, copy) NSString<Optional> *shareUrl;
@property (nonatomic, strong) HeaderDetailUserModel<Optional> *user;
@end
