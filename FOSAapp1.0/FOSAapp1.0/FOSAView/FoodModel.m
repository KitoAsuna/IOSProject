//
//  FoodModel.m
//  FOSAapp1.0
//
//  Created by hs on 2019/12/30.
//  Copyright © 2019 hs. All rights reserved.
//

#import "FoodModel.h"
@implementation FoodModel


///**SealerTableViewCell*/
//+ (instancetype)modelWithName:(NSString *)food_name expireDate:(NSString *)expireDate storageDate:(NSString *)storageDate fdevice:(NSString *)device photoPath:(NSString *)foodPhoto{
//    return [[self alloc]initWithName:food_name expireDate:expireDate storageDate:storageDate fdevice:device photoPath:foodPhoto];
//}
//- (instancetype)initWithName:(NSString *)food_name expireDate:(NSString *)expireDate storageDate:(NSString *)storageDate fdevice:(NSString *)device photoPath:(NSString *)foodPhoto{
//    if(self == [super init]){
//        self.foodName = food_name;
//        self.expireDate = expireDate;
//        self.storageDate = storageDate;
//        self.device = device;
//        self.foodPhoto = foodPhoto;
//    }
//    return self;
//}

//add food
+ (instancetype)modelWithName:(NSString *) food_name DeviceID:(NSString *)device Description:(NSString *)aboutFood StrogeDate:(NSString *)storageDate ExpireDate:(NSString *)expireDate  foodIcon:(NSString *)foodPhoto category:(NSString *)category Location:(NSString *)location{
    return [[self alloc]initWithName:(NSString *) food_name DeviceID:(NSString *)device Description:(NSString *)aboutFood StrogeDate:(NSString *)storageDate ExpireDate:(NSString *)expireDate  foodIcon:(NSString *)foodPhoto category:(NSString *)category Location:location];
}
- (instancetype)initWithName:(NSString *) food_name DeviceID:(NSString *)device Description:(NSString *)aboutFood StrogeDate:(NSString *)storageDate ExpireDate:(NSString *)expireDate  foodIcon:(NSString *)foodPhoto category:(NSString *)category Location:(NSString *)location{
    self = [super init];
    if(self){
        self.foodName       = food_name;
        self.aboutFood      = aboutFood;
        self.expireDate     = expireDate;
        self.storageDate    = storageDate;
        self.device         = device;
        self.foodPhoto      = foodPhoto;
        self.category       = category;
        self.location       = location;
        return self;
    }else{
        return nil;
    }
    
}

////show info
//+ (instancetype)modelWithName:(NSString *)food_name DeviceID:(NSString *)device RemindDate:(NSString *)remindDate ExpireDate:(NSString *)expireDate{
//    return [[self alloc]initWithName:food_name DeviceID:device RemindDate:remindDate ExpireDate:expireDate];
//}
//- (instancetype)initWithName:(NSString *)food_name DeviceID:(NSString *)device RemindDate:(NSString *)remindDate ExpireDate:(NSString *)expireDate{
//    if(self == [super init]){
//        self.foodName = food_name;
//        self.expireDate = expireDate;
//        self.remindDate = remindDate;
//        self.device = device;
//
//    }
//    return self;
//}

@end
