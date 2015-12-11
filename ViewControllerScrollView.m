//
//  ViewControllerScrollView.m
//  HDPhotoAlbum
//
//  Created by qianfeng on 15/8/27.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "ViewControllerScrollView.h"
#import "HDDefine.h"
#import "JWCache.h"
#import "NSString+Tools.h"
#import "SelectionModel.h"
#import "HDReuseScrollViewAlbum.h"
#import "UIView+Common.h"

@interface ViewControllerScrollView () {
    

}

@end

@implementation ViewControllerScrollView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    [self creatScrollAlbum];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self createGesture];
}

- (void)creatScrollAlbum {
    HDReuseScrollViewAlbum *hdScrollView = [[HDReuseScrollViewAlbum alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight())];
    
    [hdScrollView setAryData:_aryData andIndex:_selIndex];
    [self.view addSubview:hdScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
/**
 * 添加手势
 */
- (void)createGesture {
    UITapGestureRecognizer *gestureOnce = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureChange:)];
    [self.view addGestureRecognizer:gestureOnce];
    
    UITapGestureRecognizer *gestureTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTwoAction:)];
    gestureTwo.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:gestureTwo];
    
    [gestureOnce requireGestureRecognizerToFail:gestureTwo];
}

- (void)gestureTwoAction:(UIGestureRecognizer *)gesture {
//    NSLog(@"two");
}

- (void)gestureChange:(UITapGestureRecognizer *)gesture {
    
//    NSLog(@"one");
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
