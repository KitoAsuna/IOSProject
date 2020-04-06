//
//  fosaNotificationManager.m
//  FOSA
//
//  Created by hs on 2020/4/6.
//  Copyright © 2020 hs. All rights reserved.
//

#import "fosaNotificationManager.h"
#import <UserNotifications/UserNotifications.h>
#import "FosaFMDBManager.h"
#import "FosaIMGManager.h"

@interface fosaNotificationManager()<UNUserNotificationCenterDelegate>{
    NSString *foodName;
}
@property (nonatomic,strong) UIImage *image,*codeImage;
@property (nonatomic,strong) FosaIMGManager *imgManager;

@end
@implementation fosaNotificationManager

-(void)initNotification{
    NSLog(@"获取权限");
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            // 必须写代理，不然无法监听通知的接收与点击
    center.delegate = self;
        //设置预设好的交互类型，NSSet里面是设置好的UNNotificationCategory
    [center setNotificationCategories:[self createNotificationCategoryActions]];
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
    if (settings.authorizationStatus==UNAuthorizationStatusNotDetermined){
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert|UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error){
                if (granted) {
                    } else {
                    }
                }];
            }
        else{
           //do other things
        }
    }];
}
//代理回调方法，通知即将展示的时候
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"即将展示通知");
    UNNotificationRequest *request = notification.request; // 原始请求
    //NSDictionary * userInfo = notification.request.content.userInfo;//userInfo数据
    UNNotificationContent *content = request.content; // 原始内容
//建议将根据Notification进行处理的逻辑统一封装，后期可在Extension中复用~
completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 回调block，将设置传入
    [self.imgManager deleteImgWithName:content.subtitle];
}
//用户与通知进行交互后的response，比如说用户直接点开通知打开App、用户点击通知的按钮或者进行输入文本框的文本
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
   //获取通知相关内容
    UNNotificationRequest *request = response.notification.request; // 原始请求
    UNNotificationContent *content = request.content; // 原始内容
    NSString *title = content.title;  // 标题
    NSString *body = content.body;    // 推送消息体

//在此，可判断response的种类和request的触发器是什么，可根据远程通知和本地通知分别处理，再根据action进行后续回调
    if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
        UNTextInputNotificationResponse * textResponse = (UNTextInputNotificationResponse*)response;
        NSString * text = textResponse.userText;
        NSLog(@"%@",text);
    }else{
        if ([response.actionIdentifier isEqualToString:@"see1"]){
            NSLog(@"Save UIView as photo");
            UIImage *notificationImage = [self.imgManager saveViewAsPictureWithView:[self CreatNotificatonView:title body:body]];
            //[self beginShare:image];
            UIImageWriteToSavedPhotosAlbum(notificationImage, self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
        }else if ([response.actionIdentifier isEqualToString:@"see2"]) {
            //I don't care~
            NSLog(@"I know");
            [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[response.notification.request.identifier]];
        }else{
            NSLog(@"-----------------我点击了通知，打开特定的界面------------------");
            if ([self.fosadelegate respondsToSelector:@selector(JumpByFoodName:)]) {
                NSLog(@"我将跳转页面");
                [self.fosadelegate JumpByFoodName:content.subtitle];
            }
        }
    }
    completionHandler();
}

- (void)sendNotificationByDate:(FoodModel *)model body:(NSString *)body date:(NSString *)mdate foodImg:(id)image{
    NSLog(@"我将发送一个系统通知");
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Notification";
    content.subtitle = @"By Fosa";
    content.body = body;
    content.badge = @0;
    //获取沙盒中的图片
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *photopath = [NSString stringWithFormat:@"%@.png",model.foodPhoto];
    NSString *imagePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",photopath]];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    self.image = img;
    NSLog(@"%@",imagePath);
    NSError *error = nil;
    //将本地图片的路径形成一个图片附件，加入到content中
    UNNotificationAttachment *img_attachment = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:imagePath] options:nil error:&error];
    if (error) {
        NSLog(@"%@", error);
       }
    content.attachments = @[img_attachment];
    //设置为@""以后，进入app将没有启动页
    content.launchImageName = @"";
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    //设置时间间隔的触发器
    //格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yy/MM/dd/HH:mm"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    localeDate = [formatter dateFromString:mdate];
    
    NSLog(@"==================发送时间：%@",localeDate);
    NSDateComponents * components = [[NSCalendar currentCalendar]
                                                components:NSCalendarUnitYear |
                                                NSCalendarUnitMonth |
                                                NSCalendarUnitWeekday |
                                                NSCalendarUnitDay |
                                                NSCalendarUnitHour |
                                                NSCalendarUnitMinute |
                                                NSCalendarUnitSecond
                                                fromDate:localeDate];
    UNCalendarNotificationTrigger *date_trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];
    NSString *requestIdentifer = model.foodPhoto;
           //content.categoryIdentifier = @"textCategory";
    content.categoryIdentifier = @"seeCategory";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:date_trigger];
       
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
           NSLog(@"%@",error);
    }];
    //生成二维码
    NSString *message = [NSString stringWithFormat:@"FOSAINFO&%@&%@&%@&%@&%@&%@&%@",model.foodName,model.device,model.aboutFood,model.expireDate,model.storageDate,model.category,model.location];
    self.codeImage = [self.imgManager GenerateQRCodeByMessage:message];
    self.image = img;
    foodName = model.foodName;
    NSLog(@"这是分享图片上的食物%@图片:%@",model.foodName,self.image);
}
- (void)sendNotification:(FoodModel *)model body:(NSString *)body image:(UIImage *)img{
    NSLog(@"我将发送一个系统通知");
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"FOSA Reminding";
    content.subtitle = model.foodName;
    content.body = body;
    content.badge = @0;
    //获取沙盒中的图片
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *photopath = [NSString stringWithFormat:@"%@.png",model.foodName];
    NSString *imagePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",photopath]];
    NSError *error = nil;
    //将本地图片的路径形成一个图片附件，加入到content中
    UNNotificationAttachment *img_attachment = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:imagePath] options:nil error:&error];

    if (error) {
        NSLog(@"%@", error);
    }
    content.attachments = @[img_attachment];
    
    //设置为@""以后，进入app将没有启动页
    content.launchImageName = @"";
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    //设置时间间隔的触发器
    UNTimeIntervalNotificationTrigger *time_trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
    NSString *requestIdentifer = model.foodName;
    content.categoryIdentifier = @"seeCategory";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:time_trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
    //生成二维码
    NSString *message = [NSString stringWithFormat:@"FOSAINFO&%@&%@&%@&%@&%@&%@&%@",model.foodName,model.device,model.aboutFood,model.expireDate,model.storageDate,model.category,model.location];
    self.codeImage = [self.imgManager GenerateQRCodeByMessage:message];
    self.image = img;
    foodName = model.foodName;
    NSLog(@"这是分享图片上的食物%@图片:%@",model.foodName,self.image);
}

