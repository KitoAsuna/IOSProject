//
//  qrCodeScannerViewController.h
//  FOSA
//
//  Created by hs on 2020/4/3.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "foodViewController.h"
#import "qrResultViewController.h"
#import "fosaWebViewController.h"
#import "FoodModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface qrCodeScannerViewController : UIViewController

//block 传值
@property (nonatomic,copy)void(^resultBlock)(NSString *result);
@property (nonatomic,strong) NSString *scanStyle;
//扫码界面
@property (nonatomic,strong)  UIImageView *scanFrame;       //扫描框
@property (nonatomic,strong) UIImageView *scanLine;         //扫描线
@property (nonatomic,strong) UIButton *flashBtn;             //闪光灯
@property (nonatomic,strong) UIImageView *focusCursor;      //二维码位置标示

@end

NS_ASSUME_NONNULL_END
