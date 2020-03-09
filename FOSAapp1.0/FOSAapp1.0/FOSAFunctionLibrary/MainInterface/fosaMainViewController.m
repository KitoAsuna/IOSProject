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


@interface fosaMainViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    NSString *categoryID;//种类cell
    NSString *foodItemID;//食物cell
    NSString *docPath;//数据库地址
    //刷新标识
    Boolean isUpdate;
    
}
//种类数组
@property (nonatomic,strong) NSMutableArray *categoryArray;
//教学提示相关
@property (nonatomic,strong) UIView *mask;
//数据库
@property (nonatomic,strong) FMDatabase *db;
//当前选中的种类cell
@property (nonatomic,strong) categoryCollectionViewCell *selectedCategoryCell;
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
- (NSMutableArray<FoodModel *> *)tempFoodDataSource{
    if (_tempFoodDataSource == nil) {
        _tempFoodDataSource = [[NSMutableArray alloc]init];
    }
    return _tempFoodDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    // Do any additional setup after loading the view.
    [self OpenSqlDatabase:@"FOSA"];
    [self SelectDataFromFoodTable];
    [self creatNavigationButton];
    [self creatMainBackgroundPlayer];
    [self creatCategoryView];
    [self creatFoodItemCategoryView];
    //[self showUsingTips];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.sortbtn.hidden = NO;
    if (isUpdate) {
           NSLog(@"异步刷新界面");
           dispatch_async(dispatch_get_main_queue(), ^{
               [self CollectionReload];
           });
       }
}

