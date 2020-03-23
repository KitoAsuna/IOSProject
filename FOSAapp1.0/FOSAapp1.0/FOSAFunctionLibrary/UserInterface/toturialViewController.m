//
//  toturialViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/3/9.
//  Copyright © 2020 hs. All rights reserved.
//

#import "toturialViewController.h"

@interface toturialViewController ()<UIScrollViewDelegate>

@end

@implementation toturialViewController

- (UIScrollView *)toturialPicturePlayer{
    if (_toturialPicturePlayer == nil) {
        _toturialPicturePlayer = [UIScrollView new];
    }
    return _toturialPicturePlayer;
}
- (UIPageControl *)toturialPageControl{
    if (_toturialPageControl == nil) {
        _toturialPageControl = [UIPageControl new];
    }
    return _toturialPageControl;
}
- (UIButton *)skipBtn{
    if (_skipBtn == nil) {
        _skipBtn = [UIButton new];
    }
    return _skipBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.skipBtn.frame = CGRectMake(0, StatusBarH, screen_width/4, NavigationBarH);
    [self.skipBtn setTitle:@"Skip" forState:UIControlStateNormal];
    self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    [self.skipBtn addTarget:self action:@selector(skipTutorial) forControlEvents:UIControlEventTouchUpInside];
    
    self.toturialPicturePlayer.frame = CGRectMake(0, 0, screen_width, screen_height);
    self.toturialPicturePlayer.pagingEnabled = YES;
    self.toturialPicturePlayer.delegate = self;
    self.toturialPicturePlayer.showsHorizontalScrollIndicator = NO;
    self.toturialPicturePlayer.showsVerticalScrollIndicator = NO;
    self.toturialPicturePlayer.alwaysBounceVertical = NO;
            // 解决UIscrollerView在导航栏透明的情况下往下偏移的问题
    self.toturialPicturePlayer.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    self.toturialPicturePlayer.bounces = NO;
    self.toturialPicturePlayer.contentSize = CGSizeMake(screen_width*17, 0);
    for (NSInteger i = 0; i < 17; i++) {
        CGRect frame = CGRectMake(i*screen_width, 0, screen_width,screen_height);
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:frame];
        imageview.userInteractionEnabled = YES;
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        imageview.clipsToBounds = YES;
        NSString *imgName = [NSString stringWithFormat:@"%@%ld",@"img_tutorial",i+1];
        imageview.image = [UIImage imageNamed:imgName];
        [self.toturialPicturePlayer addSubview:imageview];
    }
    [self.view addSubview:self.toturialPicturePlayer];
    //轮播页面指示器
    self.toturialPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(screen_width*2/5, screen_height-30, screen_width/5, 20)];
    self.toturialPageControl.currentPage = 0;
    self.toturialPageControl.numberOfPages = 17;
    self.toturialPageControl.pageIndicatorTintColor = FOSAFoodBackgroundColor;
    self.toturialPageControl.currentPageIndicatorTintColor = FOSAgreen;
    [self.view addSubview:self.toturialPageControl];
    [self.view addSubview:self.skipBtn];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)skipTutorial{
    [self.toturialPicturePlayer removeFromSuperview];
    [self.toturialPageControl removeFromSuperview];
    [self.skipBtn removeFromSuperview];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UIScrollerView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger index = offset/screen_width;
    NSLog(@"%ld",(long)index);
    self.toturialPageControl.currentPage = index;
    if (index == 16) {
        self.skipBtn.hidden = YES;
        //添加close按钮，功能同skip
    }else{
        self.skipBtn.hidden = NO;
    }
}
@end
