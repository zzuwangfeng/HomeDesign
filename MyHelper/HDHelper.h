//
//  HDHelper.h
//  HDNOName
//
//  Created by qianfeng01 on 15/9/23.
//  Copyright (c) 2015年 hanzhiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface HDHelper : NSObject

+ (NSString *)dateToNowFromString:(NSString *)timeString dateFormatter:(NSDateFormatter *)dateFormatter;

+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;

@end


