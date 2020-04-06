//
//  foodViewController.m
//  FOSA
//
//  Created by hs on 2020/4/3.
//  Copyright © 2020 hs. All rights reserved.
//

#import "foodViewController.h"
#import "FosaDatePickerView.h"
#import <UserNotifications/UserNotifications.h>
#import "fosaNotificationManager.h"
#import "foodkindCollectionViewCell.h"
#import "FosaFMDBManager.h"
#import "FosaIMGManager.h"
#import "fosaCameraViewController.h"
#import "qrCodeScannerViewController.h"

@interface foodViewController ()<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate, UICollectionViewDelegate,FosaDatePickerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UNUserNotificationCenterDelegate>{
    NSString *kindID;
    NSString *selectCategory;
    NSString *docPath;
    NSInteger currentPictureIndex;//标识图片轮播器当前指向哪张图片
    NSString *device;              //绑定的设备二维码编号
    Boolean isEdit;
    NSString *remindStr,*storageStr;
}

@property (nonatomic,weak)   FosaDatePickerView *fosaDatePicker;//日期选择器
@property (nonatomic,strong) NSMutableArray<NSString *> *categoryArray;//种类

// 当前获取焦点的UITextField
@property (strong, nonatomic) UITextView *currentResponderTextView;
//图片轮播器
@property (nonatomic,strong) UIImageView *imageview1,*imageview2,*imageview3;
@property (nonatomic,strong) NSMutableArray<UIImageView *> *imageviewArray;
//当前选中的种类cell
@property (nonatomic,strong) foodkindCollectionViewCell *selectedCategory;

//图片放大视图
@property (nonatomic,strong) UIScrollView *backGround;
@property (nonatomic,strong) UIImageView  *bigImage;
//FOSA通知对象
@property (nonatomic,strong) fosaNotificationManager *fosaNotification;

@property (nonatomic,strong) UIButton *refreshBtn;
//数据库
@property (nonatomic,strong) FosaFMDBManager *fmdbManager;
//图片处理管理者
@property (nonatomic,strong) FosaIMGManager *imgManager;

@end

@implementation foodViewController
#pragma mark - 属性延迟加载
- (UIButton *)likeBtn{
    if (_likeBtn == nil) {
        _likeBtn = [[UIButton alloc]init];
    }
    return _likeBtn;
}
- (UIButton *)helpBtn{
    if (_helpBtn == nil) {
        _helpBtn = [[UIButton alloc]init];
    }
    return _helpBtn;
}
- (UIScrollView *)toturialPicturePlayer{
    if (_toturialPicturePlayer == nil) {
        _toturialPicturePlayer = [UIScrollView new];
    }
    return _toturialPicturePlayer;
}
- (UIPageControl *)toturialPageControl{
    if (_toturialPageControl == nil) {
        _toturialPageControl = [UIPageControl new];
    }
    return _toturialPageControl;
}
- (UIButton *)closeBtn{
    if (_closeBtn == nil) {
        _closeBtn = [UIButton new];
    }
    return _closeBtn;
}
- (UIButton *)skipBtn{
    if (_skipBtn == nil) {
        _skipBtn = [UIButton new];
    }
    return _skipBtn;
}
//header
- (UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [[UIView alloc]init];
    }
    return _headerView;
}

- (UIScrollView *)picturePlayer{
    if (_picturePlayer == nil) {
        _picturePlayer = [[UIScrollView alloc]init];
    }
    return _picturePlayer;
}
- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [UIPageControl new];
    }
    return _pageControl;
}
- (UIView *)storageView{
    if (_storageView == nil) {
        _storageView = [UIView new];
    }
    return _storageView;
}
- (UIView *)expireView{
    if (_expireView == nil) {
        _expireView = [UIView new];
    }
    return _expireView;
}
- (UIButton *)storageIcon{
    if (_storageIcon == nil) {
        _storageIcon = [UIButton new];
    }
    return _storageIcon;
}
- (UIButton *)expireIcon{
    if (_expireIcon == nil) {
        _expireIcon = [UIButton new];
    }
    return _expireIcon;
}
- (UILabel *)storageLabel{
    if (_storageLabel == nil) {
        _storageLabel = [UILabel new];
    }
    return _storageLabel;
}
- (UILabel *)expireLabel{
    if (_expireLabel == nil) {
        _expireLabel = [UILabel new];
    }
    return _expireLabel;
}
- (UILabel *)storageDateLabel{
    if (_storageDateLabel == nil) {
        _storageDateLabel = [UILabel new];
    }
    return _storageDateLabel;
}
- (UILabel *)expireDateLabel{
    if (_expireDateLabel == nil) {
        _expireDateLabel = [UILabel new];
    }
    return _expireDateLabel;
}
- (UILabel *)storageTimeLabel{
    if (_storageTimeLabel == nil) {
        _storageTimeLabel = [UILabel new];
    }
    return _storageTimeLabel;
}
- (UILabel *)expireTimeLabel{
    if (_expireTimeLabel == nil) {
        _expireTimeLabel = [UILabel new];
    }
    return _expireTimeLabel;
}
//content
- (UIScrollView *)contentView{
    if (_contentView == nil) {
        _contentView = [UIScrollView new];
        //_contentView.backgroundColor = [UIColor blueColor];
    }
    return _contentView;
}
- (UIView *)foodNameView{
    if (_foodNameView == nil) {
        _foodNameView = [UIView new];
    }
    return _foodNameView;
}
- (UILabel *)foodNameLabel{
    if (_foodNameLabel == nil) {
        _foodNameLabel = [UILabel new];
    }
    return _foodNameLabel;
}
- (UITextField *)foodTextView{
    if (_foodTextView == nil) {
        _foodTextView = [UITextField new];
    }
    return _foodTextView;
}
- (UIButton *)scanBtn{
    if (_scanBtn == nil) {
        _scanBtn = [UIButton new];
    }
    return _scanBtn;
}
- (UIButton *)shareBtn{
    if (_shareBtn == nil) {
        _shareBtn = [UIButton new];
    }
    return _shareBtn;
}
- (UIView *)foodDescribedView{
    if (_foodDescribedView == nil) {
        _foodDescribedView = [UIView new];
    }
    return _foodDescribedView;
}
- (UILabel *)foodDescribedLabel{
    if (_foodDescribedLabel == nil) {
        _foodDescribedLabel = [UILabel new];
    }
    return _foodDescribedLabel;
}
- (UITextView *)foodDescribedTextView{
    if (_foodDescribedTextView == nil) {
        _foodDescribedTextView = [UITextView new];
    }
    return _foodDescribedTextView;
}
- (UILabel *)numberLabel{
    if (_numberLabel == nil) {
        _numberLabel = [UILabel new];
    }
    return _numberLabel;
}
- (UIView *)locationView{
    if (_locationView == nil) {
        _locationView = [UIView new];
    }
    return _locationView;
}
- (UILabel *)locationLabel{
    if (_locationLabel == nil) {
        _locationLabel = [UILabel new];
    }
    return _locationLabel;
}
- (UITextField *)locationTextView{
    if (_locationTextView == nil) {
        _locationTextView = [UITextField new];
    }
    return _locationTextView;
}
//footer
- (UIView *)footerView{
    if (_footerView == nil) {
        _footerView = [UIView new];
    }
    return _footerView;
}
- (UIButton *)leftIndex{
    if (_leftIndex == nil) {
        _leftIndex = [UIButton new];
    }
    return _leftIndex;
}
- (UIButton *)rightIndex{
    if (_rightIndex == nil) {
        _rightIndex = [UIButton new];
    }
    return _rightIndex;
}
- (UIButton *)doneBtn{
    if (_doneBtn == nil) {
        _doneBtn = [UIButton new];
    }
    return _doneBtn;
}
- (UIButton *)backbtn{
    if (_backbtn == nil) {
        _backbtn = [UIButton new];
    }
    return _backbtn;
}
- (UIButton *)deleteBtn{
    if (_deleteBtn == nil) {
        _deleteBtn = [UIButton new];
    }
    return _deleteBtn;
}
- (UIImageView *)imageview1{
    if (_imageview1 == nil) {
        _imageview1 = [[UIImageView alloc]init];
    }
    return _imageview1;
}
- (UIImageView *)imageview2{
    if (_imageview2 == nil) {
        _imageview2 = [[UIImageView alloc]init];
    }
    return _imageview2;
}
- (UIImageView *)imageview3{
    if (_imageview3 == nil) {
        _imageview3 = [[UIImageView alloc]init];
    }
    return _imageview3;
}
- (NSMutableArray<UIImage *> *)foodImgArray{
    if (_foodImgArray == nil) {
        _foodImgArray = [NSMutableArray new];
    }
    return _foodImgArray;
}
- (NSMutableArray<NSString *> *)cellDic{
    if (_cellDic == nil) {
        _cellDic = [[NSMutableArray alloc]init];
    }
    return _cellDic;
}
- (NSMutableDictionary *)cellDictionary{
    if (_cellDictionary == nil) {
        _cellDictionary = [[NSMutableDictionary alloc]init];
    }
    return _cellDictionary;
}
- (NSMutableArray<NSString *> *)categoryNameArray{
    if (_categoryNameArray == nil) {
        _categoryNameArray = [NSMutableArray new];
    }
    return _categoryNameArray;
}
//食物信息展示视图相关
- (UIButton *)editBtn{
    if (_editBtn == nil) {
        _editBtn = [UIButton new];
    }
    return _editBtn;
}
- (UILabel *)showFoodNameLabel{
    if (_showFoodNameLabel == nil) {
        _showFoodNameLabel = [UILabel new];
    }
    return _showFoodNameLabel;
}
- (UIButton *)refreshBtn{
    if (_refreshBtn == nil) {
        _refreshBtn = [UIButton new];
    }
    return _refreshBtn;;
}

