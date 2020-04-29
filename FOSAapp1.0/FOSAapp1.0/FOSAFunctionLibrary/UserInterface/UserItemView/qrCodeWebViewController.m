//
//  qrCodeWebViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/3/17.
//  Copyright © 2020 hs. All rights reserved.
//

#import "qrCodeWebViewController.h"
#import <WebKit/WebKit.h>
#import "qrSelectorViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface qrCodeWebViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSMutableArray<NSString *> *defaultArray,*qrData,*sizeData,*colorData;
    NSInteger currentIndex;
    int qrkind;
    
}
//@property(nonatomic,strong) WKWebView *qrWebView;
//@property (nonatomic,strong) UIProgressView *progressView;
//缓冲图标
@property (nonatomic,strong) UIActivityIndicatorView *FOSAloadingView;
@end

@implementation qrCodeWebViewController
#pragma mark - 延迟加载

- (UIScrollView *)preview{
    if (_preview == nil) {
        _preview = [UIScrollView new];
    }
    return _preview;
}

- (UIButton *)printBtn{
    if (_printBtn == nil) {
        _printBtn = [UIButton new];
    }
    return _printBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //[self creatWebView];
    [self InitData];
    [self creatQrGenerator];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.qrTable reloadData];
}

- (void)InitData{
    NSArray *array = @[@"3R(5x6)",@"Black & White",@"0",@"0",@"0",@"0"];
    NSArray *array2 = @[@"Page size",@"Color",@"L1",@"L2",@"L3",@"L4"];
    NSArray *array3   = @[@"3R(5x6)",@"4R(6x8)",@"5R(7x9)",@"6R(9x10)",@"A4(12x15)",@"LETTER(12x15)"];
    NSArray *array4  = @[@"Black & White",@"Colours"];
    defaultArray = [NSMutableArray arrayWithArray:array];
    qrData = [NSMutableArray arrayWithArray:array2];
    sizeData = [NSMutableArray arrayWithArray:array3];
    colorData = [NSMutableArray arrayWithArray:array4];
    qrkind = 0;
}
- (void)creatQrGenerator{
    [self creatPreview];

    self.qrTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.preview.frame)+Height(10), screen_width, Height(50)*qrData.count) style:UITableViewStylePlain];
    self.qrTable.delegate = self;
    self.qrTable.dataSource = self;
    self.qrTable.bounces = NO;
    self.qrTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.qrTable];
    
    self.printBtn.frame = CGRectMake(screen_width/3, CGRectGetMaxY(self.qrTable.frame)+Height(25), screen_width/3, Height(40));
    self.printBtn.layer.cornerRadius = Height(20);
    [self.printBtn setTitle:@"Download" forState:UIControlStateNormal];
    [self.printBtn setTitleColor:FOSABlue forState:UIControlStateNormal];
    [self.printBtn setTitleColor:FOSABlueHL forState:UIControlStateHighlighted];
    self.printBtn.backgroundColor = FOSAGray;
    [self.printBtn addTarget:self action:@selector(getPhotoFromServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.printBtn];
}
- (void)creatPreview{
    self.preview.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), screen_width, screen_height*2/7);
    self.preview.pagingEnabled = YES;
    self.preview.delegate = self;
    self.preview.showsHorizontalScrollIndicator = NO;
    self.preview.showsVerticalScrollIndicator = NO;
    self.preview.alwaysBounceVertical = NO;
    self.preview.contentSize = CGSizeMake(screen_width*3, 0);
    
    [self.view addSubview:self.preview];
    for (int i = 0; i < 5; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*screen_width, 0, self.preview.frame.size.width, self.preview.frame.size.height)];
        imageView.image = [UIImage imageNamed:@"IMG_qrPreview"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.preview addSubview:imageView];
    }
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(screen_width*2/5, CGRectGetMaxY(self.preview.frame)-Height(15), screen_width/5, 10)];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 3;
    self.pageControl.pageIndicatorTintColor = FOSAFoodBackgroundColor;
    self.pageControl.currentPageIndicatorTintColor = FOSAgreen;
    [self.view addSubview:self.pageControl];
}

