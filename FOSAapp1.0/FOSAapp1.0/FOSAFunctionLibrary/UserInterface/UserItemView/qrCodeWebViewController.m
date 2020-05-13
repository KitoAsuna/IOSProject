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
#import "LoginViewController.h"
#import "AFNetworking.h"
#import "qrTypeView.h"
#import "FosaIMGManager.h"
#import "qrSizeTableViewCell.h"

@interface qrCodeWebViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSMutableArray<NSString *> *sizeData,*colorData,*counter,*previewData,*previewColorData,*dataSource;
    NSArray<NSString *> *numberOfCode;
    NSInteger selectSize,selectColor;
    int qrkind;
    FosaIMGManager *imgManager;

}
//@property(nonatomic,strong) WKWebView *qrWebView;
//@property (nonatomic,strong) UIProgressView *progressView;
//缓冲图标
@property (nonatomic,strong) UIActivityIndicatorView *FOSAloadingView;

//qrcode种类view
@property (nonatomic,strong) qrTypeView *type1,*type2,*type3,*type4;
@property (nonatomic,strong) UIImageView *previewImgView;
////图片轮播器
//@property (nonatomic,strong) UIImageView *imageview1,*imageview2,*imageview3,*imageview4,*imageview5;
@property (nonatomic,strong) NSMutableArray<UIImageView *> *imageviewArray;
@end

@implementation qrCodeWebViewController
#pragma mark - 延迟加载
//- (UIImageView *)imageview1{
//    if (_imageview1 == nil) {
//        _imageview1 = [UIImageView new];
//    }
//    return _imageview1;
//}
//
//- (UIImageView *)imageview2{
//    if (_imageview2 == nil) {
//        _imageview2 = [UIImageView new];
//    }
//    return _imageview2;
//}
//
//
//- (UIImageView *)imageview3{
//    if (_imageview3 == nil) {
//        _imageview3 = [UIImageView new];
//    }
//    return _imageview3;
//}
//
//- (UIImageView *)imageview4{
//    if (_imageview4 == nil) {
//        _imageview4 = [UIImageView new];
//    }
//    return _imageview4;
//}
//
//- (UIImageView *)imageview5{
//    if (_imageview5 == nil) {
//        _imageview5 = [UIImageView new];
//    }
//    return _imageview5;
//}
- (UILabel *)colorLabel{
    if (_colorLabel == nil) {
        _colorLabel = [UILabel new];
    }
    return _colorLabel;
}

- (UISwitch *)colorSwitch{
    if (_colorSwitch == nil) {
        _colorSwitch = [UISwitch new];
    }
    return _colorSwitch;
}

- (UIScrollView *)preview{
    if (_preview == nil) {
        _preview = [UIScrollView new];
    }
    return _preview;
}

- (UIImageView *)previewImgView{
    if (_previewImgView == nil) {
        _previewImgView = [UIImageView new];
    }
    return _previewImgView;
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

    numberOfCode = @[@"6",@"6",@"20",@"9",@"20"];
    
    NSArray *array1 = @[@"preview_3R",@"preview_4R",@"preview_A4",@"preview_A5",@"preview_US"];
    NSArray *array2  = @[@"preview_3RColor",@"preview_4RColor",@"preview_A4Color",@"preview_A5Color",@"preview_USColor"];
    NSArray *array3   = @[@"3R",@"4R",@"A4",@"A5",@"US LETTER"];
    NSArray *array4  = @[@"Black & White",@"Color"];
    NSArray *array5  = @[@"0",@"0",@"0",@"0"];
    
    previewData = [NSMutableArray arrayWithArray:array1];
    previewColorData = [NSMutableArray arrayWithArray:array2];
    sizeData = [NSMutableArray arrayWithArray:array3];
    colorData = [NSMutableArray arrayWithArray:array4];
    counter = [NSMutableArray arrayWithArray:array5];

    qrkind = 0;
    selectColor = 0;
    selectSize  = 0;
//    self.imageviewArray = [[NSMutableArray alloc]initWithObjects:self.imageview1,self.imageview2,self.imageview3,self.imageview4,self.imageview5,nil];
    
}
- (void)creatQrGenerator{
    [self creatPreview];
    
    UIView *separatLine = [[UIView alloc]initWithFrame:CGRectMake(screen_width/20, CGRectGetMaxY(self.preview.frame)-Height(1), screen_width*18/20, 2)];
    separatLine.backgroundColor = FOSAColor(240, 240, 240);
    //[self.view addSubview:separatLine];

    UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.preview.frame), screen_width, self.sizeTableView.frame.size.height/sizeData.count)];
    [self.view addSubview:colorView];
