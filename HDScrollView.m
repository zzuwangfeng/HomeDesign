//
//  QYScrollView.m
//  AlbumDemo
//
//  Created by qingyun on 15-4-8.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "HDScrollView.h"
#import "UIView+Common.h"

@implementation HDScrollView {

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.tag = 1000;
        [self addSubview:_imageView];
        [self miscInit];
        [self addDoubleTapGesture];
    }
    return self;
}

- (void)miscInit
{
    self.delegate = self;
    
    // 缩放倍数设置
    self.minimumZoomScale = 0.5;
    self.maximumZoomScale = 2;
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO; 
    
}

- (void)addDoubleTapGesture
{
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImage:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
}

- (void)zoomImage:(UITapGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self];
    if (self.zoomScale != 1.0) {
        [self setZoomScale:1 animated:YES];
    } else {
        [self zoomToRect:CGRectMake(location.x-50, location.y-100, 100, 200) animated:YES];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
@end
