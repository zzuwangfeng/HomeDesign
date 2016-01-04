//
//  HeaderDetailModel.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/7.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "HeaderDetailModel.h"

@implementation HeaderDetailCaseModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"desc"}];
}
@end

@implementation HeaderDetailPicsModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"sortId", @"description": @"desc"}];
}

@end

@implementation HeaderDetailUserModel

@end

@implementation HeaderDetailModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"case":@"caseItem", @"count.readCount":@"readCount"}];
}

@end
