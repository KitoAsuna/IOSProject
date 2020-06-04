//
//  fosaMainViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/3/6.
//  Copyright © 2020 hs. All rights reserved.
//

#import "fosaMainViewController.h"
#import "QRCodeScanViewController.h"
#import "categoryCollectionViewCell.h"
#import "foodItemCollectionViewCell.h"
#import "foodAddingViewController.h"
#import "FMDB.h"
#import "FosaNotification.h"
#import <UserNotifications/UserNotifications.h>
#import "NotificationView.h"
#import "editFoodItemViewController.h"
#import "notificationViewController.h"

#import "FosaFMDBManager.h"
#import "FosaIMGManager.h"


@interface fosaMainViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,fosaDelegate,closeViewDelegate>{
    NSString *categoryID;//种类cell
    NSString *foodItemID;//食物cell
    NSString *docPath;//数据库地址
    //刷新标识
    Boolean isUpdate,isFirst;
    Boolean isSelectCategory;
    Boolean categoryEdit;
    //排序方式数组
    NSArray *sortArray,*sortIconArray;
    FosaFMDBManager *fmdbManager;
    int categoryIndex;
}

//存储所有食物的数组
@property (nonatomic,strong) NSMutableArray *AllFoodArray;
////种类名-图标名字典
//@property (nonatomic,strong) NSMutableDictionary *categoryDictionary;
//教学提示相关
@property (nonatomic,strong) UIView *mask,*smask;
//数据库
@property (nonatomic,strong) FMDatabase *db;
//当前选中的种类cell
@property (nonatomic,strong) categoryCollectionViewCell *selectedCategoryCell;
//当前长按的种类cell
@property (nonatomic,strong) categoryCollectionViewCell *longprogressCell;
//缓冲图标
@property (nonatomic,strong) UIActivityIndicatorView *FOSAloadingView;
@property (nonatomic,strong) FosaNotification *notification;
//排序标志记录
@property (nonatomic,strong) NSUserDefaults *userdefault;

@property (nonatomic,strong) NotificationView *notifiView;

@end

@implementation fosaMainViewController

#pragma mark - 延时加载
- (UIButton *)navigationRemindBtn{
    if (_navigationRemindBtn == nil) {
        _navigationRemindBtn = [[UIButton alloc]init];
    }
    return _navigationRemindBtn;
}

- (UIButton *)sortbtn{
    if (_sortbtn == nil) {
        _sortbtn = [[UIButton alloc]init];
    }
    return _sortbtn;
}

- (UIButton *)scanBtn{
    if (_scanBtn == nil) {
        _scanBtn = [UIButton new];
    }
    return _scanBtn;
}

- (UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton new];
    }
    return _cancelBtn;
}

- (UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [UIView new];
    }
    return _headerView;
}

- (UIScrollView *)mainBackgroundImgPlayer{
    if (_mainBackgroundImgPlayer == nil) {
        _mainBackgroundImgPlayer = [UIScrollView new];
    }
    return _mainBackgroundImgPlayer;
}

- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [UIPageControl new];
    }
    return _pageControl;
}

