//
//  categoryCollectionViewCell.h
//  FOSAapp1.0
//
//  Created by hs on 2020/3/7.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface categoryCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UILabel *kind;
@property (nonatomic,strong) UIImageView *categoryPhoto;
@property (nonatomic,strong) UIView *rootView;
@property (nonatomic,strong) UIButton *badgeBtn,*editbtn;
@end

NS_ASSUME_NONNULL_END
