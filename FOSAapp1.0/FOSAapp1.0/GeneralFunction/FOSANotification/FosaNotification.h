//
//  FosaNotification.h
//  FOSAapp1.0
//
//  Created by hs on 2020/1/3.
//  Copyright © 2020 hs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FoodModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol fosaDelegate <NSObject>

- (void)JumpByFoodName:(NSString *)foodname;

@end

@interface FosaNotification : NSObject
@property (weak,nonatomic) id <fosaDelegate> fosadelegate;
- (UIView *)CreatNotificatonView:(NSString *)title body:(NSString *)body;
- (UIImage *)SaveViewAsPicture:(UIView *)view;
- (void)initNotification;
- (void)sendNotification:(FoodModel *)model body:(NSString *)body image:(UIImage *)img;
- (void)sendNotificationByDate:(FoodModel *)model body:(NSString *)body date:(NSString *)mdate foodImg:image;
- (UIImage *)GenerateQRCodeByMessage:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
