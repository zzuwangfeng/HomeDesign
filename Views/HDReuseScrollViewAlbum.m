//
//  HDReuseScrollViewAlbum.m
//  HDLoveHomeAndLife
//
//  Created by qianfeng01 on 15/10/10.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "HDReuseScrollViewAlbum.h"
#import <UIImageView+WebCache.h>
#import "UIView+Common.h"
#import "HDScrollView.h"
#import "SelectionModel.h"

// ScollView 之间的间隙的一半
#define SCROLLVIEWINTERVAL 10


@interface HDReuseScrollViewAlbum () <UIScrollViewDelegate, UIAlertViewDelegate> {
    UIScrollView *_scrollView;
    HDScrollView *_leftScrollView;
    HDScrollView *_centerScrollView;
    HDScrollView *_rightScrollView;
    NSMutableArray *_scrollViewAry;
    UIActivityIndicatorView *_activityIndicator;
    NSInteger _previousPageIndex;
    NSInteger _currentPageIndex;
    BOOL _isLongPress;
    UILabel *_labelPageNo;
    UILabel *_labelPageCount;
    UILabel *_labelTip;
}

@end

@implementation HDReuseScrollViewAlbum


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self allOpration];
    }
    return self;
}

- (void)allOpration {
    // 设置最大的缓存数
//    [[SDImageCache sharedImageCache] setMaxMemoryCountLimit:5];
    [self createActivityIndicator];
    _isLongPress = NO;
    self.backgroundColor = [UIColor blackColor];
    _scrollViewAry = [NSMutableArray array];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    self.gestureRecognizers = @[longPress];
    
    [self createScrollView];
}

// 长按触发
- (void)longPressAction:(UIGestureRecognizer *)gesture {
    
    if (!_isLongPress) {
        _isLongPress = !_isLongPress;
//        NSLog(@"%@", _labelPageNo.text);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示：" message:@"是否保存到相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
        [alert show];
    }
    
}

#pragma make - alert代理协议
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSLog(@"%ld", buttonIndex);
    if (buttonIndex == 1) {
        NSString *url = [_aryData[[_labelPageNo.text integerValue] - 1] case_image_url];
        [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            // 保存照片到相册
            UIImageWriteToSavedPhotosAlbum(image  , self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }];
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        UIAlertView *aView = [[UIAlertView alloc] initWithTitle:@"保存成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [aView show];
    }
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
//- (void)alertViewCancel:(UIAlertView *)alertView;

//- (void)willPresentAlertView:(UIAlertView *)alertView;  // before animation and showing view
//- (void)didPresentAlertView:(UIAlertView *)alertView;  // after animation
//
//- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    _isLongPress = NO;
}

- (void)createScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-10, 0, screenWidth() + 20, screenHeight())];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, screenWidth() - 80, screenWidth(), 40)];
    view.center = CGPointMake(self.center.x, screenHeight() - 60);
    
    [self addSubview:view];
    
    _labelPageNo = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth() / 2 - 110, 0, 100, 40)];
    _labelPageNo.textAlignment = NSTextAlignmentRight;
    _labelPageNo.font = [UIFont systemFontOfSize:20];
    
    _labelPageNo.textColor = [UIColor whiteColor];
    [view addSubview:_labelPageNo];
    
    _labelPageCount = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth() / 2 - 10, 0, 100, 40)];
    _labelPageCount.textAlignment = NSTextAlignmentLeft;
    _labelPageCount.font = [UIFont systemFontOfSize:20];
    _labelPageCount.textColor = [UIColor whiteColor];
    
    [view addSubview:_labelPageCount];
    
    _labelTip = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 200, 30)];
    _labelTip.text = @"Tip:长按保存照片:";
    _labelTip.textColor = [UIColor whiteColor];
    //    labelTip.backgroundColor = [UIColor whiteColor];
    _labelTip.font = [UIFont systemFontOfSize:18];
    [self addSubview:_labelTip];
    
    [self performSelector:@selector(alphaTipLabel) withObject:nil afterDelay:3.5];
    
}

