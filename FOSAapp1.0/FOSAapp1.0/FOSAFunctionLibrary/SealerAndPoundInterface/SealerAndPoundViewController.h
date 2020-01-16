//
//  SealerAndPoundViewController.h
//  FOSAapp1.0
//
//  Created by hs on 2019/12/30.
//  Copyright © 2019 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SealerAndPoundViewController : UIViewController
@property (nonatomic,strong) UIView *sealerView,*otherSealerView,*poundView;
@property (nonatomic,strong) UIImageView *sealerImageView,*otherSealerImageView,*poundImageView;
@property (nonatomic,strong) UIButton *sealerScanBtn,*sealerOpenbtn,*otherSealerScanBtn,*otherSealerOpenBtn,*poundScanBtn,*poundOpenBtn;

@end

NS_ASSUME_NONNULL_END
