//
//  SubDetailTextTableViewCell.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/14.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "SubDetailTextTableViewCell.h"
#import "UIView+Common.h"

@interface SubDetailTextTableViewCell () {
    
    UILabel *_label;
    
}

@end

@implementation SubDetailTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)createCell {
    _label = [UILabel new];
    _label.numberOfLines = 0;
    _label.font = [UIFont boldSystemFontOfSize:14];
    _label.textColor = [UIColor colorWithRed:44/255.0 green:44/255.0 blue:44/255.0 alpha:1];
    [self.contentView addSubview:_label];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    _label.frame = CGRectMake(10, 7, screenWidth() - 20, self.frame.size.height - 14);
}

- (void)setModel:(SubDetailModel *)model {
    _model = model;
    [self reloadData];
}

- (void)reloadData {
    if ([_model.article isEqualToString:@""]) {
        _label.text = _model.title;
    } else {
        _label.text = _model.article;
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
