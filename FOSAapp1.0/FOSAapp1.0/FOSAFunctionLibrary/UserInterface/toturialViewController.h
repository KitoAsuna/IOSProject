//
//  toturialViewController.h
//  FOSAapp1.0
//
//  Created by hs on 2020/3/9.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface toturialViewController : UIViewController
/**教学图片轮播*/
@property (nonatomic,strong) UIScrollView *toturialPicturePlayer;
@property (nonatomic,strong) UIPageControl *toturialPageControl;
@property (nonatomic,strong) UIButton *skipBtn,*closeBtn;
@end

NS_ASSUME_NONNULL_END
