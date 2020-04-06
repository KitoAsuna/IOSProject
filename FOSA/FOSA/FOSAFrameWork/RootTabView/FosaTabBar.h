//
//  FosaTabBar.h
//  FOSA
//
//  Created by hs on 2020/4/3.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FosaTabBar;

@protocol fosaTabBarDelegate <NSObject>
-(void)ButtonClick:(FosaTabBar *)tabBar;
@end

@interface FosaTabBar : UITabBar

@property (nonatomic,weak) UIButton *addFoodItemBtn;
@property (nonatomic,weak) id<fosaTabBarDelegate> tabBarDelegate;
@end


NS_ASSUME_NONNULL_END
