////
////  fosaPhotoViewController.m
////  FOSAapp1.0
////
////  Created by hs on 2020/2/9.
////  Copyright © 2020 hs. All rights reserved.
////
//
//#import "fosaPhotoViewController.h"
//#import "QRCodeScanViewController.h"
//#import "PhotoViewController.h"
//#import "PhotoViewController1.h"
//#import "PhotoViewController2.h"
//#import "FoodViewController.h"
//
//@interface fosaPhotoViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
//
//@property (nonatomic,strong) UIPageViewController *pageViewController;
//@property (nonatomic,strong) UIPageControl *pageControl;
//
//@property (nonatomic,strong) PhotoViewController  *photo;
//@property (nonatomic,strong) PhotoViewController1 *photo1;
//@property (nonatomic,strong) PhotoViewController2 *photo2;
//
//@property (nonatomic,strong) NSMutableArray<UIImage *> *imageArray;
//@property (nonatomic,strong) NSMutableArray<UIViewController *> *controllersArray;
//@end
//
//@implementation fosaPhotoViewController
//
///**延迟加载*/
//- (NSMutableArray<UIViewController *> *)controllersArray{
//    if (_controllersArray == nil) {
//        _controllersArray = [[NSMutableArray alloc]init];
//    }
//    return _controllersArray;
//}
//- (UIPageViewController *)pageViewController{
//    if (_pageViewController == nil) {
//        NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:1] forKey:UIPageViewControllerOptionInterPageSpacingKey];
//              _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:option];
//              _pageViewController.delegate = self;
//              _pageViewController.dataSource = self;
//    }
//    return _pageViewController;
//}
//- (PhotoViewController *)photo{
//    if (_photo == nil) {
//        _photo = [[PhotoViewController alloc]init];
//    }
//    return _photo;
//}
//
//- (PhotoViewController1 *)photo1{
//    if (_photo1 == nil) {
//        _photo1 = [[PhotoViewController1 alloc]init];
//    }
//    return _photo1;
//}
//- (PhotoViewController2 *)photo2{
//    if (_photo2 == nil) {
//        _photo2 = [[PhotoViewController2 alloc]init];
//    }
//    return _photo2;
//}
//- (UIPageControl *)pageControl{
//    if (_pageControl == nil) {
//        _pageControl = [[UIPageControl alloc]init];
//    }
//    return _pageControl;
//}
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self InitArray];
//    [self CreatNavigationBar];
//    [self InitContentView];
//    [self PageControlInit];
//}
//- (void)InitArray{
//    UIImage *image  = [UIImage imageNamed:@"icon_logoHL"];
//    UIImage *image1 = [UIImage imageNamed:@"icon_logoHL"];
//    UIImage *image2 = [UIImage imageNamed:@"icon_logoHL"];
//    _imageArray = [[NSMutableArray alloc]init];
//    [_imageArray addObject:image];
//    [_imageArray addObject:image1];
//    [_imageArray addObject:image2];
//}
//- (void)CreatNavigationBar{
//    self.navigationItem.title = @"Photo";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_scan"] style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.rightBarButtonItem.target = self;     self.navigationItem.rightBarButtonItem.action = @selector(ScanEvent);
//}
//-(void)InitContentView{
//    [self.controllersArray addObject:self.photo];
//    self.photo.imageArray = self.imageArray;
//    [self.controllersArray addObject:self.photo1];
//    self.photo1.imageArray1 = self.imageArray;
//    [self.controllersArray addObject:self.photo2];
//    self.photo2.imageArray2 = self.imageArray;
//    NSArray *showArray = [NSArray arrayWithObject:self.controllersArray[0]];
//    [self.pageViewController setViewControllers:showArray direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//    
//    [self addChildViewController:self.pageViewController];
//    [self.view addSubview:self.pageViewController.view];
//    [self PageControlInit];
//}
//#pragma mark 返回上一个ViewController对象
//- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
//               viewControllerBeforeViewController:(UIViewController *)viewController{
//    
//    NSInteger index = [self.controllersArray indexOfObject:viewController];
//    self.pageControl.currentPage = index;
//
//    index --;
//    if (index < 0 || index == NSNotFound) {
//        return nil;
//    }
//    return self.controllersArray[index];
//}
//#pragma mark 返回下一个ViewController对象
//- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
//                viewControllerAfterViewController:(UIViewController *)viewController{
//    NSInteger index = [self.controllersArray indexOfObject:viewController];
//    self.pageControl.currentPage = index;
//    index ++;
//    if (index >= self.controllersArray.count) {
//        return nil;
//    }
//    return self.controllersArray[index];
//}
//- (void)PageControlInit{
//    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3, self.view.frame.size.height-50, self.view.frame.size.width/3, 50)];
//    _pageControl.numberOfPages = 3;
//    _pageControl.pageIndicatorTintColor = FOSAWhite;
//    _pageControl.currentPageIndicatorTintColor = FOSAgreen;
//    [self.view addSubview:self.pageControl];
//    //[self.navigationController.navigationBar bringSubviewToFront:_pageControl];
//}
//- (void)stopRunning{
//    [_photo.captureSession stopRunning];
//    [_photo1.captureSession stopRunning];
//    [_photo2.captureSession stopRunning];
//}
//#pragma mark - 进入扫码界面
//-(void)ScanEvent{
////    NSLog(@"***************%@",_imageArray);
////    FoodViewController *food = [[FoodViewController alloc]init];
////    food.food_image = self.imageArray;
////    food.hidesBottomBarWhenPushed = YES;
//    
//    QRCodeScanViewController *scan = [[QRCodeScanViewController alloc]init];
//    scan.food_photo = [[NSMutableArray alloc]init];
//    scan.food_photo = self.imageArray;
//    [self stopRunning];
//    scan.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:scan animated:YES];
//    [self.navigationController popoverPresentationController];
//    
//}
//
///**隐藏底部横条，点击屏幕可显示*/
//- (BOOL)prefersHomeIndicatorAutoHidden{
//    return YES;
//}
//
//
//@end
