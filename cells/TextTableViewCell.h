//
//  TextTableViewCell.h
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/7.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderDetailModel.h"

@interface TextTableViewCell : UITableViewCell {
    @protected
    HeaderDetailCaseModel *_caseModel;
    HeaderDetailUserModel *_userModel;
    NSInteger _readCount;
}

@property (nonatomic, strong) HeaderDetailCaseModel *caseModel;
@property (nonatomic, strong) HeaderDetailUserModel *userModel;
@property (nonatomic, assign) NSInteger readCount;

@property (nonatomic, strong) HeaderDetailModel *model;
-(void) setCaseModelAndUserModel:(HeaderDetailCaseModel *)caseModel userModel:(HeaderDetailUserModel *)userModel readCount:(NSInteger)readCount;

@end