#pragma mark - 创建视图
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self creatNavigation];
    [self creatHeaderView];
    [self creatContentView];
    [self creatFooterView];
    [self showFoodInfoInView];
    [self InitialDatePicker];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![self.foodStyle isEqualToString:@"Info"]) {
        self.backbtn.hidden = NO;
        if (![device isEqualToString:@"null"]) {
            [self SystemAlert:@"Binding device successfully"];
            self.likeBtn.hidden = NO;
        }
    }
}
- (void)initData{
    self.fmdbManager = [FosaFMDBManager initFMDBManagerWithdbName:@"FOSA"];
    device = @"null";
    kindID = @"categoryCell";
    self.imgManager  = [FosaIMGManager new];
    [self.imgManager InitImgManager];
}
//导航栏视图
- (void)creatNavigation{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
/**like*/
    self.likeBtn.frame = CGRectMake(screen_width/2-NavigationBarHeight/3, NavigationBarHeight/6, NavigationBarHeight*2/3, NavigationBarHeight*2/3);
    [self.likeBtn setImage:[UIImage imageNamed:@"img_foodCode"] forState:UIControlStateNormal];
    self.likeBtn.tag = 0;
    [self.navigationController.navigationBar addSubview:self.likeBtn];
    //[self.likeBtn addTarget:self action:@selector(selectToLike) forControlEvents:UIControlEventTouchUpInside];
    self.likeBtn.hidden = YES;
/**help*/
    self.helpBtn.frame = CGRectMake(0, 0, NavigationBarHeight/2, NavigationBarHeight/2);
    [self.helpBtn setBackgroundImage:[UIImage imageNamed:@"icon_helpW"]  forState:UIControlStateNormal];
    [self.helpBtn addTarget:self action:@selector(selectToHelp) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.foodStyle isEqualToString:@"adding"]) {
        /**显示图片和标题的自定义返回按钮*/

        self.backbtn.frame = CGRectMake(10, 0, NavigationBarHeight*5/3, NavigationBarHeight*5/9);
        self.backbtn.center = CGPointMake(NavigationBarHeight*5/6+10, NavigationBarHeight/2);

        [self.backbtn setBackgroundImage:[UIImage imageNamed:@"icon_backW"] forState:UIControlStateNormal];
        [self.backbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:self.backbtn];
        //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.helpBtn];
    }else if([self.foodStyle isEqualToString:@"Info"]){
        //self.editBtn.frame = CGRectMake(0, 0, NavigationBarH*2, NavigationBarH/2);
        //添加约束
        [[self.editBtn.widthAnchor constraintEqualToConstant:NavigationBarHeight*5/3] setActive:YES];
        [[self.editBtn.heightAnchor constraintEqualToConstant:NavigationBarHeight*5/9] setActive:YES];
        self.editBtn.layer.cornerRadius = NavigationBarHeight*5/18;
        [self.editBtn setTitle:@"Edit" forState:UIControlStateNormal];
        self.editBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.editBtn.titleLabel.font = [UIFont systemFontOfSize: font(18)];
        [self.editBtn setTitleColor:FOSAgreen forState:UIControlStateHighlighted];
        //self.editBtn.layer.borderWidth = 0.5;
        self.editBtn.layer.borderColor = FOSAWhite.CGColor;
        //self.editBtn.backgroundColor = FOSAgreen;
        [self.editBtn addTarget:self action:@selector(EditInfo) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)creatHeaderView{
    //点击
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTappedToCloseKeyBoard:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.headerView.frame = CGRectMake(0, 0, screen_width, screen_height*63/143);
    //self.headerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.headerView];

    int headerWidth  = self.headerView.frame.size.width;
    int headerHeight = self.headerView.frame.size.height;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    //图片轮播器
    [self creatPicturePlayer];
    //名称
    if ([self.foodStyle isEqualToString:@"Info"]) {
        self.showFoodNameLabel.frame = CGRectMake(headerWidth/22, headerHeight*7/10, headerWidth, headerHeight/10);

        self.showFoodNameLabel.font  = [UIFont systemFontOfSize:25*(414.0/screen_width)];
        self.showFoodNameLabel.textColor = [UIColor whiteColor];
        [self.headerView addSubview:self.showFoodNameLabel];
    }
    //日期
    self.storageView.frame = CGRectMake(headerWidth/22, headerHeight*4/5, headerWidth*6/22, headerHeight/6);
    [self.headerView addSubview:self.storageView];
    
    self.expireView.frame = CGRectMake(headerWidth*15/22, headerHeight*4/5, headerWidth*6/22, headerHeight/6);
    self.expireView.userInteractionEnabled = YES;
    UITapGestureRecognizer *dateRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectExpireDate)];
    [self.expireView addGestureRecognizer:dateRecognizer];
    [self.headerView addSubview:self.expireView];

    int storageWidth = self.storageView.frame.size.width;
    int storageHeight = self.storageView.frame.size.height;

    self.storageLabel.frame = CGRectMake(0, 0, storageWidth, storageHeight/3);
    self.storageLabel.text = @"Storage Date";
    self.storageLabel.font = [UIFont systemFontOfSize:15];
    self.storageLabel.textColor = [UIColor whiteColor];
    [self.storageView addSubview:self.storageLabel];
    
    self.storageDateLabel.frame = CGRectMake(0, storageHeight/3, storageWidth, storageHeight/3);
    //获取当天的时间并进行处理
    NSDate *currentDate = [NSDate new];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yy/HH:mm"];
    NSString *currentDateStr = [formatter stringFromDate:currentDate];
    storageStr = currentDateStr;
 
    NSArray *currentArrray = [currentDateStr componentsSeparatedByString:@"/"];
    NSString *storageDate = [NSString stringWithFormat:@"%@/%@/%@",currentArrray[0],[mouth valueForKey:currentArrray[1]],currentArrray[2]];
    remindStr = [NSString stringWithFormat:@"%@/%@/%@/%@",currentArrray[2],currentArrray[1],currentArrray[0],currentArrray[3]];
    NSLog(@"==========%@",currentDateStr);
    self.storageDateLabel.text = storageDate;
    self.storageDateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0*(414.0/screen_width)];
    self.storageDateLabel.adjustsFontSizeToFitWidth = YES;
    self.storageDateLabel.textColor = [UIColor whiteColor];
    [self.storageView addSubview:self.storageDateLabel];
    
    self.storageTimeLabel.frame = CGRectMake(0, storageHeight*2/3, storageWidth, storageHeight/3);
    self.storageTimeLabel.text = currentArrray[3];
    self.storageTimeLabel.textColor = [UIColor whiteColor];
    [self.storageView addSubview:self.storageTimeLabel];
    
    int expireWidth = self.expireView.frame.size.width;
    int expireHeight = self.expireView.frame.size.height;
 
    self.expireLabel.frame = CGRectMake(0, 0, expireWidth, expireHeight/3);
    self.expireLabel.text = @"Reminder";
    self.expireLabel.font = [UIFont systemFontOfSize:15];
    self.expireLabel.textColor = [UIColor whiteColor];
    //self.expireLabel.textAlignment = NSTextAlignmentRight;
    [self.expireView addSubview:self.expireLabel];
    
    self.expireDateLabel.frame = CGRectMake(0, expireHeight/3, expireWidth, expireHeight/3);
    self.expireDateLabel.text = storageDate;
    self.expireDateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0*(414.0/screen_width)];
    self.expireDateLabel.adjustsFontSizeToFitWidth = YES;
    self.expireDateLabel.textColor = [UIColor whiteColor];
    //self.expireDateLabel.textAlignment = NSTextAlignmentRight;
    [self.expireView addSubview:self.expireDateLabel];
    
    self.expireTimeLabel.frame = CGRectMake(0, expireHeight*2/3, expireWidth, expireHeight/3);
    self.expireTimeLabel.text = currentArrray[3];
    self.expireTimeLabel.textColor = [UIColor whiteColor];
    //self.expireTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.expireView addSubview:self.expireTimeLabel];
}
- (void)creatContentView{
    self.contentView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), screen_width, screen_height*42/143);
    //self.contentView.
    int contentHeight = self.contentView.frame.size.height;
    [self.view addSubview:self.contentView];
    
    self.foodNameView.frame = CGRectMake(0, 0, screen_width, contentHeight*11/42);
    [self.contentView addSubview:self.foodNameView];

    self.foodNameLabel.frame = CGRectMake(screen_width*5/66, contentHeight/18, screen_width/3, contentHeight/16);
    self.foodNameLabel.text = @"Name";
    self.foodNameLabel.font = [UIFont systemFontOfSize:15];
    self.foodNameLabel.textColor = [UIColor grayColor];
    [self.foodNameView addSubview:self.foodNameLabel];
    self.foodTextView.frame = CGRectMake(screen_width/22, contentHeight/8, screen_width*51/66, contentHeight/8);
    self.foodTextView.layer.cornerRadius = 5;
    self.foodTextView.font = [UIFont systemFontOfSize:15*(screen_width/414.0)];
    //self.foodTextView.
    [self.foodTextView setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"];//设置输入文本的起始位置
    self.foodTextView.delegate = self;
    self.foodTextView.returnKeyType = UIReturnKeyDone;
    self.foodTextView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.foodNameView addSubview:self.foodTextView];
    self.shareBtn.frame = CGRectMake(screen_width*28/33, contentHeight/8, contentHeight/8, contentHeight/8);
    [self.shareBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(jumpToShare) forControlEvents:UIControlEventTouchUpInside];
    [self.foodNameView addSubview:self.shareBtn];
    self.scanBtn.frame = CGRectMake(screen_width*28/33, contentHeight/8, contentHeight/8, contentHeight/8);
    [self.scanBtn setImage:[UIImage imageNamed:@"icon_scan"] forState:UIControlStateNormal];
    [self.scanBtn addTarget:self action:@selector(jumpToScan) forControlEvents:UIControlEventTouchUpInside];
    [self.foodNameView addSubview:self.scanBtn];
    if ([self.foodStyle isEqualToString:@"Info"]) {
        self.scanBtn.hidden = YES;
    }else{
        self.shareBtn.hidden = YES;
    }
    
    //描述
    self.foodDescribedView.frame = CGRectMake(0, contentHeight/4, screen_width, contentHeight/2);
    [self.contentView addSubview:self.foodDescribedView];
    self.foodDescribedLabel.frame = CGRectMake(screen_width*5/66, contentHeight/18, screen_width/3, contentHeight/16);
    self.foodDescribedLabel.text = @"Description";
    self.foodDescribedLabel.font = [UIFont systemFontOfSize:15];
    self.foodDescribedLabel.textColor = [UIColor grayColor];
    [self.foodDescribedView addSubview:self.foodDescribedLabel];
    self.foodDescribedTextView.frame = CGRectMake(screen_width/22, contentHeight/8, screen_width*9/10, contentHeight*3/8);
    self.foodDescribedTextView.layer.cornerRadius = 5;
    self.foodDescribedTextView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    self.foodDescribedTextView.textColor = [UIColor blackColor];
    self.foodDescribedTextView.font = [UIFont systemFontOfSize:15*(screen_width/414.0)];
    self.foodDescribedTextView.delegate = self;
    self.foodDescribedTextView.returnKeyType = UIReturnKeyDone;
    self.foodDescribedTextView.textContainerInset = UIEdgeInsetsMake(5, 5, 0, 0);//上、左、下、右
    [self.foodDescribedView addSubview:self.foodDescribedTextView];
    //输入字数提示
    int aboutFoodInputWidth = self.foodDescribedTextView.frame.size.width;
    int aboutFoodInputHeight = self.foodDescribedTextView.frame.size.height;
    self.numberLabel.frame = CGRectMake(aboutFoodInputWidth*5/6-10, aboutFoodInputHeight*5/6-5, aboutFoodInputWidth/6, aboutFoodInputHeight/6);
    self.numberLabel.font = [UIFont systemFontOfSize:13*(screen_width/414.0)];
    if ((unsigned long)self.foodDescribedTextView.text.length > 80) {
        self.numberLabel.text = [NSString stringWithFormat:@"%d/80",80];
    }else{
        self.numberLabel.text = [NSString stringWithFormat:@"%lu/80",(unsigned long)self.foodDescribedTextView.text.length];
    }
    NSLog(@"描述文字字数：%lu",(unsigned long)self.foodDescribedTextView.text.length);
    self.numberLabel.textColor = [UIColor grayColor];
    self.numberLabel.textAlignment = 2;
    [self.foodDescribedTextView addSubview:self.numberLabel];
    
    self.locationView.frame = CGRectMake(0, contentHeight*3/4, screen_width, contentHeight/4);
    [self.contentView addSubview:self.locationView];
    self.locationLabel.frame = CGRectMake(screen_width*5/66, contentHeight/18, screen_width/3, contentHeight/16);
    self.locationLabel.text = @"Location";
    self.locationLabel.font = [UIFont systemFontOfSize:15];
    self.locationLabel.textColor = [UIColor grayColor];
    [self.locationView addSubview:self.locationLabel];
    self.locationTextView.frame = CGRectMake(screen_width/20, contentHeight/8, screen_width*9/10, contentHeight/8);
    self.locationTextView.layer.cornerRadius = 5;
    self.locationTextView.returnKeyType = UIReturnKeyDone;
    self.locationTextView.delegate = self;
    [self.locationTextView setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"];
    self.locationTextView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.locationView addSubview:self.locationTextView];
}

