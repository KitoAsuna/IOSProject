//
//  foodItemCollectionViewCell.h
//  FOSAapp1.0
//
//  Created by hs on 2020/3/7.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FoodModel;
NS_ASSUME_NONNULL_BEGIN

@interface foodItemCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *foodImgView;
@property (nonatomic,strong) UILabel  *foodNamelabel,*mouthLabel,*dayLabel,*timelabel;
@property (nonatomic,strong) UIButton *likebtn;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) FoodModel *model;

@end

NS_ASSUME_NONNULL_END
