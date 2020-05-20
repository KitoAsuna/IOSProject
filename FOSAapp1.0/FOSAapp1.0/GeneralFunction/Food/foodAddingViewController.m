//
//  foodAddingViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/3/4.
//  Copyright © 2020 hs. All rights reserved.
//

#import "foodAddingViewController.h"
#import "takePictureViewController.h"
#import "FosaDatePickerView.h"
#import "foodKindCollectionViewCell.h"
#import "FMDB.h"
#import <UserNotifications/UserNotifications.h>
#import "FosaNotification.h"
#import "QRCodeScanViewController.h"
#import "repeatWayViewController.h"
#import "categoryModel.h"

#import "FosaIMGManager.h"
#import "FosaFMDBManager.h"

@interface foodAddingViewController ()<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate, UICollectionViewDelegate,FosaDatePickerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UNUserNotificationCenterDelegate>{
    NSString *kindID;
    NSString *selectCategory,*selectCategoryIcon;
    NSString *docPath;
    NSInteger currentPictureIndex,categoryIndex;//标识图片轮播器当前指向哪张图片,当前种类栏在哪一页
    NSString *device;
    Boolean isEdit;
    NSString *expireStr,*storageStr,*issend,*remindStr;
    int foodPhotoIndex;
    FosaIMGManager *imgManager;
    FosaFMDBManager *fmdbManager;
}

@property (nonatomic,weak)   FosaDatePickerView *fosaDatePicker;//日期选择器
@property (nonatomic,strong) NSMutableArray<NSString *> *categoryArray;//种类
//@property (nonatomic,strong) FMDatabase *db;//数据库
// 当前获取焦点的UITextField
@property (strong, nonatomic) UITextView *currentResponderTextView;
//图片轮播器
@property (nonatomic,strong) UIImageView *imageview1,*imageview2,*imageview3;
@property (nonatomic,strong) NSMutableArray<UIImageView *> *imageviewArray;
//当前选中的种类cell
@property (nonatomic,strong) foodKindCollectionViewCell *selectedCategory;

//图片放大视图
@property (nonatomic,strong) UIScrollView *backGround;
@property (nonatomic,strong) UIImageView  *bigImage;
//FOSA通知对象
@property (nonatomic,strong) FosaNotification *fosaNotification;

@property (nonatomic,strong) UIButton *refreshBtn;
@property (nonatomic,strong) NSMutableArray<categoryModel *> *categoryData;
@end

@implementation foodAddingViewController
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

- (UIView *)remindView{
    if (_remindView == nil) {
        _remindView = [UIView new];
    }
    return _remindView;
}

