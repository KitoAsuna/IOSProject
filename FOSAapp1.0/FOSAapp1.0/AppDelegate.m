//
//  AppDelegate.m
//  FOSAapp1.0
//
//  Created by hs on 2019/12/29.
//  Copyright © 2019 hs. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarViewController.h"
#import "AvoidCrash.h"
#import "AFNetworking.h"
#import "FMDB.h"

#import "MainViewController.h"
#import "SealerAndPoundViewController.h"
#import "ProductViewController.h"
#import "UserViewController.h"

@interface AppDelegate (){
    FMDatabase *db;
    NSString *docPath;
    NSMutableArray *arrayData;
    NSMutableArray *dict;
}
@property(nonatomic,strong) RootTabBarViewController *root;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"********************AppDelegate");
    [AvoidCrash becomeEffective];
    //监听通知:AvoidCrashNotification, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
    
  //判断是否有更新
    NSUserDefaults *userDefault = NSUserDefaults.standardUserDefaults;
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *localVersion = [userDefault valueForKey:@"localVersion"];
    if (![currentVersion isEqualToString:localVersion]) {
            //新特性界面
    //      UIViewController *newVc = [[UIViewController alloc]init];
    //      newVc.view.backgroundColor = [UIColor redColor];
    //      self.window.rootViewController = newVc;
            [self CreatSqlDatabase:@"FOSA"];
            [self CreatDataTable];
            [self CreatCategoryTable];
            [userDefault setObject:currentVersion forKey:@"localVersion"];
        }
    //根据系统版本选择视图生成方式
    if (@available(iOS 13,*)) {
        //[self GetJSONFromServerByAFN];
        [NSThread sleepForTimeInterval:1.5];
        return YES;
    }else{
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.root = [RootTabBarViewController new];
//        
//        //初始化VC
//        MainViewController *main = (MainViewController *)[self addChildWithVCName:@"MainViewController" title:@"FOSA" image:@"icon_main" selectImage:@"icon_mainHL"];
//        SealerAndPoundViewController *sealer = (SealerAndPoundViewController *)[self addChildWithVCName:@"SealerAndPoundViewController" title:@"Device" image:@"icon_sealer" selectImage:@"icon_sealerHL"];
//        ProductViewController *product = (ProductViewController *)[self addChildWithVCName:@"ProductViewController" title:@"Product" image:@"icon_device" selectImage:@"icon_deviceHL"];
//        UserViewController *user = (UserViewController *)[self addChildWithVCName:@"UserViewController" title:@"Me" image:@"icon_me" selectImage:@"icon_meHL"];
//        
//        [self.root addChildViewController:main];
//        [self.root addChildViewController:sealer];
//        [self.root addChildViewController:product];
//        [self.root addChildViewController:user];
//        
        //添加根控制器
        self.window.rootViewController = self.root;
        //显示window
        [self.window makeKeyAndVisible];
        [NSThread sleepForTimeInterval:2];
    }
    return YES;
}
//
//-(UIViewController *)addChildWithVCName:(NSString *)vcName title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage{
//    NSLog(@"Title=========%@",title);
//    //1.创建控制器
//    Class class = NSClassFromString(vcName);//根据传入的控制器名称获得对应的控制器
//    UIViewController *fosa = [[class alloc]init];
//
//    //2.设置控制器属性
//    fosa.navigationItem.title = title;
//    fosa.tabBarItem.title = title;
//    fosa.tabBarItem.image = [UIImage imageNamed:image];
//    fosa.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
//
//    //修改字体颜色
//    if (@available(iOS 13.0, *)) {
//        NSLog(@"***************");
//         UITabBarAppearance *appearance = [UITabBarAppearance new];
//        // 设置未被选中的颜色
//        appearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
//        // 设置被选中时的颜色
//        appearance.stackedLayoutAppearance.selected.titleTextAttributes = @{ NSForegroundColorAttributeName : FOSAgreen,NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]};
//        fosa.tabBarItem.standardAppearance = appearance;
//    }else{
//        NSLog(@"#####################");
//         [fosa.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : FOSAgreen,NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]}            forState:UIControlStateSelected];
//    }
//
//    //3.创建导航控制器
//    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:fosa];
//    //设置背景透明图片,使得导航栏透明的同时item不透明
//    [nvc.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    //去掉 bar 下面有一条黑色的线
//    [nvc.navigationBar setShadowImage:[UIImage new]];
//    //[[UINavigationBar appearance]setTintColor:[UIColorwhiteColor]];
//    nvc.navigationBar.tintColor = [UIColor grayColor];
//
//    [nvc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:30*(screen_width/414.0)]}];
//    //4.添加到标签栏控制器
//    [_root addChildViewController:nvc];
//    return fosa;
//}

