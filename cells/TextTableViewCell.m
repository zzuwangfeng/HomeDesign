//
//  TextTableViewCell.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/7.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "TextTableViewCell.h"
#import "UIView+Common.h"
#import <UIImageView+WebCache.h>

@interface TextTableViewCell () {
    UILabel *_titleLabel;
    UILabel *_nameLabel;
    UILabel *_readCountLabel;
    UIImageView *_imgViewIcon;
    UILabel *_dateLabel;
    UILabel *_separateLabel;
    UILabel *_descLabel;
}

@end

@implementation TextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)createCell {
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_titleLabel];
    
    _imgViewIcon = [UIImageView new];
    _imgViewIcon.layer.cornerRadius = 15;
    _imgViewIcon.layer.masksToBounds = YES;
    _imgViewIcon.layer.borderWidth = 2;
    _imgViewIcon.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.contentView addSubview:_imgViewIcon];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont boldSystemFontOfSize:12];
    _nameLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_nameLabel];
    
    _dateLabel = [UILabel new];
    _dateLabel.font = [UIFont boldSystemFontOfSize:12];
    _dateLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_dateLabel];
    
    _readCountLabel = [UILabel new];
    _readCountLabel.font = [UIFont boldSystemFontOfSize:12];
    _readCountLabel.textAlignment = NSTextAlignmentRight;
    _readCountLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_readCountLabel];
    
    _separateLabel = [UILabel new];
    _separateLabel.layer.borderColor = [[UIColor greenColor] CGColor];
    _separateLabel.layer.borderWidth = 1;
    [self.contentView addSubview:_separateLabel];
    
    _descLabel = [UILabel new];
    _descLabel.numberOfLines = 0;
    _descLabel.font = [UIFont boldSystemFontOfSize:14];
    _descLabel.textColor = [UIColor colorWithRed:44/255.0 green:44/255.0 blue:44/255.0 alpha:1];
    [self.contentView addSubview:_descLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(10, 10, screenWidth() - 20, 42);
    
    _imgViewIcon.frame = CGRectMake(10, maxY(_titleLabel) + 10, 30, 30);
    
    _nameLabel.frame = CGRectMake(maxX(_imgViewIcon) + 10, minY(_imgViewIcon), 100, 15);
    
    _dateLabel.frame = CGRectMake(minX(_nameLabel), maxY(_nameLabel), 100, 15);
    
     _readCountLabel.frame = CGRectMake(screenWidth() - 110, minY(_dateLabel), 100, 15);
    
    _separateLabel.frame = CGRectMake(0, maxY(_imgViewIcon) + 15, screenWidth(), 1);
    
    _descLabel.frame = CGRectMake(10, maxY(_separateLabel) + 15, screenWidth() - 20, heightFromFrame(self.frame) - 136);
}

-(void)setCaseModelAndUserModel:(HeaderDetailCaseModel *)caseModel userModel:(HeaderDetailUserModel *)userModel readCount:(NSInteger)readCount{
    _caseModel = caseModel;
    _userModel = userModel;
    _readCount = readCount;
    [self reloadData];
}
- (void)setModel:(HeaderDetailModel *)model {
    _model = model;
    [self reloadData];
}
- (void)reloadData {
    _titleLabel.text = _model.case_title;
    
    [_imgViewIcon sd_setImageWithURL:[NSURL URLWithString:_model.case_image_url]];
    
    _nameLabel.text = _model.designer_nick_name;
    
    _readCountLabel.text = [NSString stringWithFormat:@"点击%@次", _model.comment_num];
    
    
    _dateLabel.text = _model.date;
    
    NSMutableAttributedString *attributedString;
    if (_model.case_desc) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:_model.case_desc];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_caseModel.desc length])];
    _descLabel.attributedText = attributedString;
    [_descLabel sizeToFit];
    
    //    _descLabel.text = _caseModel.desc;
}

//- (void)reloadData {
//    _titleLabel.text = _caseModel.title;
//    
//    [_imgViewIcon sd_setImageWithURL:[NSURL URLWithString:_userModel.headImg]];
//    
//    _nameLabel.text = _userModel.nickName;
//    
//    _readCountLabel.text = [NSString stringWithFormat:@"点击%ld次", (long)_readCount];
//    
//    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:_caseModel.updateTime];
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    df.dateFormat = @"yyyy-MM-dd";
//    _dateLabel.text = [df stringFromDate:date];
//    
//    NSMutableAttributedString *attributedString;
//    if (_caseModel.desc) {
//        attributedString = [[NSMutableAttributedString alloc] initWithString:_caseModel.desc];
//    }
//    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:3];//调整行间距
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_caseModel.desc length])];
//    _descLabel.attributedText = attributedString;
//    [_descLabel sizeToFit];
//    
////    _descLabel.text = _caseModel.desc;
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