- (UILabel *)remindLabel{
    if (_remindLabel == nil) {
        _remindLabel = [UILabel new];
    }
    return _remindLabel;
}
- (UITextField *)remindDateTextView{
    if (_remindDateTextView == nil) {
        _remindDateTextView = [UITextField new];
    }
    return _remindDateTextView;
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
- (NSMutableArray<categoryModel *> *)categoryData{
    if (_categoryData == nil) {
        _categoryData = [NSMutableArray new];
    }
    return _categoryData;
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatNavigation];
    [self creatHeaderView];
    [self creatContentView];
    [self creatFooterView];
    [self showFoodInfoInView];
    [self InitialDatePicker];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self OpenSqlDatabase:@"FOSA"]; //打开数据库
    
    self.fosaNotification = [[FosaNotification alloc]init];
    [self.fosaNotification initNotification];
    
    if (![self.foodStyle isEqualToString:@"Info"]) {
        self.backbtn.hidden = NO;
        self.mainImgBtn.hidden = NO;
        if (![device isEqualToString:@"null"]) {
            [self SystemAlert:@"Binding device successfully"];
            self.likeBtn.hidden = NO;
        }
    }
}
//UI
- (void)creatNavigation{
    device = @"null";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
/**like*/
    self.likeBtn.frame = CGRectMake(screen_width/2-NavigationBarH/3, NavigationBarH/6, NavigationBarH*2/3, NavigationBarH*2/3);
    [self.likeBtn setImage:[UIImage imageNamed:@"img_foodCode"] forState:UIControlStateNormal];
    self.likeBtn.tag = 0;
    [self.navigationController.navigationBar addSubview:self.likeBtn];
    //[self.likeBtn addTarget:self action:@selector(selectToLike) forControlEvents:UIControlEventTouchUpInside];
    self.likeBtn.hidden = YES;
    self.mainImgBtn = [UIButton new];
    self.mainImgBtn.frame = CGRectMake(screen_width-NavigationBarH*5/2, NavigationBarH/6, NavigationBarH*2/3, NavigationBarH*2/3);
    [self.mainImgBtn setBackgroundImage:[UIImage imageNamed:@"icon_setMainImg"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:self.mainImgBtn];
    [self.mainImgBtn addTarget:self action:@selector(setImgAsMainBackground) forControlEvents:UIControlEventTouchUpInside];
/**help*/
    
    self.helpBtn.frame = CGRectMake(0, 0, NavigationBarH/2, NavigationBarH/2);
    [self.helpBtn setBackgroundImage:[UIImage imageNamed:@"icon_helpW"]  forState:UIControlStateNormal];
    [self.helpBtn addTarget:self action:@selector(selectToHelp) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.foodStyle isEqualToString:@"adding"]) {
        /**显示图片和标题的自定义返回按钮*/
        self.backbtn.frame = CGRectMake(10, 0, NavigationBarH*5/3, NavigationBarH*5/9);
        self.backbtn.center = CGPointMake(NavigationBarH*5/6+10, NavigationBarH/2);
        [self.backbtn setBackgroundImage:[UIImage imageNamed:@"icon_backW"] forState:UIControlStateNormal];
        [self.backbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:self.backbtn];
        //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.helpBtn];
    }else if([self.foodStyle isEqualToString:@"Info"]){
        //self.editBtn.frame = CGRectMake(0, 0, NavigationBarH*2, NavigationBarH/2);
        //添加约束
        [[self.editBtn.widthAnchor constraintEqualToConstant:NavigationBarH*5/3] setActive:YES];
        [[self.editBtn.heightAnchor constraintEqualToConstant:NavigationBarH*5/9] setActive:YES];
        self.editBtn.layer.cornerRadius = NavigationBarH*5/18;
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
        self.showFoodNameLabel.frame = CGRectMake(headerWidth*2/33, headerHeight*7/10, headerWidth*29/33, headerHeight/10);
        self.showFoodNameLabel.font  = [UIFont systemFontOfSize:25*(414.0/screen_width)];
        self.showFoodNameLabel.textColor = [UIColor whiteColor];
        [self.headerView addSubview:self.showFoodNameLabel];
    }
    //日期
    self.storageView.frame = CGRectMake(headerWidth*2/33, headerHeight*4/5, headerWidth*9/33, headerHeight/6);
    [self.headerView addSubview:self.storageView];
    
    self.expireView.frame = CGRectMake(headerWidth*2/3, headerHeight*4/5, headerWidth/3, headerHeight/6);
    self.expireView.userInteractionEnabled = YES;
    UITapGestureRecognizer *dateRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectExpireDate)];
    [self.expireView addGestureRecognizer:dateRecognizer];
    [self.headerView addSubview:self.expireView];

    int storageWidth = self.storageView.frame.size.width;
    int storageHeight = self.storageView.frame.size.height;

    self.storageLabel.frame = CGRectMake(0, 0, storageWidth, storageHeight/3);
    self.storageLabel.text = @"Store Date";
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
 
    //界面初始化，默认存储日期和过期日期均为当天的时间
    NSArray *currentArrray = [currentDateStr componentsSeparatedByString:@"/"];
    NSString *storageDate = [NSString stringWithFormat:@"%@/%@/%@",currentArrray[0],[mouth valueForKey:currentArrray[1]],currentArrray[2]];
    expireStr = [NSString stringWithFormat:@"%@/%@/%@/%@",currentArrray[0],currentArrray[1],currentArrray[2],currentArrray[3]];
    NSLog(@"--------------------%@",expireStr);
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
    self.expireLabel.text = @"Best Before Date";
    self.expireLabel.font = [UIFont systemFontOfSize:15];
    self.expireLabel.textColor = [UIColor whiteColor];
    //self.expireLabel.textAlignment = NSTextAlignmentRight;
    [self.expireView addSubview:self.expireLabel];
    self.expireDateLabel.text = @"Tap to add";
    self.expireDateLabel.frame = CGRectMake(0, expireHeight/3, expireWidth, expireHeight/3);
    //self.expireDateLabel.text = @"Tap to add";//storageDate;
    self.expireDateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0*(414.0/screen_width)];
    self.expireDateLabel.adjustsFontSizeToFitWidth = YES;
    self.expireDateLabel.textColor = [UIColor whiteColor];
    [self.expireView addSubview:self.expireDateLabel];
    
    self.expireTimeLabel.frame = CGRectMake(0, expireHeight*2/3, expireWidth, expireHeight/3);
    //self.expireTimeLabel.text = currentArrray[3];
    self.expireTimeLabel.textColor = [UIColor whiteColor];
    [self.expireView addSubview:self.expireTimeLabel];
}

