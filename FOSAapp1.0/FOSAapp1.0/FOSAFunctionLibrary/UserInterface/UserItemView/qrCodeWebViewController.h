//
//  qrCodeWebViewController.h
//  FOSAapp1.0
//
//  Created by hs on 2020/3/17.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface qrCodeWebViewController : UIViewController
@property (nonatomic,strong) UIView *pagesizeView;
@property (nonatomic,strong) NSString *urlString;
@property (nonatomic,strong) UITableView *qrTable;
@property (nonatomic,strong) UIScrollView *preview;
@property (nonatomic,strong) UIButton *printBtn;
@property (nonatomic,strong) UIPageControl *pageControl;

@end

NS_ASSUME_NONNULL_END
