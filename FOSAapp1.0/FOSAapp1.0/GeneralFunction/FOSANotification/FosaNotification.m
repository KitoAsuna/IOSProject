//
//  FosaNotification.m
//  FOSAapp1.0
//
//  Created by hs on 2020/1/3.
//  Copyright © 2020 hs. All rights reserved.
//

#import "FosaNotification.h"
#import <UserNotifications/UserNotifications.h>
#import "foodAddingViewController.h"
#import <CoreImage/CoreImage.h>
#import "FMDB.h"
//图片宽高的最大值
#define KCompressibilityFactor 1280.00

@interface FosaNotification()<UNUserNotificationCenterDelegate>{
    NSString *foodName;
    //数据库对象
    FMDatabase *db;
}
@property (nonatomic,strong) UIImage *image,*codeImage;
@property (nonatomic,strong) UNUserNotificationCenter *center;
@end

@implementation FosaNotification


-(void)initNotification{
    NSLog(@"获取权限");
    self.center = [UNUserNotificationCenter currentNotificationCenter];
            // 必须写代理，不然无法监听通知的接收与点击
    
    self.center.delegate = self;
        //设置预设好的交互类型，NSSet里面是设置好的UNNotificationCategory
    [self.center setNotificationCategories:[self createNotificationCategoryActions]];
    
    [self.center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
    if (settings.authorizationStatus==UNAuthorizationStatusNotDetermined){
        [self.center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert|UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error){
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
    NSDictionary * userInfo = notification.request.content.userInfo;//userInfo数据
    UNNotificationContent *content = request.content; // 原始内容
    //建议将根据Notification进行处理的逻辑统一封装，后期可在Extension中复用~
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 回调block，将设置传入
    [self deleteFile:content.subtitle];

    //在这里发送重复的通知，每隔三个小时通知一次
    NSString *repeat = [userInfo objectForKey:@"repeat"]; //获取通知重复方式
    NSString *requestIdentifier = request.identifier;
    NSLog(@"重复方式:%@--------requestIdentifier:%@------%@",repeat,requestIdentifier,request.identifier);
    if ([repeat isEqualToString:@"Every three hours"] && [requestIdentifier containsString:@"Remind"]) {
        NSLog(@"我将发送一个重复系统通知");
        UNMutableNotificationContent *rcontent = [[UNMutableNotificationContent alloc] init];
        rcontent.title = @"FOSA Reminding";
        rcontent.subtitle = content.subtitle;
        rcontent.body = content.body;
        rcontent.badge = @0;
        //设置为@""以后，进入app将没有启动页
        rcontent.launchImageName = @"";
        UNNotificationSound *sound = [UNNotificationSound defaultSound];
        rcontent.sound = sound;
        //设置时间间隔的触发器
        UNTimeIntervalNotificationTrigger *time_trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:300 repeats:YES];
        NSString *Identifer = content.subtitle;
        NSLog(@"============%@",content.subtitle);
        rcontent.categoryIdentifier = @"seeCategory";
        UNNotificationRequest *request1 = [UNNotificationRequest requestWithIdentifier:Identifer content:content trigger:time_trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request1 withCompletionHandler:^(NSError * _Nullable error) {
            //NSLog(@"通知发送失败:%@",error);
        }];
    }
}

//用户与通知进行交互后的response，比如说用户直接点开通知打开App、用户点击通知的按钮或者进行输入文本框的文本
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
   //获取通知相关内容
    UNNotificationRequest *request = response.notification.request; // 原始请求
    UNNotificationContent *content = request.content; // 原始内容
    NSString *foodName = content.subtitle;  // 标题
    NSString *body = content.body;    // 推送消息体
    
    //在此，可判断response的种类和request的触发器是什么，可根据远程通知和本地通知分别处理，再根据action进行后续回调
    if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
        UNTextInputNotificationResponse * textResponse = (UNTextInputNotificationResponse*)response;
        NSString * text = textResponse.userText;
        NSLog(@"%@",text);
    }else{
        if ([response.actionIdentifier isEqualToString:@"see1"]){
            NSLog(@"Save UIView as photo");
            UIImage *notificationImage = [self SaveViewAsPicture:[self CreatNotificatonView:foodName body:body]];
            UIImageWriteToSavedPhotosAlbum(notificationImage, self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
        }else if ([response.actionIdentifier isEqualToString:@"see2"]) {
            //I don't care~
            [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[response.notification.request.identifier]];
            [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[response.notification.request.identifier]];
            NSLog(@"删除通知:%@",response.notification.request.identifier);

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
- (void)removeReminder:(NSMutableArray *)array{
    [self.center removeDeliveredNotificationsWithIdentifiers:array];
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:array];
    for (int i = 0; i < array.count; i++) {
        NSLog(@"Identifiers:%@",array[i]);
    }
}

- (void)sendNotificationByDate:(FoodModel *)model body:(NSString *)body date:(NSString *)mdate foodImg:(id)image identifier:(NSString *)identifier{
    NSLog(@"我将发送一个系统通知----------按指定日期发送通知");
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"FOSA Reminding";
    content.subtitle = model.foodName;
    content.body = body;
    content.badge = @0;
    content.userInfo = @{@"repeat":model.repeat,@"request":identifier,};
    //获取沙盒中的图片
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *photopath = [NSString stringWithFormat:@"%@.png",model.foodName];
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
    //content.launchImageName = @"";
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    //设置时间间隔的触发器
    //格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yy/HH:mm"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    localeDate = [formatter dateFromString:mdate];
    NSLog(@"==================发送时间：%@",[formatter stringFromDate:localeDate]);
    /**
     根据重复方式设置日期选择器
     */
    NSDateComponents * components;
    
    if ([model.repeat isEqualToString:@"Never"] || [identifier containsString:@"Expiry"] || [model.repeat isEqualToString:@"Every three hours"]) {
        components = [[NSCalendar currentCalendar]
                      components:NSCalendarUnitYear |
                      NSCalendarUnitMonth |
                      NSCalendarUnitWeekday |
                      NSCalendarUnitDay |
                      NSCalendarUnitHour |
                      NSCalendarUnitMinute |
                      NSCalendarUnitSecond
                      fromDate:localeDate];
    }else if ([model.repeat isEqualToString:@"Daily"]){
        NSLog(@"repeat:Daily");
        components = [[NSCalendar currentCalendar]
                      components:NSCalendarUnitHour|
                      NSCalendarUnitMinute|
                      NSCalendarUnitSecond
                      fromDate:localeDate];
    }else if ([model.repeat isEqualToString:@"Weekly"]){
        NSLog(@"repeat:Weekly");
        components = [[NSCalendar currentCalendar]
                      components:NSCalendarUnitWeekday |
                      NSCalendarUnitHour|
                      NSCalendarUnitMinute|
                      NSCalendarUnitSecond
                      fromDate:localeDate];
    }else if ([model.repeat isEqualToString:@"Monthly"]){
        NSLog(@"repeat:Monthly");
        components = [[NSCalendar currentCalendar]
                     components:NSCalendarUnitDay |
                     NSCalendarUnitHour|
                     NSCalendarUnitMinute|
                     NSCalendarUnitSecond
                     fromDate:localeDate];
    }

    UNCalendarNotificationTrigger *date_trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];

    NSString *requestIdentifer = identifier;
    content.categoryIdentifier = @"seeCategory";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:date_trigger];

    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"通知添加失败");
        }else{
            NSLog(@"通知添加成功");
        }
    }];
    //生成二维码
    NSString *message = [NSString stringWithFormat:@"FOSAINFO&%@&%@&%@&%@&%@&%@&%@&%@",model.foodName,model.device,model.aboutFood,model.expireDate,model.storageDate,model.category,model.location,model.repeat];
    self.codeImage = [self GenerateQRCodeByMessage:message];
    self.image = img;
    foodName = model.foodName;
    NSLog(@"这是分享图片上的食物%@图片:%@",model.foodName,self.image);
}
- (void)sendNotification:(FoodModel *)model body:(NSString *)body image:(UIImage *)img time:(long)timeInterval identifier:(NSString *)identifier{
    NSLog(@"我将发送一个系统通知------按间隔时间发送通知:%ld",timeInterval);
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"FOSA Reminding";
    content.subtitle = model.foodName;
    content.body = body;
    content.badge = @0;
    content.userInfo = @{@"repeat":model.repeat,@"request":identifier};
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
    UNTimeIntervalNotificationTrigger *time_trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];

    NSString *requestIdentifer = identifier;
    content.categoryIdentifier = @"seeCategory";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:time_trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"通知添加失败");
        }else{
            NSLog(@"通知添加成功");
        }
    }];
    //生成二维码
    NSString *message = [NSString stringWithFormat:@"FOSAINFO&%@&%@&%@&%@&%@&%@&%@",model.foodName,model.device,model.aboutFood,model.expireDate,model.storageDate,model.category,model.location];
    self.codeImage = [self GenerateQRCodeByMessage:message];
    self.image = img;
    foodName = model.foodName;
    NSLog(@"这是分享图片上的食物%@图片:%@",model.foodName,self.image);
}
- (void)sendNotification:(FoodModel *)model body:(NSString *)body image:(UIImage *)img time:(long int)timeInterval{
    NSLog(@"我将发送一个系统通知");
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"FOSA Reminding";
    content.subtitle = model.foodName;
    content.body = body;
    content.badge = @0;
    content.userInfo = @{@"repeat":model.repeat};
    //获取沙盒中的图片
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *photopath = [NSString stringWithFormat:@"%@.png",model.foodName];
    NSString *imagePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",photopath]];
    NSError *error = nil;
    //将本地图片的路径形成一个图片附件，加入到content中
    UNNotificationAttachment *img_attachment = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:imagePath] options:nil error:&error];
    if (error) {
        NSLog(@"通知添加失败");
    }else{
        NSLog(@"通知添加成功");
    }
    content.attachments = @[img_attachment];
    //设置为@""以后，进入app将没有启动页
    content.launchImageName = @"";
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;

    //设置时间间隔的触发器
    UNTimeIntervalNotificationTrigger *time_trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
    NSString *requestIdentifer = model.foodName;
    content.categoryIdentifier = @"seeCategory";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:time_trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
    //生成二维码
    NSString *message = [NSString stringWithFormat:@"FOSAINFO&%@&%@&%@&%@&%@&%@&%@",model.foodName,model.device,model.aboutFood,model.expireDate,model.storageDate,model.category,model.location];
    self.codeImage = [self GenerateQRCodeByMessage:message];
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
    UILabel *foodName = [[UILabel alloc]initWithFrame:CGRectMake(mainwidth/15, mainHeight*5/8, mainwidth/4, mainHeight/16)];
    
    //食物信息二维码
    UIImageView *InfoCodeView = [[UIImageView alloc]initWithFrame:CGRectMake(mainwidth*4/5-Width(15), mainHeight*5/8+Height(15), mainwidth/5, mainwidth/5)];

    //提醒内容
    UITextView *Nbody = [[UITextView alloc]initWithFrame:CGRectMake(mainwidth/15, mainHeight*11/16, mainwidth*3/5, mainwidth/5)];
    Nbody.userInteractionEnabled = NO;

    [notification addSubview:logo];
    [notification addSubview:foodName];
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
    
    foodName.font  = [UIFont systemFontOfSize:20];
    //brand.textAlignment = NSTextAlignmentCenter;
    foodName.text  = title;
    
    Nbody.font   = [UIFont systemFontOfSize:12];
    Nbody.text = body;
    
    return notification;
}

