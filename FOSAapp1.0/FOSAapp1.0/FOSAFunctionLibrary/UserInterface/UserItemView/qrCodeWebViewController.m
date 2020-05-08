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
#import "qrTypeView.h"
#import "FosaIMGManager.h"

@interface qrCodeWebViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSMutableArray<NSString *> *qrData,*sizeData,*colorData,*counter,*previewData;
    NSInteger currentIndex,selectColor;
    int qrkind;
    FosaIMGManager *imgManager;

}
//@property(nonatomic,strong) WKWebView *qrWebView;
//@property (nonatomic,strong) UIProgressView *progressView;
//缓冲图标
@property (nonatomic,strong) UIActivityIndicatorView *FOSAloadingView;

//qrcode种类view
@property (nonatomic,strong) qrTypeView *type1,*type2,*type3,*type4;
//图片轮播器
@property (nonatomic,strong) UIImageView *imageview1,*imageview2,*imageview3,*imageview4,*imageview5;
@property (nonatomic,strong) NSMutableArray<UIImageView *> *imageviewArray;
@end

@implementation qrCodeWebViewController
#pragma mark - 延迟加载
- (UIImageView *)imageview1{
    if (_imageview1 == nil) {
        _imageview1 = [UIImageView new];
    }
    return _imageview1;
}

- (UIImageView *)imageview2{
    if (_imageview2 == nil) {
        _imageview2 = [UIImageView new];
    }
    return _imageview2;
}


- (UIImageView *)imageview3{
    if (_imageview3 == nil) {
        _imageview3 = [UIImageView new];
    }
    return _imageview3;
}

- (UIImageView *)imageview4{
    if (_imageview4 == nil) {
        _imageview4 = [UIImageView new];
    }
    return _imageview4;
}