- (UIView *)categoryView{
    if (_categoryView == nil) {
        _categoryView = [UIView new];
    }
    return _categoryView;
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

- (UIButton *)leftBtn{
    if (_leftBtn == nil) {
        _leftBtn = [UIButton new];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn{
    if (_rightBtn == nil) {
        _rightBtn = [UIButton new];
    }
    return _rightBtn;
}

- (UIView *)foodItemView{
    if (_foodItemView == nil) {
        _foodItemView = [UIView new];
    }
    return _foodItemView;
}

- (NSMutableArray<FoodModel *> *)collectionDataSource{
    if (_collectionDataSource == nil) {
        _collectionDataSource = [[NSMutableArray alloc]init];
        //[self OpenSqlDatabase:@"FOSA"];
    }
    return _collectionDataSource;
}

- (NSMutableArray<NSString *> *)categoryDataSource{
    if (_categoryDataSource == nil) {
        _categoryDataSource = [[NSMutableArray alloc]init];
    }
    return _categoryDataSource;
}

- (NSMutableArray<categoryModel *> *)categoryData{
    if (_categoryData == nil) {
        _categoryData = [NSMutableArray new];
    }
    return _categoryData;
}

- (NSMutableArray<NSString *> *)categoryNameArray{
    if (_categoryNameArray == nil) {
        _categoryNameArray = [NSMutableArray new];
    }
    return _categoryNameArray;
}

- (NSMutableArray *)AllFoodArray{
    if (_AllFoodArray == nil) {
        _AllFoodArray = [NSMutableArray new];
    }
    return _AllFoodArray;
}

- (NSMutableDictionary *)categoryCellDictionary{
    if (_categoryCellDictionary == nil) {
        _categoryCellDictionary = [NSMutableDictionary new];
    }
    return _categoryCellDictionary;
}
- (NSUserDefaults *)userdefault{
    if (_userdefault == nil) {
        _userdefault = [NSUserDefaults standardUserDefaults];
    }
    return _userdefault;
}
//排序列表
- (UIView *)sortListView{
    if (_sortListView == nil) {
        _sortListView = [UIView new];
    }
    return _sortListView;
}
- (UIView *)smask{
    if (_smask == nil) {
        _smask = [UIView new];
    }
    return _smask;
}
- (UIButton *)cancelSortBtn{
    if (_cancelSortBtn == nil) {
        _cancelSortBtn = [UIButton new];
    }
    return _cancelSortBtn;
}

#pragma mark - 创建视图
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    isFirst = true;
    fmdbManager = [FosaFMDBManager initFMDBManagerWithdbName:@"FOSA"];
    // Do any additional setup after [UIApplication
    [self creatNavigationButton];
    [self creatMainBackgroundPlayer];
    [self creatCategoryView];
    [self creatFoodItemCategoryView];
    
    NSUserDefaults *userDefault = NSUserDefaults.standardUserDefaults;
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *localVersion = [userDefault valueForKey:@"localVersion"];
    if (![currentVersion isEqualToString:localVersion]) {
        NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        [userDefault setObject:currentVersion forKey:@"localVersion"];
        [self showUsingTips];
    }else{
        NSLog(@"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.scanBtn.hidden = NO;
    self.navigationRemindBtn.hidden = NO;
    self.sortbtn.hidden = NO;
    isSelectCategory = false;
    if (self.selectedCategoryCell != nil) {
        self.selectedCategoryCell.rootView.backgroundColor = [UIColor whiteColor];
        self.selectedCategoryCell.kind.textColor = [UIColor grayColor];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self CollectionReload];
        [self categoryReLoad];
    });
    
}

- (void)creatNavigationButton{
    self.notification = [[FosaNotification alloc]init];
    [self.navigationRemindBtn setImage:[UIImage imageNamed:@"icon_sendNotification"] forState:UIControlStateNormal];
    self.navigationRemindBtn.frame = CGRectMake(-screen_width/20, NavigationBarH/8, screen_width/4, NavigationBarH*3/4);
    self.navigationRemindBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.navigationController.navigationBar addSubview:self.navigationRemindBtn];
    [self.navigationRemindBtn addTarget:self action:@selector(openNotificationList) forControlEvents:UIControlEventTouchUpInside];


    self.scanBtn.frame = CGRectMake(0, 0,screen_width/4, NavigationBarH*3/4);
    self.scanBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.scanBtn.center = self.navigationController.navigationBar.center;
    [self.scanBtn setImage:[UIImage imageNamed:@"icon_scan"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:self.scanBtn];
    [self.scanBtn addTarget:self action:@selector(clickToScan) forControlEvents:UIControlEventTouchUpInside];

    self.sortbtn.frame = CGRectMake(screen_width*4/5, NavigationBarH/6, screen_width/4, NavigationBarH*2/3);
    self.sortbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.sortbtn setImage:[UIImage imageNamed:@"icon_sort"] forState:UIControlStateNormal];
    [self.sortbtn addTarget:self action:@selector(selectToSort) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.sortbtn];

}

- (void)creatMainBackgroundPlayer{
    isUpdate = false;
    self.headerView.frame = CGRectMake(0, 0, screen_width, screen_width/3);
    [self.view addSubview:self.headerView];
    //背景轮播
    int headerWidth  = self.headerView.frame.size.width;
    int headerHeight = self.headerView.frame.size.height;
    self.mainBackgroundImgPlayer.frame = CGRectMake(0, 0, headerWidth, headerHeight);
    self.mainBackgroundImgPlayer.pagingEnabled = YES;
    self.mainBackgroundImgPlayer.delegate = self;
    self.mainBackgroundImgPlayer.showsHorizontalScrollIndicator = NO;
    self.mainBackgroundImgPlayer.showsVerticalScrollIndicator = NO;
    self.mainBackgroundImgPlayer.alwaysBounceVertical = NO;
        // 解决UIscrollerView在导航栏透明的情况下往下偏移的问题
    self.mainBackgroundImgPlayer.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    self.mainBackgroundImgPlayer.bounces = NO;
    self.mainBackgroundImgPlayer.contentSize = CGSizeMake(headerWidth*3, 0);
    for (NSInteger i = 0; i < 3; i++) {
            CGRect frame = CGRectMake(i*headerWidth, 0, headerWidth, self.headerView.frame.size.height);
            UIImageView *image = [[UIImageView alloc]initWithFrame:frame];
            image.userInteractionEnabled = YES;
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
            NSString *imgName = [NSString stringWithFormat:@"%@%ld",@"img_maiBackground",i];
            image.image = [UIImage imageNamed:imgName];
            [self.mainBackgroundImgPlayer addSubview:image];
    }
           [self.headerView addSubview:self.mainBackgroundImgPlayer];
            //轮播页面指示器
           self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(headerWidth*2/5, headerHeight-15, headerWidth/5, 10)];
           self.pageControl.currentPage = 0;
           self.pageControl.numberOfPages = 3;
           self.pageControl.pageIndicatorTintColor = FOSAFoodBackgroundColor;
           self.pageControl.currentPageIndicatorTintColor = FOSAgreen;
           [self.headerView addSubview:self.pageControl];
}
- (void)creatCategoryView{
    //获取系统数据库中的食物种类categoryNameArray
    [self getCategoryArray];
    //种类排序
    [self categorySortByNumber];
    
    isSelectCategory = false;
    self.categoryView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), screen_width, screen_width*5/24);
    [self.view addSubview:self.categoryView];
    int categoryViewWidth  = self.categoryView.frame.size.width;
    int categoeyViewHeight = self.categoryView.frame.size.height;
    
    self.leftBtn.frame = CGRectMake(0, 0, screen_width/15, screen_width/15);
    self.leftBtn.center = CGPointMake(categoryViewWidth/20,categoeyViewHeight*3/7);
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"icon_leftindexW"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(offsetToLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryView addSubview:self.leftBtn];
    
    self.rightBtn.frame = CGRectMake(0, 0, screen_width/15, screen_width/15);
    self.rightBtn.center = CGPointMake(categoryViewWidth*19/20, categoeyViewHeight*3/7);
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"icon_rightindexW"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(offsetToRight) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryView addSubview:self.rightBtn];
    
    categoryID = @"categoryCell";

    //食物种类选择栏 可滚动
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake((categoryViewWidth*5/6-font(40))/5,categoeyViewHeight);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3);//上、左、下、右

    self.categoryCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, categoryViewWidth*5/6, categoeyViewHeight) collectionViewLayout:flowLayout];
    self.categoryCollection.center = CGPointMake(categoryViewWidth/2, categoeyViewHeight*7/12);
    self.categoryCollection.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    self.categoryCollection.delegate = self;
    self.categoryCollection.dataSource = self;
    self.categoryCollection.showsHorizontalScrollIndicator = NO;
    self.categoryCollection.bounces = YES;
    self.categoryCollection.pagingEnabled = YES;
    [self.categoryCollection registerClass:[categoryCollectionViewCell class] forCellWithReuseIdentifier:categoryID];
    [self.categoryView addSubview:self.categoryCollection];
    
}
- (void)creatFoodItemCategoryView{
    foodItemID = @"foodItemCell";
    self.foodItemView.frame = CGRectMake(0, CGRectGetMaxY(self.categoryView.frame)+Height(5), screen_width, screen_height-CGRectGetMaxY(self.categoryView.frame)-TabbarHeight*4/3-NavigationBarH*2);
    [self.view addSubview:self.foodItemView];
    int collectionWidth = self.foodItemView.frame.size.width;
    int collectionHeight = self.foodItemView.frame.size.height;

    UICollectionViewFlowLayout *fosaFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    fosaFlowLayout.sectionInset = UIEdgeInsetsMake(screen_height/135, font(6), 0, font(6));//上、左、下、右
    fosaFlowLayout.itemSize = CGSizeMake((collectionWidth-font(18))/2,(collectionWidth-font(15))*41/72);
    //固定的itemsize
    fosaFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滑动的方向 垂直
    
    //foodItem
     self.fooditemCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, collectionWidth, collectionHeight) collectionViewLayout:fosaFlowLayout];
     //self.foodItemCollection.layer.cornerRadius = 15;
     //[self setCornerOnRight:15 view:self.foodItemCollection];
    // 1 先判断系统版本
