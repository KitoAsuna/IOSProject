//
//  FoodModel.m
//  FOSA
//
//  Created by hs on 2020/4/3.
//  Copyright © 2020 hs. All rights reserved.
//

#import "FoodModel.h"

@implementation FoodModel
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
@end