//    self.qrTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.preview.frame)+Height(20), screen_width, Height(50)) style:UITableViewStylePlain];
//    self.qrTable.delegate = self;
//    self.qrTable.dataSource = self;
//    self.qrTable.bounces = NO;
//    self.qrTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    [self.view addSubview:self.qrTable];
    CGFloat colorHeight = colorView.frame.size.height;
    self.colorLabel.frame = CGRectMake(screen_width/15, 0, self.preview.frame.size.width/3, colorHeight);
    self.colorLabel.text  = colorData[selectColor];
    self.colorLabel.font  = [UIFont systemFontOfSize:font(15)];
    [colorView addSubview:self.colorLabel];
    
    self.colorSwitch.center = CGPointMake(screen_width*5/6, colorHeight/2);
    [self.colorSwitch addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventValueChanged];
    [colorView addSubview:self.colorSwitch];

    UIView *separatLine1 = [[UIView alloc]initWithFrame:CGRectMake(screen_width/20, CGRectGetMaxY(colorView.frame), screen_width*18/20, 2)];
    separatLine1.backgroundColor = FOSAColor(240, 240, 240);
    [self.view addSubview:separatLine1];
    
    int typeHeight = screen_height-CGRectGetMaxY(colorView.frame);
    
    UIView *typeBackground = [[UIView alloc]initWithFrame:CGRectMake(screen_width/12, CGRectGetMaxY(colorView.frame)+screen_width/24, screen_width*5/6, typeHeight/2+screen_width/24)];
    typeBackground.backgroundColor = FOSAColor(242, 242, 242);
    typeBackground.layer.cornerRadius = Height(10);
    [self.view addSubview:typeBackground];
    
    self.type1 = [[qrTypeView alloc]initWithFrame:CGRectMake(0, 0, screen_width*19/48, typeHeight/4)];
    self.type1.qrTypeImgView.image = [UIImage imageNamed:@"type1C"];
    self.type1.contentMode = UIViewContentModeScaleAspectFit;
    //self.type1.backgroundColor = FOSAColor(242, 242, 242);
    self.type2 = [[qrTypeView alloc]initWithFrame:CGRectMake(screen_width*21/48, 0, screen_width*19/48, typeHeight/4)];
    //self.type2.backgroundColor = FOSAColor(242, 242, 242);
    self.type2.qrTypeImgView.image = [UIImage imageNamed:@"type2C"];
    self.type3 = [[qrTypeView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.type1.frame)+screen_width/24, screen_width*19/48, typeHeight/4)];
    self.type3.qrTypeImgView.image = [UIImage imageNamed:@"type3C"];
    //self.type3.backgroundColor = FOSAColor(242, 242, 242);
    self.type4 = [[qrTypeView alloc]initWithFrame:CGRectMake(screen_width*21/48, CGRectGetMaxY(self.type1.frame)+screen_width/24, screen_width*19/48, typeHeight/4)];
    self.type4.qrTypeImgView.image = [UIImage imageNamed:@"type4C"];
    //self.type4.backgroundColor = FOSAColor(242, 242, 242);

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

    [typeBackground addSubview:self.type1];
    [typeBackground addSubview:self.type2];
    [typeBackground addSubview:self.type3];
    [typeBackground addSubview:self.type4];
    
    UIView *separatLine2 = [[UIView alloc]initWithFrame:CGRectMake(screen_width/20, CGRectGetMaxY(typeBackground.frame)+screen_width/24, screen_width*18/20, 2)];
    separatLine2.backgroundColor = FOSAColor(240, 240, 240);
    [self.view addSubview:separatLine2];

    self.printBtn.frame = CGRectMake(screen_width/3, CGRectGetMaxY(typeBackground.frame)+Height(45), screen_width/3, Height(40));
    self.printBtn.layer.cornerRadius = Height(20);
    [self.printBtn setTitle:@"Generate" forState:UIControlStateNormal];
    [self.printBtn setTitleColor:FOSAWhite forState:UIControlStateNormal];
    [self.printBtn setTitleColor:FOSABlueHL forState:UIControlStateHighlighted];
    self.printBtn.backgroundColor = FOSAgreen;
    //在本地生成
    [self.printBtn addTarget:self action:@selector(generateQrCodeImage) forControlEvents:UIControlEventTouchUpInside];

    //从服务器获取
    //[self.printBtn addTarget:self action:@selector(getPhotoFromServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.printBtn];
}