- (void)creatNavigationButton{
    self.navigationRemindBtn.frame = CGRectMake(0, 0, NavigationBarH, NavigationBarH);
    [self.navigationRemindBtn setImage:[UIImage imageNamed:@"icon_sendNotification"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.navigationRemindBtn];

    self.sortbtn.frame = CGRectMake(screen_width*2/3, 0,NavigationBarH, NavigationBarH);
    [self.sortbtn setImage:[UIImage imageNamed:@"icon_pullDown"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:self.sortbtn];
    
    self.scanBtn.frame = CGRectMake(0, 0, NavigationBarH, NavigationBarH);
    [self.scanBtn setImage:[UIImage imageNamed:@"icon_scan"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.scanBtn];
    [self.scanBtn addTarget:self action:@selector(clickToScan) forControlEvents:UIControlEventTouchUpInside];

}

- (void)creatMainBackgroundPlayer{
    isUpdate = false;
    self.headerView.frame = CGRectMake(0, NavigationHeight, screen_width, screen_width/3);
    [self.view addSubview:self.headerView];
    self.headerView.backgroundColor = FOSAgreen;

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
        //NSString *imgName = [NSString stringWithFormat:@"%@%ld",@"picturePlayer",i+1];
            image.image = [UIImage imageNamed:@"img_maiBackground"];
            [self.mainBackgroundImgPlayer addSubview:image];
        }
           [self.headerView addSubview:self.mainBackgroundImgPlayer];
            //轮播页面指示器
           self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(headerWidth*2/5, headerHeight-30, headerWidth/5, 20)];
           self.pageControl.currentPage = 0;
           self.pageControl.numberOfPages = 3;
           self.pageControl.pageIndicatorTintColor = FOSAFoodBackgroundColor;
           self.pageControl.currentPageIndicatorTintColor = FOSAgreen;
           [self.headerView addSubview:self.pageControl];
        
}
- (void)creatCategoryView{
    
    self.categoryView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), screen_width, screen_height/9);
    //self.categoryView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.categoryView];
    int categoryViewWidth  = self.categoryView.frame.size.width;
    int categoeyViewHeight = self.categoryView.frame.size.height;
    
    self.leftBtn.frame = CGRectMake(0, 0, screen_width/20, screen_width/20);
    self.leftBtn.center = CGPointMake(categoryViewWidth/20, categoeyViewHeight/2);
    [self.leftBtn setImage:[UIImage imageNamed:@"icon_leftindex"] forState:UIControlStateNormal];
    [self.categoryView addSubview:self.leftBtn];
    
    self.rightBtn.frame = CGRectMake(0, 0, screen_width/20, screen_width/20);
    self.rightBtn.center = CGPointMake(categoryViewWidth*19/20, categoeyViewHeight/2);
    [self.rightBtn setImage:[UIImage imageNamed:@"icon_rightindex"] forState:UIControlStateNormal];
    [self.categoryView addSubview:self.rightBtn];
    
    //初始化种类数据
    NSArray *array = @[@"Biscuit",@"Bread",@"Cake",@"Cereal",@"Dairy",@"Fruit",@"Meat",@"Snacks",@"Spice",@"Veggie"];
    self.categoryArray = [[NSMutableArray alloc]initWithArray:array];
    categoryID = @"categoryCell";
    
    //食物种类选择栏 可滚动
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake((screen_width)/7, categoeyViewHeight);

    self.categoryCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, categoryViewWidth*5/6, categoeyViewHeight) collectionViewLayout:flowLayout];
    self.categoryCollection.center = CGPointMake(categoryViewWidth/2, categoeyViewHeight*7/12);
       
    self.categoryCollection.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];;
    self.categoryCollection.delegate = self;
    self.categoryCollection.dataSource = self;
    self.categoryCollection.showsHorizontalScrollIndicator = NO;
    self.categoryCollection.bounces = NO;
    [self.categoryCollection registerClass:[categoryCollectionViewCell class] forCellWithReuseIdentifier:categoryID];
    [self.categoryView addSubview:self.categoryCollection];
}
- (void)creatFoodItemCategoryView{
    foodItemID = @"foodItemCell";
    
    self.foodItemView.frame = CGRectMake(0, CGRectGetMaxY(self.categoryView.frame), screen_width, screen_height-CGRectGetMaxY(self.categoryView.frame)-TabbarHeight);
    [self.view addSubview:self.foodItemView];
    self.foodItemView.backgroundColor = [UIColor yellowColor];
    int collectionWidth = self.foodItemView.frame.size.width;
    int collectionHeight = self.foodItemView.frame.size.height;
    
    UICollectionViewFlowLayout *fosaFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    fosaFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);//上、左、下、右
    fosaFlowLayout.itemSize = CGSizeMake((collectionWidth-30)/2,(collectionHeight-40)/2);
    fosaFlowLayout.minimumLineSpacing = 5;  //行间距
    fosaFlowLayout.minimumInteritemSpacing = 5; //列间距
    //固定的itemsize
    fosaFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滑动的方向 垂直
    
    //foodItem
     self.fooditemCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, collectionWidth, collectionHeight) collectionViewLayout:fosaFlowLayout];
     //self.foodItemCollection.layer.cornerRadius = 15;
     //[self setCornerOnRight:15 view:self.foodItemCollection];
    // 1 先判断系统版本
     if ([NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){10,0,0}])
     {
         // 2 初始化
         UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
         // 3.1 配置刷新控件
         refreshControl.tintColor = [UIColor brownColor];
         NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor redColor]};
         refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing" attributes:attributes];
         // 3.2 添加响应事件
         [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
         // 4 把创建的refreshControl赋值给scrollView的refreshControl属性
         self.fooditemCollection.refreshControl = refreshControl;
     }
     //self.foodItemCollection.alwaysBounceVertical = YES;
     self.fooditemCollection.delegate   = self;
     self.fooditemCollection.dataSource = self;
     self.fooditemCollection.showsVerticalScrollIndicator = NO;
     self.fooditemCollection.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    //[self.fooditemCollection registerClass:[foodItemCollectionViewCell class] forCellWithReuseIdentifier:foodItemID];
     //self.foodItemCollection.bounces = NO;
     [self.foodItemView addSubview:self.fooditemCollection];
}

