//
//  takePictureViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/3/4.
//  Copyright © 2020 hs. All rights reserved.
//

#import "takePictureViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface takePictureViewController ()<AVCapturePhotoCaptureDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)  UIView *containerView;//内容视图
@property (nonatomic, retain) AVCaptureSession *session;
@property (nonatomic, retain) AVCaptureDeviceInput *input;
@property (nonatomic, retain) AVCaptureDevice *device;
@property (nonatomic, retain) AVCapturePhotoOutput *imageOutput;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, retain) AVCapturePhotoSettings *outputSettings;

//缩放
 ///记录开始的缩放比例
@property(nonatomic,assign) CGFloat minZoomFactor;
 ///最后的缩放比例
@property(nonatomic,assign) CGFloat maxZoomFactor;
@property (nonatomic,assign) CGFloat currentZoomFactor;

//
@property (nonatomic, strong) UIView *controlerView;
@property (nonatomic, strong) UIButton *shutter;
@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) UIButton *flashBtn;
//图片放大视图
@property (nonatomic,strong) UIScrollView *backGround;
@property (nonatomic,strong) UIImageView  *bigImage;

@end

@implementation takePictureViewController

- (UIView *)containerView{
    if (_containerView == nil) {
        _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, NavigationHeight*4/3, screen_width, screen_width*4/3)];
    }
    return _containerView;
}

- (UIView *)controlerView{
    if (_controlerView == nil) {
        _controlerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.containerView.frame), screen_width, screen_height-CGRectGetMaxY(self.containerView.frame))];
        //_controlerView.backgroundColor = [UIColor yellowColor];
    }
    return _controlerView;
}
//最小缩放值
- (CGFloat)minZoomFactor
{
    CGFloat minZoomFactor = 1.0;
    if (@available(iOS 11.0, *)) {
        minZoomFactor = self.device.minAvailableVideoZoomFactor;
    }
    return minZoomFactor;
}

//最大缩放值
- (CGFloat)maxZoomFactor
{
    CGFloat maxZoomFactor = self.device.activeFormat.videoMaxZoomFactor;
    if (@available(iOS 11.0, *)) {
        maxZoomFactor = self.device.maxAvailableVideoZoomFactor;
    }

    if (maxZoomFactor > 20.0) {
        maxZoomFactor = 20.0;
    }
    return maxZoomFactor;
}
- (UIButton *)flashBtn{
    if (_flashBtn == nil) {
        _flashBtn = [UIButton new];
    }
    return _flashBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initCameraInPosition:YES];
    [self initControlView];
    // Do any additional setup after loading the view.
}

