//
//  FosaRootTabBarViewController.m
//  FOSA
//
//  Created by hs on 2020/4/3.
//  Copyright © 2020 hs. All rights reserved.
//

#import "FosaRootTabBarViewController.h"
#import "FosaMainViewController.h"
#import "UserViewController.h"
#import "foodViewController.h"
#import "FoodModel.h"
#import "FosaTabBar.h"

@interface FosaRootTabBarViewController ()<fosaTabBarDelegate>

@end

@implementation FosaRootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildWithVCName:@"FosaMainViewController" image:@"icon_main" selectImage:@"icon_mainHL"];
    [self addChildWithVCName:@"UserViewController" image:@"icon_me" selectImage:@"icon_meHL"];
    FosaTabBar *tabbar = [FosaTabBar new];
    tabbar.tabBarDelegate = self;
    [self setValue:tabbar forKey:@"tabBar"];
}

-(void)addChildWithVCName:(NSString *)vcName image:(NSString *)image selectImage:(NSString *)selectImage{
    //1.创建控制器
    Class class = NSClassFromString(vcName);//根据传入的控制器名称获得对应的控制器
    UIViewController *fosa = [[class alloc]init];
     
    //2.设置控制器属性
    //fosa.navigationItem.title = title;
    fosa.tabBarItem.image = [UIImage imageNamed:image];
    fosa.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    [self addChildViewController:fosa];
    
    if (screen_height/screen_width < 2) {
        //iphone 8plus 以下的机型
        UIEdgeInsets ImageInsets = UIEdgeInsetsMake(22, 0, -22, 0 );// top, left, bottom, right
        fosa.tabBarItem.imageInsets = ImageInsets;
    }else{
        //iphone X以上的机型
        UIEdgeInsets ImageInsets = UIEdgeInsetsMake(10, 0, -10, 0 );// top, left, bottom, right
        fosa.tabBarItem.imageInsets = ImageInsets;
    }
    //3.创建导航控制器
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:fosa];
    //导航控制器的半透明属性（影响（0，0）坐标的起始位置）：透明-》起始坐标从屏幕最左上角开始，不透明-〉起始坐标从导航栏左下角开始
    //nvc.navigationBar.translucent = NO;//(不透明)

    //设置背景透明图片,使得导航栏透明的同时item不透明
    [nvc.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去掉 bar 下面有一条黑色的线
    [nvc.navigationBar setShadowImage:[UIImage new]];
    //[[UINavigationBar appearance]setTintColor:[UIColorwhiteColor]];
    nvc.navigationBar.tintColor = [UIColor grayColor];
   
    [nvc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:30*(screen_width/414.0)]}];
    //4.添加到标签栏控制器
    [self addChildViewController:nvc];
}
#pragma mark - fosaTabBarDelegate
- (void)ButtonClick:(FosaTabBar *)tabBar {
    foodViewController *addFood = [[foodViewController alloc]init];
    addFood.foodStyle = @"adding";
    addFood.hidesBottomBarWhenPushed = YES;
    //3.创建导航控制器
      UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:addFood];
//导航控制器的半透明属性（影响（0，0）坐标的起始位置）：透明-》起始坐标从屏幕最左上角开始，不透明-〉起始坐标从导航栏左下角开始
      //nvc.navigationBar.translucent = NO;//(不透明)
      
     // 设置背景透明图片,使得导航栏透明的同时item不透明
      [nvc.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
      //去掉 bar 下面有一条黑色的线
      [nvc.navigationBar setShadowImage:[UIImage new]];
      //[[UINavigationBar appearance]setTintColor:[UIColorwhiteColor]];
      nvc.navigationBar.tintColor = [UIColor grayColor];

      [nvc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:30*(screen_width/414.0)]}];
    /*防止弹出界面不能占满屏幕*/
    nvc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nvc animated:YES completion:nil];
}

//禁止应用屏幕自动旋转
- (BOOL)shouldAutorotate{
    return NO;
}

@end
