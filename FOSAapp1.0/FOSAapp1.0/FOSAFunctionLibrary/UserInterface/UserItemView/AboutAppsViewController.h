//
//  AboutAppsViewController.h
//  FOSAapp1.0
//
//  Created by hs on 2020/1/13.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AboutAppsViewController : UIViewController

@property (nonatomic,strong) UIImageView *logo;
@property (nonatomic,strong) UILabel *appTitleLable,*versionLable;
@property (nonatomic,strong) UILabel *privacyLabel,*copyrightLabel;
@end

NS_ASSUME_NONNULL_END