- (UIImageView *)imageview5{
    if (_imageview5 == nil) {
        _imageview5 = [UIImageView new];
    }
    return _imageview5;
}

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

    //NSArray *array = @[@"3R(5x6)",@"Black & White",@"0",@"0",@"0",@"0"];
    NSArray *array2 = @[@"Page size",@"Color",@"L1",@"L2",@"L3",@"L4"];
    NSArray *array3   = @[@"3R(5x6)",@"4R(6x8)",@"5R(7x9)",@"6R(9x10)",@"A4(12x15)",@"LETTER(12x15)"];
    NSArray *array4  = @[@"Black & White",@"Colours"];
    NSArray *array5  = @[@"0",@"0",@"0",@"0"];
    NSArray *array6  = @[@"IMG_A4",@"IMG_A4",@"IMG_A4",@"IMG_A4",@"IMG_A4"];
    //defaultArray = [NSMutableArray arrayWithArray:array];
    qrData = [NSMutableArray arrayWithArray:array2];
    sizeData = [NSMutableArray arrayWithArray:array3];
    colorData = [NSMutableArray arrayWithArray:array4];
    counter = [NSMutableArray arrayWithArray:array5];
    previewData = [NSMutableArray arrayWithArray:array6];
    qrkind = 0;
    selectColor = 0;
    currentIndex = 0;
    self.imageviewArray = [[NSMutableArray alloc]initWithObjects:self.imageview1,self.imageview2,self.imageview3,self.imageview4,self.imageview5,nil];
    
}
- (void)creatQrGenerator{
    [self creatPreview];

    self.qrTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.preview.frame)+Height(10), screen_width, Height(50)) style:UITableViewStylePlain];
    self.qrTable.delegate = self;
    self.qrTable.dataSource = self;
    self.qrTable.bounces = NO;
    self.qrTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.qrTable];
    
    
    int typeHeight = screen_height-CGRectGetMaxY(self.qrTable.frame);
    
    self.type1 = [[qrTypeView alloc]initWithFrame:CGRectMake(screen_width/12, CGRectGetMaxY(self.qrTable.frame)+screen_width/24, screen_width*19/48, typeHeight/4)];
    self.type1.qrTypeImgView.image = [UIImage imageNamed:@"type1"];
    self.type1.backgroundColor = FOSAColor(242, 242, 242);
    self.type2 = [[qrTypeView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.type1.frame)+screen_width/24, CGRectGetMaxY(self.qrTable.frame)+screen_width/24, screen_width*19/48, typeHeight/4)];
    self.type2.backgroundColor = FOSAColor(242, 242, 242);
    self.type2.qrTypeImgView.image = [UIImage imageNamed:@"type2"];
    self.type3 = [[qrTypeView alloc]initWithFrame:CGRectMake(screen_width/12, CGRectGetMaxY(self.type1.frame)+screen_width/24, screen_width*19/48, typeHeight/4)];
    self.type3.qrTypeImgView.image = [UIImage imageNamed:@"type3"];
    self.type3.backgroundColor = FOSAColor(242, 242, 242);
    self.type4 = [[qrTypeView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.type3.frame)+screen_width/24, CGRectGetMaxY(self.type2.frame)+screen_width/24, screen_width*19/48, typeHeight/4)];
    self.type4.qrTypeImgView.image = [UIImage imageNamed:@"type4"];
    self.type4.backgroundColor = FOSAColor(242, 242, 242);

    UITapGestureRecognizer *selectRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectType1)];

    self.type1.userInteractionEnabled = YES;
    [self.type1 addGestureRecognizer:selectRecognizer];
    
    UITapGestureRecognizer *selectRecognizer1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectType2)];
    self.type2.userInteractionEnabled = YES;
    [self.type2 addGestureRecognizer:selectRecognizer1];

    UITapGestureRecognizer *selectRecognizer2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectType3)];
    self.type3.userInteractionEnabled = YES;
    [self.type3 addGestureRecognizer:selectRecognizer2];

    UITapGestureRecognizer *selectRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectType4)];
    self.type4.userInteractionEnabled = YES;
    [self.type4 addGestureRecognizer:selectRecognizer3];

    [self.view addSubview:self.type1];
    [self.view addSubview:self.type2];
    [self.view addSubview:self.type3];
    [self.view addSubview:self.type4];

    self.printBtn.frame = CGRectMake(screen_width/3, CGRectGetMaxY(self.type3.frame)+Height(25), screen_width/3, Height(40));
       self.printBtn.layer.cornerRadius = Height(20);
       [self.printBtn setTitle:@"Generate" forState:UIControlStateNormal];
       [self.printBtn setTitleColor:FOSAWhite forState:UIControlStateNormal];
       [self.printBtn setTitleColor:FOSABlueHL forState:UIControlStateHighlighted];
       self.printBtn.backgroundColor = FOSAgreen;
       [self.printBtn addTarget:self action:@selector(generateQrCodeImageOfA4) forControlEvents:UIControlEventTouchUpInside];
       [self.view addSubview:self.printBtn];
}

- (void)creatPreview{
    if (_preview == nil) {
        self.preview.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), screen_width, screen_width*3/4);
        self.preview.pagingEnabled = YES;
        self.preview.delegate = self;
        self.preview.showsHorizontalScrollIndicator = NO;
        self.preview.showsVerticalScrollIndicator = NO;
        self.preview.alwaysBounceVertical = NO;
        self.preview.contentSize = CGSizeMake(screen_width*5, 0);
        [self.view addSubview:self.preview];
    }
    for (int i = 0; i < 5; i++) {
        self.imageviewArray[i].frame = CGRectMake(i*screen_width, 0, self.preview.frame.size.width, self.preview.frame.size.height);
        if (selectColor == 1) {
            self.imageviewArray[i].image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Colour",previewData[i]]];
        }else{
            self.imageviewArray[i].image = [UIImage imageNamed:previewData[i]];
        }
        self.imageviewArray[i].contentMode = UIViewContentModeScaleAspectFit;
        [self.preview addSubview:self.imageviewArray[i]];
    }
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(screen_width*2/5, CGRectGetMaxY(self.preview.frame)-Height(10), screen_width/5, 5)];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 5;
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
        NSString *cc = [NSString stringWithFormat:@"%ld",selectColor];
        NSString *s  = [NSString stringWithFormat:@"%ld",currentIndex];
        
        
        NSString *Addr = [NSString stringWithFormat:@"https://fosahome.com/qrlabel/?cc=%@&s=%@&l1=%@&l2=%@&l3=%@&l4=%@&l9=0&g=2&j=1",cc,s,counter[0],counter[1],counter[2],counter[3]];
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
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 100.0f, 100.0f, 100.0f)];
//
//    [imageView setImageWithURL:[NSURL URLWithString:imgAddr] placeholderImage:[UIImage imageNamed:@"qrcode"]];
//    UIImage *image = [UIImage imageNamed:@"qrcode"];
//
//    NSLog(@"%@",image);
//    UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
//[self.view addSubview:imageView];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgAddr]];
    UIImage *image = [UIImage imageWithData:data]; // 取得图片
    NSLog(@"%@",image);
    UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
}

