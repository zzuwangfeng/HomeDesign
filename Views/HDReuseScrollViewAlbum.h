//
//  HDReuseScrollViewAlbum.h
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/10.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDReuseScrollViewAlbum : UIView

@property (nonatomic, strong) NSArray *aryData;
@property (nonatomic, assign) NSInteger selIndex;

- (void)setAryData:(NSArray *)aryData andIndex:(NSInteger)index;
- (void)alphaTipLabel;

@end
