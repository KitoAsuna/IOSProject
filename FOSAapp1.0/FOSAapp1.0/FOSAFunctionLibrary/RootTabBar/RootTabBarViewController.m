//
//  RootTabBarViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2019/12/30.
//  Copyright © 2019 hs. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "SealerAndPoundViewController.h"
#import "ProductViewController.h"
#import "UserViewController.h"
#import "fosaPhotoViewController.h"
#import "FOSATabbar.h"
#import "foodAddingViewController.h"
#import "fosaMainViewController.h"

@interface RootTabBarViewController ()<fosaTabBarDelegate>

@end

@implementation RootTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"RootView Begin");
    // Do any additional setup after loading the view.
    [self addChildWithVCName:@"fosaMainViewController" title:@"FOSA" image:@"icon_main" selectImage:@"icon_mainHL"];
   // [self addChildWithVCName:@"SealerAndPoundViewController" title:@"Device" image:@"icon_sealer" selectImage:@"icon_sealerHL"];

    //[self addChildWithVCName:@"ProductViewController" title:@"Product" image:@"icon_device" selectImage:@"icon_deviceHL"];
    [self addChildWithVCName:@"UserViewController" title:@"Me" image:@"icon_me" selectImage:@"icon_meHL"];
    /**** 更换TabBar ****/
    FOSATabbar *tabbar = [[FOSATabbar alloc] init];
    tabbar.tabBarDelegate = self;
    [self setValue:tabbar forKey:@"tabBar"];
}

-(void)addChildWithVCName:(NSString *)vcName title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage{
    NSLog(@"Title=========%@",title);
    //1.创建控制器
    Class class = NSClassFromString(vcName);//根据传入的控制器名称获得对应的控制器
    UIViewController *fosa = [[class alloc]init];
     
    //2.设置控制器属性
    //fosa.navigationItem.title = title;
    fosa.tabBarItem.image = [UIImage imageNamed:image];
    fosa.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    [self addChildViewController:fosa];
    //调整图片和文字的位置
//    if ([vcName isEqualToString:@"MainViewController"] && StatusBarH == 44) {
//
//        UIEdgeInsets ImageInsets = UIEdgeInsetsMake(-10, -screen_width/24, 10, screen_width/24 );// top, left, bottom, right
//        fosa.tabBarItem.imageInsets = ImageInsets;
//    }else if([vcName isEqualToString:@"UserViewController"] && StatusBarH == 44){
//
    if (screen_height/screen_width < 2) {
        //iphone 8plus 以下的机型
        UIEdgeInsets ImageInsets = UIEdgeInsetsMake(22, 0, -22, 0 );// top, left, bottom, right
        fosa.tabBarItem.imageInsets = ImageInsets;
    }else{
        //iphone X以上的机型
        UIEdgeInsets ImageInsets = UIEdgeInsetsMake(15, 0, -15, 0 );// top, left, bottom, right
        fosa.tabBarItem.imageInsets = ImageInsets;
    }
        
//    }

//    //修改字体颜色大小
//    if (@available(iOS 13,*)) {
//         fosa.tabBarController.tabBar.tintColor = FOSAgreen;
//    }
//    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : FOSAgreen,NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]}            forState:UIControlStateSelected];

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

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.AddButton.center = CGPointMake(self.tabBar.frame.size.width* 0.5, self.tabBar.frame.size.height * 0.2);
//    [self.AddButton setBackgroundImage:[UIImage imageNamed:@"icon_Addbtn"] forState:UIControlStateNormal];
//    [self.tabBar addSubview:self.AddButton];
//    [self.AddButton addTarget:self action:@selector(addFunction) forControlEvents:UIControlEventTouchUpInside];
//}
//
//- (void) addFunction{
//    foodAddingViewController *addFood = [[foodAddingViewController alloc]init];
//    addFood.hidesBottomBarWhenPushed = YES;
//    [self presentViewController:addFood animated:YES completion:nil];
//}

//禁止应用屏幕自动旋转
- (BOOL)shouldAutorotate{
    return NO;
}

- (void)ButtonClick:(FOSATabbar *)tabBar {
    NSLog(@"*****************************");
    foodAddingViewController *addFood = [[foodAddingViewController alloc]init];
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

@end