- (void)creatContentView{
    self.contentView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), screen_width, screen_height*50/143);
    int contentHeight = self.contentView.frame.size.height;
    [self.view addSubview:self.contentView];
    
    self.foodNameView.frame = CGRectMake(0, 0, screen_width, contentHeight/5);
    [self.contentView addSubview:self.foodNameView];

    self.foodNameLabel.frame = CGRectMake(screen_width*2/33+Width(10), contentHeight/30, screen_width/3, contentHeight*2/30);
    self.foodNameLabel.text = @"Name";
    self.foodNameLabel.font = [UIFont systemFontOfSize:font(15)];
    self.foodNameLabel.textColor = [UIColor grayColor];
    [self.foodNameView addSubview:self.foodNameLabel];
    self.foodTextView.frame = CGRectMake(screen_width*2/33, contentHeight/10, screen_width*51/66, contentHeight/10);
    self.foodTextView.layer.cornerRadius = 5;
    self.foodTextView.font = [UIFont systemFontOfSize:font(15)];
    [self.foodTextView addTarget:self action:@selector(textFieldEditChange:) forControlEvents:UIControlEventEditingChanged];
    //self.foodTextView.
    [self.foodTextView setValue:[NSNumber numberWithInt:Width(10)] forKey:@"paddingLeft"];//设置输入文本的起始位置
    self.foodTextView.delegate = self;
    self.foodTextView.returnKeyType = UIReturnKeyDone;
    self.foodTextView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.foodNameView addSubview:self.foodTextView];
    self.shareBtn.frame = CGRectMake(screen_width*31/33-contentHeight/10, contentHeight/10, contentHeight/10, contentHeight/10);
    [self.shareBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(jumpToShare) forControlEvents:UIControlEventTouchUpInside];
    [self.foodNameView addSubview:self.shareBtn];
    self.scanBtn.frame = CGRectMake(screen_width*31/33-contentHeight/10, contentHeight/10, contentHeight/10, contentHeight/10);
    [self.scanBtn setImage:[UIImage imageNamed:@"icon_scan"] forState:UIControlStateNormal];
    [self.scanBtn addTarget:self action:@selector(jumpToScan) forControlEvents:UIControlEventTouchUpInside];
    [self.foodNameView addSubview:self.scanBtn];
    if ([self.foodStyle isEqualToString:@"Info"]) {
        self.scanBtn.hidden = YES;
    }else{
        self.shareBtn.hidden = YES;
    }
    /**
                提示与文字上下一致
     */
    //描述
    self.foodDescribedView.frame = CGRectMake(0, CGRectGetMaxY(self.foodNameView.frame), screen_width, contentHeight*2/5);
    [self.contentView addSubview:self.foodDescribedView];
    self.foodDescribedLabel.frame = CGRectMake(screen_width*2/33+Width(10), contentHeight/30, screen_width/3, contentHeight/15);
    self.foodDescribedLabel.text = @"Description";
    self.foodDescribedLabel.font = [UIFont systemFontOfSize:font(15)];
    self.foodDescribedLabel.textColor = [UIColor grayColor];
    [self.foodDescribedView addSubview:self.foodDescribedLabel];
    self.foodDescribedTextView.frame = CGRectMake(screen_width*2/33, contentHeight/10, screen_width*29/33, contentHeight*3/10);
    self.foodDescribedTextView.layer.cornerRadius = 5;
    self.foodDescribedTextView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    self.foodDescribedTextView.textColor = [UIColor blackColor];
    self.foodDescribedTextView.font = [UIFont systemFontOfSize:font(15)];
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
    
    self.remindView.frame = CGRectMake(0, CGRectGetMaxY(self.foodDescribedView.frame), screen_width, contentHeight/5);
    [self.contentView addSubview:self.remindView];
    self.remindLabel.frame = CGRectMake(screen_width*2/33+Width(10), contentHeight/30, screen_width/3, contentHeight/15);
    self.remindLabel.text = @"Reminder";
    self.remindLabel.font = [UIFont systemFontOfSize:font(15)];
    self.remindLabel.textColor = [UIColor grayColor];
    [self.remindView addSubview:self.remindLabel];
    
    self.remindDateTextView.frame = CGRectMake(screen_width*2/33, contentHeight/10, screen_width*29/33, contentHeight/10);
    self.remindDateTextView.adjustsFontSizeToFitWidth = YES;
    self.remindDateTextView.layer.cornerRadius = 5;
    self.remindDateTextView.userInteractionEnabled = NO;
    self.remindDateTextView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    self.remindDateTextView.font = [UIFont systemFontOfSize:font(13)];
    [self.remindDateTextView setValue:[NSNumber numberWithInt:font(10)] forKey:@"paddingLeft"];//设置输入文本的起始位置
    self.remindDateTextView.userInteractionEnabled = YES;
    UITapGestureRecognizer *dateReconizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectExpireDate)];
    [self.remindDateTextView addGestureRecognizer:dateReconizer];
    
    [self.remindView addSubview:self.remindDateTextView];
    
    
    self.locationView.frame = CGRectMake(0, CGRectGetMaxY(self.remindView.frame), screen_width, contentHeight/5);
    [self.contentView addSubview:self.locationView];
    self.locationLabel.frame = CGRectMake(screen_width*2/33+Width(10), contentHeight/30, screen_width/3, contentHeight/15);
    self.locationLabel.text = @"Location";
    self.locationLabel.font = [UIFont systemFontOfSize:font(15)];
    self.locationLabel.textColor = [UIColor grayColor];
    [self.locationView addSubview:self.locationLabel];
    self.locationTextView.frame = CGRectMake(screen_width*2/33, contentHeight/10, screen_width*29/33, contentHeight/10);
    self.locationTextView.font = [UIFont systemFontOfSize:font(15)];
    self.locationTextView.layer.cornerRadius = 5;
    self.locationTextView.returnKeyType = UIReturnKeyDone;
    self.locationTextView.delegate = self;
    [self.locationTextView setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"];
    self.locationTextView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.locationView addSubview:self.locationTextView];
}