#pragma mark - UICollectionViewDataSource
//每个section有几个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.categoryCollection) {
        return self.categoryArray.count;
    }else{
        if (self.collectionDataSource.count <= 4 && self.tempFoodDataSource.count == 0) {
            return 4;
        }else if(self.tempFoodDataSource.count > 0){
            return self.tempFoodDataSource.count;
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
//        // 每次先从字典中根据IndexPath取出唯一标识符
//        NSString *identifier = [_cellDictionary objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
//         // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
//        if (identifier == nil) {
//            identifier = [NSString stringWithFormat:@"%@%@", categoryID, [NSString stringWithFormat:@"%@", indexPath]];
//            [_cellDictionary setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
//        // 注册Cell
//            [self.categoryCollection registerClass:[categoryCollectionViewCell class] forCellWithReuseIdentifier:identifier];
//            }
        categoryCollectionViewCell *cell = [self.categoryCollection dequeueReusableCellWithReuseIdentifier:categoryID forIndexPath:indexPath];
        cell.kind.text = self.categoryArray[indexPath.row];
        cell.categoryPhoto.image = [UIImage imageNamed:self.categoryArray[indexPath.row]];
        if ([self caculateCategoryNumber:cell.kind.text]>0) {
            cell.badgeBtn.hidden = NO;
            [cell.badgeBtn setTitle:[NSString stringWithFormat:@"%d",[self caculateCategoryNumber:cell.kind.text]] forState:UIControlStateNormal];
        }
        return cell;
    }else{
        long int index = indexPath.section*2+indexPath.row;
        // 每次先从字典中根据IndexPath取出唯一标识符
        NSString *identifier = [self.cellDictionary objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
         // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
        if (identifier == nil) {
            identifier = [NSString stringWithFormat:@"%@%ld", foodItemID,index];
            [_cellDictionary setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
            [self.fooditemCollection registerClass:[foodItemCollectionViewCell class] forCellWithReuseIdentifier:identifier];
            }
        NSLog(@"%ld",index);
        foodItemCollectionViewCell *cell = [self.fooditemCollection dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        if (self.tempFoodDataSource.count > 0) {
            [cell setModel:self.tempFoodDataSource[index]];
        }else  if (index < self.collectionDataSource.count) {
                [cell setModel:self.collectionDataSource[index]];
        }
        
        return cell;
    }
}
//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.categoryCollection) {
           categoryCollectionViewCell *cell = (categoryCollectionViewCell *)[self.categoryCollection cellForItemAtIndexPath:indexPath];
           cell.rootView.backgroundColor = FOSAgreen;
           cell.categoryPhoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@W",cell.kind.text]];
        self.selectedCategoryCell = cell;
           NSLog(@"Selectd:%@",self.selectedCategoryCell.kind.text);
        
        [self selectFoodByCategory:self.selectedCategoryCell.kind.text];
        
    }else if(collectionView == self.fooditemCollection){
           foodItemCollectionViewCell *cell = (foodItemCollectionViewCell *)[self.fooditemCollection cellForItemAtIndexPath:indexPath];
           if (cell.model.foodName != nil) {
               [self ClickFoodItem:cell];
//               UITapGestureRecognizer *clickToCheckInfo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(JumpToInfo)];
//               cell.userInteractionEnabled = YES;
//               [cell addGestureRecognizer:clickToCheckInfo];
           }
       }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.categoryCollection) {
//        categoryCollectionViewCell *cell = (categoryCollectionViewCell *)[self.categoryCollection cellForItemAtIndexPath:indexPath];
        NSLog(@"取消选中%@",self.selectedCategoryCell.kind.text);
        self.selectedCategoryCell.rootView.backgroundColor = [UIColor whiteColor];
        self.selectedCategoryCell.categoryPhoto.image = [UIImage imageNamed:self.selectedCategoryCell.kind.text];
    }else{
        
    }
    
}

