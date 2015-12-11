//
//  SubDetailTableViewCell.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/14.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "SubDetailPicTableViewCell.h"
#import "UIView+Common.h"
#import <UIImageView+WebCache.h>

@implementation SubDetailPicTableViewCell

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
    _imgView.frame = CGRectMake(10, 7, screenWidth() - 20, self.frame.size.height - 14);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
