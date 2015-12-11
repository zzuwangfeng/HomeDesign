//
//  HDHelper.m
//  HDNOName
//
//  Created by qianfeng01 on 15/9/23.
//  Copyright (c) 2015年 hanzhiyuan. All rights reserved.
//

#import "HDHelper.h"

/**
 *  HDDateMethod
 */
@interface HDDateMethod : HDHelper

+ (NSTimeInterval)dateToNowFromString:(NSString *)timeString dateFormatter:(NSDateFormatter *)dateFormatter;

@end

@implementation HDDateMethod

/**
 *  获取距离当前时间 NSTimeInterval
 *
 *  @param timeString    时间字符串
 *  @param dateFormatter 时间格式
 *
 *  @return 距离当前时间 NSTimeInterval
 */
+ (NSTimeInterval)dateToNowFromString:(NSString *)timeString dateFormatter:(NSDateFormatter *)dateFormatter{
    NSDate *dateStamp = [dateFormatter dateFromString:timeString];
    return [dateStamp timeIntervalSinceNow];
}

@end



@implementation HDHelper

+(NSString *)dateToNowFromString:(NSString *)timeString dateFormatter:(NSDateFormatter *)dateFormatter {
    NSTimeInterval timeInterval = [HDDateMethod dateToNowFromString:timeString dateFormatter:dateFormatter];
    if (timeInterval <= 0) {
        return @"已经过期";
    } else {
        int hour = timeInterval / 3600;
        int minute = ((NSUInteger)timeInterval % 3600) / 60;
        int second = (NSUInteger)timeInterval %60;
        
        return [NSString stringWithFormat:@"%2d:%2d:%2d", hour, minute, second];
    }
}

+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size{
    if ([HDHelper getCurrentIOS] >= 7.0) {
        //iOS7之后
        /*
         第一个参数: 预设空间 宽度固定  高度预设 一个最大值
         第二个参数: 行间距 如果超出范围是否截断
         第三个参数: 属性字典 可以设置字体大小
         */
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
        CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        //返回计算出的行高
        return rect.size.height + rect.size.height / size * 3 + 10;
        
    }else {
        //iOS7之前
        /*
         1.第一个参数  设置的字体固定大小
         2.预设 宽度和高度 宽度是固定的 高度一般写成最大值
         3.换行模式 字符换行
         */
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:CGSizeMake(textWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        return textSize.height;//返回 计算出得行高
    }
}

+ (double)getCurrentIOS {
    return [[[UIDevice currentDevice] systemVersion] doubleValue];
}


@end
//





































//