#pragma mark -- UIScrollerView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger index = offset/self.headerView.frame.size.width;
    self.pageControl.currentPage = index;
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
    //[self.db close];
}
- (void)SelectDataFromFoodTable{

    NSString *sql = @"select * from FoodStorageInfo";
    FMResultSet *set = [self.db executeQuery:sql];
    while ([set next]) {
        //NSLog(@"===============================================================");
        NSString *foodName = [set stringForColumn:@"foodName"];
        NSString *device   = [set stringForColumn:@"device"];
        NSString *aboutFood = [set stringForColumn:@"aboutFood"];
        NSString *storageDate = [set stringForColumn:@"storageDate"];
        NSString *expireDate = [set stringForColumn:@"expireDate"];
        NSString *foodImg = [set stringForColumn:@"foodImg"];
        NSString *category = [set stringForColumn:@"category"];
        NSString *isLike   = [set stringForColumn:@"like"];
        FoodModel *model = [FoodModel modelWithName:foodName DeviceID:device Description:aboutFood StrogeDate:storageDate ExpireDate:expireDate foodIcon:foodImg category:category like:isLike];
        [self.collectionDataSource addObject:model];
        NSLog(@"*********************************************");
        NSLog(@"foodName    = %@",foodName);
        NSLog(@"device      = %@",device);
        NSLog(@"aboutFood   = %@",aboutFood);
        NSLog(@"remindDate  = %@",storageDate);
        NSLog(@"expireDate  = %@",expireDate);
        NSLog(@"foodImg     = %@",foodImg);
        NSLog(@"category    = %@",category);
        NSLog(@"islike    = %@",isLike);
    }
}

- (NSMutableArray<NSString *> *)getCategoryArray{
    [self OpenSqlDatabase:@"FOSA"];
    NSMutableArray<NSString *> *category = [[NSMutableArray alloc]init];
    NSString *selSql = @"select * from category";
    FMResultSet *set = [self.db executeQuery:selSql];
    while ([set next]) {
        NSString *kind = [set stringForColumn:@"categoryName"];
        NSLog(@"%@",kind);
        [category addObject:kind];
    }
    NSLog(@"所有种类:%@",category);
    [category addObject:@"Add"];
    return category;
}
#pragma mark - 遍历食物数组
- (int)caculateCategoryNumber:(NSString *)category{
    int num = 0;
    for (FoodModel *model in self.collectionDataSource) {
        if ([category isEqualToString:model.category]) {
            num++;
        }
    }
    return num;

}
- (void)selectFoodByCategory:(NSString *)category{
    [self.tempFoodDataSource removeAllObjects];
    for (FoodModel *model in self.collectionDataSource) {
        if ([category isEqualToString:model.category]) {
            [self.tempFoodDataSource addObject:model];
        }
    }
}
#pragma mark - 响应事件
- (void)CollectionReload{
    [self.collectionDataSource removeAllObjects];
    [self.cellDictionary removeAllObjects];
    [self OpenSqlDatabase:@"FOSA"];
    [self SelectDataFromFoodTable];
    [self.fooditemCollection reloadData];
    [self.categoryCollection reloadData];
}

//食物Item点击事件
- (void)ClickFoodItem:(foodItemCollectionViewCell *)cell{
    foodAddingViewController *add = [foodAddingViewController new];
    add.foodStyle = @"Info";
    add.hidesBottomBarWhenPushed = YES;
    add.model = cell.model;
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
    [self.fooditemCollection reloadData];
    // 停止刷新
    [sender endRefreshing];
}

#pragma mark -- 教学提示
- (void)showUsingTips{
    
    self.mask = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.mask.backgroundColor = [UIColor blackColor];
    self.mask.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:self.mask];
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
    //[[UIApplication sharedApplication].keyWindow addSubview:self.mask];
}

- (void)viewWillDisappear:(BOOL)animated{
    isUpdate = true;
    self.sortbtn.hidden = YES;
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
