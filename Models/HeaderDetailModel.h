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
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, assign) NSInteger image_id;
@property (nonatomic, assign) NSInteger like;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *url;
@end


@interface HeaderDetailUserModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *headImg;
@property (nonatomic, copy) NSString<Optional> *nickName;
@end


@interface HeaderDetailModel : JSONModel
@property (nonatomic, strong)HeaderDetailCaseModel<Optional>  *caseItem;
//@property (nonatomic, assign) NSInteger readCount;
@property (nonatomic, strong) NSArray<HeaderDetailPicsModel, Optional> *case_pics;
@property (nonatomic, copy) NSString<Optional> *shareUrl;
@property (nonatomic, copy) NSString<Optional> *case_desc;
@property (nonatomic, copy) NSString<Optional> *case_id;
@property (nonatomic, copy) NSString<Optional> *case_image_url;
@property (nonatomic, copy) NSString<Optional> *case_title;
@property (nonatomic, copy) NSString<Optional> *comment_num;
@property (nonatomic, copy) NSString<Optional> *date;
@property (nonatomic, copy) NSString<Optional> *designer_id;
@property (nonatomic, copy) NSString<Optional> *designer_image_url;
@property (nonatomic, copy) NSString<Optional> *designer_nick_name;
@property (nonatomic, copy) NSString<Optional> *designer_real_name;
@property (nonatomic, copy) NSString<Optional> *image_id;
@property (nonatomic, copy) NSString<Optional> *like;
//@property (nonatomic, strong) HeaderDetailUserModel<Optional> *user;
@end
