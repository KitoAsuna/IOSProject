//
//  foodAddingViewController.h
//  FOSAapp1.0
//
//  Created by hs on 2020/3/4.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "foodKindView.h"
#import "FoodModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface foodAddingViewController : UIViewController

//导航栏
@property (nonatomic,strong) UIButton *likeBtn,*helpBtn,*backbtn;
//头部视图
@property (nonatomic,strong) UIView *headerView;//头部底层视图
@property (nonatomic,strong) UIScrollView *picturePlayer;//图片轮播器
@property (nonatomic,strong) UIPageControl *pageControl;    //轮播指示器
@property (nonatomic,strong) NSMutableArray<UIImage *> *foodImgArray;
//@property (nonatomic,strong) UILabel *foodNameLabel;//食物名称
@property (nonatomic,strong) UIView *storageView,*expireView;
@property (nonatomic,strong) UIButton *storageIcon,*expireIcon;
@property (nonatomic,strong) UILabel *storageLabel,*storageDateLabel,*storageTimeLabel;
@property (nonatomic,strong) UILabel *expireLabel,*expireDateLabel,*expireTimeLabel;

//内容视图
@property (nonatomic,strong) UIScrollView *contentView;
@property (nonatomic,strong) UIView *foodNameView,*foodDescribedView,*locationView;
@property (nonatomic,strong) UILabel *foodNameLabel,*foodDescribedLabel,*locationLabel,*numberLabel;;
@property (nonatomic,strong) UITextField *foodTextView,*locationTextView;
@property (nonatomic,strong) UITextView *foodDescribedTextView;
@property (nonatomic,strong) UIButton *scanBtn;

//底部视图
@property (nonatomic,strong) UIView *footerView;
@property (nonatomic,strong) UICollectionView *categoryCollection;
@property (nonatomic,strong) NSMutableArray<NSString *> *cellDic;
@property(nonatomic,strong) NSMutableArray<NSString *> *categoryNameArray;
@property (nonatomic, strong) NSMutableDictionary *cellDictionary;
@property (nonatomic,strong) UIButton *leftIndex,*rightIndex;

@property (nonatomic,strong) UIButton *doneBtn;

/**展示食物信息部分*/
@property (nonatomic,strong) FoodModel *model;
@property (nonatomic,strong) NSString *foodStyle;//@"adding"表示添加模式，@"Info"表示展示模式
@property (nonatomic,strong) UILabel *showFoodNameLabel;
@property (nonatomic,strong) UIButton *editBtn,*shareBtn,*deleteBtn;
@property (nonatomic,strong) foodKindView *foodCell;
@property (nonatomic,strong) NSString *foodCategoryIconname;

/**教学图片轮播*/
@property (nonatomic,strong) UIScrollView *toturialPicturePlayer;
@property (nonatomic,strong) UIPageControl *toturialPageControl;
@property (nonatomic,strong) UIButton *skipBtn;
@end

NS_ASSUME_NONNULL_END
