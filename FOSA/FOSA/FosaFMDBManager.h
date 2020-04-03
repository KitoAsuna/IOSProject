//
//  FosaFMDBManager.h
//  FOSA
//
//  Created by hs on 2020/4/3.
//  Copyright © 2020 hs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "FoodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FosaFMDBManager : NSObject

+(instancetype) initFMDBMaanagerWithdbName:(NSString *)dbName;
-(instancetype) initFMdatabaseWithName:(NSString *)dbName;

- (BOOL)insertDataWithTableName:(NSString *)tableName sql:(NSString *)insertSql;
- (NSMutableArray *)selectDataWithTableName:(NSString *)tableName sql:(NSString *)selectSql;
- (BOOL)deleteDataWithTableName:(NSString *)tableName sql:(NSString *)deleteSql;

@end

NS_ASSUME_NONNULL_END