- (void)alphaTipLabel {
//    [UIView animateWithDuration:10 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        _labelTip.alpha = 0;
//    } completion:^(BOOL finished) {
//        
//    }];
    
    [UIView animateWithDuration:1 animations:^{
        _labelTip.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setAryData:(NSArray *)aryData andIndex:(NSInteger)index{
    _aryData = aryData;
    _selIndex = index;
    _labelPageNo.text = [NSString stringWithFormat:@"%ld", (long)_selIndex + 1];
    _labelPageCount.text = [NSString stringWithFormat:@" / %ld", (long)_aryData.count];
    _scrollView.contentSize = CGSizeMake((_aryData.count + 0) * (2 * SCROLLVIEWINTERVAL + screenWidth()), self.frame.size.height);
    [self createImgView];
}

#pragma make - 创建imgView
- (void)createImgView {
    for (int i = 0; i < 3; i ++) {
        HDScrollView *scrollView = [[HDScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight() - 200)];
        scrollView.center = CGPointMake(screenWidth()/2 + SCROLLVIEWINTERVAL + (i + _selIndex - 1) * (screenWidth() + SCROLLVIEWINTERVAL * 2), midY(self));
        [_scrollView addSubview:scrollView];
        [_scrollViewAry addObject:scrollView];
        if (_selIndex != 0 && _selIndex != _aryData.count - 1) {
            [self refrePhotoWithUrl:[_aryData[_selIndex - 1 + i] case_image_url] scrollView:scrollView];
        } else if(_selIndex == 0) {
            if (i != 0) {
                [self refrePhotoWithUrl:[_aryData[_selIndex - 1 + i] case_image_url] scrollView:scrollView];
            }
        } else if (_selIndex == _aryData.count - 1) {
            if (i != 2) {
                [self refrePhotoWithUrl:[_aryData[_selIndex - 1 + i] case_image_url] scrollView:scrollView];
            }
        }
    }
    _previousPageIndex = _selIndex;
    _scrollView.contentOffset = CGPointMake((_selIndex) * (screenWidth() + 2 * SCROLLVIEWINTERVAL), 0);
}

#pragma make - 创建菊花指示器
- (void)createActivityIndicator {
    _activityIndicator= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.center = self.center;
    [self addSubview:_activityIndicator];
}

- (void)refrePhotoWithUrl:(NSString *)url scrollView:(HDScrollView *)scrollView{
    [_activityIndicator startAnimating];
    [scrollView.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_activityIndicator stopAnimating];
    }];
}


#pragma make - scrollView 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int index = scrollView.contentOffset.x / (screenWidth() + 20) + 0.5;
    _labelPageNo.text = [NSString stringWithFormat:@"%d", index + 1];
    
    // 处理滑动翻页
    _currentPageIndex = scrollView.contentOffset.x / (screenWidth() + 2 * SCROLLVIEWINTERVAL) + 0.5;
    if (_currentPageIndex != _previousPageIndex) {
        if (_currentPageIndex > _previousPageIndex) {
            HDScrollView *scrollView = (HDScrollView *)_scrollViewAry[0];
            if (_currentPageIndex != 0 && _currentPageIndex != _aryData.count - 1) {
                [self refrePhotoWithUrl:[_aryData[_currentPageIndex + 1] case_image_url] scrollView:scrollView];
            }
            
            scrollView.center = CGPointMake(scrollView.center.x + 3 * (screenWidth() + 20), scrollView.center.y);
            
            [_scrollViewAry insertObject:scrollView atIndex:3];
            [_scrollViewAry removeObjectAtIndex:0];
        }else if (_currentPageIndex < _previousPageIndex) {
            HDScrollView *scrollView = (HDScrollView *)_scrollViewAry[2];
            if (_currentPageIndex != 0 && _currentPageIndex != _aryData.count - 1) {
                [self refrePhotoWithUrl:[_aryData[_currentPageIndex - 1] case_image_url] scrollView:scrollView];
            }
            
            scrollView.center = CGPointMake(scrollView.center.x - 3 * (screenWidth() + 20), scrollView.center.y);
            
            [_scrollViewAry insertObject:scrollView atIndex:0];
            [_scrollViewAry removeObjectAtIndex:3];
        }
        _previousPageIndex = _currentPageIndex;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (HDScrollView *scr in _scrollViewAry) {
        if (scr.zoomScale != 1.0) {
            scr.zoomScale = 1.0;
        };
    }

}



@end
