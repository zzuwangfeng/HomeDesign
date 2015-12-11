//
//  HeaderCollectionReusableView.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/7.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@implementation HeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createLabel];
    }
    return self;
}

- (void)createLabel {
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width - 20, self.frame.size.height)];
    
    [self addSubview:_textLabel];
}

@end