- (void)dealwithCrashMessage:(NSNotification *)note {
    //注意:所有的信息都在userInfo中
    //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
    NSLog(@"%@",note.userInfo);
}
- (void)GetJSONFromServerByAFN{
    ///1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   //获取食物种类
    NSString *categoryAddr = @"http://192.168.3.109/fosa/HttpComunication.php";
    [manager GET:categoryAddr parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject class],responseObject[1][@"CategoryName"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
    //获取营养库
    NSString *nutrientAddr = @"http://192.168.3.109/fosa/GetAllNutrientDataFromServer.php";
    //NSString *nutrientAddr = @"http://192.168.43.21/fosa/GetAllNutrientDataFromServer.php";
    [manager GET:nutrientAddr parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject class],responseObject[1][@"Calorie(Kcal)"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}

- (void)CreatSqlDatabase:(NSString *)dataBaseName{
    //获取数据库地址
    docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    NSLog(@"%@",docPath);
    //设置数据库名
    NSString *fileName = [docPath stringByAppendingPathComponent:dataBaseName];
    //创建数据库
    db = [FMDatabase databaseWithPath:fileName];
    if([db open]){
        NSLog(@"打开数据库成功");
    }else{
        NSLog(@"打开数据库失败");
    }
}
- (void)CreatDataTable{
    NSString *categoryTableSql = @"CREATE TABLE IF NOT EXISTS FoodCategory(id integer PRIMARY KEY AUTOINCREMENT, CategoryName text NOT NULL, CategoryImg text,UNIQUE(CategoryName));";
    NSString *nutrientTableSql = @"create table if not exists Nutrient(id integer primary key,foodName text,Category text,Calorie text,Protein text,Fat text,Carbohydrate text,DietaryFiber text,Cholesterin text,Ca text,Mg text,Fe text,Zn text,K text,VitaminC text,VitaminE text,VitaminA text,Carotene text)";
    BOOL categoryResult = [db executeUpdate:categoryTableSql];
    if(categoryResult)
    {
        NSLog(@"创建食物种类表成功");
    }else{
        NSLog(@"创建食物种类表失败");
    }
    BOOL nutrientResult = [db executeUpdate:nutrientTableSql];
    if (nutrientResult) {
        NSLog(@"创建营养成分表成功");
    }else{
        NSLog(@"创建营养成分表失败");
    }
}
- (void)CreatCategoryTable{
    NSString *categoryTableSql = @"create table if not exists category(id integer primary key,categoryName text)";
    BOOL categoryResult = [db executeUpdate:categoryTableSql];
    if (categoryResult) {
        NSLog(@"创建种类表成功");
        [self InsertCategory];
    }else {
        NSLog(@"创建种类表失败");
    }
}
- (void)InsertCategory{
     NSArray *array = @[@"Cereal",@"Fruit",@"Meat",@"Vegetable",@"Spice"];
    NSString *insertSql = @"insert into category(categoryName) values(?)";
    if ([db open]) {
        for (int i = 0; i < array.count; i++) {
            BOOL result = [db executeUpdate:insertSql,array[i]];
            if (result) {
                NSLog(@"插入数据成功");
            }else{
                NSLog(@"插入数据失败");
            }
        }
    }
}




#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

@end
