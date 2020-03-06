//
//  takePictureViewController.h
//  FOSAapp1.0
//
//  Created by hs on 2020/3/4.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface takePictureViewController : UIViewController
@property (nonatomic,copy)void(^photoBlock)(UIImage *img);
@end

NS_ASSUME_NONNULL_END
