//
//  selClickModel.h
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/10.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "JSONModel.h"

@protocol selClickDataModel
@end
@interface selClickDataModel : JSONModel
@property (nonatomic, assign) NSInteger caseId;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) NSInteger picId;
@property (nonatomic, copy) NSString *picUrl;
@end


@interface selClickModel : JSONModel
@property (nonatomic, strong) NSMutableArray<Optional, selClickDataModel> *data;
@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageTotal;
@end
