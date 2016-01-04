//
//  HeadTableViewCell.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/5.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "HeadTableViewCell.h"
#import "UIView+Common.h"
#import <UIImageView+WebCache.h>
#import "HeaderModel.h"
#import "WFHeaderModel.h"
#define LeftWidth 10
#define TopHeight 15

@interface HeadTableViewCell () {
    UIView *_view;
    UIImageView *_imgView;
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    UILabel *_updateLabel;
}

@end

@implementation HeadTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)createCell {
    _view = [UIView new];
    _view.layer.cornerRadius = 5;
    _view.layer.borderWidth = 1;
    _view.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:1] CGColor];
    _view.layer.masksToBounds = YES;
    [self.contentView addSubview:_view];
    
    _imgView = [UIImageView new];
    _imgView.contentMode = UIViewContentModeRedraw;
    [_view addSubview:_imgView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor blackColor];
    [_view addSubview:_titleLabel];
    
    _contentLabel = [UILabel new];
    _contentLabel.numberOfLines = 2;
    _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _contentLabel.font = [UIFont boldSystemFontOfSize:13];
    _contentLabel.textColor = [UIColor grayColor];
    [_view addSubview:_contentLabel];
    
    _updateLabel = [UILabel new];
    _updateLabel.textAlignment = NSTextAlignmentRight;
    _updateLabel.font = [UIFont systemFontOfSize:15];
    _updateLabel.textColor = [UIColor blackColor];
    [_view addSubview:_updateLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _view.frame = CGRectMake(LeftWidth, TopHeight, screenWidth() - 2*LeftWidth, 200);
    
    _imgView.frame = CGRectMake(0, 0, widthFromFrame(_view.frame), 130);
    
    _titleLabel.frame = CGRectMake(10, maxY(_imgView) + 8, widthFromFrame(_view.frame) / 2, 15);
    
    _updateLabel.frame = CGRectMake(maxX(_titleLabel) + 20, minY(_titleLabel), widthFromFrame(_view.frame) / 2 - 20 - 20, 15);
    
    _contentLabel.frame = CGRectMake(minX(_titleLabel), maxY(_titleLabel) + 8, widthFromFrame(_view.frame) - 20, 33);
}

- (void)reloadData {
//    [_imgView sd_setImageWithURL:[NSURL URLWithString:_model.jsonContent.img_url] placeholderImage:[UIImage imageNamed:@"ZM_First_Page_Other_Defaut"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//    }];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_model.case_image_url] placeholderImage:[UIImage imageNamed:@"ZM_First_Page_Other_Defaut"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
//    _titleLabel.text = _model.jsonContent.title;
    _titleLabel.text = _model.case_title;
    
//    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:_model.updateTime];
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    df.dateFormat = @"yyyy-MM-dd";
//    _updateLabel.text = [df stringFromDate:date];
    _updateLabel.text = @"";
    
//    _contentLabel.text = _model.jsonContent.desc;
    _contentLabel.text = _model.case_desc;
}

- (void)setModel:(WFHeaderModel *)model {
    _model = model;
    [self reloadData];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
//





































//
