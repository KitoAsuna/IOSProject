//
//  ProductViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2019/12/30.
//  Copyright © 2019 hs. All rights reserved.
//
/**
 目前还存在数组越界问题
 */
#import "ProductViewController.h"
#import "device/DeviceCollectionViewCell.h"
#import "CategoryTableViewCell.h"

@interface ProductViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    //NSArray *arrayData;
    //NSArray *array1,*array2,*array3,*array4,*array5,*array6,*array7;
    NSMutableArray<NSString *> *fosaDataSource,*myDeviceSource;
    CGFloat lastContentOffset;
    NSString *fosaDeviceID,*myDeviceID;
    NSInteger index;//当前滚动的位置
    NSIndexPath *currentFosaIndexPath,*currentMyIndexpath;
    Boolean isFirstOpen;
}
@property (nonatomic,strong) NSArray *arrayData,*array1,*array2,*array3,*array4,*array5,*array6,*array7;
//@property (nonatomic,strong) NSMutableArray<NSString *> *fosaDataSource,*myDeviceSource;
@property (nonatomic,strong) UIView *indecator;
@end
@implementation ProductViewController

#pragma mark - 延迟加载
- (UIView *)header{
    if (_header == nil) {
        _header = [[UIView alloc]init];
    }
    return _header;
}

- (UIView *)productCategoryView{
    if (_productCategoryView == nil) {
        _productCategoryView = [[UIView alloc]init];
    }
    return _productCategoryView;
}

- (UIView *)productView{
    if (_productView == nil) {
        _productView = [[UIView alloc]init];
    }
    return _productView;
}

- (UIView *)titleView{
    if (_titleView == nil) {
        _titleView = [[UIView alloc]init];
    }
    return _titleView;
}
- (UIButton *)fosa{
    if (_fosa == nil) {
        _fosa = [[UIButton alloc]init];
    }
    return _fosa;
}

- (UIButton *)myFosa{
    if (_myFosa == nil) {
        _myFosa = [[UIButton alloc]init];
    }
    return _myFosa;
}

- (UISearchBar *)searchBar{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]init];
    }
    return _searchBar;
}

- (UITableView *)productCategory{
    if (_productCategory == nil) {
        _productCategory = [[UITableView alloc]init];
    }
    return _productCategory;
}

- (UIScrollView *)mainScrollView{
    if (_mainScrollView == nil) {
        _mainScrollView = [[UIScrollView alloc]init];
    }
    return _mainScrollView;
}
- (UIView *)indecator{
    if (_indecator == nil) {
        _indecator = [[UIView alloc]init];
    }
    return _indecator;
}
- (NSArray *)arrayData{
    if (_arrayData == nil) {
        _arrayData = @[@"MADRID",@"BARCELONA",@"MALAGA",@"O2Go",@"O2Go WINE",@"New Product",@"All"];
    }
    return _arrayData;
}
- (NSArray *)array1{
    if (_array1 == nil) {
        _array1 = @[@"MAD(20oz)",@"MAD850ml(28oz)",@"MAD1250ml(45oz)",@"MAD2850ml(96oz)",@"MAR3450ml(116oz)",@"Round01",@"Round02",@"Round03",@"Round04"];
    }
    return _array1;
}
- (NSArray *)array2{
    if (_array2 == nil) {
        _array2 = @[@"BAR1450ml(49oz)",@"BAR2300ml(77oz)",@"Square01",@"Square03",@"Square04",@"Square05",@"Square06",@"Square07"];
    }
    return _array2;
}
- (NSArray *)array3{
    if (_array3 == nil) {
        _array3 = @[@"S Size0.9L",@"M Size2L",@"L Size3.8L",@"V-ADAPTER"];
    }
    return _array3;
}
- (NSArray *)array4{
    if (_array4 == nil) {
        _array4 = @[@"0.97L(33oz)",@"1.32L(45oz)"];
    }
    return _array4;
}
- (NSArray *)array5{
    if (_array5 == nil) {
        _array5 = @[@"WINE_Pouchbag",@"WINE0.97L(33oz)"];
    }
    return _array5;
}
- (NSArray *)array6{
    if (_array6 == nil) {
        _array6 = @[@"FOSA003",@"FOSA001",@"IMG_Pound"];
    }
    return _array6;
}
- (NSArray *)array7{
    if (_array7 == nil) {
        _array7 = @[@"MAD(20oz)",@"MAD850ml(28oz)",@"MAD1250ml(45oz)",@"MAD2850ml(96oz)",@"MAR3450ml(116oz)",@"Round01",@"Round02",@"Round03",@"Round04",@"BAR1450ml(49oz)",@"BAR2300ml(77oz)",@"Square01",@"Square03",@"Square04",@"Square05",@"Square06",@"Square07",@"S Size0.9L",@"M Size2L",@"L Size3.8L",@"V-ADAPTER",@"0.97L(33oz)",@"1.32L(45oz)",@"WINE_Pouchbag",@"WINE0.97L(33oz)",@"FOSA003",@"FOSA001",@"IMG_Pound"];
    }
    return _array7;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];;
     NSLog(@"Product------------------------------------------");
    [self CreatHeader];
    [self CreatProductCategoryTable];
    [self CreatProductCollection];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self initData];
    //种类栏默认选中第一个
    UITableViewCell *cell = (UITableViewCell *)[self.productCategory cellForRowAtIndexPath:currentFosaIndexPath];
    cell.textLabel.textColor = FOSAgreen;
    [self.productCategory selectRowAtIndexPath:currentFosaIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    self.indecator.frame = CGRectMake(0, cell.frame.size.height/4, 5, cell.frame.size.height/2);
    self.indecator.backgroundColor = FOSAgreen;
    self.indecator.layer.cornerRadius = 2;
    [cell addSubview:self.indecator];
}

