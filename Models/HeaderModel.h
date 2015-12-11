//
//  HeaderModel.h
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/5.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "JSONModel.h"

@protocol ContentModel
@end
@interface ContentModel : JSONModel
@property (nonatomic, assign) NSInteger caseId;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, assign) NSInteger img_id;
@property (nonatomic, copy) NSString<Optional> *img_title;
@property (nonatomic, assign) NSInteger img_total;
@property (nonatomic, copy) NSString<Optional> *img_url;
@property (nonatomic, assign) BOOL isCase;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *url;
@end


@interface HeaderModel : JSONModel
@property (nonatomic, assign) NSUInteger createTime;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) ContentModel<Optional> *jsonContent;
@property (nonatomic, assign) NSInteger recommend;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, assign) NSUInteger updateTime;
@end

