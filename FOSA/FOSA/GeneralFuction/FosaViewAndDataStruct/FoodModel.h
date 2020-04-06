//
//  FoodModel.h
//  FOSA
//
//  Created by hs on 2020/4/3.
//  Copyright © 2020 hs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FoodModel : NSObject
@property (nonatomic,copy) NSString *foodName,*aboutFood,*foodPhoto
,*remindDate,*device,*expireDate
,*storageDate,*calorie,*weight,*location,*category,*islike;

+ (instancetype)modelWithName:(NSString *) food_name DeviceID:(NSString *)device Description:(NSString *)aboutFood StrogeDate:(NSString *)storageDate ExpireDate:(NSString *)expireDate  foodIcon:(NSString *)foodPhoto category:(NSString *)category Location:(NSString *)location;
- (instancetype)initWithName:(NSString *) food_name DeviceID:(NSString *)device Description:(NSString *)aboutFood StrogeDate:(NSString *)storageDate ExpireDate:(NSString *)expireDate  foodIcon:(NSString *)foodPhoto category:(NSString *)category Location:(NSString *)location;

@end

NS_ASSUME_NONNULL_END