- (void)initData{
    //arrayData = @[@"MADRID",@"BARCELONA",@"MALAGA",@"O2Go",@"O2Go WINE",@"New Product",@"All"];
    //array1 = @[@"MAD(20oz)",@"MAD850ml(28oz)",@"MAD1250ml(45oz)",@"MAD2850ml(96oz)",@"MAR3450ml(116oz)",@"Round01",@"Round02",@"Round03",@"Round04"];
    //array2 = @[@"BAR1450ml(49oz)",@"BAR2300ml(77oz)",@"Square01",@"Square03",@"Square04",@"Square05",@"Square06",@"Square07"];
    //array3 = @[@"S Size0.9L",@"M Size2L",@"L Size3.8L",@"V-ADAPTER"];
    //array4 = @[@"0.97L(33oz)",@"1.32L(45oz)"];
    //array5 = @[@"WINE_Pouchbag",@"WINE0.97L(33oz)"];
    //array6 = @[@"FOSA003",@"FOSA001",@"IMG_Pound"];
    //array7 = @[@"MAD(20oz)",@"MAD850ml(28oz)",@"MAD1250ml(45oz)",@"MAD2850ml(96oz)",@"MAR3450ml(116oz)",@"Round01",@"Round02",@"Round03",@"Round04",@"BAR1450ml(49oz)",@"BAR2300ml(77oz)",@"Square01",@"Square03",@"Square04",@"Square05",@"Square06",@"Square07",@"S Size0.9L",@"M Size2L",@"L Size3.8L",@"V-ADAPTER",@"0.97L(33oz)",@"1.32L(45oz)",@"WINE_Pouchbag",@"WINE0.97L(33oz)",@"FOSA003",@"FOSA001",@"IMG_Pound"];

    fosaDataSource = [[NSMutableArray alloc]initWithArray:self.array1];//默认选中1
    //[self addObjectByArray:self.array1 target:fosaDataSource];
    myDeviceSource = [[NSMutableArray alloc]initWithArray:self.array1];
    //[self addObjectByArray:self.array1 target:myDeviceSource];
    
    fosaDeviceID = @"fosaDeviceCell";
    myDeviceID   = @"myDeviceCell";
    //默认一开始选中第一行
    currentMyIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    currentFosaIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)CreatHeader{
    self.header.frame = CGRectMake(0, StatusBarH, screen_width,NavigationBarHeight);
    self.header.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [self.view addSubview:self.header];
    self.searchBar.frame = CGRectMake(0, 0, screen_width, NavigationBarHeight);
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
    [self.header addSubview:self.searchBar];
}