- (void)creatFooterView{
    selectCategory = self.model.category;
    [self getCategoryArray];
    kindID = @"categoryCell";
    categoryIndex = 0;
    self.footerView.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame)+5, screen_width, screen_width*5/24);
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
    self.categoryCollection.pagingEnabled = YES;
    [self.categoryCollection registerClass:[foodKindCollectionViewCell class] forCellWithReuseIdentifier:kindID];
    [self.footerView addSubview:self.categoryCollection];
    
    self.doneBtn.frame = CGRectMake(screen_width/3, CGRectGetMaxY(self.footerView.frame)+screen_height*4/143, screen_width/3, screen_height*6/143);
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
        self.deleteBtn.frame = CGRectMake(screen_width/3, CGRectGetMaxY(self.footerView.frame)+screen_height*4/143, screen_width/3, screen_height*6/143);
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
        self.mainImgBtn.hidden = YES;
        //禁止界面互动
        self.foodTextView.userInteractionEnabled = NO;
        self.foodDescribedTextView.userInteractionEnabled = NO;
        self.storageView.userInteractionEnabled = NO;
        self.expireView.userInteractionEnabled = NO;
        self.locationView.userInteractionEnabled = NO;
        self.remindView.userInteractionEnabled = NO;

        NSArray<NSString *> *storageTimeArray;
        storageTimeArray = [self.model.storageDate componentsSeparatedByString:@"/"];

        NSLog(@"--->>>%@",self.model.expireDate);
        if (![self.model.expireDate isEqualToString:@""]) {
            NSArray<NSString *> *expireTimeArray;
            expireTimeArray = [self.model.expireDate componentsSeparatedByString:@"/"];
            expireStr = self.model.expireDate;
            self.expireDateLabel.text = [NSString stringWithFormat:@"%@/%@/%@",expireTimeArray[0],expireTimeArray[1],expireTimeArray[2]];
            self.expireTimeLabel.text = expireTimeArray[3];
        }

        self.showFoodNameLabel.text = self.model.foodName;
        self.showFoodNameLabel.font = [UIFont systemFontOfSize:22 weight:20];
        
        if (![self.model.device isEqualToString:@"null"]) {
            self.likeBtn.hidden = NO;
            device = self.model.device;
        }
        
        if (self.model.remindDate.length > 0) {
            self.remindDateTextView.text = [NSString stringWithFormat:@"%@ -%@",self.model.remindDate,self.model.repeat];
        }
        self.storageDateLabel.text = [NSString stringWithFormat:@"%@/%@/%@",storageTimeArray[0],storageTimeArray[1],storageTimeArray[2]];
        
        self.storageTimeLabel.text = storageTimeArray[3];

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
    //初始化图片管理者对象
    imgManager = [FosaIMGManager new];
    [imgManager InitImgManager];
    
    self.imageviewArray = [[NSMutableArray alloc]initWithObjects:self.imageview1,self.imageview2,self.imageview3, nil];
    foodPhotoIndex = 1;
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
        NSString *img = [NSString stringWithFormat:@"%@%ld",self.model.foodName,i+1];
        if ([self.foodStyle isEqualToString:@"Info"] && [self getImage:img] != nil) {
            
            self.imageviewArray[i].image = [self getImage:img];
            self.foodImgArray[i] = self.imageviewArray[i].image;
        }else{
            NSString *imgName = [NSString stringWithFormat:@"%@%ld",@"picturePlayer",i+1];
            self.imageviewArray[i].image = [UIImage imageNamed:imgName];
        }
        UITapGestureRecognizer *clickRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumptoPhoto:)];
               //clickRecognizer.view.tag = i;
        [self.imageviewArray[i] addGestureRecognizer:clickRecognizer];
        [self.picturePlayer addSubview:self.imageviewArray[i]];
    }
    NSLog(@"====================>>>>>>>>>>:%@",self.foodImgArray);
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
    FosaDatePickerView *DatePicker = [[FosaDatePickerView alloc]initWithFrame:CGRectMake(0, screen_height, self.view.frame.size.width, screen_height*80/143) expireDate:expireStr remindDate:self.remindDateTextView.text  repeatWay:self.model.repeat];
    DatePicker.delegate = self;
    DatePicker.title = @"Expiration date";
    [self.view addSubview:DatePicker];
    self.fosaDatePicker = DatePicker;
    self.fosaDatePicker.hidden = YES;
    remindStr = @"";
}
#pragma mark -- FosaDatePickerViewDelegate
/**
 保存按钮代理方法
 @param timer 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer remindDate:(nonnull NSString *)remindTimer {
    NSLog(@"保存点击");
    //处理日期字符串
    NSArray *array = [timer componentsSeparatedByString:@"/"];
    
    expireStr = [NSString stringWithFormat:@"%@/%@/%@/%@",array[1],array[0],array[2],array[3]];
    NSLog(@"^^^^^^^^^^^^^^^^^^^^我选择了expireStr:%@",expireStr);

    NSString *dateStr = [NSString stringWithFormat:@"%@/%@/%@",array[1],[mouth valueForKey:array[0]],array[2]];
    self.expireDateLabel.text = dateStr;
    self.expireTimeLabel.text= array[3];
    if (remindTimer.length > 0) {
        remindStr = remindTimer;
        self.remindDateTextView.text = [NSString stringWithFormat:@"%@ -%@",remindTimer,self.fosaDatePicker.repeatWayLabel.text];//remindTimer;
    }
    NSLog(@"%@",dateStr);
    [UIView animateWithDuration:0.3 animations:^{
       self.fosaDatePicker.frame = CGRectMake(0, screen_height, self.view.frame.size.width, screen_height*80/143);
   }];
}
/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate {
    NSLog(@"取消点击");
    [UIView animateWithDuration:0.3 animations:^{
        self.fosaDatePicker.frame = CGRectMake(0, screen_height, self.view.frame.size.width, screen_height*80/143);
    }];
}
/**
 选择重复提醒方式
 */
- (void)jumpToRepeatView{
    repeatWayViewController *repeat = [repeatWayViewController new];
    repeat.currentRepeat = self.fosaDatePicker.repeatWayLabel.text;
    repeat.repeatBlock = ^(NSString *repeatWay){
        self.fosaDatePicker.repeatWayLabel.text = repeatWay;
    };
    [self.navigationController pushViewController:repeat animated:YES];
    
}
#pragma mark -- UIScrollerView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    if (scrollView == self.picturePlayer) {
        NSInteger index = offset/self.headerView.frame.size.width;
        self.pageControl.currentPage = index;
        currentPictureIndex = index;
    }else if(scrollView == self.categoryCollection){
        categoryIndex = offset/(self.categoryCollection.frame.size.width);
        NSLog(@"食物种类滚动了,当前位置:%ld",(long)categoryIndex);
    }else{
        NSInteger index = offset/screen_width;
        self.toturialPageControl.currentPage = index;
        if (index == 14) {
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
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    self.bigImage.center = self.view.center;
//}

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
    return self.categoryData.count;
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
    
    foodKindCollectionViewCell *cell = [self.categoryCollection dequeueReusableCellWithReuseIdentifier:kindID forIndexPath:indexPath];
    cell.kind.text = self.categoryData[indexPath.row].categoryName;
    if ([self.foodStyle isEqualToString:@"edit"] && [self.categoryData[indexPath.row].categoryName isEqualToString:selectCategory]) {
        cell.rootView.backgroundColor = FOSAYellow;
        cell.kind.textColor = FOSAYellow;
        //selectCategory = self.categoryData[indexPath.row].categoryName;
        selectCategoryIcon = self.categoryData[indexPath.row].categoryIconName;
        cell.categoryPhoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@W",selectCategoryIcon]];
        self.selectedCategory = cell;
    }else{
        cell.rootView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        cell.categoryPhoto.image = [UIImage imageNamed:self.categoryData[indexPath.row].categoryIconName];
        cell.kind.textColor = [UIColor grayColor];
    }
    return cell;
}
//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    foodKindCollectionViewCell *cell = (foodKindCollectionViewCell *)[self.categoryCollection cellForItemAtIndexPath:indexPath];
    if (![cell.kind.text isEqualToString:selectCategory]) {
        self.selectedCategory.rootView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        self.selectedCategory.categoryPhoto.image = [UIImage imageNamed:selectCategoryIcon];
        self.selectedCategory.categoryPhoto.backgroundColor = [UIColor clearColor];
        self.selectedCategory.kind.textColor = [UIColor grayColor];
    }
    cell.rootView.backgroundColor = FOSAYellow;
    cell.kind.textColor = FOSAYellow;
    selectCategory = self.categoryData[indexPath.row].categoryName;
    selectCategoryIcon  = self.categoryData[indexPath.row].categoryIconName;
    
    cell.categoryPhoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@W",selectCategoryIcon]];
    self.selectedCategory = cell;
    NSLog(@"Selectd:%@",selectCategory);
}
//
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//    self.selectedCategory.rootView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
//    self.selectedCategory.categoryPhoto.image = [UIImage imageNamed:selectCategoryIcon];
//    self.selectedCategory.categoryPhoto.backgroundColor = [UIColor clearColor];
//}