//     if ([NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){10,0,0}])
//     {
//         // 2 初始化
//         UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//         // 3.1 配置刷新控件
//         refreshControl.tintColor = [UIColor brownColor];
//         NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor redColor]};
//         refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing" attributes:attributes];
//         // 3.2 添加响应事件
//         [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
         // 4 把创建的refreshControl赋值给scrollView的refreshControl属性
         
         //self.fooditemCollection.refreshControl = refreshControl;
//   }
     //self.foodItemCollection.alwaysBounceVertical = YES;
     self.fooditemCollection.delegate   = self;
     self.fooditemCollection.dataSource = self;
     //self.fooditemCollection.showsVerticalScrollIndicator = NO;
    self.fooditemCollection.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.fooditemCollection registerClass:[foodItemCollectionViewCell class] forCellWithReuseIdentifier:foodItemID];
     //self.foodItemCollection.bounces = NO;
     [self.foodItemView addSubview:self.fooditemCollection];
    [self creatSortListView];
}

//创建排序列表视图
- (void)creatSortListView{
    sortArray = @[@"Best Before Date Soon",@"Best Before Date Far",@"Early Input Date",@"Lately Input Date"];
    sortIconArray = @[@"icon_earlyExpiry",@"icon_lateExpiry",@"icon_earlyAdd",@"lateAdd"];
    self.smask.frame = [UIScreen mainScreen].bounds;
    self.smask.backgroundColor = [UIColor blackColor];
    self.smask.alpha = 0.5;
    self.smask.userInteractionEnabled = YES;
    UITapGestureRecognizer *cancelRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelSort)];
    [self.smask addGestureRecognizer:cancelRecognizer];
    [self.tabBarController.view addSubview:self.smask];
    self.smask.hidden = YES;

    self.sortListView = [[UIView alloc]initWithFrame:CGRectMake(0, screen_height, screen_width, screen_height*2/5)];
    self.sortListView.backgroundColor = [UIColor whiteColor];
    //self.sortListView.backgroundColor = FOSAgreen;
    [self.tabBarController.view addSubview:self.sortListView];
    //self.sortListView.hidden = YES;
    int sortHeight = self.sortListView.frame.size.height;

    //标题
    UILabel *sortTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width, sortHeight/8-1)];
    sortTitle.text = @"Sort";
    sortTitle.textAlignment = NSTextAlignmentCenter;
    [self.sortListView addSubview:sortTitle];
    UIView *line  = [[UIView alloc]initWithFrame:CGRectMake(0, sortHeight/8-1, screen_width, 0.5)];
    line.backgroundColor = FOSAGray;
    [self.sortListView addSubview:line];

    self.sortListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, sortHeight/8, screen_width, sortHeight*5/8) style:UITableViewStylePlain];
    self.sortListTable.delegate = self;
    self.sortListTable.dataSource = self;
    self.sortListTable.bounces = NO;
    self.sortListTable.showsVerticalScrollIndicator = NO;
    self.sortListTable.showsHorizontalScrollIndicator = NO;
    self.sortListTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.sortListTable.tintColor = FOSAColor(78, 169, 233);
    [self.sortListView addSubview:self.sortListTable];

    self.cancelBtn.frame = CGRectMake(screen_width/3, sortHeight*3/4+Height(2), screen_width/3, sortHeight/8);
    [self.cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:FOSARed forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:FOSAgreen forState:UIControlStateHighlighted];
    [self.sortListView addSubview:self.cancelBtn];

    [self.cancelBtn addTarget:self action:@selector(cancelSort) forControlEvents:UIControlEventTouchUpInside];
}
- (void)cancelSort{
    [UIView animateWithDuration:0.1 animations:^{
        self.sortListView.center = CGPointMake(screen_width/2, screen_height*6/5);
        self.smask.hidden = YES;
    }];
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark - UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sortArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.sortListTable.frame.size.height/sortArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    //初始化cell，并指定其类型
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        //创建cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSInteger row = indexPath.row;
    //取消点击cell时显示的背景色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = sortArray[row];
    cell.textLabel.font = [UIFont systemFontOfSize:font(15)];
    if ([sortArray[row] isEqualToString:[self.userdefault objectForKey:@"sort"]]) {
        cell.textLabel.textColor = FOSAColor(78, 169, 233);
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@HL",sortIconArray[row]]];
    }else{
        cell.textLabel.textColor = FOSAColor(153, 153, 153);
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.imageView.image = [UIImage imageNamed:sortIconArray[row]];
    }
    cell.backgroundColor = FOSAWhite;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //cell.textLabel.textColor = FOSAColor(11, 206, 255);
    //记录排序方式
    [self.userdefault removeObjectForKey:@"sort"];
    NSString *sortType = cell.textLabel.text;
    NSLog(@"排序方式:%@",sortType);
    [self.userdefault setObject:sortType forKey:@"sort"];
    [self.userdefault synchronize];
    [self CollectionReload];
    [self cancelSort];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    //cell.backgroundColor = fosaw
    
}

