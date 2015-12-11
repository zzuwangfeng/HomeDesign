//
//  SelectionModel.h
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/6.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "HDModel.h"

@interface SelectionModel : HDModel

@property (nonatomic, assign) NSInteger case_id;
@property (nonatomic, assign) NSInteger image_id;
@property (nonatomic, copy) NSString *case_image_url;

@end