- (void)creatPreview{
    if (_preview == nil) {
        self.preview.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), screen_width, screen_width*4/5);
        self.preview.pagingEnabled = YES;
        self.preview.delegate = self;
        self.preview.showsHorizontalScrollIndicator = NO;
        self.preview.showsVerticalScrollIndicator = NO;
        self.preview.alwaysBounceVertical = NO;
        //self.preview.contentSize = CGSizeMake(screen_width*5, 0);
        [self.view addSubview:self.preview];
        dataSource = previewData;
    }
    int sizeHeight = self.preview.frame.size.height;
    int sizeWidth  = self.preview.frame.size.width;
    self.sizeTableView = [[UITableView alloc]initWithFrame:CGRectMake(sizeWidth*2/3, 0, sizeWidth/3, sizeHeight) style:UITableViewStylePlain];
    self.sizeTableView.delegate = self;
    self.sizeTableView.dataSource = self;
    self.sizeTableView.bounces = NO;
    [self.preview addSubview:self.sizeTableView];
    
    self.previewImgView.frame = CGRectMake(0, 0, sizeWidth*2/3, sizeHeight-Height(5));
    self.previewImgView.image = [UIImage imageNamed:dataSource[0]];
    self.previewImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.preview addSubview:self.previewImgView];
    
    //其实默认选中
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.sizeTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition: UITableViewScrollPositionNone];
    [self.sizeTableView cellForRowAtIndexPath:selectedIndexPath].backgroundColor = FOSAgreen;
    //[self.sizeTableView cellForRowAtIndexPath:selectedIndexPath].accessoryType = UITableViewCellAccessoryDisclosureIndicator;

//    for (int i = 0; i < 5; i++) {
//        self.imageviewArray[i].frame = CGRectMake(i*screen_width, 0, self.preview.frame.size.width, self.preview.frame.size.height);
//        if (selectColor == 1) {
//            self.imageviewArray[i].image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Colour",previewData[i]]];
//        }else{
//            self.imageviewArray[i].image = [UIImage imageNamed:previewData[i]];
//        }
//        self.imageviewArray[i].contentMode = UIViewContentModeScaleAspectFit;
//        [self.preview addSubview:self.imageviewArray[i]];
//    }
//
//    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(screen_width*2/5, CGRectGetMaxY(self.preview.frame)-Height(10), screen_width/5, 5)];
//    self.pageControl.currentPage = 0;
//    self.pageControl.numberOfPages = 5;
//    self.pageControl.pageIndicatorTintColor = FOSAFoodBackgroundColor;
//    self.pageControl.currentPageIndicatorTintColor = FOSAgreen;
//    [self.view addSubview:self.pageControl];
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
        NSString *s  = [NSString stringWithFormat:@"%ld",selectSize];


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
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgAddr]];
    UIImage *image = [UIImage imageWithData:data]; // 取得图片
    NSLog(@"%@",image);
    UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
}

- (void)selectType1{
    if ([counter[0] isEqualToString:@"0"]) {
        self.type1.selectBox.image = [UIImage imageNamed:@"icon_select"];
        qrkind ++;
        counter[0] = [NSString stringWithFormat:@"%d",[numberOfCode[selectSize] intValue]/qrkind];
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
        counter[1] = [NSString stringWithFormat:@"%d",[numberOfCode[selectSize] intValue]/qrkind];
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
        counter[2] = [NSString stringWithFormat:@"%d",[numberOfCode[selectSize] intValue]/qrkind];
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
        counter[3] = [NSString stringWithFormat:@"%d",[numberOfCode[selectSize] intValue]/qrkind];
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
            counter[i] = [NSString stringWithFormat:@"%d",[numberOfCode[selectSize] intValue]/qrkind];
        }
    }
    if (![counter[0] isEqualToString:@"0"]) {
        counter[0] = [NSString stringWithFormat:@"%d",[numberOfCode[selectSize] intValue]-[counter[0] intValue]*(qrkind-1)];
    }
    self.type1.qrCountLabel.text = [NSString stringWithFormat:@"x%@",counter[0]];
    self.type2.qrCountLabel.text = [NSString stringWithFormat:@"x%@",counter[1]];
    self.type3.qrCountLabel.text = [NSString stringWithFormat:@"x%@",counter[2]];
    self.type4.qrCountLabel.text = [NSString stringWithFormat:@"x%@",counter[3]];
}