-(NSSet *)createNotificationCategoryActions{
    //定义按钮的交互button action
    UNNotificationAction * likeButton = [UNNotificationAction actionWithIdentifier:@"see1" title:@"Save as Picture" options:UNNotificationActionOptionAuthenticationRequired|UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    UNNotificationAction * dislikeButton = [UNNotificationAction actionWithIdentifier:@"see2" title:@"I don't care~" options:UNNotificationActionOptionAuthenticationRequired|UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    //定义文本框的action
    UNTextInputNotificationAction * text = [UNTextInputNotificationAction actionWithIdentifier:@"text" title:@"How about it~?" options:UNNotificationActionOptionAuthenticationRequired|UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    //将这些action带入category
    UNNotificationCategory * choseCategory = [UNNotificationCategory categoryWithIdentifier:@"seeCategory" actions:@[likeButton,dislikeButton] intentIdentifiers:@[@"see1",@"see2"] options:UNNotificationCategoryOptionNone];
    UNNotificationCategory * comment = [UNNotificationCategory categoryWithIdentifier:@"textCategory" actions:@[text] intentIdentifiers:@[@"text"] options:UNNotificationCategoryOptionNone];
    return [NSSet setWithObjects:choseCategory,comment,nil];
}

#pragma mark - 分享图片
//仿照系统通知绘制UIview
- (UIView *)CreatNotificatonView:(NSString *)title body:(NSString *)body{
    NSLog(@"begin creating");
    
    int mainwidth = screen_width;
    int mainHeight = screen_height;
    
    UIView *notification = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainwidth,mainHeight)];
    notification.backgroundColor = [UIColor whiteColor];

    //食物图片
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0,mainHeight/8, mainwidth, mainHeight/2)];
    
    //FOSA的logo
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(mainwidth*2/5, mainHeight-mainwidth/5, mainwidth/5, mainwidth/5)];
    
    //FOSA
    UILabel *brand = [[UILabel alloc]initWithFrame:CGRectMake(mainwidth/15, mainHeight*5/8, mainwidth/4, mainHeight/16)];
    
    //食物信息二维码
    UIImageView *InfoCodeView = [[UIImageView alloc]initWithFrame:CGRectMake(mainwidth*4/5-20, mainHeight*5/8+5, mainwidth/5, mainwidth/5)];

    //提醒内容
    UITextView *Nbody = [[UITextView alloc]initWithFrame:CGRectMake(mainwidth/15, mainHeight*11/16, mainwidth*3/5, mainwidth/5)];
    Nbody.userInteractionEnabled = NO;

    [notification addSubview:logo];
    [notification addSubview:brand];
    [notification addSubview:InfoCodeView];
    [notification addSubview:image];
    [notification addSubview:Nbody];

    logo.image  = [UIImage imageNamed:@"icon_ntificationBrand"];
    NSLog(@"食物图片被添加到分享视图上:%@",self.image);
    image.image = self.image;
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    InfoCodeView.image = self.codeImage;
    InfoCodeView.backgroundColor = [UIColor redColor];
    InfoCodeView.contentMode = UIViewContentModeScaleAspectFill;
    InfoCodeView.clipsToBounds = YES;
    
    brand.font  = [UIFont systemFontOfSize:20];
    //brand.textAlignment = NSTextAlignmentCenter;
    brand.text  = @"FOSA";
    
    Nbody.font   = [UIFont systemFontOfSize:12];
    Nbody.text = body;
    
    return notification;
}
#pragma mark - <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
        NSLog(@"%@",msg);
    }else{
        msg = @"保存图片成功" ;
        NSLog(@"%@",msg);
        //[self SystemAlert:msg];
    }
}

@end