- (void)creatFooterView{
    NSString *selSql = @"select * from category";
    self.categoryNameArray = [self.fmdbManager selectDataWithTableName:@"category" sql:selSql];

    //初始化种类数据
    NSArray *array = @[@"Biscuit",@"Bread",@"Cake",@"Cereal",@"Dairy",@"Fruit",@"Meat",@"Snacks",@"Spice",@"Veggie"];
    self.categoryArray = [[NSMutableArray alloc]initWithArray:array];
    
    self.footerView.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame), screen_width, screen_width*5/24);
    //self.footerView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.footerView];
    int footerHeight = self.footerView.frame.size.height;
    self.leftIndex.frame = CGRectMake(0, 0, screen_width/18, screen_width/18);
    self.leftIndex.center = CGPointMake(screen_width/20, footerHeight-(screen_width*5/6-font(45))/10);
    self.leftIndex.layer.cornerRadius = self.leftIndex.frame.size.width/2;
    [self.leftIndex setBackgroundImage:[UIImage imageNamed:@"icon_leftindex"] forState:UIControlStateNormal];
    [self.leftIndex addTarget:self action:@selector(offsetToLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:self.leftIndex];
    
    self.rightIndex.frame = CGRectMake(0, 0, screen_width/18, screen_width/18);//
    self.rightIndex.center = CGPointMake(screen_width*19/20, footerHeight-(screen_width*5/6-font(45))/10);
    self.rightIndex.layer.cornerRadius = self.rightIndex.frame.size.width/2;
    [self.rightIndex setBackgroundImage:[UIImage imageNamed:@"icon_rightindex"] forState:UIControlStateNormal];
    [self.rightIndex addTarget:self action:@selector(offsetToRight) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:self.rightIndex];
    
    //食物种类选择栏 可滚动
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake((screen_width*5/6-font(45))/5, footerHeight);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 2);

    self.categoryCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(screen_width/12, 0, screen_width*5/6, footerHeight) collectionViewLayout:flowLayout];
    
    self.categoryCollection.backgroundColor = [UIColor whiteColor];
    self.categoryCollection.delegate = self;
    self.categoryCollection.dataSource = self;
    self.categoryCollection.showsHorizontalScrollIndicator = NO;
    self.categoryCollection.bounces = NO;
    [self.categoryCollection registerClass:[foodkindCollectionViewCell class] forCellWithReuseIdentifier:kindID];
    [self.footerView addSubview:self.categoryCollection];
    
    self.doneBtn.frame = CGRectMake(screen_width/3, CGRectGetMaxY(self.footerView.frame)+screen_height*6/143, screen_width/3, screen_height*6/143);
    self.doneBtn.layer.cornerRadius = self.doneBtn.frame.size.height/2;
    [self.doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    self.doneBtn.backgroundColor = FOSAgreen;
    [self.view addSubview:self.doneBtn];
    [self.doneBtn addTarget:self action:@selector(saveInfoAndFinish) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.foodStyle isEqualToString:@"Info"]) {
        self.leftIndex.hidden = YES;
        self.rightIndex.hidden = YES;
        self.categoryCollection.hidden = YES;
        self.doneBtn.hidden = YES;
        self.foodCell = [[foodKindView alloc]initWithFrame:CGRectMake(0, 0, (screen_width*48/66)/5, footerHeight)];
        self.foodCell.center = self.categoryCollection.center;
        [self.footerView addSubview:self.foodCell];
        self.deleteBtn.frame = CGRectMake(screen_width/3, CGRectGetMaxY(self.footerView.frame)+screen_height*3/143, screen_width/3, screen_height*6/143);
        self.deleteBtn.backgroundColor = FOSARed;
        [self.deleteBtn addTarget:self action:@selector(deleteFoodRecord) forControlEvents:UIControlEventTouchUpInside];
        self.deleteBtn.layer.cornerRadius = self.deleteBtn.frame.size.height/2;
        [self.deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
        [self.view addSubview:self.deleteBtn];
    }
}