#pragma mark - UITextViewDelegate,UITextFiledDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.5 animations:^{
        [self.contentView setContentOffset:CGPointMake(0, self.contentView.frame.size.height/5)];
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

//textFiled额外的点击方法
- (void)textFieldEditChange:(UITextField*)textField{
    self.showFoodNameLabel.text = textField.text;
}

#pragma mark - 响应事件

- (void)offsetToLeft{
    if (categoryIndex-1 >= 0) {
        [self.categoryCollection setContentOffset:CGPointMake((categoryIndex-1)*self.categoryCollection.frame.size.width, 0)];
        categoryIndex --;
    }
}
- (void)offsetToRight{
    if (categoryIndex+1 < 4) {
        [self.categoryCollection setContentOffset:CGPointMake((categoryIndex+1)*self.categoryCollection.frame.size.width, 0)];
        categoryIndex ++;
    }

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
- (void)setImgAsMainBackground{
    NSLog(@"currentIndex:%ld",(long)currentPictureIndex);
    [self.mainImgBtn setBackgroundImage:[UIImage imageNamed:@"icon_setMainImgG"] forState:UIControlStateNormal];
    if (currentPictureIndex != 0) {
        foodPhotoIndex = (int)currentPictureIndex+1;
        NSString *mainImg = [NSString stringWithFormat:@"%@%ld",self.foodTextView.text,currentPictureIndex];
        NSString *updateSql = [NSString stringWithFormat:@"update FoodStorageInfo set foodImg = '%@' where foodName = '%@'",mainImg,self.foodTextView.text];
        NSLog(@"foodImg:%@",updateSql);
        if ([fmdbManager isFmdbOpen]) {
            if([fmdbManager updateDataWithSql:updateSql]){
                NSLog(@"修改成功");
            }
        }
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
    self.remindView.userInteractionEnabled = YES;
    
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
        self.mainImgBtn.hidden = NO;
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
        self.mainImgBtn.hidden = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editBtn];
    }];
}
- (void)selectToHelp{
    //隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
    
    self.skipBtn.frame = CGRectMake(0, NavigationBarH, screen_width/4, NavigationBarH);
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
    self.toturialPicturePlayer.contentSize = CGSizeMake(screen_width*15, 0);
    for (NSInteger i = 0; i < 15; i++) {
        CGRect frame = CGRectMake(i*screen_width, 0, screen_width,screen_height);
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:frame];
        imageview.userInteractionEnabled = YES;
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        imageview.clipsToBounds = YES;
        NSString *imgName = [NSString stringWithFormat:@"%@%ld",@"img_tutorial",i+1];
        imageview.image = [UIImage imageNamed:imgName];
        [self.toturialPicturePlayer addSubview:imageview];
        
        if (i == 14) {
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
    self.toturialPageControl.numberOfPages = 15;
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
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy/HH:mm"];
    NSDate *date = [dateFormatter dateFromString:expireStr];
    self.fosaDatePicker.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.fosaDatePicker.center = CGPointMake(screen_width/2, screen_height*103/143);
        self.fosaDatePicker.date = [dateFormatter stringFromDate:date];
        [self.fosaDatePicker show];
       }];
}

- (void)jumptoPhoto:(UITapGestureRecognizer *)tap{
    CGPoint touchPoint = [tap locationInView:self.picturePlayer];
    NSLog(@"%f-----%f",touchPoint.x,touchPoint.y);
    if (touchPoint.y < self.headerView.frame.size.height*4/5) {
        if ([self.foodStyle isEqualToString:@"Info"]) {
            NSLog(@"放大图片");
            [self EnlargePhoto];
        }else{
            takePictureViewController *photo = [[takePictureViewController alloc]init];
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
}
- (void)jumptoPhoto{
    if ([self.foodStyle isEqualToString:@"Info"]) {
        NSLog(@"放大图片");
        [self EnlargePhoto];
    }else{
        takePictureViewController *photo = [[takePictureViewController alloc]init];
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
     UIAlertController *backAlert = [UIAlertController alertControllerWithTitle:AlertTitle message:@"Do you want to leave the page?" preferredStyle:UIAlertControllerStyleAlert];
    [backAlert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
       }]];
    [backAlert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
       }]];
    [self presentViewController:backAlert animated:true completion:nil];
}

- (void)jumpToScan{
    QRCodeScanViewController *scan = [QRCodeScanViewController new];
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
    UIImage *sharephoto1 = [imgManager saveViewAsPictureWithView:view];
    NSArray *activityItems = @[sharephoto1];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}
- (void)saveInfoAndFinish{
    //if ([self.foodStyle isEqualToString:@"edit"]) {
            
    //}else{
    //    [self SavephotosInSanBox:self.foodImgArray];
    [imgManager savePhotosWithImages:self.foodImgArray name:self.foodTextView.text];
    [self DeleteRecord];
    //}
    [self CreatDataTable];
}
- (void)deleteFoodRecord{
    //功能有待完善，添加点击放大图片的功能
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AlertTitle message:@"You will delete this food record" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self DeleteRecord];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:true completion:nil];
    
}

