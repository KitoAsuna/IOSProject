//
//  FosaFMDBManager.m
//  FOSA
//
//  Created by hs on 2020/4/3.
//  Copyright © 2020 hs. All rights reserved.
//

#import "FosaFMDBManager.h"
#import "categoryModel.h"


@interface FosaFMDBManager(){
    FMDatabase *db;
    NSString *docPath;
}
@end

@implementation FosaFMDBManager
+ (instancetype)initFMDBManagerWithdbName:(NSString *)dbName{
    return [[FosaFMDBManager alloc]initFMDBdatabaseWithName:dbName];
}

- (instancetype)initFMDBdatabaseWithName:(NSString *)dbName{
    //获取数据库地址
    docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
       NSLog(@"%@",docPath);
       //设置数据库名
       NSString *fileName = [docPath stringByAppendingPathComponent:dbName];
       //创建数据库
       db = [FMDatabase databaseWithPath:fileName];
       if([db open]){
           NSLog(@"打开数据库成功");
       }else{
           NSLog(@"打开数据库失败");
       }
    return self;
}

- (BOOL)creatTableWithSql:(nonnull NSString *)tableSql{
    return [db executeUpdate:tableSql];
}
- (BOOL)isFmdbOpen{
    return [db open];
}

- (BOOL)insertDataWithSql:(NSString *)insertSql{
    BOOL insertResult = [db executeUpdate:insertSql];
    return insertResult;
}

- (BOOL)updateDataWithSql:(NSString *)updateSql{
    return [db executeUpdate:updateSql];
}

- (NSMutableArray *)selectDataWithTableName:(NSString *)tableName sql:(NSString *)selectSql{
    NSMutableArray *resultArray = [NSMutableArray new];
    FMResultSet *set = [db executeQuery:selectSql];
    
    if ([tableName isEqualToString:@"FoodStorageInfo"]) {
        while ([set next]) {
            NSString *foodName    = [set stringForColumn:@"foodName"];
            NSString *device      = [set stringForColumn:@"device"];
            NSString *aboutFood   = [set stringForColumn:@"aboutFood"];
            NSString *storageDate = [set stringForColumn:@"storageDate"];
            NSString *expireDate  = [set stringForColumn:@"expireDate"];
            NSString *foodImg     = [set stringForColumn:@"foodImg"];
            NSString *category    = [set stringForColumn:@"category"];
            NSString *location    = [set stringForColumn:@"location"];
            NSString *remindDate  = [set stringForColumn:@"remindDate"];
            NSString *repeatWay   = [set stringForColumn:@"repeatWay"];
            NSString *send        = [set stringForColumn:@"send"];
            if (![remindDate isEqualToString:@""]) {
                if ([self adjustRemindDate:remindDate repeat:repeatWay]) {
                    FoodModel *model      = [FoodModel modelWithName:foodName DeviceID:device Description:aboutFood StrogeDate:storageDate ExpireDate:expireDate remindDate:remindDate foodIcon:foodImg category:category Location:location repeatWay:repeatWay send:send];
                    [resultArray addObject:model];
                }
            }
        }
    }else if([tableName isEqualToString:@"category"]){
        while ([set next]) {
            NSString *kind = [set stringForColumn:@"categoryName"];
            NSString *icon = [set stringForColumn:@"categoryIcon"];
            categoryModel *model = [categoryModel modelWithName:kind iconName:icon];
            [resultArray addObject:model];
        }
    }
    return resultArray;
}

- (NSMutableArray *)selectDataWithTableNameByReminder:(NSString *)tableName sql:(NSString *)selectSql{
    NSMutableArray *resultArray = [NSMutableArray new];
    FMResultSet *set = [db executeQuery:selectSql];
    while ([set next]) {
               NSString *foodName    = [set stringForColumn:@"foodName"];
               NSString *device      = [set stringForColumn:@"device"];
               NSString *aboutFood   = [set stringForColumn:@"aboutFood"];
               NSString *storageDate = [set stringForColumn:@"storageDate"];
               NSString *expireDate  = [set stringForColumn:@"expireDate"];
               NSString *foodImg     = [set stringForColumn:@"foodImg"];
               NSString *category    = [set stringForColumn:@"category"];
               NSString *location    = [set stringForColumn:@"location"];
               NSString *remindDate  = [set stringForColumn:@"remindDate"];
               NSString *repeatWay   = [set stringForColumn:@"repeatWay"];
               NSString *send        = [set stringForColumn:@"send"];
               if (![remindDate isEqualToString:@""] && [send isEqualToString:@"YES"]) {
                   if ([self adjustRemindDate:remindDate repeat:repeatWay]) {
                       FoodModel *model      = [FoodModel modelWithName:foodName DeviceID:device Description:aboutFood StrogeDate:storageDate ExpireDate:expireDate remindDate:remindDate foodIcon:foodImg category:category Location:location repeatWay:repeatWay send:send];
                       [resultArray addObject:model];
                   }
               }
           }
    return resultArray;
}

- (FoodModel *)selectModelWithSql:(NSString *)selectSql{
    FMResultSet *set = [db executeQuery:selectSql];
    FoodModel *model = [FoodModel new];
    if (set.columnCount == 0) {
        return model;
    }else{
        if([set next]) {
            NSString *foodName       = [set stringForColumn:@"foodName"];
            NSString *device        = [set stringForColumn:@"device"];
            NSString *aboutFood     = [set stringForColumn:@"aboutFood"];
            NSString *storageDate   = [set stringForColumn:@"storageDate"];
            NSString *expireDate    = [set stringForColumn:@"expireDate"];
            NSString *foodImg       = [set stringForColumn:@"foodImg"];
            NSString *location      = [set stringForColumn:@"location"];
            NSString *category      = [set stringForColumn:@"category"];
            NSString *remindDate    = [set stringForColumn:@"remindDate"];
            NSString *repeat        = [set stringForColumn:@"repeatWay"];
            model = [FoodModel modelWithName:foodName DeviceID:device Description:aboutFood StrogeDate:storageDate ExpireDate:expireDate remindDate:remindDate foodIcon:foodImg category:category Location:location repeatWay:repeat];
        }
    }
    return model;
}

- (BOOL)deleteDataWithSql:(NSString *)deleteSql{
    return [db executeUpdate:deleteSql];
}

- (BOOL)closeDB{
    return [db close];
}

- (BOOL)adjustRemindDate:(NSString *)remindDate repeat:(NSString *)repeatWay{
    /**
     如果提醒日期还过期则判断是否设置了重复通知，设置了则返回YES，否则返回NO,如果没有过期则返回YES
     */
    NSLog(@"%@",remindDate);
    NSArray *tempArray;
    NSString *tempStr;
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"dd MM/yyyy hh:mm"];
    //[format2 setDateFormat:@"dd/MM/yyyy/HH:mm"];
//    format.AMSymbol = @"AM";
//    format.PMSymbol = @"PM";
    tempArray = [remindDate componentsSeparatedByString:@","];
    tempStr = [NSString stringWithFormat:@"%@/%@ %@",tempArray[1],tempArray[2],tempArray[3]];
    NSDate *date = [format dateFromString:tempStr];
    NSDate *currentDate = [NSDate new];
    NSComparisonResult result = [currentDate compare:date];
    NSLog(@"remindDate:%@",date);
    if (result == NSOrderedAscending) {
        return  YES;
    }else{
        if (![repeatWay isEqualToString:@"Never"]) {
            return YES;
        }else{
            return NO;
        }
    }
}

@end
