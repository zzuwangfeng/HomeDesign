//
//  SubDetailTableViewCell.h
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/14.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubDetailModel.h"

@interface SubDetailPicTableViewCell : UITableViewCell

@property (nonatomic, strong) SubDetailModel *model;

@property (nonatomic, strong) UIImageView *imgView;

@end
