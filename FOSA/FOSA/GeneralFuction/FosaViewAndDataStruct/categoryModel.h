//
//  categoryModel.h
//  FOSA
//
//  Created by hs on 2020/5/27.
//  Copyright © 2020 hs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface categoryModel : NSObject
@property (nonatomic,copy) NSString *categoryName,*categoryIconName;

+ (instancetype)modelWithName:(NSString *)categoryName iconName:(NSString *)categoryIconName;
- (instancetype)initWithName:(NSString *)categoryName iconName:(NSString *)categoryIconName;
@end

NS_ASSUME_NONNULL_END
