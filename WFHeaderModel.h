//
//  WFHeaderModel.h
//  HDLoveHomeAndLife
//
//  Created by JackWong on 16/1/4.
//  Copyright © 2016年 韩志远. All rights reserved.
//

#import "JSONModel.h"

@interface WFHeaderModel : JSONModel

@property (nonatomic, copy) NSString <Optional>*case_desc;
@property (nonatomic, copy) NSString <Optional>*case_id;
@property (nonatomic, copy) NSString <Optional>*case_image_url;
@property (nonatomic, copy) NSString <Optional>*case_title;
@property (nonatomic, copy) NSString <Optional>*designer_id;
@property (nonatomic, copy) NSString <Optional>*designer_image_url;
@property (nonatomic, copy) NSString <Optional>*designer_nick_name;
@property (nonatomic, copy) NSString <Optional>*designer_real_name;
@property (nonatomic, copy) NSString <Optional>*image_id;
@property (nonatomic, copy) NSString <Optional>*like;


@end
