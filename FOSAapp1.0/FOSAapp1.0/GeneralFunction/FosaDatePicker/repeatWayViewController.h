//
//  repeatWayViewController.h
//  FOSAapp1.0
//
//  Created by hs on 2020/4/13.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface repeatWayViewController : UIViewController
//block 传值
@property (nonatomic,copy)void(^repeatBlock)(NSString *repeatWay);
@property (nonatomic,strong) UITableView *repeatTable;
@property (nonatomic,strong) NSMutableArray<NSString *> *dataSource;
@property (nonatomic,strong) NSString *currentRepeat;
@end

NS_ASSUME_NONNULL_END
