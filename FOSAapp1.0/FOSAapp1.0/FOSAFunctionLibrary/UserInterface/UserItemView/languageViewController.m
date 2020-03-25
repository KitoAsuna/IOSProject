//
//  languageViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/3/9.
//  Copyright © 2020 hs. All rights reserved.
//

#import "languageViewController.h"

@interface languageViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation languageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    self.navigationItem.title = @"Language";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0],NSForegroundColorAttributeName, nil]];
    [self creatLanguageTable];
}
- (void)viewWillAppear:(BOOL)animated{
    //UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
    [super viewWillAppear:animated];
}
- (void)creatLanguageTable{
    self.dataSource = [NSMutableArray new];
    [self.dataSource addObjectsFromArray:@[@"简体中文",@"繁体中文",@"English"]];
    self.languageTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationHeight*1.5, screen_width, screen_height/5) style:UITableViewStylePlain];
    self.languageTable.delegate = self;
    self.languageTable.dataSource = self;
    self.languageTable.bounces = NO;
    self.languageTable.layer.cornerRadius = 15;
    self.languageTable.showsVerticalScrollIndicator = NO;
    [self.languageTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.languageTable.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:self.languageTable];
    
    
    [self.languageTable reloadData];
    NSInteger selectedIndex = 0;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self.languageTable selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.languageTable cellForRowAtIndexPath:selectedIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
//
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.languageTable.frame.size.height/self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /**
     cell.accessoryType = UITableViewCellAccessoryNone;//cell没有任何的样式
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//cell的右边有一个小箭头，距离右边有十几像素；
     cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;//cell右边有一个蓝色的圆形button；
     cell.accessoryType = UITableViewCellAccessoryCheckmark;//cell右边的形状是对号;
     
     cell.selectionStyle = UITableViewCellSelectionStyleNone;//无色
     cell.selectionStyle = UITableViewCellSelectionStyleBlue;//蓝色
     cell.selectionStyle = UITableViewCellSelectionStyleGray;//灰色
     */
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
    cell.textLabel.font = [UIFont systemFontOfSize:20*(([UIScreen mainScreen].bounds.size.width/414.0))];
    cell.textLabel.text = self.dataSource[row];
    cell.textLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    cell.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    //返回cell
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.languageTable cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}


@end