- (void)getPhotoFromServer{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:nil preferredStyle:UIAlertControllerStyleAlert];
    if (qrkind == 0) {
        alert.message = @"Please choose print quantity first!";
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self CreatLoadView];
        ///1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //下载图片
        NSString *cc = [NSString stringWithFormat:@"%ld",[colorData indexOfObject:defaultArray[1]]];
        NSString *s  = [NSString stringWithFormat:@"%ld",[sizeData indexOfObject:defaultArray[0]]];
        
        
        NSString *Addr = [NSString stringWithFormat:@"https://fosahome.com/qrlabel/?cc=%@&s=%@&l1=%@&l2=%@&l3=%@&l4=%@&l9=0&g=2&j=1",cc,s,defaultArray[2],defaultArray[3],defaultArray[4],defaultArray[5]];
        NSLog(@"API:%@",Addr);
        
         [manager GET:Addr parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog(@"success--%@--%@",[responseObject class],responseObject);
             [self.FOSAloadingView stopAnimating];
             NSString *imgPath = responseObject[@"file"];
             [self downLoadImg:imgPath];
             

         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"failure--%@",error);
             [self.FOSAloadingView stopAnimating];
         }];
    }
}
- (void)downLoadImg:(NSString *)imgAddr{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 100.0f, 100.0f, 100.0f)];

    [imageView setImageWithURL:[NSURL URLWithString:imgAddr] placeholderImage:[UIImage imageNamed:@"qrcode"]];
    UIImage *image = imageView.image;
    NSLog(@"%@",image);
    UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
[self.view addSubview:imageView];
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
    }
}

- (void)CreatLoadView{
    //self.loadView
    if (@available(iOS 13.0, *)) {
        if (_FOSAloadingView == nil) {
           self.FOSAloadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleLarge)];
        }
    } else {
        self.FOSAloadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleMedium)];
    }
    [self.view addSubview:self.FOSAloadingView];
    //设置小菊花的frame
    self.FOSAloadingView.frame= CGRectMake(0, 0, 200, 200);
    self.FOSAloadingView.center = self.view.center;
    //设置小菊花颜色
    self.FOSAloadingView.color = FOSAgreen;
    //设置背景颜色
    self.FOSAloadingView.backgroundColor = [UIColor clearColor];
//刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    self.FOSAloadingView.hidesWhenStopped = YES;
    [self.FOSAloadingView startAnimating];
}


#pragma mark -UIScrollerViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    currentIndex = offset/screen_width;
    self.pageControl.currentPage = currentIndex;
}

