//
//  editFoodItemViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/4/16.
//  Copyright © 2020 hs. All rights reserved.
//

#import "editFoodItemViewController.h"
#import "categoryCell.h"
#import "categoryModel.h"
#import "FosaFMDBManager.h"

@interface editFoodItemViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>{
    NSString *cellIndetifier;
    NSString *selectIcon;
    categoryCell *selectCell;
    FosaFMDBManager *fmdbManager;
    NSMutableArray<categoryModel *> *categoryData;
    NSMutableArray<NSString *> *datasource;
}

@end

@implementation editFoodItemViewController
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}

- (UIButton *)resetBtn{
    if (_resetBtn == nil) {
        _resetBtn = [UIButton new];
    }
    return _resetBtn;
}

- (UIButton *)doneBtn{
    if (_doneBtn == nil) {
        _doneBtn = [UIButton new];
    }
    return _doneBtn;
}
- (UITextField *)categoryNameTextView{
    if (_categoryNameTextView == nil) {
        _categoryNameTextView = [UITextField new];
    }
    return _categoryNameTextView;
}
- (UISearchBar *)iconSearchBar{
    if (_iconSearchBar == nil) {
        _iconSearchBar = [UISearchBar new];
    }
    return _iconSearchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = FOSAWhite;
    // Do any additional setup after loading the view.
    [self initData];
    [self creatEditFoodCategoryView];
}

- (void)initData{
    [self getCategoryArray];
    NSArray *dataArray = @[@"Biscuit",@"Bread",@"Cake",@"Cereal",@"Dairy",@"Fruit",@"Meat",@"Snacks",@"Spice",@"Veggie",@"Tonic",@"Nut",@"Drink",@"HighFat",@"Milk",@"Molasses",@"Starch",@"Tea",@"Beans",@"Liquor",@"Fruit1",@"Fruit2",@"Fruit3",@"Fruit4",@"Fruit5",@"Fruit6",@"Fruit7",@"Fruit8",@"Fruit9",@"Fruit10",@"Fruit11",@"Meat1",@"Meat2",@"Meat3",@"Meat4",@"Meat5",@"Meat6",@"Meat7",@"Meat8",@"Meat9",@"Meat10",@"Meat11",@"Snack1",@"Snack2",@"Snack3",@"Snack4",@"Snack5",@"Snack6",@"Snack7",@"Snack8",@"Snack9",@"Snack10",@"Snack11",@"Snack12",@"Snack13",@"Snack14",@"Snack15",@"Vegetable1",@"Vegetable2",@"Vegetable3",@"Vegetable4",@"Vegetable5",@"Vegetable6",@"Vegetable7",@"Vegetable8",@"Vegetable9",@"Vegetable10",@"Vegetable11",@"Vegetable12",@"Vegetable13"];
    datasource = [[NSMutableArray alloc]initWithArray:dataArray];
    for (int i = 0; i < categoryData.count; i++) {
        NSLog(@"已经被选中的图标:%@",categoryData[i].categoryIconName);
        [datasource removeObject:categoryData[i].categoryIconName];
    }
    //把当前种类图标放在第一个
    [datasource insertObject:self.selectCategoryIcon atIndex:0];
    cellIndetifier = @"cellIndetifier";
}
- (void)getCategoryArray{
    fmdbManager = [FosaFMDBManager initFMDBManagerWithdbName:@"FOSA"];
    NSString *selSql = @"select * from category";
    if ([fmdbManager isFmdbOpen]) {
        categoryData = [fmdbManager selectDataWithTableName:@"category" sql:selSql];
    }
}
- (void)creatEditFoodCategoryView{
    
    CGFloat height = self.view.bounds.size.height;
    CGFloat width  = self.view.bounds.size.width;
    
    UIImageView *editImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, height/25, height/25)];
    editImgView.image = [UIImage imageNamed:@"icon_edit"];
    editImgView.center =CGPointMake(self.view.center.x, height/20);
    [self.view addSubview:editImgView];
    
    self.titleLabel.frame = CGRectMake(width/3, CGRectGetMaxY(editImgView.frame), width/3, height/30);
    self.titleLabel.text = @"Edit Category";
    self.titleLabel.textColor = FOSAGray;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    self.doneBtn.frame = CGRectMake(width*4/5, height/40, width/6, height/20);
    [self.doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:FOSAColor(0, 155, 250) forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:FOSAColor(0, 180, 255) forState:UIControlStateHighlighted];
    [self.view addSubview:self.doneBtn];
    [self.doneBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    
    self.resetBtn.frame = CGRectMake(width/30, height/40, width/6, height/20);
    [self.resetBtn setTitle:@"Reset" forState:UIControlStateNormal];
    [self.resetBtn setTitleColor:FOSAColor(0, 155, 250) forState:UIControlStateNormal];
    [self.resetBtn setTitleColor:FOSAColor(0, 180, 255) forState:UIControlStateHighlighted];
    [self.view addSubview:self.resetBtn];
    [self.resetBtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), width, 0.5)];
    line.backgroundColor = FOSAGray;
    //[self.view addSubview:line];
    
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(width/20+Width(10), CGRectGetMaxY(self.titleLabel.frame)+Height(10), width/4, height/40)];
    namelabel.text = @"Name";
    namelabel.textColor = FOSAGray;
    [self.view addSubview:namelabel];
    self.categoryNameTextView.frame = CGRectMake(width/20, CGRectGetMaxY(namelabel.frame), width*9/10, height/25);
    self.categoryNameTextView.layer.cornerRadius = 10;
    [self.categoryNameTextView setValue:[NSNumber numberWithInt:Width(10)] forKey:@"paddingLeft"];
    self.categoryNameTextView.returnKeyType = UIReturnKeyDone;
    self.categoryNameTextView.delegate = self;
    self.categoryNameTextView.text = self.selectCategory;
    self.categoryNameTextView.backgroundColor = FOSAColor(245, 245, 245);
    [self.view addSubview:self.categoryNameTextView];