#pragma mark - 键盘事件

//点击键盘以外的地方退出键盘
-(void)viewTappedToCloseKeyBoard:(UITapGestureRecognizer*)tapGr{
    [self.foodTextView resignFirstResponder];
    [self.foodDescribedTextView resignFirstResponder];
    [self.locationTextView resignFirstResponder];
}

#pragma mark -- FMDB数据库操作

- (void)OpenSqlDatabase:(NSString *)dataBaseName{
    fmdbManager = [FosaFMDBManager initFMDBManagerWithdbName:@"FOSA"];
//    //获取数据库地址
//    docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
//    NSLog(@"%@",docPath);
//    //设置数据库名
//    NSString *fileName = [docPath stringByAppendingPathComponent:dataBaseName];
//    //创建数据库
//    self.db = [FMDatabase databaseWithPath:fileName];
//    if([self.db open]){
//        NSLog(@"打开数据库成功");
//    }else{
//        NSLog(@"打开数据库失败");
//    }
}
- (void)CreatDataTable{
    NSString *Sql = @"CREATE TABLE IF NOT EXISTS FoodStorageInfo(id integer PRIMARY KEY AUTOINCREMENT, foodName text NOT NULL, device text, aboutFood text,storageDate text NOT NULL,expireDate text NOT NULL,remindDate text,location text,foodImg text NOT NULL,category text NOT NULL,repeatWay text,send text);";
    //BOOL categoryResult = [self.db executeUpdate:Sql];
    if([fmdbManager creatTableWithSql:Sql])
    {
        NSLog(@"创建食物存储表成功");
        [self InsertDataIntoFoodTable];
    }else{
        NSLog(@"创建食物存储表失败");
    }
}

- (void)InsertDataIntoFoodTable{
    NSLog(@"=================》》》》%@",expireStr);
    NSString *storagedate = [NSString stringWithFormat:@"%@/%@",self.storageDateLabel.text,self.storageTimeLabel.text];
    NSString *expiredate;
    if ([self.expireDateLabel.text isEqualToString:@"Tap to add"]) {
        expiredate = @"";
    }else{
        expiredate = [NSString stringWithFormat:@"%@/%@",self.expireDateLabel.text,self.expireTimeLabel.text];
    }
    
    if (![self.remindDateTextView.text isEqualToString:@""]) {
        issend = @"YES";
    }else{
        issend = @"NO";
    }
    NSString *mainImg = [NSString stringWithFormat:@"%@%d",self.foodTextView.text,foodPhotoIndex];
    NSString *insertSql = [NSString stringWithFormat:@"insert into FoodStorageInfo(foodName,device,aboutFood,storageDate,expireDate,remindDate,location,foodImg,category,repeatWay,send) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",self.foodTextView.text,device,self.foodDescribedTextView.text,storagedate,expiredate,remindStr,self.locationTextView.text,mainImg,selectCategory,self.fosaDatePicker.repeatWayLabel.text,issend];
    if ([self.foodTextView.text isEqualToString:@""]) {
        [self SystemAlert:@"Please input the name of your food!"];
    }else if(selectCategory == nil){
        [self SystemAlert:@"Please select a category for your food"];
    }else{
        if ([fmdbManager isFmdbOpen]) {
            
            //BOOL insertResult = [self.db executeUpdate:insertSql];
            NSLog(@"~~~~~~~~~~~~~~~~~~~~设备号：%@",device);
            if ([fmdbManager insertDataWithSql:insertSql]) {
                [self sendReminderNotification];
                [self sendNotificationByExpireday];
            }else{
                [self SystemAlert:@"Error"];
            }
        }
    }
}

//获取食品种类
- (void)getCategoryArray{
   [self OpenSqlDatabase:@"FOSA"];
//    NSString *selSql = @"select * from category";
//    FMResultSet *set = [self.db executeQuery:selSql];
//    [self.categoryData removeAllObjects];
//    while ([set next]) {
//        NSString *kind = [set stringForColumn:@"categoryName"];
//        NSString *icon = [set stringForColumn:@"categoryIcon"];
//        NSLog(@"%@",kind);
//        categoryModel *model = [categoryModel modelWithName:kind iconName:icon];
//        [self.categoryData addObject:model];
//    }
      NSString *selSql = @"select * from category";
    if ([fmdbManager isFmdbOpen]) {
        self.categoryData = [fmdbManager selectDataWithTableName:@"category" sql:selSql];
    }
    if ([self.foodStyle isEqualToString:@"Info"]) {
        for (int i = 0; i < self.categoryData.count; i++) {
            if ([self.categoryData[i].categoryName isEqualToString:selectCategory]) {
                [self.categoryData exchangeObjectAtIndex:i withObjectAtIndex:0];
                break;
            }
        }
    }
}

#pragma mark - 图片
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

//保存图片到沙盒
-(void)Savephoto:(UIImage *)image name:(NSString *)foodname{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *photoName = [NSString stringWithFormat:@"%@.png",foodname];
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent: photoName];// 保存文件的路径
    NSLog(@"这个是照片的保存地址:%@",filePath);
    BOOL result =[UIImagePNGRepresentation(image) writeToFile:filePath  atomically:YES];// 保存成功会返回YES
    if(result == YES) {
        NSLog(@"通知界面图片保存成功");
    }
}
//取出保存在本地的图片
- (UIImage*)getImage:(NSString *)filepath{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *photopath = [NSString stringWithFormat:@"%@.png",filepath];
    NSString *imagePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",photopath]];
    // 保存文件的名称
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    if (img == NULL) {
        img = [UIImage imageNamed:@"icon_defaultImg"];
    }else if (self.imgOfFood != nil) {
        //如果是读取相册二维码或者分享二维码，imeOfFood为图片中食物部分的截取
        img = self.imgOfFood;
    }
    NSLog(@"===%@", img);
    return img;
}