/**
 生成二维码图片
 */
- (void)generateQrCodeImage{
         [self CreatLoadView];
         imgManager = [FosaIMGManager new];
         [imgManager InitImgManager];
         switch (selectSize) {
             case 0:
                 if (selectColor == 0) {
                     [self generateQrCodeImageOf3RWithImg:[UIImage imageNamed:@"IMG_3RBackground"]];
                 }else{
                     [self generateQrCodeImageOf3RWithImg:[UIImage imageNamed:@"IMG_3RBackgroundColor"]];
                 }
                 break;
        case 1:
            if (selectColor == 0) {
                [self generateQrCodeImageOf4RWithImg:[UIImage imageNamed:@"IMG_4RBackground"]];
            }else{
                [self generateQrCodeImageOf4RWithImg:[UIImage imageNamed:@"IMG_4RBackgroundColor"]];
            }
            break;
        case 2:
            if (selectColor == 0) {
                [self generateQrCodeImageOfA4WithImg:[UIImage imageNamed:@"IMG_A4Background"]];
            }else{
                [self generateQrCodeImageOfA4WithImg:[UIImage imageNamed:@"IMG_A4BackgroundColor"]];
            }
            break;
        case 3:
            if (selectColor == 0) {
                [self generateQrCodeImageOfA5WithImg:[UIImage imageNamed:@"IMG_A5Background"]];
            }else{
                [self generateQrCodeImageOfA5WithImg:[UIImage imageNamed:@"IMG_A5BackgroundColor"]];
            }
            break;
        case 4:
            if (selectColor == 0) {
                [self generateQrCodeImageOfUSWithImg:[UIImage imageNamed:@"IMG_USBackground"]];
            }else{
                [self generateQrCodeImageOfUSWithImg:[UIImage imageNamed:@"IMG_USBackgroundColor"]];
            }
            break;
        default:
            break;
    }
}
/**
 3R
 */
- (void)generateQrCodeImageOf3RWithImg:(UIImage *)backImg{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"]) {
        
        UIImageView *qrcodeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavigationBarH*3, screen_width, screen_width*(152.0/102))];
        qrcodeImage.backgroundColor = [UIColor blackColor];
        qrcodeImage.image = backImg;
        qrcodeImage.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat height = qrcodeImage.frame.size.height;
        CGFloat width  = qrcodeImage.frame.size.width;
           
        int kind1 = [counter[0] intValue];
        int kind2 = [counter[1] intValue];
        int kind3 = [counter[2] intValue];
        int kind4 = [counter[3] intValue];
        NSString *typeStr;
        NSString *color = @"B";
        if (selectColor == 0) {
            color = @"B";
        }else{
            color = @"C";
        }
        for (int i = 0; i < 6; i++) {
            int j = i+1;
            if (j <= kind1) {
                typeStr = [NSString stringWithFormat:@"type1%@",color];
            }else if(kind1 < j && j <= kind2+kind1){
                typeStr = [NSString stringWithFormat:@"type2%@",color];
            }else if(kind2+kind1 < j && j <= kind2+kind1+kind3){
                typeStr = [NSString stringWithFormat:@"type3%@",color];
            }else if(kind2+kind1+kind3 < j && j <= kind2+kind1+kind3+kind4){
                typeStr = [NSString stringWithFormat:@"type4%@",color];
            }else{
                typeStr = [NSString stringWithFormat:@"type1%@",color];
            }
            NSString *message = [NSString stringWithFormat:@"FS91000000000000000%d",j];
            UIImageView *qrview = [[UIImageView alloc]initWithFrame:CGRectMake(width*(16.9/102.0+(i%3)*24.4/102.0), height*(75.6/152.0+(i/3)*30.0/152.0), width*(19.5/102.0), height*(19.5/152.0))];
            qrview.image = [FosaIMGManager GenerateQRCodeWithIcon:[UIImage imageNamed:typeStr] Message:message];
            [qrcodeImage addSubview:qrview];
        }
        UIImage *qrLabelImg = [imgManager saveViewAsPictureWithView:qrcodeImage];
        UIImageWriteToSavedPhotosAlbum(qrLabelImg, self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"You must login your account before using this function" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Go to Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               LoginViewController *login = [LoginViewController new];
               [self.navigationController pushViewController:login animated:YES];
           }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
