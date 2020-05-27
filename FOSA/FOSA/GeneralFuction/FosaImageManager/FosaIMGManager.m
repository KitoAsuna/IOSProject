//
//  FosaIMGManager.m
//  FOSA
//
//  Created by hs on 2020/4/6.
//  Copyright © 2020 hs. All rights reserved.
//

#import "FosaIMGManager.h"
#import <CoreImage/CoreImage.h>

@interface FosaIMGManager(){
    NSArray *paths;
}
@end

@implementation FosaIMGManager
- (void)InitImgManager{
    paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
}
- (BOOL)savePhotoWithImage:(UIImage *)img name:(NSString *)imgName{
    NSString *photoName = [NSString stringWithFormat:@"%@.png",imgName];
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent: photoName];// 保存文件的路径
    BOOL result =[UIImagePNGRepresentation(img) writeToFile:filePath  atomically:YES];// 保存成功会返回YES
    return result;
}
- (void)savePhotosWithImages:(NSMutableArray<UIImage *> *)imgs name:(nonnull NSString *)imgName{
    NSLog(@"%@",imgs);
    if (imgs.count > 0) {
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        for (int i = 0; i < imgs.count; i++) {
            NSString *photoName = [NSString stringWithFormat:@"%@%d.png",imgName,i+1];
            NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent: photoName];// 保存文件的路径
            NSLog(@"这个是照片的保存地址:%@",filePath);
            UIImage *img = imgs[i];//[self fixOrientation:images[i]];
            BOOL result =[UIImagePNGRepresentation(img) writeToFile:filePath  atomically:YES];// 保存成功会返回YES
            if(result == YES) {
                NSLog(@"保存成功");
            }
        }
    }
}

- (UIImage *)getImgWithName:(NSString *)imgName{
    NSString *photopath = [NSString stringWithFormat:@"%@.png",imgName];
    NSString *imagePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",photopath]];
    // 保存文件的名称
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    return img;
}

- (void)deleteImgWithName:(NSString *)imgName{
    NSString *photo = [NSString stringWithFormat:@"%@.png",imgName];
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
- (UIImage *)saveViewAsPictureWithView:(UIView *)view{
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 4);
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

// 将二维码转成高清的格式
//- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
//
//    CGRect extent = CGRectIntegral(image.extent);
//    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
//    // 1.创建bitmap;
//    size_t width = CGRectGetWidth(extent) * scale;
//    size_t height = CGRectGetHeight(extent) * scale;
//    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
//    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
//    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
//    CGContextScaleCTM(bitmapRef, scale, scale);
//    CGContextDrawImage(bitmapRef, extent, bitmapImage);
//
//    // 2.保存bitmap到图片
//    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
//    UIImage *resultImg = [UIImage imageWithCGImage:scaledImage];
//    CGContextRelease(bitmapRef);
//    CGImageRelease(bitmapImage);
//    CGColorSpaceRelease(cs);
//    CGImageRelease(scaledImage);
//    return resultImg;
//}

typedef NS_OPTIONS(NSUInteger, QRCodeLogoType) {
    QRCodeLogoType_Default = 0,//默认无圆角logo
    QRCodeLogoType_Round   = 1,//正圆logo
    QRCodeLogoType_Radius  = 2 //圆角的logo
};

+ (UIImage *)createNewImage:(UIImage *)theImage logoImage:(UIImage *)logoImage logoType:(QRCodeLogoType)logoType{
    float width = 400;
    float height = width * (theImage.size.height / theImage.size.width);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width,height)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *bacImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width,height)];
    bacImageView.image = theImage;
    bacImageView.backgroundColor = [UIColor whiteColor];
    [view addSubview:bacImageView];

    int width_logo = width/4;
    UIView *logoBacView = [[UIView alloc]initWithFrame:CGRectMake((width - width_logo)/2 , (height - width_logo)/2, width_logo + 20,width_logo + 20)];
    logoBacView.backgroundColor = [UIColor whiteColor];
    logoBacView.layer.masksToBounds = YES;
    [bacImageView addSubview:logoBacView];
    UIImageView *centerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, width_logo,width_logo)];
    centerImgView.image = logoImage;
    centerImgView.layer.masksToBounds = YES;
    centerImgView.backgroundColor = [UIColor whiteColor];
    [logoBacView addSubview:centerImgView];
    //设置圆角
    float radius = 0;
    float radius_img = 0;
    if (logoType == QRCodeLogoType_Round) {
        radius = (width_logo + 10)/2;
        radius_img = width_logo/2;
    }else if (logoType == QRCodeLogoType_Radius){
        radius = 15;
        radius_img = 15;
    }else {
        radius = 0;
        radius_img = 0;
    }
    logoBacView.layer.cornerRadius = radius;
centerImgView.layer.cornerRadius = radius_img;
 //生成图片
    UIImage *img = [self snapshotViewFromRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) withCapInsets:UIEdgeInsetsZero layer:view.layer];
    return img;
}
//生成的图片
+ (UIImage *)snapshotViewFromRect:(CGRect)rect withCapInsets:(UIEdgeInsets)capInsets layer:(CALayer *)theLayer{

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);

    CGContextRef currentContext = UIGraphicsGetCurrentContext();

    [theLayer renderInContext:currentContext];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();

    NSData * data = UIImageJPEGRepresentation(snapshotImage, 1);
    UIGraphicsEndImageContext();
    UIImage *img = [UIImage imageWithData:data];
    return img;
}

//得到二维码打印图片的二维码
+ (UIImage *)GenerateQRCodeWithIcon:(UIImage *)centerIcon Message:(NSString *)message{
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    // 2. 给滤镜添加数据
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    //放大图片
    image = [image imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    //将CIImage类型转换成UIImage类型
    // 转成高清格式
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:image withSize:200];
    //生成图片，并获取上下文，得到一个带头像的二维码图片
    qrcode = [self createNewImage:qrcode logoImage:centerIcon logoType:1];
    //返回二维码图像
    return qrcode;
}

// 将二维码转成高清的格式
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
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
       UIImage *resultImg = [UIImage imageWithCGImage:scaledImage];
       CGContextRelease(bitmapRef);
       CGImageRelease(bitmapImage);
       CGColorSpaceRelease(cs);
       CGImageRelease(scaledImage);
       return resultImg;
}
//纠正图片的方向
- (UIImage *)fixOrientation:(UIImage *)aImage {
// No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp){
        NSLog(@"不需要纠正");
        return aImage;
    }
        
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
     switch (aImage.imageOrientation) {
         case UIImageOrientationDown:
         case UIImageOrientationDownMirrored:
             transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
             transform = CGAffineTransformRotate(transform, M_PI);
             break;
         case UIImageOrientationLeft:
         case UIImageOrientationLeftMirrored:
             transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
             transform = CGAffineTransformRotate(transform, M_PI_2);
             break;
         case UIImageOrientationRight:
         case UIImageOrientationRightMirrored:
             transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
             transform = CGAffineTransformRotate(transform, -M_PI_2);
             break;
         default:
             break;
     }
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
     CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,CGImageGetBitsPerComponent(aImage.CGImage), 0,CGImageGetColorSpace(aImage.CGImage),CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }

// And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
