//
//  FosaIMGManager.h
//  FOSA
//
//  Created by hs on 2020/4/6.
//  Copyright © 2020 hs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FosaIMGManager : NSObject

- (void)InitImgManager;

- (BOOL)savePhotoWithImage:(UIImage *)img name:(NSString *)imgName;
- (void)savePhotosWithImages:(NSMutableArray<UIImage *> *)imgs name:(NSString *)imgName;
- (UIImage *)getImgWithName:(NSString *)imgName;
- (void)deleteImgWithName:(NSString *)imgName;

- (UIImage *)saveViewAsPictureWithView:(UIView *)view;
- (UIImage *)GenerateQrcodeWithLogo:(UIImage *)logo Message:(NSString *)message;
- (UIImage *)GenerateQRCodeByMessage:(NSString *)message;
+ (UIImage *)GenerateQRCodeWithIcon:(UIImage *)centerIcon Message:(NSString *)message;
- (UIImage *)fixOrientation:(UIImage *)aImage;
@end

NS_ASSUME_NONNULL_END
