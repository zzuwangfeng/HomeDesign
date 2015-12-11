//
//  NSString+Tools.h
//  HDNOName
//
//  Created by qianfeng01 on 15/9/24.
//  Copyright (c) 2015年 hanzhiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tools)

/**
 *  MD5 验证
 *
 *  @param aString
 *
 *  @return MD5编码
 */
NSString * MD5Hash(NSString *aString);

/**
 *  URL 中文编码
 *
 *  @param str
 *
 *  @return URL 中文编码
 */
NSString * URLEncodedString(NSString *str);

@end