#pragma mark - UICollectionViewDataSource
//每个section有几个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.categoryCollection) {
        return self.categoryData.count;
    }else{
        if (self.collectionDataSource.count <= 4) {
            return 4;
        }else{
            return self.collectionDataSource.count;
        }
    }
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
    if (collectionView == self.categoryCollection) {
        // 每次先从字典中根据IndexPath取出唯一标识符
        NSString *identifier = [self.categoryCellDictionary objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
         // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
        if (identifier == nil) {
            identifier = [NSString stringWithFormat:@"%@%@", categoryID, [NSString stringWithFormat:@"%@", indexPath]];
            [self.categoryCellDictionary setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
            [self.categoryCollection registerClass:[categoryCollectionViewCell class] forCellWithReuseIdentifier:identifier];
            }
        categoryCollectionViewCell *cell = [self.categoryCollection dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.kind.text = self.categoryData[indexPath.row].categoryName;
        cell.categoryPhoto.image = [UIImage imageNamed:self.categoryData[indexPath.row].categoryIconName];
        cell.accessibilityValue = self.categoryData[indexPath.row].categoryIconName;
        
        //为每一个Item添加长按事件
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressCellToEdit:)];
        longPress.minimumPressDuration = 0.5;
        [cell addGestureRecognizer:longPress];
        cell.userInteractionEnabled = YES;
        [cell addGestureRecognizer:longPress];
        //根据数量显示角标
        if ([self caculateCategoryNumber:cell.kind.text]>0) {
            cell.badgeBtn.hidden = NO;
            [cell.badgeBtn setTitle:[NSString stringWithFormat:@"%d",[self caculateCategoryNumber:cell.kind.text]] forState:UIControlStateNormal];
        }else{
            cell.badgeBtn.hidden = YES;
        }
//        if (categoryEdit){
//            cell.editbtn.hidden = NO;
//            cell.kind.userInteractionEnabled = YES;
//            cell.kind.returnKeyType = UIReturnKeyDone;
//            cell.kind.tag = indexPath.row;
//            cell.kind.delegate = self;
//        }else{
//            cell.editbtn.hidden = YES;
//            cell.kind.userInteractionEnabled = NO;
//        }
        return cell;
    }else{
        long int index = indexPath.section*2+indexPath.row;
        // 每次先从字典中根据IndexPath取出唯一标识符
        NSString *identifier = [_cellDictionary objectForKey:[NSString stringWithFormat:@"%@",indexPath]];
             // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
        if (identifier == nil) {
                identifier = [NSString stringWithFormat:@"%@%@", foodItemID, indexPath];
                [_cellDictionary setValue:identifier forKey:[NSString stringWithFormat:@"%@",indexPath]];
            // 注册Cell
                [self.fooditemCollection registerClass:[foodItemCollectionViewCell class] forCellWithReuseIdentifier:identifier];
            }
        NSLog(@"---------------------------------Item:%ld",index);
        
        foodItemCollectionViewCell *cell = [self.fooditemCollection dequeueReusableCellWithReuseIdentifier:foodItemID forIndexPath:indexPath];
        
        if (index < self.collectionDataSource.count ) {
            cell.isDraw = @"YES";
            cell.indexOfImg = index%4;
            [cell setModel:self.collectionDataSource[index]];
            //标记为需要重绘，异步调用drawRect，但是绘制视图的动作需要等到下一个绘制周期执行，并非调用该方法立即执行;
            [cell setNeedsDisplay];
        }else{
            cell.isDraw = @"NO";
            cell.indexOfImg = index%4;
            cell.foodNamelabel.text = @"";
            cell.locationLabel.text = @"";
            cell.dayLabel.text = @"";
            cell.timelabel.text = @"";
            cell.mouthLabel.text = @"";
            cell.likebtn.hidden = YES;
            cell.foodImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_defaultImg%ld",index%4+1]];
            [cell setNeedsDisplay];
        }
        return cell;
    }
}
//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.categoryCollection) {
        if (categoryEdit) {
            return;
        }
        categoryCollectionViewCell *cell = (categoryCollectionViewCell *)[self.categoryCollection cellForItemAtIndexPath:indexPath];

        if ([cell.kind.text isEqualToString:self.selectedCategoryCell.kind.text]) {
            NSLog(@"取消选中%@",self.selectedCategoryCell.kind.text);
            isSelectCategory = false;
            self.selectedCategoryCell.rootView.backgroundColor = [UIColor whiteColor];
            self.selectedCategoryCell.kind.textColor = [UIColor grayColor];
            self.selectedCategoryCell.categoryPhoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.selectedCategoryCell.accessibilityValue]];
            self.selectedCategoryCell = nil;
            [self CollectionReload];
            [self categoryReLoad];
        }else{
            isSelectCategory = true;
            cell.rootView.backgroundColor = FOSAYellow;
            cell.kind.textColor = FOSAYellow;
            NSString *imgName = [NSString stringWithFormat:@"%@W",self.categoryData[indexPath.row].categoryIconName];
            cell.categoryPhoto.image = [UIImage imageNamed:imgName];
            self.selectedCategoryCell = cell;
            self.selectedCategoryCell.accessibilityValue =self.categoryData[indexPath.row].categoryIconName;
            [self CollectionReload];
        }
    }else if(collectionView == self.fooditemCollection){
        foodItemCollectionViewCell *cell = (foodItemCollectionViewCell *)[self.fooditemCollection cellForItemAtIndexPath:indexPath];
               [self ClickFoodItem:cell];
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.categoryCollection) {

        NSLog(@"取消选中%@",self.selectedCategoryCell.kind.text);
        self.selectedCategoryCell.rootView.backgroundColor = [UIColor whiteColor];
        self.selectedCategoryCell.kind.textColor = [UIColor grayColor];
        self.selectedCategoryCell.categoryPhoto.image = [UIImage imageNamed:self.selectedCategoryCell.accessibilityValue];
    }else{
        foodItemCollectionViewCell *cell = (foodItemCollectionViewCell *)[self.fooditemCollection cellForItemAtIndexPath:indexPath];
               [self ClickFoodItem:cell];
        cell.alpha = 1;
    }
}

// 两列cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.fooditemCollection) {
        return font(8);
    }else{
        return font(8);
    }
}

// 两行cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.fooditemCollection) {
        return font(6);
    }else{
        return 0;
    }
}

#pragma mark -- UIScrollerView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.categoryCollection) {
        CGFloat offset = scrollView.contentOffset.x;
        categoryIndex = offset/(screen_width*5/6);
        NSLog(@"食物种类滚动了,当前位置:%d",categoryIndex);
    }else{
        CGFloat offset = scrollView.contentOffset.x;
        NSInteger index = offset/self.headerView.frame.size.width;
        self.pageControl.currentPage = index;
    }
    
}

#pragma mark -- UItextFiledView
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"%ld",(long)textField.tag);
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -- FMDB数据库操作

- (void)OpenSqlDatabase:(NSString *)dataBaseName{
    //获取数据库地址
    docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    //NSLog(@"%@",docPath);
    //设置数据库名
    NSString *fileName = [docPath stringByAppendingPathComponent:dataBaseName];
    //创建数据库
    self.db = [FMDatabase databaseWithPath:fileName];
    if([self.db open]){
        NSLog(@"打开数据库成功");
    }else{
        NSLog(@"打开数据库失败");
    }
}

