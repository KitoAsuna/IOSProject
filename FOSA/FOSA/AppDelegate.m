//
//  AppDelegate.m
//  FOSA
//
//  Created by hs on 2020/3/20.
//  Copyright © 2020 hs. All rights reserved.
//

#import "AppDelegate.h"
#import <AvoidCrash.h>
#import "FosaRootTabBarViewController.h"
#import "FosaFMDBManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //启动防奔溃第三方库
    [self startAvoidCrash];
    
    //判断是否有更新
    NSUserDefaults *userDefault = NSUserDefaults.standardUserDefaults;
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *localVersion = [userDefault valueForKey:@"localVersion"];
    if (![currentVersion isEqualToString:localVersion]) {
        [self updateCategoryTable];
        [userDefault setObject:currentVersion forKey:@"localVersion"];
    }
    //根据系统版本选择视图生成方式
    if (@available(iOS 13,*)) {
        return YES;
    }else{
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        //添加根控制器
        self.window.rootViewController = [FosaRootTabBarViewController new];
        //显示window
        [self.window makeKeyAndVisible];
        [NSThread sleepForTimeInterval:1];
    }
    return YES;
}

- (void)startAvoidCrash{
    //启动防止崩溃功能(注意区分becomeEffective和makeAllEffective的区别)
    //具体区别请看 AvoidCrash.h中的描述
    //建议在didFinishLaunchingWithOptions最初始位置调用 上面的方法
    [AvoidCrash makeAllEffective];
    //若出现unrecognized selector sent to instance导致的崩溃并且控制台输出:
    //-[__NSCFConstantString initWithName:age:height:weight:]: unrecognized selector sent to instance
    //你可以将@"__NSCFConstantString"添加到如下数组中，当然，你也可以将它的父类添加到下面数组中
    //比如，对于部分字符串，继承关系如下
    //__NSCFConstantString --> __NSCFString --> NSMutableString --> NSString
    //你可以将上面四个类随意一个添加到下面的数组中，建议直接填入 NSString
    NSArray *noneSelClassStrings = @[
                                     @"NSString"
                                     ];
    [AvoidCrash setupNoneSelClassStringsArr:noneSelClassStrings];
    //监听通知:AvoidCrashNotification, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
}
- (void)dealwithCrashMessage:(NSNotification *)note {
    //注意:所有的信息都在userInfo中
    //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
    NSLog(@"%@",note.userInfo);
}

#pragma mark - 更新食物种类数据
- (void)updateCategoryTable{
    //数据库管理者
    FosaFMDBManager *fmdbManager = [FosaFMDBManager initFMDBManagerWithdbName:@"FOSA"];
    if ([fmdbManager isFmdbOpen]) {
        NSString *categoryTableSql = @"create table if not exists category(id integer primary key,categoryName text)";
        NSArray *array = @[@"Biscuit",@"Bread",@"Cake",@"Cereal",@"Dairy",@"Fruit",@"Meat",@"Snacks",@"Spice",@"Veggie"];
        if ([fmdbManager creatTableWithSql:categoryTableSql]) {
            for (int i = 0; i < array.count; i++) {
                NSString *insertSql = [NSString stringWithFormat:@"insert into category(categoryName) values('%@')",array[i]];
                BOOL result = [fmdbManager insertDataWithSql:insertSql];
                if (result) {
                    NSLog(@"insert data:%@ successfully",array[i]);
                }
            }
        }
    }else{
        NSLog(@"database open failed")
    }
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
