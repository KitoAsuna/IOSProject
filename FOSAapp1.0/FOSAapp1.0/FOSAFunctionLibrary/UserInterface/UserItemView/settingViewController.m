//
//  settingViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/3/9.
//  Copyright © 2020 hs. All rights reserved.
//

#import "settingViewController.h"

@interface settingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *selectedSetting;
}
@property(nonatomic,strong) NSUserDefaults *userDefaults;
@end
@implementation settingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTable];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.title = @"Setting";
}
- (void)creatTable{
    self.dataSource = [NSMutableArray new];
    [self.dataSource addObjectsFromArray:@[@"当天提醒",@"提前一天",@"提前两天"]];
    self.settingTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height/2) style:UITableViewStylePlain];
    self.settingTable.delegate = self;
    self.settingTable.dataSource = self;
    self.settingTable.bounces = NO;
    self.settingTable.layer.cornerRadius = 15;
    self.settingTable.showsVerticalScrollIndicator = NO;
    [self.settingTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.settingTable.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.settingTable];
    
    [self.settingTable reloadData];
    NSInteger selectedIndex = 0;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self.settingTable selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.settingTable cellForRowAtIndexPath:selectedIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.settingTable.frame.size.height/self.dataSource.count;
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
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;

    cell.textLabel.text = self.dataSource[row];
    //返回cell
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    selectedSetting = cell.textLabel.text;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.userDefaults = [NSUserDefaults standardUserDefaults];// 初始化
    [self.userDefaults setObject:selectedSetting forKey:@"notificationSetting"];
}
@end
