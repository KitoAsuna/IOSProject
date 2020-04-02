#import "SceneDelegate.h"
#import "RootTabBarViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions  API_AVAILABLE(ios(13.0)){
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    //在这里手动创建新的window
        if (scene) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
            self.window.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            NSUserDefaults *userDefault = NSUserDefaults.standardUserDefaults;
            NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
            NSString *localVersion = [userDefault valueForKey:@"localVersion"];
            if (![currentVersion isEqualToString:localVersion]) {
                //新特性界面
//                UIViewController *newVc = [[UIViewController alloc]init];
//                newVc.view.backgroundColor = [UIColor redColor];
//                self.window.rootViewController = newVc;
                [userDefault setObject:currentVersion forKey:@"localVersion"];
            }else{
                //添加根控制器
                self.window.rootViewController = [RootTabBarViewController new];
            }
            [self.window makeKeyAndVisible];
        }
    [NSThread sleepForTimeInterval:1];
    NSLog(@"&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
}

- (void)sceneDidDisconnect:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}

@end
