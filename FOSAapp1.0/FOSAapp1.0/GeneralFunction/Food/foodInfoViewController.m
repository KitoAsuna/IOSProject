//
//  foodInfoViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/3/7.
//  Copyright © 2020 hs. All rights reserved.
//

#import "foodInfoViewController.h"

@interface foodInfoViewController ()

@end

@implementation foodInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**隐藏底部横条，点击屏幕可显示*/
- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}
//禁止应用屏幕自动旋转
- (BOOL)shouldAutorotate{
    return NO;
}

@end