//删除记录
- (void)DeleteRecord{
    NSString *delSql = [NSString stringWithFormat:@"delete from FoodStorageInfo where foodName = '%@'",self.model.foodName];
    if ([fmdbManager isFmdbOpen]) {
        NSLog(@"删除%@",self.model.foodName);
        //BOOL result = [self.db executeUpdate:delSql];
        if ([fmdbManager deleteDataWithSql:delSql]) {
            if (![self.foodTextView.text isEqualToString:self.model.foodName]) {
                //[self SavephotosInSanBox:self.foodImgArray];
                for (int i = 1; i <= 3; i++) {
                    NSString *photoName = [NSString stringWithFormat:@"%@%d",self.model.foodName,i];
                    [self deleteFile:photoName];
                }
            }
            if (!isEdit && [self.foodStyle isEqualToString:@"Info"]) {
                [self SystemAlert:@"Delete data successfully"];
            }
        }else{
            NSLog(@"Fail to delete");
        }
    }
}
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
        }else {            NSLog(@"dele fail");
        }
    }
}
//- (Boolean)CheckFoodInfoWithName:(NSString *)foodName fdevice:(NSString *)device{
//    NSString *sql = [NSString stringWithFormat:@"select * from FoodStorageInfo where foodName = '%@' and device = '%@';",foodName,device];
////    FMResultSet *result = [self.db executeQuery:sql];
////    NSLog(@"查询到数据项:%d",result.columnCount);
////    if (result.columnCount == 0) {
////        return true;
////    }else{
////        return false;
////    }
//    NSMutableArray *result = [fmdbManager selectDataWithTableName:@"FoodStorageInfo" sql:sql];
//    if (result.count == 0) {
//        return true;
//    }else{
//        return false;
//    }
//}
#pragma mark - 发送通知
- (void)sendReminderNotification{
    //保存成功之后，检查是否设置了提醒日期，若是，则准备注册通知
    NSLog(@"-----------------------发送提醒通知------------------------");
    //![self.foodStyle isEqualToString:@"edit"] &&
    if (self.remindDateTextView.text.length>0) {
        NSArray *tempArray;
        NSString *tempStr;
        NSDateFormatter *format = [NSDateFormatter new];
        NSDateFormatter *format2 = [NSDateFormatter new];
        [format setDateFormat:@"dd MM/yyyy hh:mm a"];
        [format2 setDateFormat:@"dd/MM/yyyy/HH:mm"];
        format.AMSymbol = @"AM";
        format.PMSymbol = @"PM";

        //设定通知
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        //获取用户设置，是否设定免打扰
        NSString *autoNotification = [userdefault valueForKey:@"autonotification"];
        if ([autoNotification isEqualToString:@"NO"] || autoNotification == nil) {
            //[self.fosaNotification initNotification];
            NSString *body = [NSString stringWithFormat:@"FOSA remind you to eat your food %@ in time",self.foodTextView.text];
             //获取通知的图片
            UIImage *image = [self getImage:[NSString stringWithFormat:@"%@%d",self.foodTextView.text,1]];
           // NSLog(@"%@",image)
            //另存通知图片
            //[self Savephoto:image name:self.foodTextView.text];
            [imgManager savePhotoWithImage:image name:self.foodTextView.text];

            tempArray = [remindStr componentsSeparatedByString:@","];
            tempStr = [NSString stringWithFormat:@"%@/%@ %@",tempArray[1],tempArray[2],tempArray[3]];
            NSDate *date = [format dateFromString:tempStr];
            
            NSDate *currentDate = [NSDate new];
            double dateTime = [date timeIntervalSince1970];
            double currentDateTime = [currentDate timeIntervalSince1970];
            NSLog(@"=============%d",(int)(dateTime-currentDateTime));
            if (dateTime-currentDateTime > 0) {
                FoodModel *model = [FoodModel modelWithName:self.foodTextView.text DeviceID:device Description:self.foodDescribedTextView.text StrogeDate:storageStr ExpireDate:expireStr remindDate:self.remindDateTextView.text foodIcon:self.foodTextView.text category:selectCategory Location:self.locationTextView.text repeatWay:self.fosaDatePicker.repeatWayLabel.text];
                //||[self.fosaDatePicker.repeatWayLabel.text isEqualToString:@"Never"]
                NSString *identifier;
                if ([self.fosaDatePicker.repeatWayLabel.text isEqualToString:@"Custom reminder"]){
                    NSLog(@"重复次数:%d-------重复间隔:%d",[[userdefault valueForKey:@"repeatTimes"] intValue],[[userdefault valueForKey:@"repeatTimeInterval"] intValue]);
                    for (int i = 0; i < [[userdefault valueForKey:@"repeatTimes"] intValue]; i++) {
                        identifier = [NSString stringWithFormat:@"%@Remind%d",self.foodTextView.text,i];
                        [self.fosaNotification sendNotification:model body:body image:image time:(dateTime-currentDateTime)+i*3600*([[userdefault valueForKey:@"repeatTimeInterval"] intValue]) identifier:identifier];
                    }
                }else{
                    identifier = [NSString stringWithFormat:@"%@Remind",self.foodTextView.text];
                    [self.fosaNotification sendNotificationByDate:model body:body date:[format2 stringFromDate:date] foodImg:image identifier:identifier];
                }
            }
        }
    }
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Success" preferredStyle:UIAlertControllerStyleAlert];
//    [self presentViewController:alert animated:true completion:nil];
//    [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
}

