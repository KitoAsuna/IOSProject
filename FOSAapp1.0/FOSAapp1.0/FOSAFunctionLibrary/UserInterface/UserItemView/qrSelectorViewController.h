//
//  qrSelectorViewController.h
//  FOSAapp1.0
//
//  Created by hs on 2020/4/29.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface qrSelectorViewController : UIViewController
//block 传值
@property (nonatomic,copy)   void(^seletBlock)(NSString *selector);
@property (nonatomic,strong) NSArray<NSString *> *selectData;
@property (nonatomic,strong) UITableView *selectorTable;
@property (nonatomic,copy)   NSString *current;
@end

NS_ASSUME_NONNULL_END
