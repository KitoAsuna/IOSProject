//
//  languageViewController.h
//  FOSAapp1.0
//
//  Created by hs on 2020/3/9.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface languageViewController : UIViewController
@property (nonatomic,strong) UITableView *languageTable;
@property (nonatomic,strong) NSMutableArray<NSString *> *dataSource;
@end

NS_ASSUME_NONNULL_END
