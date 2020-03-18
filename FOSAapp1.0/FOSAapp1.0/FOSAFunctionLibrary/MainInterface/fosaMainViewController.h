//
//  fosaMainViewController.h
//  FOSAapp1.0
//
//  Created by hs on 2020/3/6.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "foodModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface fosaMainViewController : UIViewController
@property (nonatomic,strong) UIButton *navigationRemindBtn,*sortbtn,*scanBtn,*cancelBtn;

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIScrollView *mainBackgroundImgPlayer;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIView *categoryView;
@property (nonatomic,strong) UIButton *leftBtn,*rightBtn;
@property (nonatomic,strong) UICollectionView *categoryCollection;
@property (nonatomic,strong) NSMutableArray<NSString *> *categoryNameArray;
@property (nonatomic,strong) NSMutableArray<NSString *> *cellDic;
@property (nonatomic,strong) NSMutableDictionary *cellDictionary;
@property (nonatomic,strong) NSMutableDictionary *categoryCellDictionary;
@property (nonatomic,strong) UIView *foodItemView;
@property (nonatomic,strong) UICollectionView *fooditemCollection;

@property (strong,nonatomic) NSMutableArray<NSString *> *categoryDataSource;
@property (strong,nonatomic) NSMutableArray<FoodModel *> *collectionDataSource;


@end

NS_ASSUME_NONNULL_END