- (void)SelectDataFromFoodTable{
    [self.collectionDataSource removeAllObjects];
    NSString *sql ;
    if (isSelectCategory) {
        sql = [NSString stringWithFormat:@"select * from FoodStorageInfo where category = '%@'",self.selectedCategoryCell.kind.text];
    }else{
        sql = @"select * from FoodStorageInfo";
        [self.AllFoodArray removeAllObjects];
    }
    FMResultSet *set = [self.db executeQuery:sql];
    while ([set next]) {
        NSString *foodName    = [set stringForColumn:@"foodName"];
        NSString *device      = [set stringForColumn:@"device"];
        NSString *aboutFood   = [set stringForColumn:@"aboutFood"];
        NSString *storageDate = [set stringForColumn:@"storageDate"];
        NSString *expireDate  = [set stringForColumn:@"expireDate"];
        NSString *foodImg     = [set stringForColumn:@"foodImg"];
        NSString *category    = [set stringForColumn:@"category"];
        NSString *location    = [set stringForColumn:@"location"];
        NSString *remindDate  = [set stringForColumn:@"remindDate"];
        NSString *repeat      = [set stringForColumn:@"repeatWay"];
        FoodModel *model      = [FoodModel modelWithName:foodName DeviceID:device Description:aboutFood StrogeDate:storageDate ExpireDate:expireDate remindDate:remindDate foodIcon:foodImg category:category Location:location repeatWay:repeat];
        [self.collectionDataSource addObject:model];
        if (!isSelectCategory) {
            [self.AllFoodArray addObject:model];
        }
        NSLog(@"*********************************************foodName    = %@",foodName);
        NSLog(@"foodImg     = %@",foodImg);
    }

    NSString *currentSortType = [self.userdefault valueForKey:@"sort"];
//@"Early Expiration Date",@"Late Expiration data",@"Early Add",@"Lately Add"
    if ([currentSortType isEqualToString:@"Best Before Date Soon"]) {
        //过期日期从早到晚排列
        [self sortByMostRecent];
    }else if([currentSortType isEqualToString:@"Best Before Date Far"]){
        //过期日期从晚到早排列
        [self sortByLeastRecent];
    }else if([currentSortType isEqualToString:@"Early Input Date"]){
        //保存日期从早到晚排列
        [self sortByLeastAdd];
    }else if([currentSortType isEqualToString:@"Lately Input Date"]){
        //保存日期从晚到早排列
        [self sortByRecentAdd];
    }
    [self.fooditemCollection reloadData];
    [self.db close];
}
- (void)getCategoryArray{
//    [self OpenSqlDatabase:@"FOSA"];
    categoryIndex = 0;
    NSString *selSql = @"select * from category";
//    FMResultSet *set = [self.db executeQuery:selSql];
//    [self.categoryData removeAllObjects];
//    while ([set next]) {
//        NSString *kind = [set stringForColumn:@"categoryName"];
//        NSString *icon = [set stringForColumn:@"categoryIcon"];
//        NSLog(@"%@",kind);
//        categoryModel *model = [categoryModel modelWithName:kind iconName:icon];
//        //[self.categoryNameArray addObject:kind];
//        [self.categoryData addObject:model];
//    }
    if ([fmdbManager isFmdbOpen]) {
        self.categoryData = [fmdbManager selectDataWithTableName:@"category" sql:selSql];
    }
    
}

- (FoodModel *)CheckFoodInfoWithName:(NSString *)foodName{
    [self OpenSqlDatabase:@"FOSA"];
    NSString *sql = [NSString stringWithFormat:@"select * from FoodStorageInfo where foodName = '%@';",foodName];
    NSLog(@"%@",sql);
    FMResultSet *set = [self.db executeQuery:sql];
    FoodModel *model;
    if (set.columnCount == 0) {
        return nil;
    }else{
        if([set next]) {
            NSString *foodName       = [set stringForColumn:@"foodName"];
            NSString *device        = [set stringForColumn:@"device"];
            NSString *aboutFood     = [set stringForColumn:@"aboutFood"];
            NSString *storageDate   = [set stringForColumn:@"storageDate"];
            NSString *expireDate    = [set stringForColumn:@"expireDate"];
            NSString *foodImg       = [set stringForColumn:@"foodImg"];
            NSString *location      = [set stringForColumn:@"location"];
            NSString *category      = [set stringForColumn:@"category"];
            NSString *remindDate    = [set stringForColumn:@"remindDate"];
            NSString *repeat        = [set stringForColumn:@"repeatWay"];
            model = [FoodModel modelWithName:foodName DeviceID:device Description:aboutFood StrogeDate:storageDate ExpireDate:expireDate remindDate:remindDate    foodIcon:foodImg category:category Location:location repeatWay:repeat];
        }
    }
    return model;
}

#pragma mark - 遍历食物数组,返回对应种类的数量
- (int)caculateCategoryNumber:(NSString *)category{
    int num = 0;
    for (FoodModel *model in self.AllFoodArray) {
        if ([category isEqualToString:model.category]) {
            num++;
        }
    }
    return num;
}
#pragma mark - 响应事件

- (void)CollectionReload{
    [self.collectionDataSource removeAllObjects];
    [self.cellDictionary removeAllObjects];
    NSLog(@"------------------------------%lu",(unsigned long)self.collectionDataSource.count);
    [self OpenSqlDatabase:@"FOSA"];
    [self SelectDataFromFoodTable];
    //全局只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self SendExpiryNotification];
    });
}
- (void)categoryReLoad{
    [self getCategoryArray];
    [self.categoryCellDictionary removeAllObjects];
    //种类排序
    [self categorySortByNumber];
    [self.categoryCollection reloadData];
}