//    self.iconSearchBar.frame = CGRectMake(0, CGRectGetMaxY(self.categoryNameTextView.frame)+Height(10), screen_width, screen_height/20);
//    self.iconSearchBar.placeholder = @"Search";
//    self.iconSearchBar.backgroundColor = FOSAColor(245, 245, 245);
//    self.iconSearchBar.delegate = self;
    //[self.view addSubview:self.iconSearchBar];

    CGFloat collectWidth = screen_width*9/10;
    UICollectionViewFlowLayout *fosaFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    fosaFlowLayout.sectionInset = UIEdgeInsetsMake(Height(12),Width(10),0,Width(10));//上、左、下、右
    fosaFlowLayout.itemSize = CGSizeMake(collectWidth/5-Width(10),collectWidth/5-Width(10));

       //固定的itemsize
    fosaFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滑动的方向 垂直
    
    UILabel *iconlabel = [[UILabel alloc]initWithFrame:CGRectMake(width/20+Width(10), CGRectGetMaxY(self.categoryNameTextView.frame)+Height(10), width/4, height/40)];
    iconlabel.text = @"Icon";
    iconlabel.textColor = FOSAGray;
    [self.view addSubview:iconlabel];

    self.categoryIconView = [[UICollectionView alloc]initWithFrame:CGRectMake(screen_width/20, CGRectGetMaxY(iconlabel.frame), collectWidth, height-CGRectGetMaxY(iconlabel.frame)-5*NavigationBarH/2) collectionViewLayout:fosaFlowLayout];
    self.categoryIconView.delegate = self;
    self.categoryIconView.dataSource = self;
    self.categoryIconView.layer.cornerRadius = 10;
    self.categoryIconView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];

    [self.categoryIconView registerClass:[categoryCell class] forCellWithReuseIdentifier:cellIndetifier];
    [self.view addSubview:self.categoryIconView];
    
}
#pragma mark - UIcollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return datasource.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath {
    categoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndetifier forIndexPath:indexPath];
    long index = indexPath.row;

    if ([datasource[index] isEqualToString:self.selectCategoryIcon]) {
        cell.backgroundColor = FOSAYellow;
        cell.categoryView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@W",datasource[index]]];
        selectCell = cell;
    }else{
        cell.categoryView.image = [UIImage imageNamed:datasource[index]];
        cell.backgroundColor = FOSAWhite;
    }
    cell.imgName = datasource[index];
    cell.layer.cornerRadius = cell.bounds.size.width/2;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    categoryCell *cell = (categoryCell *) [self.categoryIconView cellForItemAtIndexPath:indexPath];
    if (![cell.imgName isEqualToString:selectCell.imgName]) {
        selectCell.backgroundColor = FOSAWhite;
        selectCell.categoryView.image = [UIImage imageNamed:selectCell.imgName];
    }
    selectIcon = cell.imgName;
    NSLog(@"%@",cell.imgName);
    cell.backgroundColor = FOSAYellow;
    cell.categoryView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@W",cell.imgName]];
    selectCell = cell;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    categoryCell *cell = (categoryCell *) [self.categoryIconView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = FOSAWhite;
    cell.categoryView.image = [UIImage imageNamed:cell.imgName];
}
// 两列cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return Height(8);
}

// 两行cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - UItextFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
////将要开始编辑时的回调，返回为NO，则不能编辑
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    return YES;
//}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//    self.iconSearchBar.showsCancelButton = YES;
//    NSLog(@"begin");
//}
////已经结束编辑的回调
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//    NSLog(@"end");
//    [searchBar resignFirstResponder];
//}
////点击搜索按钮的回调
//- (void)searchBarSearchButtonClicked:(UISearchBar* )searchBar{
//    NSLog(@"%@",searchBar.text);
//    [searchBar resignFirstResponder];
//    searchBar.showsCancelButton = NO;
//}
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    NSLog(@"搜索框输入:%@",searchText);
//}
////点击取消按钮的回调
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//     self.iconSearchBar.showsCancelButton = NO;
//    NSLog(@"cancel");
//    [searchBar resignFirstResponder];
//}

- (void)finish{
    //NSLog(@"categoryName:%@-----selectIcon:%@",self.categoryNameTextView.text,selectIcon);
    NSString *categoryStr = self.selectCategory;
    if (![self.selectCategory isEqualToString:self.categoryNameTextView.text]) {
        categoryStr = self.categoryNameTextView.text;
        NSString *updateSql = [NSString stringWithFormat:@"update category set categoryName = '%@' where categoryName = '%@'",categoryStr,self.selectCategory];
        if ([fmdbManager updateDataWithSql:updateSql]) {
            NSLog(@"修改食物种类名称成功");
        }
        NSString *updateFoodSql = [NSString stringWithFormat:@"update FoodStorageInfo set category = '%@' where category = '%@'",categoryStr,self.selectCategory];
        if ([fmdbManager updateDataWithSql:updateFoodSql]) {
            NSLog(@"修改食物项种类完成");
        }
    }
    if (selectIcon) {
        NSString *updateIconSql = [NSString stringWithFormat:@"update category set categoryIcon = '%@' where categoryName = '%@'",selectIcon,categoryStr];
        if ([fmdbManager updateDataWithSql:updateIconSql]) {
            NSLog(@"修改食物种类名称图标成功");
        }
    }
    self.categoryBlock(YES);
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)reset{
    self.categoryNameTextView.text = self.selectCategory;
    [self.categoryIconView reloadData];
}
@end