#pragma mark -UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Height(50);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return qrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"qrcell";
       //初始化cell，并指定其类型
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        //创建cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    NSInteger row = indexPath.row;
    //取消点击cell时显示的背景
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:20*(([UIScreen mainScreen].bounds.size.width/414.0))];
    cell.textLabel.text = qrData[row];
    cell.backgroundColor = FOSAWhite;
    switch (row) {
        case 0:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
        case 3:
        case 4:
        case 5:
            if (![defaultArray[row] isEqualToString:@"0"]) {
                defaultArray[row] = [NSString stringWithFormat:@"%d",24/qrkind];
            }
            break;
        default:
            break;
    }
    cell.detailTextLabel.text = defaultArray[row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger row = indexPath.row;
    //cell.backgroundColor = [UIColor grayColor];
    NSLog(@"%ld",row);
    if (row == 0) {
        qrSelectorViewController *selector = [qrSelectorViewController new];
        selector.selectData = sizeData;
        selector.current = cell.detailTextLabel.text;
        selector.navigationItem.title = @"Page Size";
        selector.seletBlock = ^(NSString * _Nonnull selector) {
            self->defaultArray[row] = selector;
        };
        [self.navigationController pushViewController:selector animated:YES];
    }else if (row == 1){
        qrSelectorViewController *selector = [qrSelectorViewController new];
        selector.selectData = colorData;
        selector.current = cell.detailTextLabel.text;
        selector.navigationItem.title = @"Color";
        selector.seletBlock = ^(NSString * _Nonnull selector) {
            self->defaultArray[row] = selector;
        };
        [self.navigationController pushViewController:selector animated:YES];
    }else{
        switch (row) {
            case 2:
            case 3:
            case 4:
            case 5:
                if ([defaultArray[row] isEqualToString:@"0"]) {
                    qrkind ++;
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    defaultArray[row] = [NSString stringWithFormat:@"%d",24/qrkind];
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    qrkind --;
                    defaultArray[row] = @"0";
                }
                    break;
            default:
                break;
        }
        [self.qrTable reloadData];
    }
    
}
//
//- (void)creatWebView{
//    //创建网络配置对象
//    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
//    self.qrWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NavigationBarH, screen_width, screen_height-NavigationBarH) configuration:config];
//    self.qrWebView.UIDelegate = self;
//    self.qrWebView.navigationDelegate = self;
//    self.qrWebView.allowsBackForwardNavigationGestures = YES;
//
//    WKPreferences *prefrences = [WKPreferences new];
//    //最小字体大小
//    prefrences.minimumFontSize = 0;
//    //设置支持JavaScript,默认支持
//    prefrences.javaScriptEnabled = YES;
//    //在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
//    prefrences.javaScriptCanOpenWindowsAutomatically = YES;
//    config.preferences = prefrences;
//
//    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
//    config.allowsInlineMediaPlayback = YES;
//    //config.allowsAirPlayForMediaPlayback = YES;
//    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
//    config.mediaTypesRequiringUserActionForPlayback = YES;
//    //设置是否允许画中画技术 在特定设备上有效
//    config.allowsPictureInPictureMediaPlayback = YES;
//    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
//    config.applicationNameForUserAgent = @"ChinaDailyForiPad";
//
//    [self.qrWebView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];//https://fosahome.com/qrlabel/////https://www.bilibili.com
//    NSLog(@"%@",self.urlString);
//    [self.view addSubview:self.qrWebView];
//
//    //加载进度条
//    //进度条高度不可修改
//    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(50, screen_height/2, screen_width-100, 40)];
//    //设置进度条的颜色
//    self.progressView.progressTintColor = [UIColor blueColor];
//    //设置进度条的当前值，范围：0~1；
//    self.progressView.progress = 0;
//    self.progressView.progressViewStyle = UIProgressViewStyleDefault;
//    [self.view addSubview:self.progressView];
//    //添加观察者
//    [self.qrWebView addObserver:self forKeyPath:@"estimatedProgress" options:0 context:nil];
//}
//
//   //kvo 监听进度 必须实现此方法
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
//        && object == self.qrWebView) {
//       NSLog(@"网页加载进度 = %f",self.qrWebView.estimatedProgress);
//        self.progressView.progress = self.qrWebView.estimatedProgress;
//        if (self.qrWebView.estimatedProgress >= 1.0f) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.progressView.progress = 0;
//            });
//        }
//    }else if([keyPath isEqualToString:@"title"]
//             && object == self.qrWebView){
//        self.navigationItem.title = self.qrWebView.title;
//    }else{
//        [super observeValueForKeyPath:keyPath
//                             ofObject:object
//                               change:change
//                              context:context];
//    }
//}
//    // 页面开始加载时调用
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
//    NSLog(@"开始加载");
//}
//// 页面加载失败时调用
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"%@",error);
//    [self.navigationController popViewControllerAnimated:YES];
//}
// // 页面加载完成之后调用
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    NSLog(@"加载完成");
//    //[self.qrWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
//    [self.progressView removeFromSuperview];
//}
@end
