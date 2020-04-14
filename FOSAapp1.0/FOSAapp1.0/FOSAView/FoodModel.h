//
//  FoodModel.h
//  FOSAapp1.0
//
//  Created by hs on 2019/12/30.
//  Copyright © 2019 hs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FoodModel : NSObject
@property (nonatomic,copy) NSString *foodName,*aboutFood,*foodPhoto
                                    ,*remindDate,*device,*expireDate
                                    ,*storageDate,*calorie,*weight,*location,*category,*repeat,*isSend;


//add food
+ (instancetype)modelWithName:(NSString *) food_name DeviceID:(NSString *)device Description:(NSString *)aboutFood StrogeDate:(NSString *)storageDate ExpireDate:(NSString *)expireDate remindDate:(NSString *)remindDate foodIcon:(NSString *)foodPhoto category:(NSString *)category Location:(NSString *)location repeatWay:(NSString *)repeat;
- (instancetype)initWithName:(NSString *) food_name DeviceID:(NSString *)device Description:(NSString *)aboutFood StrogeDate:(NSString *)storageDate ExpireDate:(NSString *)expireDate remindDate:(NSString *)remindDate foodIcon:(NSString *)foodPhoto category:(NSString *)category Location:(NSString *)location repeatWay:(NSString *)repeat;

+ (instancetype)modelWithName:(NSString *) food_name DeviceID:(NSString *)device Description:(NSString *)aboutFood StrogeDate:(NSString *)storageDate ExpireDate:(NSString *)expireDate remindDate:(NSString *)remindDate foodIcon:(NSString *)foodPhoto category:(NSString *)category Location:(NSString *)location repeatWay:(NSString *)repeat send:(NSString *)isSend;
- (instancetype)initWithName:(NSString *) food_name DeviceID:(NSString *)device Description:(NSString *)aboutFood StrogeDate:(NSString *)storageDate ExpireDate:(NSString *)expireDate remindDate:(NSString *)remindDate foodIcon:(NSString *)foodPhoto category:(NSString *)category Location:(NSString *)location repeatWay:(NSString *)repeat send:(NSString *)isSend;


@end

NS_ASSUME_NONNULL_END