/**
 4R
 */
- (void)generateQrCodeImageOf4RWithImg:(UIImage *)backImg{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"]) {

        UIImageView *qrcodeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavigationBarH*3, screen_width, screen_width*(131.67/89))];
        qrcodeImage.backgroundColor = [UIColor blackColor];
        qrcodeImage.image = backImg;
        qrcodeImage.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat height = qrcodeImage.frame.size.height;
        CGFloat width  = qrcodeImage.frame.size.width;
           
        int kind1 = [counter[0] intValue];
        int kind2 = [counter[1] intValue];
        int kind3 = [counter[2] intValue];
        int kind4 = [counter[3] intValue];
        NSString *typeStr;
        NSString *color = @"B";
        if (selectColor == 0) {
            color = @"B";
        }else{
            color = @"C";
        }
        for (int i = 0; i < 6; i++) {
            int j = i+1;
            if (j <= kind1) {
                typeStr = [NSString stringWithFormat:@"type1%@",color];
            }else if(kind1 < j && j <= kind2+kind1){
                typeStr = [NSString stringWithFormat:@"type2%@",color];
            }else if(kind2+kind1 < j && j <= kind2+kind1+kind3){
                typeStr = [NSString stringWithFormat:@"type3%@",color];
            }else if(kind2+kind1+kind3 < j && j <= kind2+kind1+kind3+kind4){
                typeStr = [NSString stringWithFormat:@"type4%@",color];
            }else{
                typeStr = [NSString stringWithFormat:@"type1%@",color];
            }
            NSString *message = [NSString stringWithFormat:@"FS91000000000000000%d",j];
            UIImageView *qrview = [[UIImageView alloc]initWithFrame:CGRectMake(width*(9.6/89+(i%3)*25.16/89), height*(61.345/131.67+(i/3)*27.7/131.67), width*(19.5/89), height*(19.5/131.67))];
            qrview.image = [FosaIMGManager GenerateQRCodeWithIcon:[UIImage imageNamed:typeStr] Message:message];
            [qrcodeImage addSubview:qrview];
        }
        UIImage *qrLabelImg = [imgManager saveViewAsPictureWithView:qrcodeImage];
        UIImageWriteToSavedPhotosAlbum(qrLabelImg, self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"You must login your account before using this function" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Go to Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               LoginViewController *login = [LoginViewController new];
               [self.navigationController pushViewController:login animated:YES];
           }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
/*
 A4
 */