- (void)CreatProductCategoryTable{
    isFirstOpen = true;
    self.productCategoryView.frame = CGRectMake(0, NavigationBarHeight+StatusBarH, screen_width/4, screen_height-NavigationBarHeight-TabbarHeight);
    self.productCategoryView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.productCategoryView];
    self.productCategory.frame = CGRectMake(0, 0, self.productCategoryView.frame.size.width, self.productCategoryView.frame.size.height);
    self.productCategory.delegate = self;
    self.productCategory.dataSource = self;
    self.productCategory.bounces = NO;
    self.productCategory.showsVerticalScrollIndicator = NO;
    [self.productCategoryView addSubview:self.productCategory];

}

- (void)CreatProductCollection{
    fosaDeviceID = @"fosaDeviceCell";
    myDeviceID   = @"myDeviceCell";
    self.productView.frame = CGRectMake(screen_width/4+0.5, NavigationBarHeight+StatusBarH, screen_width*3/4-0.5, screen_height-NavigationBarHeight-TabbarHeight);
    self.productView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.productView];
    
    // 添加标题视图
    self.titleView.frame = CGRectMake(10, 10, self.productView.frame.size.width-20, 40);
    self.titleView.layer.borderWidth = 1;
    self.titleView.layer.cornerRadius = 10;
    self.titleView.layer.borderColor = FOSAgreen.CGColor;
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self.productView addSubview:self.titleView];
    // 添加标题按钮
    self.fosa.frame = CGRectMake(0, 0, self.productView.frame.size.width/2-10, 40);
    [self.fosa setTitle:@"FOSA" forState:UIControlStateNormal];
    //[self.fosa setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //[self.fosa setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self setCornerOnLeft:10 view:self.fosa];
    [self.fosa addTarget:self action:@selector(switchDevice:) forControlEvents:UIControlEventTouchUpInside];
    self.fosa.tag = 0;
    self.fosa.backgroundColor = FOSAgreen;  //默认选中；
    
    self.myFosa.frame = CGRectMake(self.productView.frame.size.width/2-10, 0, self.productView.frame.size.width/2-10, 40);
    [self.myFosa setTitle:@"My Device" forState:UIControlStateNormal];
    [self.myFosa setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.myFosa setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.myFosa.clipsToBounds = YES;
    [self setCornerOnRight:10 view: self.myFosa];
    [self.myFosa addTarget:self action:@selector(switchDevice:) forControlEvents:UIControlEventTouchUpInside];
    self.myFosa.tag = 1;
    self.myFosa.backgroundColor = [UIColor whiteColor];
    
    [self.titleView addSubview:self.fosa];
    [self.titleView addSubview:self.myFosa];
    
    self.mainScrollView.frame = CGRectMake(0,55, self.productView.frame.size.width, self.productView.frame.size.height-55);
    self.mainScrollView.delegate = self;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    [self.productView addSubview:self.mainScrollView];
    
   //layout
    CGFloat scrollerWidth = self.mainScrollView.frame.size.width;
    CGFloat scrollerHeight = self.mainScrollView.frame.size.height;
    
    UICollectionViewFlowLayout *fosaFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    fosaFlowLayout.minimumLineSpacing = 5;  //行间距
    fosaFlowLayout.minimumInteritemSpacing = 5; //列间距
    fosaFlowLayout.itemSize = CGSizeMake((scrollerWidth-20)/3, (scrollerWidth-20)/2); //固定的itemsize
    fosaFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滑动的方向 垂直
    UICollectionViewFlowLayout *myFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    myFlowLayout.minimumLineSpacing = 5;  //行间距
    myFlowLayout.minimumInteritemSpacing = 5; //列间距
    myFlowLayout.itemSize = CGSizeMake((scrollerWidth-20)/3, scrollerWidth/2);; //固定的itemsize
    myFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滑动的方向 垂直
    //fosaDevice
    self.fosaProductCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, scrollerWidth, scrollerHeight) collectionViewLayout:fosaFlowLayout];
    self.fosaProductCollection.backgroundColor = [UIColor whiteColor];
    self.fosaProductCollection.delegate = self;
    self.fosaProductCollection.dataSource = self;
    self.fosaProductCollection.showsVerticalScrollIndicator = NO;
    self.fosaProductCollection.bounces = NO;
    [self.fosaProductCollection registerClass:[DeviceCollectionViewCell class] forCellWithReuseIdentifier:fosaDeviceID];   //注册cell
    [self.mainScrollView addSubview:self.fosaProductCollection];
    self.myProductCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(scrollerWidth, 0, scrollerWidth, scrollerHeight) collectionViewLayout:myFlowLayout];
    self.myProductCollection.backgroundColor = [UIColor whiteColor];
    self.myProductCollection.delegate = self;
    self.myProductCollection.dataSource = self;
    self.myProductCollection.showsVerticalScrollIndicator = NO;
    self.myProductCollection.bounces = NO;
    [self.myProductCollection registerClass:[DeviceCollectionViewCell class] forCellWithReuseIdentifier:myDeviceID];   //注册cell
    [self.mainScrollView addSubview:self.myProductCollection];
    self.mainScrollView.contentSize = CGSizeMake(scrollerWidth*2, 0);
}
#pragma mark - UISearchBarDelegate
//将要开始编辑时的回调，返回为NO，则不能编辑
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = YES;
    NSLog(@"begin");
}
//已经结束编辑的回调
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"end");
    [searchBar resignFirstResponder];
}
//点击搜索按钮的回调
- (void)searchBarSearchButtonClicked:(UISearchBar* )searchBar{
    NSLog(@"%@",searchBar.text);
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}
//点击取消按钮的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
     self.searchBar.showsCancelButton = NO;
    NSLog(@"cancel");
    [searchBar resignFirstResponder];
}
#pragma mark - UITableViewDelegate
//行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.productCategoryView.frame.size.height)/8;
}
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}
//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//每行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    //初始化cell，并指定其类型
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        //创建cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    //取消点击cell时显示的背景色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:11*(([UIScreen mainScreen].bounds.size.width/414.0))];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.highlightedTextColor = FOSAgreen;
    cell.textLabel.text = self.arrayData[indexPath.row];
    //返回cell
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"当前点击第%ld行",(long)indexPath.row);
    if (index == 0) {
        currentFosaIndexPath = indexPath;
    }else{
        currentMyIndexpath   = indexPath;
    }
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
    switch (indexPath.row) {
        case 0:
            [self switchProductCategoryByArray:self.array1];
            break;
        case 1:
            [self switchProductCategoryByArray:self.array2];
            break;
        case 2:
            [self switchProductCategoryByArray:self.array3];
            break;
        case 3:
            [self switchProductCategoryByArray:self.array4];
            break;
        case 4:
            [self switchProductCategoryByArray:self.array5];
            break;
        case 5:
            [self switchProductCategoryByArray:self.array6];
            break;
        case 6:
            [self switchProductCategoryByArray:self.array7];
            break;
        default:
            break;
    }
    //获取点击的cell
     UITableViewCell * cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = FOSAgreen;
    self.indecator.frame = CGRectMake(0, cell.frame.size.height/4, 5, cell.frame.size.height/2);
    self.indecator.backgroundColor = FOSAgreen;
    [cell addSubview:self.indecator];
    NSLog(@"%@",cell.textLabel.text);
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor blackColor];
    [self.indecator removeFromSuperview];

}