- (void)initCameraInPosition:(BOOL)isBack {
    self.currentZoomFactor = 1.0;
    [self.view addSubview:self.containerView];
    self.session = [AVCaptureSession new];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    NSArray *devices = [NSArray new];
    devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (isBack) {
            if ([device position] == AVCaptureDevicePositionBack) {
                _device = device;
                break;
            }
        }else {
            if ([device position] == AVCaptureDevicePositionFront) {
                _device = device;
                break;
            }
        }
    }
    
    NSError *error;
    
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&error];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }

    self.imageOutput = [[AVCapturePhotoOutput alloc] init];
    NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
    _outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
    [self.imageOutput setPhotoSettingsForSceneMonitoring:_outputSettings];
    [self.session addOutput:self.imageOutput];
    
     //缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(ZoomByPinch:)];
    self.containerView.userInteractionEnabled = YES;
    [self.containerView addGestureRecognizer:pinchGestureRecognizer];

    
    self.preview = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.preview setFrame:CGRectMake(0, 0, screen_width, self.containerView.frame.size.height)];
    [self.containerView.layer addSublayer:self.preview];
    [self.session startRunning];
    
    
}
- (void)initControlView{
    [self.view addSubview:self.controlerView];
    self.flashBtn.frame = CGRectMake(screen_width/2-NavigationBarH/3, NavigationBarH/6, NavigationBarH*2/3, NavigationBarH*2/3);
    [self.flashBtn setImage:[UIImage imageNamed:@"icon_flashG"] forState:UIControlStateNormal];
    [self.flashBtn addTarget:self action:@selector(clickToFlash) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.flashBtn];
    //快门
    self.shutter = [[UIButton alloc]initWithFrame:CGRectMake(screen_width/2-screen_width*9/100, self.controlerView.frame.size.height/3-screen_width/10, screen_width/5, screen_width/5)];
    [self.controlerView addSubview:_shutter];
    [self.shutter setBackgroundImage:[UIImage imageNamed:@"icon_takePhoto"] forState:UIControlStateNormal];
    [self.shutter addTarget:self action:@selector(clickToCapture) forControlEvents:UIControlEventTouchUpInside];
    //预览
    self.pictureView = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width/20, self.controlerView.frame.size.height/3-screen_width*4/50, screen_width*4/25, screen_width*4/25)];
    self.pictureView.layer.cornerRadius = self.pictureView.frame.size.width/8;
    self.pictureView.backgroundColor = [UIColor grayColor];
    [self.controlerView addSubview:self.pictureView];
    self.pictureView.userInteractionEnabled = YES;
    UITapGestureRecognizer *pictureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToCheckPhoto)];
    [self.pictureView addGestureRecognizer:pictureRecognizer];
    
    
    //确定
    self.finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(screen_width*4/5, self.controlerView.frame.size.height/3-screen_width*4/50, screen_width*4/25, screen_width*4/25)];
    [_finishBtn setTitle:@"TAKE" forState:UIControlStateNormal];
    [self.controlerView addSubview:_finishBtn];
    [self.finishBtn addTarget:self action:@selector(clickToFinish) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - 控制区功能
//点击拍照
- (void)clickToCapture{
    NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
    AVCapturePhotoSettings *outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
    [self.imageOutput capturePhotoWithSettings:outputSettings delegate:self];
}
//点击确定
- (void)clickToFinish{
    self.photoBlock(self.pictureView.image);
    [self.navigationController popViewControllerAnimated:YES];
}

//打开闪光灯
- (void)clickToFlash{
    [self.device lockForConfiguration:nil];
    if (self.device.torchMode == AVCaptureTorchModeOff) {
        [self.device setTorchMode:AVCaptureTorchModeOn];
        [self.flashBtn setImage:[UIImage imageNamed:@"icon_flashW"] forState:UIControlStateNormal];
    }else{
        [self.device setTorchMode:AVCaptureTorchModeOff];
        [self.flashBtn setImage:[UIImage imageNamed:@"icon_flashG"] forState:UIControlStateNormal];
    }
    [self.device unlockForConfiguration];
}

//双指手势缩放
- (void)ZoomByPinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan ||
           pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
       {
           CGFloat currentZoomFactor = self.currentZoomFactor * pinchGestureRecognizer.scale;
           
           if (currentZoomFactor < self.maxZoomFactor &&
               currentZoomFactor > self.minZoomFactor){
               
               NSError *error = nil;
               if ([self.device lockForConfiguration:&error] ) {
                   self.device.videoZoomFactor = currentZoomFactor;
                   [self.device unlockForConfiguration];
               } else {
                   NSLog( @"Could not lock device for configuration: %@", error );
               }
           }
       }
}
//点击预览图查看图片
- (void)clickToCheckPhoto{
    self.navigationController.navigationBar.hidden = YES;   //隐藏导航栏
    [UIApplication sharedApplication].statusBarHidden = YES;             //隐藏状态栏
    [self.view endEditing:YES];
       //底层视图
    self.backGround = [[UIScrollView alloc]init];
    _backGround.backgroundColor = [UIColor blackColor];
    _backGround.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    _backGround.frame = self.view.frame;
    _backGround.showsHorizontalScrollIndicator = NO;
    _backGround.showsVerticalScrollIndicator = NO;
    _backGround.multipleTouchEnabled = YES;
    _backGround.maximumZoomScale = 5;
    _backGround.minimumZoomScale = 1;
    _backGround.delegate = self;

    self.bigImage = [[UIImageView alloc]init];
    _bigImage.frame = self.view.frame;
    _bigImage.image = self.pictureView.image;
    _bigImage.userInteractionEnabled = YES;
    _bigImage.contentMode = UIViewContentModeScaleAspectFit;
    _bigImage.clipsToBounds = YES;
    UITapGestureRecognizer *shrinkRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shirnkPhoto)];
    [shrinkRecognizer setNumberOfTapsRequired:1];
    [_bigImage addGestureRecognizer:shrinkRecognizer];
    //添加双击事件
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [_bigImage addGestureRecognizer:doubleTapGesture];
    [shrinkRecognizer requireGestureRecognizerToFail:doubleTapGesture];
    [_backGround addSubview:self.bigImage];
    [self.view addSubview:self.backGround];
}

#pragma mark UIScrollerViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.bigImage;
}

/**双击定点放大*/
- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    CGFloat zoomScale = self.backGround.zoomScale;
    NSLog(@"%f",self.backGround.zoomScale);
    zoomScale = (zoomScale == 1.0) ? 3.0 : 1.0;
    CGRect zoomRect = [self zoomRectForScale:zoomScale withCenter:[gesture locationInView:gesture.view]];
    [self.backGround zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height =self.view.frame.size.height / scale;
    zoomRect.size.width  =self.view.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}

//点击缩小视图
- (void)shirnkPhoto{
    [self.backGround removeFromSuperview];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
}

#pragma mark - AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error{
    NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *image = [UIImage imageWithData:data];
    self.pictureView.image = [self fixOrientation:image];
       //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    NSLog(@"+++++++++++%@", msg);
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

- (void)viewWillDisappear:(BOOL)animated{
    [self.session stopRunning];
    self.session = nil;
    [self.flashBtn removeFromSuperview];
}

@end