- (void)generateQrCodeImageOfA4WithImg:(UIImage *)backImg{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"]) {

        UIImageView *qrcodeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavigationBarH*3, screen_width, screen_width*(297.0/210))];
        qrcodeImage.backgroundColor = [UIColor blackColor];
        qrcodeImage.image = backImg;
        qrcodeImage.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat height = qrcodeImage.frame.size.height;
        CGFloat width  = qrcodeImage.frame.size.width;

        int kind1 = [counter[0] intValue];
        int kind2 = [counter[1] intValue];
        int kind3 = [counter[2] intValue];
        int kind4 = [counter[3] intValue];
        NSString *typeStr;
        NSString *color = @"B";
        if (selectColor == 0) {
            color = @"B";
        }else{
            color = @"C";
        }
        for (int i = 0; i < 20; i++) {
            int j = i+1;
            if (j <= kind1) {
                typeStr = [NSString stringWithFormat:@"type1%@",color];
            }else if(kind1 < j && j <= kind2+kind1){
                typeStr = [NSString stringWithFormat:@"type2%@",color];
            }else if(kind2+kind1 < j && j <= kind2+kind1+kind3){
                typeStr = [NSString stringWithFormat:@"type3%@",color];
            }else if(kind2+kind1+kind3 < j && j <= kind2+kind1+kind3+kind4){
                typeStr = [NSString stringWithFormat:@"type4%@",color];
            }else{
                typeStr = [NSString stringWithFormat:@"type1%@",color];
            }
            
            NSString *message = [NSString stringWithFormat:@"FS91000000000000000%d",j];
            UIImageView *qrview = [[UIImageView alloc]initWithFrame:CGRectMake(width*(29.5/210.0+(i%5)*32.8/210.0), height*(139.476/297.0+(i/5)*30.352/297.0), width*(19.5/210.0), height*(19.5/297.0))];
            qrview.image = [FosaIMGManager GenerateQRCodeWithIcon:[UIImage imageNamed:typeStr] Message:message];
            [qrcodeImage addSubview:qrview];
        }
        UIImage *qrLabelImg = [imgManager saveViewAsPictureWithView:qrcodeImage];
        UIImageWriteToSavedPhotosAlbum(qrLabelImg, self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"You must login your account before using this function" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Go to Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LoginViewController *login = [LoginViewController new];
            [self.navigationController pushViewController:login animated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
/**
 A5
 */
- (void)generateQrCodeImageOfA5WithImg:(UIImage *)backImg{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"]) {
        
        UIImageView *qrcodeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavigationBarH*3, screen_width, screen_width*(206.79/140.478))];
        qrcodeImage.backgroundColor = [UIColor blackColor];
        qrcodeImage.image = backImg;
        qrcodeImage.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat height = qrcodeImage.frame.size.height;
        CGFloat width  = qrcodeImage.frame.size.width;
        
        int kind1 = [counter[0] intValue];
        int kind2 = [counter[1] intValue];
        int kind3 = [counter[2] intValue];
        int kind4 = [counter[3] intValue];
        NSString *typeStr;
        NSString *color = @"B";
        if (selectColor == 0) {
            color = @"B";
        }else{
            color = @"C";
        }
        for (int i = 0; i < 9; i++) {
            int j = i+1;
            if (j <= kind1) {
                typeStr = [NSString stringWithFormat:@"type1%@",color];
            }else if(kind1 < j && j <= kind2+kind1){
                typeStr = [NSString stringWithFormat:@"type2%@",color];
            }else if(kind2+kind1 < j && j <= kind2+kind1+kind3){
                typeStr = [NSString stringWithFormat:@"type3%@",color];
            }else if(kind2+kind1+kind3 < j && j <= kind2+kind1+kind3+kind4){
                typeStr = [NSString stringWithFormat:@"type4%@",color];
            }else{
                typeStr = [NSString stringWithFormat:@"type1%@",color];
            }
            
            NSString *message = [NSString stringWithFormat:@"FS91000000000000000%d",j];
            UIImageView *qrview = [[UIImageView alloc]initWithFrame:CGRectMake(width*(28.13/140.478+(i%3)*32.339/140.478), height*(96/206.79+(i/3)*30/206.79), width*(19.5/140.478), height*(19.5/206.79))];
            qrview.image = [FosaIMGManager GenerateQRCodeWithIcon:[UIImage imageNamed:typeStr] Message:message];
            [qrcodeImage addSubview:qrview];
        }
        UIImage *qrLabelImg = [imgManager saveViewAsPictureWithView:qrcodeImage];
        UIImageWriteToSavedPhotosAlbum(qrLabelImg, self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"You must login your account before using this function" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Go to Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LoginViewController *login = [LoginViewController new];
            [self.navigationController pushViewController:login animated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
/**
 US Letter
 */
- (void)generateQrCodeImageOfUSWithImg:(UIImage *)backImg{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"]) {
        
        UIImageView *qrcodeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavigationBarH*3, screen_width, screen_width*(279.0/216.0))];
        qrcodeImage.backgroundColor = [UIColor blackColor];
        qrcodeImage.image = backImg;
        qrcodeImage.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat height = qrcodeImage.frame.size.height;
        CGFloat width  = qrcodeImage.frame.size.width;
        
        int kind1 = [counter[0] intValue];
        int kind2 = [counter[1] intValue];
        int kind3 = [counter[2] intValue];
        int kind4 = [counter[3] intValue];
        NSString *typeStr;
        NSString *color = @"B";
        if (selectColor == 0) {
            color = @"B";
        }else{
            color = @"C";
        }
        for (int i = 0; i < 20; i++) {
            int j = i+1;
            if (j <= kind1) {
                typeStr = [NSString stringWithFormat:@"type1%@",color];
            }else if(kind1 < j && j <= kind2+kind1){
                typeStr = [NSString stringWithFormat:@"type2%@",color];
            }else if(kind2+kind1 < j && j <= kind2+kind1+kind3){
                typeStr = [NSString stringWithFormat:@"type3%@",color];
            }else if(kind2+kind1+kind3 < j && j <= kind2+kind1+kind3+kind4){
                typeStr = [NSString stringWithFormat:@"type4%@",color];
            }else{
                typeStr = [NSString stringWithFormat:@"type1%@",color];
            }
            
            NSString *message = [NSString stringWithFormat:@"FS91000000000000000%d",j];
            UIImageView *qrview = [[UIImageView alloc]initWithFrame:CGRectMake(width*(30.6/216.0+(i%5)*33.7/216.0), height*(137.315/279.0+(i/5)*31.2/279.0), width*(20/216.0), height*(20/279.0))];
            qrview.image = [FosaIMGManager GenerateQRCodeWithIcon:[UIImage imageNamed:typeStr] Message:message];
            [qrcodeImage addSubview:qrview];
        }
        UIImage *qrLabelImg = [imgManager saveViewAsPictureWithView:qrcodeImage];
        UIImageWriteToSavedPhotosAlbum(qrLabelImg, self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"You must login your account before using this function" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Go to Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LoginViewController *login = [LoginViewController new];
            [self.navigationController pushViewController:login animated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
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

//#pragma mark -UIScrollerViewDelegate
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    CGFloat offset = scrollView.contentOffset.x;
//    currentIndex = offset/screen_width;
//    self.pageControl.currentPage = currentIndex;
//}

#pragma mark -UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.sizeTableView.frame.size.height/sizeData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sizeData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"qrcell";
    //初始化cell，并指定其类型
    qrSizeTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        //创建cell
        cell = [[qrSizeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    //取消点击cell时显示的背景
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType  = UITableViewCellAccessoryNone;
//    cell.textLabel.font = [UIFont systemFontOfSize:20*(([UIScreen mainScreen].bounds.size.width/414.0))];
    cell.backgroundColor = FOSAWhite;
    cell.sizeLabel.text = sizeData[indexPath.row];
    cell.sizeLabel.font = [UIFont systemFontOfSize:font(15)];
    
    if (indexPath.row == 4) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
    }
    return cell;
}

- (void)changeColor:(UISwitch *)sender{

    BOOL isButtonOn = [self.colorSwitch isOn];
    if (isButtonOn) {
        selectColor = 1;
        dataSource = previewColorData;
    }else{
        selectColor = 0;
        dataSource = previewData;
    }

    self.colorLabel.text = colorData[selectColor];
    self.previewImgView.image = [UIImage imageNamed:dataSource[0]];
    [self.sizeTableView reloadData];

    //
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectSize inSection:0];
    [self.sizeTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition: UITableViewScrollPositionNone];
    [self.sizeTableView cellForRowAtIndexPath:selectedIndexPath].backgroundColor = FOSAColor(240, 240, 240);
    [self.sizeTableView cellForRowAtIndexPath:selectedIndexPath].accessoryType = UITableViewCellAccessoryDisclosureIndicator;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    qrSizeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor  = FOSAgreen;
    //cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
    self.previewImgView.image = [UIImage imageNamed:dataSource[indexPath.row]];
    selectSize = indexPath.row;

    counter[0] = @"0";
    counter[1] = @"0";
    counter[2] = @"0";
    counter[3] = @"0";

    self.type1.qrCountLabel.text = [NSString stringWithFormat:@"x%@",counter[0]];
    self.type2.qrCountLabel.text = [NSString stringWithFormat:@"x%@",counter[1]];
    self.type3.qrCountLabel.text = [NSString stringWithFormat:@"x%@",counter[2]];
    self.type4.qrCountLabel.text = [NSString stringWithFormat:@"x%@",counter[3]];

    self.type1.selectBox.image   = [UIImage imageNamed:@"icon_unselect"];
    self.type2.selectBox.image   = [UIImage imageNamed:@"icon_unselect"];
    self.type3.selectBox.image   = [UIImage imageNamed:@"icon_unselect"];
    self.type4.selectBox.image   = [UIImage imageNamed:@"icon_unselect"];
    qrkind = 0;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType  = UITableViewCellAccessoryNone;
}

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

//    [self.qrWebView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];//https://fosahome.com/qrlabel/////https://www.bilibili.com
//    NSLog(@"%@",self.urlString);
//    [self.view addSubview:self.qrWebView];

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
- (void)viewWillDisappear:(BOOL)animated{
    [self.FOSAloadingView stopAnimating];
}
@end