- (void)switchProductCategoryByArray:(NSArray *)array{
    if (index == 0) {
        //[self addObjectByArray:array target:fosaDataSource];
        [fosaDataSource removeAllObjects];
        [fosaDataSource addObjectsFromArray:array];
        NSLog(@"fosaProduct:%@",fosaDataSource);
        [self.fosaProductCollection reloadData];
    }else if(index == 1){
        //[self addObjectByArray:array target:myDeviceSource];
        [myDeviceSource removeAllObjects];
        [myDeviceSource addObjectsFromArray:array];
        NSLog(@"myDevice:%@",myDeviceSource);
        [self.myProductCollection reloadData];
    }
}

- (void)addObjectByArray:(NSArray *)array target:(NSMutableArray<NSString *> *)tarray{
    [tarray removeAllObjects];
    for (int i = 0; i < array.count; i++) {
        [tarray addObject:array[i]];
    }
}
- (void)switchDevice:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0) {
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.fosa.backgroundColor = FOSAgreen;
        self.fosa.titleLabel.textColor = [UIColor whiteColor];
        self.myFosa.backgroundColor = [UIColor whiteColor];
        self.myFosa.titleLabel.textColor = [UIColor grayColor];
        UITableViewCell *cell1 = (UITableViewCell *)[self.productCategory cellForRowAtIndexPath:currentMyIndexpath];
        cell1.textLabel.textColor = [UIColor blackColor];
        [self.indecator removeFromSuperview];
        
        UITableViewCell *cell2 = (UITableViewCell *)[self.productCategory cellForRowAtIndexPath:currentFosaIndexPath];
        cell2.textLabel.textColor = FOSAgreen;
        [cell2 addSubview:self.indecator];
        [self.productCategory selectRowAtIndexPath:currentFosaIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        index = 0;
    }else if(btn.tag == 1){
        index = 1;
        [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.frame.size.width, 0) animated:YES];
        self.myFosa.backgroundColor = FOSAgreen;
        self.myFosa.titleLabel.textColor = [UIColor whiteColor];
        self.fosa.backgroundColor = [UIColor whiteColor];
        self.fosa.titleLabel.textColor = [UIColor grayColor];
        UITableViewCell *cell = (UITableViewCell *)[self.productCategory cellForRowAtIndexPath:currentFosaIndexPath];
        cell.textLabel.textColor = [UIColor blackColor];
        [self.indecator removeFromSuperview];
        UITableViewCell *cell1 = (UITableViewCell *)[self.productCategory cellForRowAtIndexPath:currentMyIndexpath];
        cell1.textLabel.textColor = FOSAgreen;
        [cell1 addSubview:self.indecator];
        [self.productCategory selectRowAtIndexPath:currentMyIndexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}
#pragma mark - UIScrollerViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    lastContentOffset = scrollView.contentOffset.y;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"当前滚动视图:%@",scrollView);
    if (![scrollView isKindOfClass:[self.fosaProductCollection class]]) {
        CGFloat offset = scrollView.contentOffset.x;
        index = offset/self.mainScrollView.frame.size.width;
        NSLog(@"%ld",(long)index);
        if (index == 0) {
            self.fosa.backgroundColor = FOSAgreen;
            self.fosa.titleLabel.textColor = [UIColor whiteColor];
            self.myFosa.backgroundColor = [UIColor whiteColor];
            self.myFosa.titleLabel.textColor = [UIColor grayColor];
            UITableViewCell *cell1 = (UITableViewCell *)[self.productCategory cellForRowAtIndexPath:currentMyIndexpath];
            cell1.textLabel.textColor = [UIColor blackColor];
            [self.indecator removeFromSuperview];
            
            UITableViewCell *cell2 = (UITableViewCell *)[self.productCategory cellForRowAtIndexPath:currentFosaIndexPath];
            cell2.textLabel.textColor = FOSAgreen;
            [cell2 addSubview:self.indecator];
            [self.productCategory selectRowAtIndexPath:currentFosaIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }else if(index == 1){
            self.myFosa.backgroundColor = FOSAgreen;
            self.myFosa.titleLabel.textColor = [UIColor whiteColor];
            self.fosa.backgroundColor = [UIColor whiteColor];
            self.fosa.titleLabel.textColor = [UIColor grayColor];
            UITableViewCell *cell = (UITableViewCell *)[self.productCategory cellForRowAtIndexPath:currentFosaIndexPath];
            cell.textLabel.textColor = [UIColor blackColor];
            [self.indecator removeFromSuperview];
            UITableViewCell *cell1 = (UITableViewCell *)[self.productCategory cellForRowAtIndexPath:currentMyIndexpath];
            cell1.textLabel.textColor = FOSAgreen;
            [cell1 addSubview:self.indecator];
            [self.productCategory selectRowAtIndexPath:currentMyIndexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
         
}
#pragma mark - UICollectionViewDataSource

//每个section有几个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.fosaProductCollection]) {
        NSLog(@"===========%lu",(unsigned long)fosaDataSource.count);
        return fosaDataSource.count;
    }else if([collectionView isEqual:self.myProductCollection]){
        NSLog(@"<<<<<<<<<<<<%lu",(unsigned long)myDeviceSource.count);
        return myDeviceSource.count;
    }else{
        return 0;
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
    if ([collectionView isEqual:self.fosaProductCollection]) {
        DeviceCollectionViewCell *cell = [self.fosaProductCollection dequeueReusableCellWithReuseIdentifier:fosaDeviceID forIndexPath:indexPath];
        NSInteger index = indexPath.row;
        NSLog(@"fosaProduct>>>>>>>>>>>>%ld----------fosaDataSource:%lu",(long)index,fosaDataSource.count);
        cell.productImageView.image = [UIImage imageNamed:fosaDataSource[index]];
        cell.productName.text = fosaDataSource[index];
        cell.layer.cornerRadius = 5;

        cell.layer.shadowColor = FOSAshadowColor.CGColor;
        cell.layer.shadowOffset = CGSizeMake(3,3.0f);
        cell.layer.shadowRadius =2.0f;
        cell.layer.shadowOpacity =0.5f;
        cell.layer.masksToBounds =NO;
        //cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
        return cell;
    }else{
        DeviceCollectionViewCell *cell = [self.myProductCollection dequeueReusableCellWithReuseIdentifier:myDeviceID forIndexPath:indexPath];
        NSInteger index = indexPath.row;
        cell.productImageView.image = [UIImage imageNamed:myDeviceSource[index]];
        cell.productName.text = myDeviceSource[index];
        cell.layer.cornerRadius = 5;
        
        cell.layer.shadowColor = FOSAshadowColor.CGColor;
        cell.layer.shadowOffset = CGSizeMake(3,3.0f);
        cell.layer.shadowRadius =2.0f;
        cell.layer.shadowOpacity =0.5f;
        cell.layer.masksToBounds =NO;
        //cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
        return cell;
    }
}
//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //获取点击的cell
     [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//点击效果
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    if (index == 0) {
        DeviceCollectionViewCell *cell = (DeviceCollectionViewCell *)[self.fosaProductCollection cellForItemAtIndexPath:indexPath];
        NSLog(@"---------------------%@",cell.productName.text);
        cell.alpha = 0.5;
        //cell.backgroundColor = [UIColor lightGrayColor];
    }else if (index == 1){
        DeviceCollectionViewCell *cell = (DeviceCollectionViewCell *)[self.myProductCollection cellForItemAtIndexPath:indexPath];
        cell.alpha = 0.5;
        //cell.backgroundColor = [UIColor lightGrayColor];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{

    if (index == 0) {
        DeviceCollectionViewCell *cell = (DeviceCollectionViewCell *)[self.fosaProductCollection cellForItemAtIndexPath:indexPath];
        cell.alpha = 1.0;
        //cell.backgroundColor = [UIColor whiteColor];
    }else if (index == 1){
        DeviceCollectionViewCell *cell = (DeviceCollectionViewCell *)[self.myProductCollection cellForItemAtIndexPath:indexPath];
        cell.alpha = 1.0;
        //cell.backgroundColor = [UIColor whiteColor];
    }
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 0, 5);
}

//#pragma mark -设置圆角
///*设置顶部圆角*/
//- (void)setCornerOnTop:(CGFloat )cornerRadius {
//    UIBezierPath *maskPath;
//    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
//                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
//                                           cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.layer.mask = maskLayer;
//}
///*设置底部圆角*/
//- (void)setCornerOnBottom:(CGFloat )cornerRadius {
//    UIBezierPath *maskPath;
//    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
//                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
//                                           cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.layer.mask = maskLayer;
//}
/*设置左边圆角*/
- (void)setCornerOnLeft:(CGFloat )cornerRadius view:(UIButton *)button{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                                           cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = button.bounds;
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}
/*设置右边圆角*/
- (void)setCornerOnRight:(CGFloat )cornerRadius view:(UIButton *)button{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds
                                     byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = button.bounds;
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
}
/**隐藏底部横条，点击屏幕可显示*/
- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}
@end
