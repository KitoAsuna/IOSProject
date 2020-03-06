//
//  fosaMainViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/3/6.
//  Copyright © 2020 hs. All rights reserved.
//

#import "fosaMainViewController.h"

@interface fosaMainViewController ()<UIScrollViewDelegate>

@end

@implementation fosaMainViewController

#pragma mark - 延时加载
- (UIButton *)navigationRemindBtn{
    if (_navigationRemindBtn == nil) {
        _navigationRemindBtn = [[UIButton alloc]init];
    }
    return _navigationRemindBtn;
}
- (UIButton *)sortbtn{
    if (_sortbtn == nil) {
        _sortbtn = [[UIButton alloc]init];
    }
    return _sortbtn;
}
- (UIButton *)scanBtn{
    if (_scanBtn == nil) {
        _scanBtn = [UIButton new];
    }
    return _scanBtn;
}

- (UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [UIView new];
    }
    return _headerView;
}
- (UIScrollView *)mainBackgroundImgPlayer{
    if (_mainBackgroundImgPlayer == nil) {
        _mainBackgroundImgPlayer = [UIScrollView new];
    }
    return _mainBackgroundImgPlayer;
}
- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [UIPageControl new];
    }
    return _pageControl;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    // Do any additional setup after loading the view.
    [self creatNavigationButton];
    [self creatMainBackgroundPlayer];
}

- (void)creatNavigationButton{
    self.navigationRemindBtn.frame = CGRectMake(0, 0, NavigationBarH, NavigationBarH);
    [self.navigationRemindBtn setImage:[UIImage imageNamed:@"icon_sendNotification"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.navigationRemindBtn];
    
    self.sortbtn.frame = CGRectMake(screen_width*2/3, 0,NavigationBarH, NavigationBarH);
    [self.sortbtn setImage:[UIImage imageNamed:@"icon_pullDown"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:self.sortbtn];
    
    self.scanBtn.frame = CGRectMake(0, 0, NavigationBarH, NavigationBarH);
    [self.scanBtn setImage:[UIImage imageNamed:@"icon_scan"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.scanBtn];
    
}

- (void)creatMainBackgroundPlayer{
    self.headerView.frame = CGRectMake(0, NavigationHeight, screen_width, screen_width/3);
    [self.view addSubview:self.headerView];
    self.headerView.backgroundColor = FOSAgreen;
    
    //背景轮播
    int headerWidth  = self.headerView.frame.size.width;
    int headerHeight = self.headerView.frame.size.height;
    self.mainBackgroundImgPlayer.frame = CGRectMake(0, 0, headerWidth, headerHeight);
    self.mainBackgroundImgPlayer.pagingEnabled = YES;
    self.mainBackgroundImgPlayer.delegate = self;
    self.mainBackgroundImgPlayer.showsHorizontalScrollIndicator = NO;
    self.mainBackgroundImgPlayer.showsVerticalScrollIndicator = NO;
    self.mainBackgroundImgPlayer.alwaysBounceVertical = NO;
        // 解决UIscrollerView在导航栏透明的情况下往下偏移的问题
    self.mainBackgroundImgPlayer.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    self.mainBackgroundImgPlayer.bounces = NO;
    self.mainBackgroundImgPlayer.contentSize = CGSizeMake(headerWidth*3, 0);
    for (NSInteger i = 0; i < 3; i++) {
            CGRect frame = CGRectMake(i*headerWidth, 0, headerWidth, self.headerView.frame.size.height);
            UIImageView *image = [[UIImageView alloc]initWithFrame:frame];
            image.userInteractionEnabled = YES;
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
        //NSString *imgName = [NSString stringWithFormat:@"%@%ld",@"picturePlayer",i+1];
            image.image = [UIImage imageNamed:@"img_maiBackground"];
            [self.mainBackgroundImgPlayer addSubview:image];
        }
           [self.headerView addSubview:self.mainBackgroundImgPlayer];
            //轮播页面指示器
           self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(headerWidth*2/5, headerHeight-30, headerWidth/5, 20)];
           self.pageControl.currentPage = 0;
           self.pageControl.numberOfPages = 3;
           self.pageControl.pageIndicatorTintColor = FOSAFoodBackgroundColor;
           self.pageControl.currentPageIndicatorTintColor = FOSAgreen;
           [self.headerView addSubview:self.pageControl];
    
}
#pragma mark -- UIScrollerView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger index = offset/self.headerView.frame.size.width;
    self.pageControl.currentPage = index;
}

@end
