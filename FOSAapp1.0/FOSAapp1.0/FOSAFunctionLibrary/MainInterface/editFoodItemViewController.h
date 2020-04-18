//
//  editFoodItemViewController.h
//  FOSAapp1.0
//
//  Created by hs on 2020/4/16.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface editFoodItemViewController : UIViewController

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *doneBtn,*resetBtn;
@property (nonatomic,strong) UITextField *categoryNameTextView;
@property (nonatomic,strong) UICollectionView *categoryIconView;
@property (nonatomic,strong) UISearchBar *iconSearchBar;
@property (copy,nonatomic) NSString *selectCategory,*selectCategoryIcon;
@property (nonatomic,copy) void(^categoryBlock)(BOOL reload);
@end

NS_ASSUME_NONNULL_END