//将UIView转化为图片并保存在相册
- (UIImage *)SaveViewAsPicture:(UIView *)view{
    NSLog(@"begin saving");
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageRet;
}

- (UIImage *)GenerateQRCodeByMessage:(NSString *)message{
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    // 2. 给滤镜添加数据
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    //[self createNonInterpolatedUIImageFormCIImage:image withSize:];
    return [UIImage imageWithCIImage:image];
}

//获得高清的二维码图片
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage *returnimage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);//手动释放
    CGColorSpaceRelease(cs);//手动释放
    return returnimage;
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
//删除图片
- (void)deleteFile:(NSString *)photoName {
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *photo = [NSString stringWithFormat:@"%@.png",photoName];
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent: photo];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!blHave) {
        NSLog(@"no  have");
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:filePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
    }
}
//取出保存在本地的图片
- (void)getImage:(NSString *)filepath{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *photopath = [NSString stringWithFormat:@"%@.png",filepath];
    NSString *imagePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",photopath]];
    // 保存文件的名称
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%@", img);
}
-(void)beginShare:(UIImage *)image{
    NSLog(@"点击了分享");
    //UIImage *sharephoto = [self getJPEGImagerImg:self.food_image];
    //UIImage *sharephoto1 = [self getJPEGImagerImg:[UIImage imageNamed:@"启动图2"]];
    //NSArray *activityItems = @[image];
    //UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
}
#pragma mark - 压缩图片
- (UIImage *)getJPEGImagerImg:(UIImage *)image{
 CGFloat oldImg_WID = image.size.width;
 CGFloat oldImg_HEI = image.size.height;
 //CGFloat aspectRatio = oldImg_WID/oldImg_HEI;//宽高比
 if(oldImg_WID > KCompressibilityFactor || oldImg_HEI > KCompressibilityFactor){
 //超过设置的最大宽度 先判断那个边最长
 if(oldImg_WID > oldImg_HEI){
  //宽度大于高度
  oldImg_HEI = (KCompressibilityFactor * oldImg_HEI)/oldImg_WID;
  oldImg_WID = KCompressibilityFactor;
 }else{
  oldImg_WID = (KCompressibilityFactor * oldImg_WID)/oldImg_HEI;
  oldImg_HEI = KCompressibilityFactor;
 }
 }
 UIImage *newImg = [self imageWithImage:image scaledToSize:CGSizeMake(oldImg_WID, oldImg_HEI)];
 NSData *dJpeg = nil;
 if (UIImagePNGRepresentation(newImg)==nil) {
 dJpeg = UIImageJPEGRepresentation(newImg, 0.5);
 }else{
 dJpeg = UIImagePNGRepresentation(newImg);
 }
 return [UIImage imageWithData:dJpeg];
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
 UIGraphicsBeginImageContext(newSize);
 [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
 UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 return newImage;
}

@end