- (void)selectToSort{
//    NSString *currentSortType = [self.userdefault valueForKey:@"sort"];
//    NSInteger selectIndex0 = 0;
//    NSInteger selectIndex1 = 1;
//    NSInteger selectIndex2 = 2;
//    NSInteger selectIndex3 = 3;
//    NSDictionary *sortDic  =  @{ @"Early Expiration Date":[NSIndexPath indexPathForRow:selectIndex0 inSection:0],@"Late Expiration data":[NSIndexPath indexPathForRow:selectIndex1 inSection:0],@"Early Add":[NSIndexPath indexPathForRow:selectIndex2 inSection:0],@"Lately Add":[NSIndexPath indexPathForRow:selectIndex3 inSection:0]};
//    [self.sortListTable selectRowAtIndexPath:[sortDic valueForKey:currentSortType] animated:NO scrollPosition:UITableViewScrollPositionNone];
//    //selectedCell = [self.sortListView cellForRowAtIndexPath:[self.sortDic valueForKey:select]];
//    [self.sortListTable cellForRowAtIndexPath:[sortDic valueForKey:currentSortType]].accessoryType = UITableViewCellAccessoryCheckmark;
//    [self.sortListTable cellForRowAtIndexPath:[sortDic valueForKey:currentSortType]].textLabel.textColor = FOSAColor(11, 206, 255);
    [UIView animateWithDuration:0.2 animations:^{
        [self.sortListTable reloadData];
        self.tabBarController.tabBar.hidden = YES;
        self.sortListView.center = CGPointMake(screen_width/2, screen_height*4/5);
        self.smask.hidden = NO;
    }];
}
- (void)sortByMostRecent{
    NSComparator compare = ^(FoodModel* obj1,FoodModel* obj2){
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM/dd/yy HH:mm"];
        
        NSArray<NSString *> *dateArray1 = [obj1.expireDate componentsSeparatedByString:@"/"];
        NSString *RDate1 = [NSString stringWithFormat:@"%@/%@/%@ %@", dateArray1[1],dateArray1[0],dateArray1[2],dateArray1[3]];
        NSDate *foodDate1 = [formatter dateFromString:RDate1];
        NSLog(@"---------------%@",foodDate1);
        
        NSArray<NSString *> *dateArray2 = [obj2.expireDate componentsSeparatedByString:@"/"];
        NSString *RDate2 = [NSString stringWithFormat:@"%@/%@/%@ %@",dateArray2[1],dateArray2[0],dateArray2[2],dateArray2[3]];
        NSDate *foodDate2 = [formatter dateFromString:RDate2];
        NSComparisonResult result = [foodDate1 compare:foodDate2];
        
        if (result == NSOrderedDescending) {//foodDate1 在 foodDate2 之后
            return (NSComparisonResult)NSOrderedDescending;
        }else if(result == NSOrderedAscending){//foodDate1 在 foodDate2 之前
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *sortArray = [self.collectionDataSource copy];

    NSArray *resultArray = [sortArray sortedArrayUsingComparator:compare];
    
    self.collectionDataSource = [resultArray mutableCopy];
    [self.fooditemCollection reloadData];
}

- (void)sortByLeastRecent{
    NSComparator compare = ^(FoodModel* obj1,FoodModel* obj2){
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
        
        NSArray<NSString *> *dateArray1 = [obj1.expireDate componentsSeparatedByString:@"/"];
        NSString *RDate1 = [NSString stringWithFormat:@"%@/%@/%@ %@",dateArray1[1],dateArray1[0],dateArray1[2],dateArray1[3]];
        NSDate *foodDate1 = [formatter dateFromString:RDate1];
        
        NSArray<NSString *> *dateArray2 = [obj2.expireDate componentsSeparatedByString:@"/"];
        NSString *RDate2 = [NSString stringWithFormat:@"%@/%@/%@ %@",dateArray2[1],dateArray2[0],dateArray2[2],dateArray2[3]];
        NSDate *foodDate2 = [formatter dateFromString:RDate2];
        NSComparisonResult result = [foodDate1 compare:foodDate2];
        
        if (result == NSOrderedDescending) {//foodDate1 在 foodDate2 之后
            return (NSComparisonResult)NSOrderedAscending;
        }else if(result == NSOrderedAscending){//foodDate1 在 foodDate2 之前
            return (NSComparisonResult)NSOrderedDescending;

        }
        return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *sortArray = [self.collectionDataSource copy];

    NSArray *resultArray = [sortArray sortedArrayUsingComparator:compare];
    
    self.collectionDataSource = [resultArray mutableCopy];
    [self.fooditemCollection reloadData];
}
- (void)sortByRecentAdd{
    NSComparator compare = ^(FoodModel* obj1,FoodModel* obj2){
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM/dd/yyyy HH:mm"];

        NSArray<NSString *> *dateArray1 = [obj1.storageDate componentsSeparatedByString:@"/"];
        NSString *RDate1 = [NSString stringWithFormat:@"%@/%@/%@ %@",dateArray1[1],dateArray1[0],dateArray1[2],dateArray1[3]];
        NSDate *foodDate1 = [formatter dateFromString:RDate1];
        
        NSArray<NSString *> *dateArray2 = [obj2.storageDate componentsSeparatedByString:@"/"];
        NSString *RDate2 = [NSString stringWithFormat:@"%@/%@/%@ %@",dateArray2[1],dateArray2[0],dateArray2[2],dateArray2[3]];
        NSDate *foodDate2 = [formatter dateFromString:RDate2];
        NSComparisonResult result = [foodDate1 compare:foodDate2];
        
        if (result == NSOrderedDescending) {//foodDate1 在 foodDate2 之后
            return (NSComparisonResult)NSOrderedAscending;
        }else if(result == NSOrderedAscending){//foodDate1 在 foodDate2 之前
            return (NSComparisonResult)NSOrderedDescending;

        }
        return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *sortArray = [self.collectionDataSource copy];

    NSArray *resultArray = [sortArray sortedArrayUsingComparator:compare];
    
    self.collectionDataSource = [resultArray mutableCopy];
    [self.fooditemCollection reloadData];
}
- (void)sortByLeastAdd{
    NSComparator compare = ^(FoodModel* obj1,FoodModel* obj2){
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
        
        NSArray<NSString *> *dateArray1 = [obj1.storageDate componentsSeparatedByString:@"/"];
        NSString *RDate1 = [NSString stringWithFormat:@"%@/%@/%@ %@",dateArray1[1],dateArray1[0],dateArray1[2],dateArray1[3]];
        NSDate *foodDate1 = [formatter dateFromString:RDate1];
        
        NSArray<NSString *> *dateArray2 = [obj2.storageDate componentsSeparatedByString:@"/"];
        NSString *RDate2 = [NSString stringWithFormat:@"%@/%@/%@ %@",dateArray2[1],dateArray2[0],dateArray2[2],dateArray2[3]];
        NSDate *foodDate2 = [formatter dateFromString:RDate2];
        NSComparisonResult result = [foodDate1 compare:foodDate2];
        
        if (result == NSOrderedDescending) {//foodDate1 在 foodDate2 之后
            return (NSComparisonResult)NSOrderedDescending;
        }else if(result == NSOrderedAscending){//foodDate1 在 foodDate2 之前
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *sortArray = [self.collectionDataSource copy];
    NSArray *resultArray = [sortArray sortedArrayUsingComparator:compare];
    self.collectionDataSource = [resultArray mutableCopy];
    [self.fooditemCollection reloadData];
}
#pragma mark - 种类栏事件

//种类排序事件，按照食物数量排序
- (void)categorySortByNumber{
    NSComparator comparator = ^(categoryModel* obj1,categoryModel* obj2){
        if ([self caculateCategoryNumber:obj1.categoryName] < [self caculateCategoryNumber:obj2.categoryName]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if([self caculateCategoryNumber:obj2.categoryName] > [self caculateCategoryNumber:obj1.categoryName]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *sortArray = [self.categoryData copy];
    NSArray *resultArray = [sortArray sortedArrayUsingComparator:comparator];
    [self.categoryData removeAllObjects];
    self.categoryData = [[NSMutableArray alloc]initWithArray:resultArray];
}

//种类按钮长按事件
-  (void)longPressCellToEdit:(UILongPressGestureRecognizer *)longPress{
    categoryCollectionViewCell *cell = (categoryCollectionViewCell *)longPress.view;
    self.longprogressCell = cell;
    NSLog(@"长按：%@",cell.kind.text);
    editFoodItemViewController *editFood = [editFoodItemViewController new];
    editFood.selectCategory = cell.kind.text;
    editFood.selectCategoryIcon = cell.accessibilityValue;
    NSLog(@"selectCategoryIcon:%@",cell.accessibilityValue);
    editFood.categoryBlock = ^(BOOL reload) {
        if (reload) {
            self->isSelectCategory = false;
            if (self.selectedCategoryCell != nil) {
                self.selectedCategoryCell.rootView.backgroundColor = [UIColor whiteColor];
                self.selectedCategoryCell.kind.textColor = [UIColor grayColor];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self CollectionReload];
                [self categoryReLoad];
            });
        }
    };
    [self presentViewController:editFood animated:YES completion:nil];
//    categoryEdit = true;
//    [self.categoryCollection reloadData];
//    [cell.kind becomeFirstResponder];
//
//    //取消选中状态
//    isSelectCategory = false;
//    self.selectedCategoryCell.rootView.backgroundColor = [UIColor whiteColor];
//    self.selectedCategoryCell.categoryPhoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.selectedCategoryCell.accessibilityValue]];
//    self.selectedCategoryCell = nil;
//    [self CollectionReload];
//
//    //为退出按钮添加约束
//    [self.cancelBtn.widthAnchor constraintEqualToConstant:NavigationBarH*5/3].active = YES;
//    [self.cancelBtn.heightAnchor constraintEqualToConstant:NavigationBarH*2/3].active = YES;
//    [self.cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
//    //self.cancelBtn.layer.borderWidth = 1;
//    self.cancelBtn.layer.cornerRadius = NavigationBarH/3;
//    self.cancelBtn.backgroundColor = FOSARed;
//    [self.cancelBtn setTitleColor:FOSAWhite forState:UIControlStateNormal];
//    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:15];
//    [self.cancelBtn addTarget:self action:@selector(cancelEdit) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.cancelBtn];
}

//取消种类编辑
//- (void)cancelEdit{
//    categoryEdit = false;
//    [self getCategoryArray];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.sortbtn];
//    //取消选中状态
//    isSelectCategory = false;
//    self.selectedCategoryCell.rootView.backgroundColor = [UIColor whiteColor];
//    self.selectedCategoryCell.categoryPhoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.selectedCategoryCell.accessibilityValue]];
//    self.selectedCategoryCell = nil;
//    [self CollectionReload];
//    [self.categoryCollection reloadData];
//    //种类排序
//    [self categorySortByNumber];
//}

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

//食物Item点击事件
- (void)ClickFoodItem:(foodItemCollectionViewCell *)cell{
    foodAddingViewController *add = [foodAddingViewController new];
    if ([cell.foodNamelabel.text isEqualToString:@""]) {
        add.foodStyle = @"adding";
        add.navigationItem.hidesBackButton = YES;
    }else{
        add.foodStyle = @"Info";
        add.model = cell.model;
    }
    add.hidesBottomBarWhenPushed = YES;
    //查找种类图标名
//    for(int i = 0;i < self.categoryData.count;i++){
//        if ([self.categoryData[i].categoryName isEqualToString:cell.model.category]) {
//            add.foodCategoryIconname = self.categoryData[i].categoryIconName;
//            break;
//        }
//    }
    //NSLog(@"<<<<<<<<<<<<<<<<<%@",add.foodCategoryIconname);
    [self.navigationController pushViewController:add animated:YES];
}

- (void)clickToScan{
    QRCodeScanViewController *scan = [QRCodeScanViewController new];
    scan.scanStyle = @"";
    scan.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scan animated:YES];
}

- (void)refresh:(UIRefreshControl *)sender
{
    [self CollectionReload];
    // 停止刷新
    [sender endRefreshing];
}
#pragma mark - 发送提醒

//fosaDelegate协议方法
- (void)JumpByFoodName:(NSString *)foodname{
    NSLog(@"食物跳转：%@",foodname);
    foodAddingViewController *add = [foodAddingViewController new];
    add.foodStyle = @"Info";
    add.hidesBottomBarWhenPushed = YES;
    add.model = [self CheckFoodInfoWithName:foodname];
    //add.foodCategoryIconname = @"Biscuit";
    //add.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:add animated:YES];
}
- (void)SystemAlert:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AlertTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:true completion:nil];
    [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:1];
}
- (void)dismissAlertView:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
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
    self.FOSAloadingView.center = self.foodItemView.center;
    //设置小菊花颜色
    self.FOSAloadingView.color = FOSAgreen;
    //设置背景颜色
    self.FOSAloadingView.backgroundColor = [UIColor clearColor];
//刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    self.FOSAloadingView.hidesWhenStopped = YES;
    [self.FOSAloadingView startAnimating];
}

//获取用户选择的提醒设定
- (int)getNotificationSetting{
    NSString *notificationSetting = [self.userdefault valueForKey:@"notificationSetting"];
    NSLog(@"%@",notificationSetting);
    if([notificationSetting isEqualToString:@"On expiry day"]) {
        return 0;
    }else if([notificationSetting isEqualToString:@"One day before expiry"]){
        return 1;
    }else if([notificationSetting isEqualToString:@"Two days before expiry"]){
        return 2;
    }
    return 0;
}

- (void)openNotificationList{
    self.navigationRemindBtn.alpha = 0.5;
//    notificationViewController *notify = [notificationViewController new];
//    notify.hidesBottomBarWhenPushed = YES;
//    [self presentViewController:notify animated:YES completion:nil];
    [UIView animateWithDuration:0.5 animations:^{
        self.smask.hidden = NO;
        self.tabBarController.tabBar.hidden = YES;
        self.smask.userInteractionEnabled = NO;
        if (self->_notifiView == nil) {
            self->_notifiView = [[NotificationView alloc]initWithFrame:CGRectMake(5, NavigationBarH, screen_width-10, screen_height*127/143)];
        }
        NSString *isDisdurb = [[NSUserDefaults standardUserDefaults] valueForKey:@"autonotification"];
        if (![isDisdurb isEqualToString:@"YES"]) {
            self.notifiView.styleLabel.hidden = YES;
        }
        [self.notifiView getFoodDataFromSql];
        self.notifiView.closeDelegate = self;
        self.notifiView.layer.cornerRadius = 15;
        [self.tabBarController.view addSubview:self.notifiView];
    } completion:^(BOOL finished) {
        self.navigationRemindBtn.alpha = 1.0;
    }];
}
#pragma mark - closeViewDelegate
- (void)closeNotificationList{
    [UIView animateWithDuration:0.5 animations:^{
        self.smask.hidden = YES;
        self.smask.userInteractionEnabled = YES;
        self.tabBarController.tabBar.hidden = NO;
        [self.notifiView removeFromSuperview];
        [self CollectionReload];
    }];
}

- (void)SendExpiryNotification{
    [self CreatLoadView];
    [self.notification initNotification];
    self.notification.fosadelegate = self;

    FosaIMGManager *imgManager = [FosaIMGManager new];
    [imgManager InitImgManager];

    UIImage *image;
    //获取用户设定的提醒方式
    //获取当前日期
    NSDate *currentDate = [[NSDate alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy/MM/dd"];
    NSLog(@"%@",[formatter stringFromDate:currentDate]);
    currentDate = [formatter dateFromString:[formatter stringFromDate:currentDate]];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"currentDate:%@",currentDate);
    NSDate *foodDate;
    for(int i = 0;i < self.collectionDataSource.count; i++){
        NSLog(@"%@的提醒日期为%@",self.collectionDataSource[i].foodName,self.collectionDataSource[i].remindDate);
        NSArray<NSString *> *dateArray = [self.collectionDataSource[i].expireDate componentsSeparatedByString:@"/"];
        NSString *RDate = [NSString stringWithFormat:@"%@/%@/%@",dateArray[2],dateArray[1],dateArray[0]];
        foodDate = [formatter dateFromString:RDate];
        //比较过期日期与今天的日期
        NSComparisonResult result = [currentDate compare:foodDate];
        NSLog(@"==============================%ld",(long)result);
        if (result == NSOrderedSame) {
            //isSend = true;
            NSString *body = [NSString stringWithFormat:@"%@ will expire today (%@)",self.collectionDataSource[i].foodName,[self getWeekDayOfDate:self.collectionDataSource[i].expireDate]];
            //发送通知
            //获取通知的图片
            image = [imgManager getImgWithName:self.collectionDataSource[i].foodPhoto];
            //[self getImage:self.collectionDataSource[i].foodPhoto];
            //另存通知图片
            [imgManager savePhotoWithImage:image name:self.collectionDataSource[i].foodName];
            //[self Savephoto:image name:self.collectionDataSource[i].foodName];
            [self.notification sendNotification:self.collectionDataSource[i] body:body image:image time:2];
        }
//        else if(result == NSOrderedDescending){
//            NSString *body = [NSString stringWithFormat:@"FOSA remind you :%@ has expired on %@",self.collectionDataSource[i].foodName,[formatter1 stringFromDate:foodDate]];
//            //发送通知
//            //获取通知的图片
//            image = [imgManager getImgWithName:self.collectionDataSource[i].foodPhoto];//[self getImage:self.collectionDataSource[i].foodPhoto];
//            //另存通知图片
//            [imgManager savePhotoWithImage:image name:self.collectionDataSource[i].foodName]; //[self Savephoto:image name:self.collectionDataSource[i].foodName];
//            [self.notification sendNotification:self.collectionDataSource[i] body:body image:image time:2];
//        }
    }
//    if (!isSend) {
//        [self SystemAlert:@"No Result Found"];
//    }
    [self performSelector:@selector(stoploading) withObject:nil afterDelay:1.0];
}
/**
 根据日期字符串获取对应的星期
 */
- (NSString *)getWeekDayOfDate:(NSString *)date{
    NSArray * arrWeekDay=[NSArray arrayWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat", nil];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd/MM/yy/HH:mm"];
    NSDate *tempDate = [formatter dateFromString:date];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone localTimeZone];
   
       /*
        NSInteger unitFlags = NSYearCalendarUnit |
        NSMonthCalendarUnit |
        NSDayCalendarUnit |
        NSWeekdayCalendarUnit |
        NSHourCalendarUnit |
        NSMinuteCalendarUnit |
        NSSecondCalendarUnit;
        */
    NSInteger unitFlags = NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday | NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:tempDate];
    return [arrWeekDay objectAtIndex:comps.weekday-1];
}

- (void)stoploading{
    [self.FOSAloadingView stopAnimating];
}

#pragma mark -- 教学提示
- (void)showUsingTips{
    self.mask = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.mask.backgroundColor = [UIColor blackColor];
    self.mask.alpha = 0.5;
    [self.tabBarController.view addSubview:self.mask];
    UIImageView *index = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 120)];
    index.image = [UIImage imageNamed:@"icon_downindex"];
    index.center = CGPointMake(self.view.center.x, screen_height-2*TabbarHeight);
    [self.mask addSubview:index];
    UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width, 30)];
    tips.text = @"Add Food";
    tips.textColor = [UIColor whiteColor];
    tips.textAlignment = NSTextAlignmentCenter;
    tips.center = CGPointMake(self.view.center.x, screen_height-2*TabbarHeight-60);
    [self.mask addSubview:tips];
    [self indexDownAnimation:index];

    self.mask.userInteractionEnabled = YES;
    UITapGestureRecognizer *clickToClose = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToClose)];
    [self.mask addGestureRecognizer:clickToClose];
}
- (void)indexDownAnimation:(UIImageView *)index{

    [UIView animateWithDuration:0.5 animations:^{
            index.center = CGPointMake(self.view.center.x, screen_height-1.7*TabbarHeight);
    } completion:^(BOOL finished) {
        [self indexUpAnimation:index];
    }];
}
- (void)indexUpAnimation:(UIImageView *)index{
    [UIView animateWithDuration:0.5 animations:^{
            index.center = CGPointMake(self.view.center.x, screen_height-2*TabbarHeight);
    } completion:^(BOOL finished) {
        [self indexDownAnimation:index];
    }];
}
- (void)clickToClose{
    [self.mask removeFromSuperview];
    
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
    isUpdate = true;
    self.navigationController.navigationBar.translucent = YES;
    [self.db close];
    self.scanBtn.hidden = YES;
    self.navigationRemindBtn.hidden = YES;
    self.sortbtn.hidden = YES;
}

@end
