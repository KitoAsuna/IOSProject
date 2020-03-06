//
//  foodAddingViewController.h
//  FOSAapp1.0
//
//  Created by hs on 2020/3/4.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface foodAddingViewController : UIViewController

//导航栏
@property (nonatomic,strong) UIButton *likeBtn,*helpBtn;
//头部视图
@property (nonatomic,strong) UIView *headerView;//头部底层视图
@property (nonatomic,strong) UIScrollView *picturePlayer;//图片轮播器
@property (nonatomic,strong) UIPageControl *pageControl;    //轮播指示器
//@property (nonatomic,strong) UILabel *foodNameLabel;//食物名称
@property (nonatomic,strong) UIView *storageView,*expireView;
@property (nonatomic,strong) UIButton *storageIcon,*expireIcon;
@property (nonatomic,strong) UILabel *storageLabel,*storageDateLabel,*storageTimeLabel;
@property (nonatomic,strong) UILabel *expireLabel,*expireDateLabel,*expireTimeLabel;

//内容视图
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIView *foodNameView,*foodDescribedView,*locationView;
@property (nonatomic,strong) UILabel *foodNameLabel,*foodDescribedLabel,*locationLabel;
@property (nonatomic,strong) UITextField *foodTextView,*locationTextView;
@property (nonatomic,strong) UITextView *foodDescribedTextView;
@property (nonatomic,strong) UIButton *scanBtn;

//底部视图
@property (nonatomic,strong) UIView *footerView;
@property (nonatomic,strong) UICollectionView *categoryCollection;
@property (nonatomic,strong) UIButton *leftIndex,*rightIndex;

@property (nonatomic,strong) UIButton *doneBtn;

@end

NS_ASSUME_NONNULL_END