- (void)showFoodInfoInView{
    if ([self.foodStyle isEqualToString:@"Info"]) {
        //编辑按钮
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editBtn];
        //禁止界面互动
        self.foodTextView.userInteractionEnabled = NO;
        self.foodDescribedTextView.userInteractionEnabled = NO;
        self.storageView.userInteractionEnabled = NO;
        self.expireView.userInteractionEnabled = NO;
        self.locationView.userInteractionEnabled = NO;

        
        NSArray<NSString *> *storageTimeArray;
        storageTimeArray = [self.model.storageDate componentsSeparatedByString:@"/"];
        NSArray<NSString *> *expireTimeArray;
        expireTimeArray = [self.model.expireDate componentsSeparatedByString:@"/"];
        NSLog(@"%@",storageTimeArray);
        NSLog(@"%@",expireTimeArray);
        
        self.showFoodNameLabel.text = self.model.foodName;
        self.showFoodNameLabel.font = [UIFont systemFontOfSize:22 weight:20];
        
        if (![self.model.device isEqualToString:@"null"]) {
            self.likeBtn.hidden = NO;
            device = self.model.device;
        }
        selectCategory = self.model.category;
        self.storageDateLabel.text = [NSString stringWithFormat:@"%@/%@/%@",storageTimeArray[0],storageTimeArray[1],storageTimeArray[2]];
        self.storageTimeLabel.text = storageTimeArray[3];
        self.expireDateLabel.text = [NSString stringWithFormat:@"%@/%@/%@",expireTimeArray[0],expireTimeArray[1],expireTimeArray[2]];
        self.expireTimeLabel.text = expireTimeArray[3];
        
        self.foodTextView.text = self.model.foodName;
        self.foodDescribedTextView.text = self.model.aboutFood;
        self.locationTextView.text = self.model.location;
        self.foodCell.kind.text = self.model.category;
        self.foodCell.categoryPhoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@W",self.foodCategoryIconname]];
        NSLog(@"-------------------------%@",self.foodCategoryIconname);
        //self.foodCell.categoryPhoto.image = [UIImage imageNamed:@"BiscuitW"];

        //字数指示器
        if ((unsigned long)self.foodDescribedTextView.text.length > 80) {
            self.numberLabel.text = [NSString stringWithFormat:@"%d/80",80];
        }else{
            self.numberLabel.text = [NSString stringWithFormat:@"%lu/80",(unsigned long)self.foodDescribedTextView.text.length];
        }
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.helpBtn];
    }
}