- (void)sendNotificationByExpireday{
    NSLog(@"-----------------------发送过期通知------------------------");
    if (![self.foodStyle isEqualToString:@"edit"]) {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        //获取用户设置，是否自动发送
        NSString *autoNotification = [userdefault valueForKey:@"autonotification"];
        if ([autoNotification isEqualToString:@"NO"] || autoNotification == nil) {
            FoodModel *model = [FoodModel modelWithName:self.foodTextView.text DeviceID:device Description:self.foodDescribedTextView.text StrogeDate:storageStr ExpireDate:expireStr remindDate:self.remindDateTextView.text foodIcon:self.foodTextView.text category:selectCategory Location:self.locationTextView.text repeatWay:self.fosaDatePicker.repeatWayLabel.text];
            NSString *body = [NSString stringWithFormat:@"Your food %@ will expire today",self.foodTextView.text];
             //获取通知的图片
            UIImage *image = [self getImage:[NSString stringWithFormat:@"%@%d",self.foodTextView.text,1]];
            //另存通知图片
            [imgManager savePhotoWithImage:image name:self.foodTextView.text];
            NSLog(@">>>=================%@",expireStr);
            NSString *identifier = [NSString stringWithFormat:@"%@Expiry",self.foodTextView.text];
            [self.fosaNotification sendNotificationByDate:model body:body date:expireStr foodImg:image identifier:identifier];
            //在过期当日的早上9点，12点，下午3点，6点都发一次
            NSArray *repeatTime = @[@"09:00",@"12:00",@"15:00",@"18:00"];
            NSArray *expireArray = [expireStr componentsSeparatedByString:@"/"];
            for (int i = 0; i < 4; i++) {
//                UIImage *image = [self getImage:[NSString stringWithFormat:@"%@%d",self.foodTextView.text,1]];
//                //另存通知图片
//                [imgManager savePhotoWithImage:image name:[NSString stringWithFormat:@"%d%@",i,self.foodTextView.text]];
                NSString *expire = [NSString stringWithFormat:@"%@/%@/%@/%@",expireArray[0],expireArray[1],expireArray[2],repeatTime[i]];
                NSLog(@"重复发送过期的通知:%@",expire);
                 NSString *identifier = [NSString stringWithFormat:@"%@Expiry%d",self.foodTextView.text,i];
                [self.fosaNotification sendNotificationByDate:model body:body date:expire foodImg:image.copy identifier:identifier];
            }
        }
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Success" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:true completion:nil];
    [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:1];
}

#pragma mark - 生成分享视图
//分享视图与食物二维码
//仿照系统通知绘制UIview
- (UIView *)CreatNotificatonViewWithContent:(NSString *)body{
    NSString *storagedate = [NSString stringWithFormat:@"%@/%@",self.storageDateLabel.text,self.storageTimeLabel.text];
    NSString *expiredate;
    if ([self.expireDateLabel.text isEqualToString:@"Tap to add"]) {
        expiredate = @"";
    }else{
        expiredate = [NSString stringWithFormat:@"%@/%@",self.expireDateLabel.text,self.expireTimeLabel.text];
    }
    //分享二维码食物信息
    NSString *message = [NSString stringWithFormat:@"FOSAINFO&%@&%@&%@&%@&%@&%@&%@&%@",self.foodTextView.text,device,self.foodDescribedTextView.text,expiredate,storagedate,remindStr,selectCategory,self.fosaDatePicker.repeatWayLabel.text];
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
    UILabel *brand = [[UILabel alloc]initWithFrame:CGRectMake(mainwidth/3, NavigationBarH, mainwidth/3, mainHeight/16)];

    //食物信息二维码
    UIImageView *InfoCodeView = [[UIImageView alloc]initWithFrame:CGRectMake(mainwidth*4/5-20, mainHeight*5/8+5, mainwidth/5, mainwidth/5)];

    //提醒内容
    UITextView *Nbody = [[UITextView alloc]initWithFrame:CGRectMake(mainwidth/15, CGRectGetMaxY(image.frame), mainwidth*3/5, mainwidth/5)];
    Nbody.userInteractionEnabled = NO;

    [notification addSubview:logo];
    [notification addSubview:brand];
    [notification addSubview:InfoCodeView];
    [notification addSubview:image];
    [notification addSubview:Nbody];

    logo.image  = [UIImage imageNamed:@"icon_ntificationBrand"];
    if (self.foodImgArray.count > 0) {
        image.image = self.foodImgArray[currentPictureIndex];
    }else{
        image.image = [UIImage imageNamed:@"icon_defaultImg"];
    }
    
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    InfoCodeView.image = [self GenerateQRCodeByMessage:message];
    InfoCodeView.backgroundColor = [UIColor redColor];
    InfoCodeView.contentMode = UIViewContentModeScaleAspectFill;
    InfoCodeView.clipsToBounds = YES;
    
    brand.font  = [UIFont systemFontOfSize:font(20)];
    brand.textAlignment = NSTextAlignmentCenter;
    brand.text  = @"FOSA";
    
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
//弹出系统提示
-(void)SystemAlert:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AlertTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if ([message isEqualToString:@"Delete data successfully"] ) {
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
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [fmdbManager closeDB];
    self.likeBtn.hidden = YES;
    self.backbtn.hidden = YES;
    self.mainImgBtn.hidden = YES;
}

/**隐藏底部横条，点击屏幕可显示*/
- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}
//禁止应用屏幕自动旋转
- (BOOL)shouldAutorotate{
    return NO;
}
@end

//图片的显示模式；
/*
 UIViewContentModeScaleToFill,         // 拉伸充满整个载体；
 UIViewContentModeScaleAspectFit,      //拉伸不改变比例，充满最小的一边；
 UIViewContentModeScaleAspectFill,     // 拉伸不改变比例，充满最大的一边
 UIViewContentModeRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
 UIViewContentModeCenter,              // contents remain same size. positioned adjusted.
 UIViewContentModeTop,
 UIViewContentModeBottom,
 UIViewContentModeLeft,
 UIViewContentModeRight,
 UIViewContentModeTopLeft,
 UIViewContentModeTopRight,
 UIViewContentModeBottomLeft,
 UIViewContentModeBottomRight,
 */
