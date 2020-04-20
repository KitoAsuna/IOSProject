//
//  FosaFMDBManager.h
//  FOSA
//
//  Created by hs on 2020/4/3.
//  Copyright © 2020 hs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "FoodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FosaFMDBManager : NSObject

+(instancetype) initFMDBManagerWithdbName:(NSString *)dbName;
-(instancetype) initFMDBdatabaseWithName:(NSString *)dbName;

- (BOOL)isFmdbOpen;
- (BOOL)creatTableWithSql:(NSString *)tableSql;
- (BOOL)insertDataWithSql:(NSString *)insertSql;
- (BOOL)updateDataWithSql:(NSString *)updateSql;
- (NSMutableArray *)selectDataWithTableName:(NSString *)tableName sql:(NSString *)selectSql;
- (FoodModel *)selectModelWithSql:(NSString *)selectSql;
- (BOOL)deleteDataWithSql:(NSString *)deleteSql;
- (BOOL)closeDB;

@end

NS_ASSUME_NONNULL_END
