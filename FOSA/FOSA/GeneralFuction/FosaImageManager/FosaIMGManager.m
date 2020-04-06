//
//  FosaIMGManager.m
//  FOSA
//
//  Created by hs on 2020/4/6.
//  Copyright © 2020 hs. All rights reserved.
//

#import "FosaIMGManager.h"

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

//纠正图片的方向
- (UIImage *)fixOrientation:(UIImage *)aImage {
// No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
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
