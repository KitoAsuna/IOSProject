//
//  MacroHeader.h
//  FOSA
//
//  Created by hs on 2020/4/6.
//  Copyright © 2020 hs. All rights reserved.
//

#ifndef MacroHeader_h
#define MacroHeader_h
// 常用对象
#define fosaApplication [UIApplication sharedApplication]

#define fosaAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define fosaUserDefaults [NSUserDefaults standardUserDefaults]

#define fosaNotificationCenter [NSNotificationCenter defaultCenter]

//APP版本号
#define FosaAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//系统版本号
#define FosaSystemVersion [[UIDevice currentDevice] systemVersion]

//获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//plist文件常量 ——>路径
#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

//历史搜索记录
#define HISTORYSEARCHFILE [DocumentsDirectory stringByAppendingPathComponent:@"historySearch.plist"]

//获取appDelegates类
#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

// 1.判断是否为iOS8
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
// 2.判断是否为iOS9
#define iOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
// 3.判断是否为iOS10
#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
// 4.判断是否为iOS11
#define iOS11 ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)
// 5.判断是否为iOS12
#define iOS12 ([[UIDevice currentDevice].systemVersion doubleValue] >= 12.0)
// 6.判断是否为iOS13
#define iOS13 ([[UIDevice currentDevice].systemVersion doubleValue] >= 13.0)

//手机型号和平板
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6P (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)
#define IS_IPHONE_X (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)812) < DBL_EPSILON) || (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)896) < DBL_EPSILON)

/** 屏幕高度 */
#define screen_height (int)[UIScreen mainScreen].bounds.size.height
/** 屏幕宽度 */
#define screen_width (int)[UIScreen mainScreen].bounds.size.width
/**状态栏高度*/
#define statusHIOS13 [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height
#define statusH [UIApplication sharedApplication].statusBarFrame.size.height
#define statusBarH (IOS13 ? statusIOS13 : statusH)
/**导航栏高度*/
//获取导航栏的高度 - （不包含状态栏高度） 44pt
#define NavigationBarHeight self.navigationController.navigationBar.frame.size.height
//屏幕顶部 导航栏高度（包含状态栏高度）
#define NavigationHeight (statusBarH + NavigationBarHeight)
/**tabbar*/
#define TabbarHeight  ([[UIApplication sharedApplication] statusBarFrame].size.height > 20?83:49)  //根据状态栏的高度判断tabBar的高度
// 字体适配
#define font(R) (R)*(screen_width)/375.0

// 全局颜色
#define FOSAgreen [UIColor colorWithRed:90/255.0 green:172/255.0 blue:51/255.0 alpha:1.0]
#define FOSAgreengrad [UIColor colorWithRed:80/255.0 green:200/255.0 blue:84/255.0 alpha:1.0]
#define FOSARed  [UIColor colorWithRed:252/255.0 green:84/255.0 blue:116/255.0 alpha:1.0]
#define FOSAYellow [UIColor colorWithRed:248/255.0 green:181/255.0 blue:81/255.0 alpha:1.0]
#define RandomColor ([UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0])//随机颜色
#define FOSAFoodBackgroundColor [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]
#define FOSAWhite [UIColor whiteColor]
#define FOSAGray  [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]


// 8.解决日志打印不全的问题
#ifdef DEBUG
#define NSLog( s, ... ) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String] );
#else
#define NSLog( s, ... )
#endif

#define mouth [NSDictionary dictionaryWithObjectsAndKeys:@"Jan",@"01",@"Feb",@"02",@"Mar",@"03",@"Apr",@"04",@"May",@"05",@"June",@"06",@"July",@"07",@"Aug",@"08",@"Sept",@"09",@"Oct",@"10",@"Nov",@"11",@"Dec",@"12",nil]
#define month2 [NSDictionary dictionaryWithObjectsAndKeys:@"01",@"Jan",@"02",@"Feb",@"03",@"Mar",@"04",@"Apr",@"05",@"May",@"06",@"June",@"07",@"July",@"08",@"Aug",@"09",@"Sept",@"10",@"Oct",@"11",@"Nov",@"12",@"Dec",nil]

#define AlertTitle @"NOTICE"

#endif /* MacroHeader_h */
