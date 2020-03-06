//
//  FOSATabbar.h
//  FOSAapp1.0
//
//  Created by hs on 2020/2/26.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FOSATabbar;

@protocol fosaTabBarDelegate <NSObject>
-(void)ButtonClick:(FOSATabbar *)tabBar;
@end

@interface FOSATabbar : UITabBar

@property (nonatomic,weak) UIButton *addFoodItemBtn;
@property (nonatomic,weak) id<fosaTabBarDelegate> tabBarDelegate;
@end

NS_ASSUME_NONNULL_END
