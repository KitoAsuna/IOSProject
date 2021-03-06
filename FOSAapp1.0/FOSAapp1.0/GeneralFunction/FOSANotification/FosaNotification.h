//
//  FosaNotification.h
//  FOSAapp1.0
//
//  Created by hs on 2020/1/3.
//  Copyright © 2020 hs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
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
- (void)sendNotification:(FoodModel *)model body:(NSString *)body image:(UIImage *)img time:(long int)timeInterval;
- (void)sendNotification:(FoodModel *)model body:(NSString *)body image:(NSString *)img time:(long int)timeInterval identifier:(NSString *)identifier;
- (void)sendNotificationByDate:(FoodModel *)model body:(NSString *)body date:(NSString *)mdate foodImg:(NSString *)image identifier:(NSString *)identifier;
- (void)removeReminder:(UNNotificationResponse *)response;
- (UIImage *)GenerateQRCodeByMessage:(NSString *)message;
- (void)addNotificationAttachmentContent:(UNMutableNotificationContent *)content attachmentName:(NSString *)attachmentName  options:(NSDictionary *)options withCompletion:(void(^)(NSError * error , UNNotificationAttachment * notificationAtt))completion;
@end

NS_ASSUME_NONNULL_END
