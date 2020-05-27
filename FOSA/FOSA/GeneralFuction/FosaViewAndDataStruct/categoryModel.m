//
//  categoryModel.m
//  FOSA
//
//  Created by hs on 2020/5/27.
//  Copyright © 2020 hs. All rights reserved.
//

#import "categoryModel.h"

@implementation categoryModel
+ (instancetype)modelWithName:(NSString *)categoryName iconName:(NSString *)categoryIconName{
    return [[self alloc]initWithName:categoryName iconName:categoryIconName];
}
- (instancetype)initWithName:(NSString *)categoryName iconName:(NSString *)categoryIconName{
    self = [super init];
    if (self) {
        self.categoryName = categoryName;
        self.categoryIconName = categoryIconName;
        return self;
    }else{
        return nil;
    }
}
@end
