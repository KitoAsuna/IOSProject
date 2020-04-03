//
//  FosaFMDBManager.m
//  FOSA
//
//  Created by hs on 2020/4/3.
//  Copyright © 2020 hs. All rights reserved.
//

#import "FosaFMDBManager.h"



@interface FosaFMDBManager(){
    FMDatabase *db;
    NSString *docPath;
}
@end

@implementation FosaFMDBManager
+ (instancetype)initFMDBMaanagerWithdbName:(NSString *)dbName{
    return [[FosaFMDBManager alloc]initFMdatabaseWithName:dbName];
}

- (instancetype)initFMdatabaseWithName:(NSString *)dbName{
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

- (BOOL)insertDataWithTableName:(NSString *)tableName sql:(NSString *)insertSql{
    BOOL insertResult = [db executeUpdate:insertSql];
    return insertResult;
}

- (NSMutableArray *)selectDataWithTableName:(NSString *)tableName sql:(NSString *)selectSql{
    NSMutableArray *resultArray;
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
        FoodModel *model      = [FoodModel modelWithName:foodName DeviceID:device Description:aboutFood StrogeDate:storageDate ExpireDate:expireDate foodIcon:foodImg category:category Location:location];
        [resultArray addObject:model];
        
//        NSLog(@"*********************************************foodName    = %@",foodName);
//        NSLog(@"device      = %@",device);
//        NSLog(@"aboutFood   = %@",aboutFood);
//        NSLog(@"remindDate  = %@",storageDate);
//        NSLog(@"expireDate  = %@",expireDate);
//        NSLog(@"foodImg     = %@",foodImg);
//        NSLog(@"category    = %@",category);
    }
    return resultArray;
}


@end
