//
//  SubDetailModel.h
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/13.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "JSONModel.h"

@interface SubDetailModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *albumId;
@property (nonatomic, copy) NSString<Optional> *block;
@property (nonatomic, copy) NSString<Optional> *block_type;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *article;

@end
