//
//  FavoriteModel.h
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/16.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "HDModel.h"

@interface FavoriteModel : HDModel

@property (nonatomic, copy) NSString *favorityId;
@property (nonatomic, copy) NSString *album_type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *recordType;

@end
