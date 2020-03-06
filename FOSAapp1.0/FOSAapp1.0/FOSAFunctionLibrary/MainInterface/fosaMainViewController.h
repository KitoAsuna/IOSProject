//
//  fosaMainViewController.h
//  FOSAapp1.0
//
//  Created by hs on 2020/3/6.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface fosaMainViewController : UIViewController
@property (nonatomic,strong) UIButton *navigationRemindBtn,*sortbtn,*scanBtn;

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIScrollView *mainBackgroundImgPlayer;
@property (nonatomic,strong) UIPageControl *pageControl;

@end

NS_ASSUME_NONNULL_END
