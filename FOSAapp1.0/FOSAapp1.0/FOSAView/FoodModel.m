//
//  FoodModel.m
//  FOSAapp1.0
//
//  Created by hs on 2019/12/30.
//  Copyright © 2019 hs. All rights reserved.
//

#import "FoodModel.h"
@implementation FoodModel



//add food
+ (instancetype)modelWithName:(NSString *) food_name DeviceID:(NSString *)device Description:(NSString *)aboutFood StrogeDate:(NSString *)storageDate ExpireDate:(NSString *)expireDate remindDate:(NSString *)remindDate foodIcon:(NSString *)foodPhoto category:(NSString *)category Location:(NSString *)location repeatWay:(NSString *)repeat{
    return [[self alloc]initWithName:(NSString *) food_name DeviceID:(NSString *)device Description:(NSString *)aboutFood StrogeDate:(NSString *)storageDate ExpireDate:(NSString *)expireDate remindDate:(NSString *)remindDate foodIcon:(NSString *)foodPhoto category:(NSString *)category Location:location repeatWay:repeat];
}
- (instancetype)initWithName:(NSString *) food_name DeviceID:(NSString *)device Description:(NSString *)aboutFood StrogeDate:(NSString *)storageDate ExpireDate:(NSString *)expireDate remindDate:(NSString *)remindDate foodIcon:(NSString *)foodPhoto category:(NSString *)category Location:(NSString *)location repeatWay:(NSString *)repeat{
    self = [super init];
    if(self){
        self.foodName       = food_name;
        self.aboutFood      = aboutFood;
        self.expireDate     = expireDate;
        self.storageDate    = storageDate;
        self.remindDate     = remindDate;
        self.device         = device;
        self.foodPhoto      = foodPhoto;
        self.category       = category;
        self.location       = location;
        self.repeat         = repeat;
        return self;
    }else{
        return nil;
    }
    
}

+ (instancetype)modelWithName:(NSString *) food_name DeviceID:(NSString *)device Description:(NSString *)aboutFood StrogeDate:(NSString *)storageDate ExpireDate:(NSString *)expireDate remindDate:(NSString *)remindDate foodIcon:(NSString *)foodPhoto category:(NSString *)category Location:(NSString *)location repeatWay:(NSString *)repeat send:(nonnull NSString *)isSend{
    return [[self alloc]initWithName:(NSString *) food_name DeviceID:(NSString *)device Description:(NSString *)aboutFood StrogeDate:(NSString *)storageDate ExpireDate:(NSString *)expireDate remindDate:(NSString *)remindDate foodIcon:(NSString *)foodPhoto category:(NSString *)category Location:location repeatWay:repeat send:isSend];
}
- (instancetype)initWithName:(NSString *) food_name DeviceID:(NSString *)device Description:(NSString *)aboutFood StrogeDate:(NSString *)storageDate ExpireDate:(NSString *)expireDate remindDate:(NSString *)remindDate foodIcon:(NSString *)foodPhoto category:(NSString *)category Location:(NSString *)location repeatWay:(NSString *)repeat send:(nonnull NSString *)isSend{
    self = [super init];
    if(self){
        self.foodName       = food_name;
        self.aboutFood      = aboutFood;
        self.expireDate     = expireDate;
        self.storageDate    = storageDate;
        self.remindDate     = remindDate;
        self.device         = device;
        self.foodPhoto      = foodPhoto;
        self.category       = category;
        self.location       = location;
        self.repeat         = repeat;
        self.isSend         = isSend;
        return self;
    }else{
        return nil;
    }
    
}

@end