- (void)selectType1{
    if ([counter[0] isEqualToString:@"0"]) {
        self.type1.selectBox.image = [UIImage imageNamed:@"icon_select"];
        qrkind ++;
        counter[0] = [NSString stringWithFormat:@"%d",24/qrkind];
    }else{
        self.type1.selectBox.image = [UIImage imageNamed:@"icon_unselect"];
        counter[0] = @"0";
        qrkind --;
    }
    [self refreshCounter];
}
- (void)selectType2{
    if ([counter[1] isEqualToString:@"0"]) {
        qrkind ++;
        self.type2.selectBox.image = [UIImage imageNamed:@"icon_select"];
        counter[1] = [NSString stringWithFormat:@"%d",24/qrkind];
    }else{
        self.type2.selectBox.image = [UIImage imageNamed:@"icon_unselect"];
        counter[1] = @"0";
        qrkind --;
    }
    [self refreshCounter];
}
- (void)selectType3{

    if ([counter[2] isEqualToString:@"0"]) {
        qrkind ++;
        self.type3.selectBox.image = [UIImage imageNamed:@"icon_select"];
        counter[2] = [NSString stringWithFormat:@"%d",24/qrkind];
    }else{
        self.type3.selectBox.image = [UIImage imageNamed:@"icon_unselect"];
        counter[2] = @"0";
        qrkind --;
    }
    [self refreshCounter];
}
- (void)selectType4{
    if ([counter[3] isEqualToString:@"0"]) {
        self.type4.selectBox.image = [UIImage imageNamed:@"icon_select"];
        qrkind ++;
        counter[3] = [NSString stringWithFormat:@"%d",24/qrkind];
    }else{
        self.type4.selectBox.image = [UIImage imageNamed:@"icon_unselect"];
        counter[3] = @"0";
        qrkind --;
    }
    [self refreshCounter];
}
- (void)refreshCounter{
    for (int i = 0; i < 4; i++) {
        if (![counter[i] isEqualToString:@"0"]) {
            counter[i] = [NSString stringWithFormat:@"%d",24/qrkind];
        }
    }
    self.type1.qrCountLabel.text = [NSString stringWithFormat:@"x%@",counter[0]];
    self.type2.qrCountLabel.text = [NSString stringWithFormat:@"x%@",counter[1]];
    self.type3.qrCountLabel.text = [NSString stringWithFormat:@"x%@",counter[2]];
    self.type4.qrCountLabel.text = [NSString stringWithFormat:@"x%@",counter[3]];
}

/*
 生成二维码图片
 */