#pragma mark - 图片轮播器

- (void)creatPicturePlayer{
    self.imageviewArray = [[NSMutableArray alloc]initWithObjects:self.imageview1,self.imageview2,self.imageview3, nil];
    
    int headerWidth  = self.headerView.frame.size.width;
    int headerHeight = self.headerView.frame.size.height;
    self.picturePlayer.frame = CGRectMake(0, 0, headerWidth, headerHeight);
    self.picturePlayer.pagingEnabled = YES;
    self.picturePlayer.delegate = self;
    self.picturePlayer.showsHorizontalScrollIndicator = NO;
    self.picturePlayer.showsVerticalScrollIndicator = NO;
    self.picturePlayer.alwaysBounceVertical = NO;
        // 解决UIscrollerView在导航栏透明的情况下往下偏移的问题
    self.picturePlayer.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.picturePlayer.bounces = NO;
    self.picturePlayer.contentSize = CGSizeMake(headerWidth*3, 0);
    for (NSInteger i = 0; i < 3; i++) {
            CGRect frame = CGRectMake(i*headerWidth, 0, headerWidth, self.headerView.frame.size.height);
        self.imageviewArray[i].frame = frame;
        self.imageviewArray[i].userInteractionEnabled = YES;
        self.imageviewArray[i].contentMode = UIViewContentModeScaleAspectFill;
        self.imageviewArray[i].clipsToBounds = YES;
        if ([self.foodStyle isEqualToString:@"Info"] && [self.imgManager getImgWithName:[NSString stringWithFormat:@"%@%ld",self.model.foodPhoto,i+1]] != nil) {
            NSString *img = [NSString stringWithFormat:@"%@%ld",self.model.foodPhoto,i+1];
            self.imageviewArray[i].image = [self.imgManager getImgWithName:img];
            self.foodImgArray[i] = self.imageviewArray[i].image;
        }else{
            NSString *imgName = [NSString stringWithFormat:@"%@%ld",@"picturePlayer",i+1];
            self.imageviewArray[i].image = [UIImage imageNamed:imgName];
        }

        UITapGestureRecognizer *clickRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumptoPhoto)];
               //clickRecognizer.view.tag = i;
        [self.imageviewArray[i] addGestureRecognizer:clickRecognizer];
        [self.picturePlayer addSubview:self.imageviewArray[i]];
    }
    [self.headerView addSubview:self.picturePlayer];
        //轮播页面指示器
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(headerWidth*2/5, headerHeight-15, headerWidth/5, 10)];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 3;
    self.pageControl.pageIndicatorTintColor = FOSAFoodBackgroundColor;
    self.pageControl.currentPageIndicatorTintColor = FOSAgreen;
    [self.headerView addSubview:self.pageControl];
    
    self.refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.refreshBtn.center = self.headerView.center;
    [self.refreshBtn setBackgroundImage:[UIImage imageNamed:@"icon_refreshPicture"] forState:UIControlStateNormal];
    [self.refreshBtn addTarget:self action:@selector(jumptoPhoto) forControlEvents:UIControlEventTouchUpInside];
    self.refreshBtn.hidden = YES;
    [self.headerView addSubview:self.refreshBtn];
}
#pragma mark - 初始化日期选择器
-(void)InitialDatePicker{
    FosaDatePickerView *DatePicker = [[FosaDatePickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300)];
    DatePicker.delegate = self;
    DatePicker.title = @"Reminder date";
    [self.view addSubview:DatePicker];
    self.fosaDatePicker = DatePicker;
    self.fosaDatePicker.hidden = YES;
}
#pragma mark -- FosaDatePickerViewDelegate
/**
 保存按钮代理方法
 @param timer 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer {
    NSLog(@"保存点击");
    //处理日期字符串
    NSArray *array = [timer componentsSeparatedByString:@"/"];
    
    remindStr = [NSString stringWithFormat:@"%@/%@/%@/%@",array[2],array[0],array[1],array[3]];
    NSLog(@"------------------%@",remindStr);
//    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yy/MM/dd/HH:mm"];
//    NSDate *expDate = [formatter dateFromString:expireStr];
//    NSLog(@">>>>>>>>>>>>>>>>>>>%@",expDate);

    NSString *dateStr = [NSString stringWithFormat:@"%@/%@/%@",array[1],[mouth valueForKey:array[0]],array[2]];
    self.expireDateLabel.text = dateStr;
    self.expireTimeLabel.text= array[3];
    NSLog(@"%@",dateStr);
    [UIView animateWithDuration:0.3 animations:^{
       self.fosaDatePicker.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
   }];
}
/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate {
    NSLog(@"取消点击");
    [UIView animateWithDuration:0.3 animations:^{
        self.fosaDatePicker.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    }];
}

#pragma mark -- UIScrollerView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.picturePlayer) {
        CGFloat offset = scrollView.contentOffset.x;
        NSInteger index = offset/self.headerView.frame.size.width;
        self.pageControl.currentPage = index;
        currentPictureIndex = index;
    }else{
        CGFloat offset = scrollView.contentOffset.x;
        NSInteger index = offset/screen_width;
        self.toturialPageControl.currentPage = index;
        if (index == 16) {
            self.skipBtn.hidden = YES;
            //添加close按钮，功能同skip
        }else{
            self.skipBtn.hidden = NO;
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.bigImage;
}
//放大查看全图
- (void)EnlargePhoto{
    self.navigationController.navigationBar.hidden = YES;   //隐藏导航栏
    //[UIApplication sharedApplication].statusBarHidden = YES;             //隐藏状态栏
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
    _bigImage.image = self.imageviewArray[currentPictureIndex].image;
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
    //[UIApplication sharedApplication].statusBarHidden = NO;
}

#pragma mark - UICollectionViewDataSource
//每个section有几个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryArray.count;
}
//collectionView有几个section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//返回这个UICollectionViewCell是否可以被选择
- ( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    return YES ;
}
//每个cell的具体内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath {
    // 每次先从字典中根据IndexPath取出唯一标识符
//    NSString *identifier = [_cellDictionary objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
//     // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
//    if (identifier == nil) {
//        identifier = [NSString stringWithFormat:@"%@%@", kindID, [NSString stringWithFormat:@"%@", indexPath]];
//        [_cellDictionary setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
//    // 注册Cell
//        [self.categoryCollection registerClass:[foodKindCollectionViewCell class] forCellWithReuseIdentifier:identifier];
//    }
    
    foodkindCollectionViewCell *cell = [self.categoryCollection dequeueReusableCellWithReuseIdentifier:kindID forIndexPath:indexPath];
    cell.kind.text = self.categoryNameArray[indexPath.row];
    if ([self.foodStyle isEqualToString:@"edit"] && [self.categoryNameArray indexOfObject:self.model.category] == indexPath.row) {
        cell.rootView.backgroundColor = FOSAYellow;
        cell.categoryPhoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@W",self.categoryArray[indexPath.row]]];
        selectCategory = self.categoryArray[indexPath.row];
        self.selectedCategory = cell;
    }else{
        cell.rootView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        cell.categoryPhoto.image = [UIImage imageNamed:self.categoryArray[indexPath.row]];
    }
    return cell;
}
//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    foodkindCollectionViewCell *cell = (foodkindCollectionViewCell *)[self.categoryCollection cellForItemAtIndexPath:indexPath];
    if (![cell.kind.text isEqualToString:selectCategory]) {
        self.selectedCategory.rootView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        self.selectedCategory.categoryPhoto.image = [UIImage imageNamed:selectCategory];
        self.selectedCategory.categoryPhoto.backgroundColor = [UIColor clearColor];
    }
    cell.rootView.backgroundColor = FOSAYellow;
    cell.categoryPhoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@W",self.categoryArray[indexPath.row]]];
    selectCategory = self.categoryNameArray[indexPath.row];
    self.selectedCategory = cell;
    NSLog(@"Selectd:%@",selectCategory);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
        self.selectedCategory.rootView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        self.selectedCategory.categoryPhoto.image = [UIImage imageNamed:selectCategory];
        self.selectedCategory.categoryPhoto.backgroundColor = [UIColor clearColor];
}

#pragma mark - UITextViewDelegate,UITextFiledDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.5 animations:^{
        [self.contentView setContentOffset:CGPointMake(0, self.contentView.frame.size.height/4)];
    }];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //不支持系统表情的输入
    if ([[textView textInputMode]primaryLanguage]==nil||[[[textView textInputMode]primaryLanguage]isEqualToString:@"emoji"]) {
        return NO;
    }
    if([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.foodDescribedTextView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/80",(unsigned long)textView.text.length];
    if (textView.text.length >= 80) {
        textView.text = [textView.text substringToIndex:80];
        self.numberLabel.text = @"80/80";
    }
}

//已经结束/退出编辑模式
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.5 animations:^{
        [self.contentView setContentOffset:CGPointMake(0, 0)];
    }];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.foodTextView) {
        [UIView animateWithDuration:0.5 animations:^{
               [self.contentView setContentOffset:CGPointMake(0, CGRectGetMinY(self.foodNameView.frame))];
           }];
        NSLog(@"food");
    }else if(textField == self.locationTextView){
        [UIView animateWithDuration:0.5 animations:^{
            [self.contentView setContentOffset:CGPointMake(0, CGRectGetMinY(self.locationView.frame))];
        }];
        NSLog(@"location");
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.5 animations:^{
        [self.contentView setContentOffset:CGPointMake(0, 0)];
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 响应事件

- (void)offsetToLeft{
    [self.categoryCollection setContentOffset:CGPointMake(0, 0)];
}
- (void)offsetToRight{
    [self.categoryCollection setContentOffset:CGPointMake(self.categoryCollection.frame.size.width, 0)];
}

- (void)selectToLike{
    if (self.likeBtn.tag == 0) {
        [self.likeBtn setImage:[UIImage imageNamed:@"icon_likeHL"] forState:UIControlStateNormal];
        self.likeBtn.tag = 1;
        self.likeBtn.accessibilityValue = @"1";
    }else{
        [self.likeBtn setImage:[UIImage imageNamed:@"icon_likeW"] forState:UIControlStateNormal];
        self.likeBtn.tag = 0;
        self.likeBtn.accessibilityValue = @"0";
    }
}
- (void)EditInfo{
    isEdit = true;
    self.foodStyle = @"edit";
    self.foodTextView.userInteractionEnabled = YES;
    self.foodDescribedTextView.userInteractionEnabled = YES;
    self.storageView.userInteractionEnabled = YES;
    self.expireView.userInteractionEnabled = YES;
    self.locationView.userInteractionEnabled = YES;
    self.picturePlayer.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.leftIndex.hidden = NO;
        self.rightIndex.hidden = NO;
        self.categoryCollection.hidden = NO;
        self.doneBtn.hidden = NO;
        self.refreshBtn.hidden = NO;
        self.scanBtn.hidden = NO;
        self.shareBtn.hidden = YES;
        self.foodCell.hidden = YES;
        self.deleteBtn.hidden = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.helpBtn];
    }];
    [self.categoryCollection reloadData];
}
- (void)recoverEditView{
    self.foodCell.kind.text = selectCategory;
    self.foodCell.categoryPhoto.image = self.selectedCategory.categoryPhoto.image;
    
    //禁止界面互动
    self.foodTextView.userInteractionEnabled = NO;
    self.foodDescribedTextView.userInteractionEnabled = NO;
    self.storageView.userInteractionEnabled = NO;
    self.expireView.userInteractionEnabled = NO;
    self.locationView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.leftIndex.hidden = YES;
        self.rightIndex.hidden = YES;
        self.categoryCollection.hidden = YES;
        self.doneBtn.hidden = YES;
        self.foodCell.hidden = NO;
        self.deleteBtn.hidden = NO;
        self.refreshBtn.hidden = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editBtn];
    }];
}
- (void)selectToHelp{
    //隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
    
    self.skipBtn.frame = CGRectMake(0, NavigationBarHeight, screen_width/4, NavigationBarHeight);
    [self.skipBtn setTitle:@"Skip" forState:UIControlStateNormal];
    self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.skipBtn addTarget:self action:@selector(skipTutorial) forControlEvents:UIControlEventTouchUpInside];
    
    self.toturialPicturePlayer.frame = CGRectMake(0, 0, screen_width, screen_height);
    self.toturialPicturePlayer.pagingEnabled = YES;
    self.toturialPicturePlayer.delegate = self;
    self.toturialPicturePlayer.showsHorizontalScrollIndicator = NO;
    self.toturialPicturePlayer.showsVerticalScrollIndicator = NO;
    self.toturialPicturePlayer.alwaysBounceVertical = NO;
            // 解决UIscrollerView在导航栏透明的情况下往下偏移的问题
    self.toturialPicturePlayer.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
    self.toturialPicturePlayer.bounces = NO;
    self.toturialPicturePlayer.contentSize = CGSizeMake(screen_width*17, 0);
    for (NSInteger i = 0; i < 17; i++) {
        CGRect frame = CGRectMake(i*screen_width, 0, screen_width,screen_height);
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:frame];
        imageview.userInteractionEnabled = YES;
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        imageview.clipsToBounds = YES;
        NSString *imgName = [NSString stringWithFormat:@"%@%ld",@"img_tutorial",i+1];
        imageview.image = [UIImage imageNamed:imgName];
        [self.toturialPicturePlayer addSubview:imageview];
        
        if (i == 16) {
            self.closeBtn.frame = CGRectMake(screen_width*12/33, screen_height*116/143, screen_width*3/11, screen_height*7/143);
            self.closeBtn.layer.borderWidth = 1;
            self.closeBtn.layer.cornerRadius = self.closeBtn.frame.size.height/2;
            [self.closeBtn setTitle:@"close" forState:UIControlStateNormal];
            [self.closeBtn setTitleColor:FOSAWhite forState:UIControlStateNormal];
            self.closeBtn.titleLabel.font = [UIFont systemFontOfSize:25];
            self.closeBtn.layer.borderColor = FOSAWhite.CGColor;
            [self.closeBtn addTarget:self action:@selector(skipTutorial) forControlEvents:UIControlEventTouchUpInside];
            [imageview addSubview:self.closeBtn];
            
        }
        [self.toturialPicturePlayer addSubview:imageview];
    }
    [self.view addSubview:self.toturialPicturePlayer];
        //轮播页面指示器
    self.toturialPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(screen_width*2/5, screen_height-30, screen_width/5, 20)];
    self.toturialPageControl.currentPage = 0;
    self.toturialPageControl.numberOfPages = 17;
    self.toturialPageControl.pageIndicatorTintColor = FOSAFoodBackgroundColor;
    self.toturialPageControl.currentPageIndicatorTintColor = FOSAgreen;
    [self.view addSubview:self.toturialPageControl];
    [self.view addSubview:self.skipBtn];
}
- (void)skipTutorial{
    [self.toturialPicturePlayer removeFromSuperview];
    [self.toturialPageControl removeFromSuperview];
    [self.skipBtn removeFromSuperview];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)selectExpireDate{
    self.fosaDatePicker.hidden = NO;
       [UIView animateWithDuration:0.3 animations:^{
           self.fosaDatePicker.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
           [self.fosaDatePicker show];
       }];
}

- (void)jumptoPhoto{
    if ([self.foodStyle isEqualToString:@"Info"]) {
        NSLog(@"放大图片");
        [self EnlargePhoto];
    }else{
        fosaCameraViewController *photo = [[fosaCameraViewController alloc]init];
        photo.photoBlock = ^(UIImage *img){
            //通过block将相机拍摄的图片放置在对应的位置
            if (img != nil) {
                self.imageviewArray[self->currentPictureIndex].image = img;
                self.foodImgArray[self->currentPictureIndex] = img;
            }
        };
        [self.navigationController pushViewController:photo animated:NO];
    }
}

- (void)back{
     UIAlertController *backAlert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Do you want to leave the page?" preferredStyle:UIAlertControllerStyleAlert];
    [backAlert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
       }]];
    [backAlert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
       }]];
    [self presentViewController:backAlert animated:true completion:nil];
}

- (void)jumpToScan{
    qrCodeScannerViewController *scan = [qrCodeScannerViewController new];
    scan.scanStyle = @"block";
    scan.resultBlock = ^(NSString * _Nonnull result) {
        self->device = result;
        NSLog(@"我获得了设备号：%@",self->device);
    };
    [self.navigationController pushViewController:scan animated:NO];
    //[self presentViewController:scan animated:YES completion:nil];
}

- (void)jumpToShare{
    NSLog(@"点击了分享");
    NSString *body = [NSString stringWithFormat:@"This is my food %@,you can scan the QRCode check it",self.foodTextView.text];
    UIView *view = [self CreatNotificatonViewWithContent:body];
    UIImage *sharephoto1 = [self.imgManager saveViewAsPictureWithView:view];
    NSArray *activityItems = @[sharephoto1];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

- (void)saveInfoAndFinish{
    if ([self.foodStyle isEqualToString:@"edit"]) {
            [self DeleteRecord];
    }else{
        //[self SavephotosInSanBox:self.foodImgArray];
        [self.imgManager savePhotosWithImages:self.foodImgArray name:self.foodTextView.text];
    }
    NSString *tableSql = @"CREATE TABLE IF NOT EXISTS FoodStorageInfo(id integer PRIMARY KEY AUTOINCREMENT, foodName text NOT NULL, device text, aboutFood text,storageDate text NOT NULL,expireDate text NOT NULL,location text,foodImg text NOT NULL,category text NOT NULL,like text);";
    if ([self.fmdbManager creatTableWithSql:tableSql]) {
        NSString *storagedate = [NSString stringWithFormat:@"%@/%@",self.storageDateLabel.text,self.storageTimeLabel.text];
        NSString *expiredate  = [NSString stringWithFormat:@"%@/%@",self.expireDateLabel.text,self.expireTimeLabel.text];
        NSString *insertSql = [NSString stringWithFormat:@"insert into FoodStorageInfo(foodName,device,aboutFood,storageDate,expireDate,location,foodImg,category) values('%@','%@','%@','%@','%@','%@','%@','%@')",self.foodTextView.text,device,self.foodDescribedTextView.text,storagedate,expiredate,self.locationTextView.text,self.foodTextView.text,selectCategory];
        if ([self.foodTextView.text isEqualToString:@""]) {
               [self SystemAlert:@"Please input the name of your food!"];
           }else if(selectCategory == nil){
               [self SystemAlert:@"Please select a category for your food"];
           }else{
               if ([self.fmdbManager isFmdbOpen]) {
                   
                   BOOL insertResult = [self.fmdbManager insertDataWithSql:insertSql];
                   NSLog(@"~~~~~~~~~~~~~~~~~~~~设备号：%@",device);
                   if (insertResult) {
                       [self sendNotificationByExpireday];
                   }else{
                       [self SystemAlert:@"Error"];
                   }
               }
           }
    }
}
- (void)deleteFoodRecord{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"You will delete this food record" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self DeleteRecord];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:true completion:nil];
    
}
//删除记录
- (void)DeleteRecord{
    NSString *delSql = [NSString stringWithFormat:@"delete from FoodStorageInfo where foodName = '%@'",self.model.foodName];
    if ([self.fmdbManager isFmdbOpen]) {
        NSLog(@"删除%@",self.model.foodName);
        BOOL result = [self.fmdbManager deleteDataWithSql:delSql];
        if (result) {
            if (![self.foodTextView.text isEqualToString:self.model.foodName]) {
                [self.imgManager savePhotosWithImages:self.foodImgArray name:self.foodTextView.text];
                for (int i = 1; i <= 3; i++) {
                    NSString *photoName = [NSString stringWithFormat:@"%@%d",self.model.foodName,i];
                    [self.imgManager deleteImgWithName:photoName];
                }
            }
            if (!isEdit) {
                [self SystemAlert:@"Delete data successfully"];
            }
        }else{
            NSLog(@"Fail to delete");
        }
    }
}
#pragma mark - 键盘事件

//点击键盘以外的地方退出键盘
-(void)viewTappedToCloseKeyBoard:(UITapGestureRecognizer*)tapGr{
    [self.foodTextView resignFirstResponder];
    [self.foodDescribedTextView resignFirstResponder];
    [self.locationTextView resignFirstResponder];
}


#pragma mark - 根据食物过期日期发送通知
- (void)sendNotificationByExpireday{
    if (![self.foodStyle isEqualToString:@"edit"]) {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        //获取用户设置，是否自动发送
        NSString *autoNotification = [userdefault valueForKey:@"autonotification"];
        if ([autoNotification isEqualToString:@"YES"]) {
            self.fosaNotification = [[fosaNotificationManager alloc]init];
            [self.fosaNotification initNotification];
            //self.foodTextView.text,device,self.foodDescribedTextView.text,storagedate,expiredate,self.locationTextView.text,self.foodTextView.text,selectCategory,self.likeBtn.accessibilityValue
            FoodModel *model = [FoodModel modelWithName:self.foodTextView.text DeviceID:device Description:self.foodDescribedTextView.text StrogeDate:storageStr ExpireDate:remindStr foodIcon:self.foodTextView.text category:selectCategory Location:self.locationTextView.text];
            NSString *body = [NSString stringWithFormat:@"Your food %@ has expired",self.foodTextView.text];
            //获取通知的图片
            UIImage *image = [self.imgManager getImgWithName:[NSString stringWithFormat:@"%@%d",self.foodTextView.text,1]];
            NSLog(@"%@",image)
            //另存通知图片
            [self.imgManager savePhotoWithImage:image name:self.foodTextView.text];
            
            NSLog(@">>>=================%@",remindStr);
            [self.fosaNotification sendNotificationByDate:model body:body date:remindStr foodImg:image];
        }
    }
    [self SystemAlert:@"Success"];
}

#pragma mark - 生成分享视图
//分享视图与食物二维码
//仿照系统通知绘制UIview
- (UIView *)CreatNotificatonViewWithContent:(NSString *)body{
    //分享二维码食物信息
    NSString *message = [NSString stringWithFormat:@"FOSAINFO&%@&%@&%@&%@&%@&%@",self.foodTextView.text,device,self.foodDescribedTextView.text,self.expireDateLabel.text,self.storageDateLabel.text,selectCategory];
    NSLog(@"begin creating");
    int mainwidth = screen_width;
    int mainHeight = screen_height;

    UIView *notification = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainwidth,mainHeight)];
    notification.backgroundColor = [UIColor whiteColor];

    //食物图片
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0,mainHeight/8, mainwidth, mainHeight/2)];
    
    //FOSA的logo
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(mainwidth*2/5, mainHeight-mainwidth/5, mainwidth/10, mainwidth/10)];
    
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
    if (self.imageviewArray.count > 0) {
        image.image = self.imageviewArray[0].image;
    }else{
        image.image = [UIImage imageNamed:@"icon_defaultImg"];
    }
    
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    InfoCodeView.image = [self.imgManager GenerateQRCodeByMessage:message];
    InfoCodeView.backgroundColor = [UIColor redColor];
    InfoCodeView.contentMode = UIViewContentModeScaleAspectFill;
    InfoCodeView.clipsToBounds = YES;
    
    brand.font  = [UIFont systemFontOfSize:15];
    brand.textAlignment = NSTextAlignmentCenter;
    brand.text  = @"FOSA";
    
    Nbody.font   = [UIFont systemFontOfSize:12];
    Nbody.text = body;
    
    return notification;
}
//弹出系统提示
-(void)SystemAlert:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if ([message isEqualToString:@"Success"] || [message isEqualToString:@"Delete data successfully"] ) {
        [self presentViewController:alert animated:true completion:nil];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:1];
    }else{
        [alert addAction:[UIAlertAction actionWithTitle:@"Get It" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:true completion:nil];
    }
}
- (void)dismissAlertView:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
    if ([alert.message isEqualToString:@"Success"]) {

        if ([self.foodStyle isEqualToString:@"edit"]){
            self.foodStyle = @"Info";
            //[self.navigationController popViewControllerAnimated:YES];
            [self recoverEditView];
        }else if([self.foodStyle isEqualToString:@"adding"]){
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if([alert.message isEqualToString:@"Delete data successfully"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**隐藏底部横条，点击屏幕可显示*/
- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}
//禁止应用屏幕自动旋转
- (BOOL)shouldAutorotate{
    return NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.fmdbManager closeDB];
    self.likeBtn.hidden = YES;
    self.backbtn.hidden = YES;
}
@end
