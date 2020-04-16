//
//  editFoodItemViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/4/16.
//  Copyright © 2020 hs. All rights reserved.
//

#import "editFoodItemViewController.h"
#import "categoryCell.h"

@interface editFoodItemViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>{
    NSArray *datasource;
    NSString *cellIndetifier;
}

@end

@implementation editFoodItemViewController
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
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
    datasource = @[@"VegetableB1",@"VegetableB2",@"VegetableB3",@"VegetableB4",@"VegetableB5",@"VegetableB6",@"VegetableB7",@"VegetableB8",];
    cellIndetifier = @"cellIndetifier";
}
- (void)creatEditFoodCategoryView{
    self.titleLabel.frame = CGRectMake(screen_width/3, 0, screen_width/3, screen_height/20);
    self.titleLabel.text = @"Edit Category";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    self.doneBtn.frame = CGRectMake(screen_width*3/4-Width(10), 0, screen_width/4, screen_height/20);
    [self.doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:FOSAColor(0, 155, 250) forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:FOSAColor(0, 180, 255) forState:UIControlStateHighlighted];
    [self.view addSubview:self.doneBtn];
    [self.doneBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), screen_width, 0.5)];
    line.backgroundColor = FOSAGray;
    [self.view addSubview:line];
    
    self.categoryNameTextView.frame = CGRectMake(screen_width/20, screen_height/15, screen_width*9/10, screen_height/20);
    self.categoryNameTextView.layer.cornerRadius = 5;
    [self.categoryNameTextView setValue:[NSNumber numberWithInt:Width(10)] forKey:@"paddingLeft"];
    self.categoryNameTextView.text = self.selectCategory;
    self.categoryNameTextView.backgroundColor = FOSAColor(245, 245, 245);
    [self.view addSubview:self.categoryNameTextView];
    self.iconSearchBar.frame = CGRectMake(0, CGRectGetMaxY(self.categoryNameTextView.frame)+Height(10), screen_width, screen_height/20);
    self.iconSearchBar.placeholder = @"Search";
    self.iconSearchBar.backgroundColor = FOSAColor(245, 245, 245);
    self.iconSearchBar.delegate = self;
    [self.view addSubview:self.iconSearchBar];

    
    UICollectionViewFlowLayout *fosaFlowLayout = [[UICollectionViewFlowLayout alloc] init];
       //fosaFlowLayout.sectionInset = UIEdgeInsetsMake();//上、左、下、右
       fosaFlowLayout.itemSize = CGSizeMake(screen_width/5,screen_width/5);
       //固定的itemsize
       fosaFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滑动的方向 垂直
    self.categoryIconView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.iconSearchBar.frame)+Height(5), screen_width, screen_height/2) collectionViewLayout:fosaFlowLayout];
    self.categoryIconView.delegate = self;
    self.categoryIconView.dataSource = self;
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
    long index = indexPath.section*4+indexPath.row;
    cell.categoryView.image = [UIImage imageNamed:datasource[index]];
    //cell.backgroundColor = FOSAColor(153, 153, 153);
    return cell;
}
#pragma mark - UISearchBarDelegate
//将要开始编辑时的回调，返回为NO，则不能编辑
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.iconSearchBar.showsCancelButton = YES;
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
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"搜索框输入:%@",searchText);
}
//点击取消按钮的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
     self.iconSearchBar.showsCancelButton = NO;
    NSLog(@"cancel");
    [searchBar resignFirstResponder];
}

- (void)finish{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
