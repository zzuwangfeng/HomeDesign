//
//  PicsTableViewCell.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/7.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "PicsTableViewCell.h"
#import "UIView+Common.h"
#import <UIImageView+WebCache.h>


@interface PicsTableViewCell () {
    UIImageView *_imgView;
}

@end

@implementation PicsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}


- (void)createCell {
    _imgView = [UIImageView new];
    [self.contentView addSubview:_imgView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imgView.frame = CGRectMake(10, 0, screenWidth() - 20, heightFromFrame(self.frame) - 15);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