- (void)generateQrCodeImageOfA4{
    [self CreatLoadView];
    imgManager = [FosaIMGManager new];
    [imgManager InitImgManager];
   
    UIImageView *qrcodeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavigationBarH*3, screen_width, screen_width*(297.0/210))];
    qrcodeImage.backgroundColor = [UIColor blackColor];
    qrcodeImage.image = [UIImage imageNamed:@"IMG_usletterColour"];
    qrcodeImage.contentMode = UIViewContentModeScaleAspectFill;
    CGFloat height = qrcodeImage.frame.size.height;
    CGFloat width  = qrcodeImage.frame.size.width;
    for (int i = 0; i < 20; i++) {
        NSString *message = [NSString stringWithFormat:@"FS91000000000000000%d",i+1];
        UIImageView *qrview = [[UIImageView alloc]initWithFrame:CGRectMake(width*(25.5/210.0+(i%5)*34.95/210.0), height*(138.876/297.0+(i/5)*32.252/297.0), width*(19.5/210.0), height*(19.5/297.0))];
        //qrview.backgroundColor = FOSARed;
        qrview.image = [FosaIMGManager GenerateQRCodeWithIcon:[UIImage imageNamed:@"type1"] Message:message];
        //qrview.image = [imgManager GenerateQrcodeWithLogo:[UIImage imageNamed:@"type1"] Message:message];
        //qrview.contentMode = UIViewContentModeScaleAspectFit;
        [qrcodeImage addSubview:qrview];
    }
    UIImage *qrLabelImg = [imgManager saveViewAsPictureWithView:qrcodeImage];
    
    UIImageWriteToSavedPhotosAlbum(qrLabelImg, self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
    
}


#pragma mark - <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [self.FOSAloadingView stopAnimating];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    if(error || image == nil){
        alert.message = @"Error";
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        alert.message = @"Save success";
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
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
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"qrcell";
       //初始化cell，并指定其类型
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        //创建cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    //取消点击cell时显示的背景
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:20*(([UIScreen mainScreen].bounds.size.width/414.0))];
    cell.backgroundColor = FOSAWhite;
    cell.textLabel.text = colorData[selectColor];
    if (_colorSwitch == nil) {
        self.colorSwitch = [UISwitch new];
        self.colorSwitch.center = CGPointMake(screen_width-Width(40), cell.frame.size.height/2);
        [cell.contentView addSubview:self.colorSwitch];
        [self.colorSwitch addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventValueChanged];
    }
    return cell;
}
- (void)changeColor:(UISwitch *)sender{
    BOOL isButtonOn = [self.colorSwitch isOn];
    if (isButtonOn) {
        selectColor = 1;
    }else{
        selectColor = 0;
    }
    [self.qrTable reloadData];
    [self refreshPreview];
}
- (void)refreshPreview{
    for (int i = 0; i < 5; i++) {
        self.imageviewArray[i].frame = CGRectMake(i*screen_width, 0, self.preview.frame.size.width, self.preview.frame.size.height);
        if (selectColor == 1) {
            self.imageviewArray[i].image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Colour",previewData[i]]];
        }else{
            self.imageviewArray[i].image = [UIImage imageNamed:previewData[i]];
        }
          
    }
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSInteger row = indexPath.row;
//    //cell.backgroundColor = [UIColor grayColor];
//    NSLog(@"%ld",row);
//    if (row == 0) {
//        qrSelectorViewController *selector = [qrSelectorViewController new];
//        selector.selectData = sizeData;
//        selector.current = cell.detailTextLabel.text;
//        selector.navigationItem.title = @"Page Size";
//        selector.seletBlock = ^(NSString * _Nonnull selector) {
//            self->defaultArray[row] = selector;
//        };
//        [self.navigationController pushViewController:selector animated:YES];
//    }else if (row == 1){
//        qrSelectorViewController *selector = [qrSelectorViewController new];
//        selector.selectData = colorData;
//        selector.current = cell.detailTextLabel.text;
//        selector.navigationItem.title = @"Color";
//
//        selector.seletBlock = ^(NSString * _Nonnull selector) {
//            self->defaultArray[row] = selector;
//        };
//        [self.navigationController pushViewController:selector animated:YES];
//    }else{
//        switch (row) {
//            case 2:
//            case 3:
//            case 4:
//            case 5:
//                if ([defaultArray[row] isEqualToString:@"0"]) {
//                    qrkind ++;
//                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                    defaultArray[row] = [NSString stringWithFormat:@"%d",24/qrkind];
//                }else{
//                    cell.accessoryType = UITableViewCellAccessoryNone;
//                    qrkind --;
//                    defaultArray[row] = @"0";
//                }
//                    break;
//            default:
//                break;
//        }
//        [self.qrTable reloadData];
//    }
//}
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
