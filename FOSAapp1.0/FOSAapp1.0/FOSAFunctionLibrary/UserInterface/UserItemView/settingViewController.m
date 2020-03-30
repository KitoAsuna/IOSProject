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
    UITableViewCell *selectedCell;
    NSString *autoNotification;
}
@property(nonatomic,strong) NSUserDefaults *userDefaults;
@property (nonatomic,strong) NSDictionary *setDic;
@property (nonatomic,strong) UISwitch *mswitch;
@end
@implementation settingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];;
    [self creatTable];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Setting";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0],NSForegroundColorAttributeName, nil]];
}
- (void)creatTable{
//    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight*2, screen_width, NavigationBarHeight)];
//    UILabel *headerLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width/2, 20)];
//    headerLable.text = @"Automatic Reminder";
//    [header addSubview:headerLable];
//    UISwitch *mswitch = [UISwitch new];
//    mswitch.center = CGPointMake(screen_width*3/4, 10);
//    [header addSubview:mswitch];
//    [self.view addSubview:header];
//
    self.userDefaults = [NSUserDefaults standardUserDefaults];// 初始化
    self.dataSource = [NSMutableArray new];
    [self.dataSource addObjectsFromArray:@[@"Remind at expired day",@"Remind before one day",@"Remind before two days",@"Automatic Reminder"]];
    self.setDic = [[NSDictionary alloc]init];
    self.settingTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight*3, screen_width, screen_height/4) style:UITableViewStylePlain];
    self.settingTable.delegate = self;
    self.settingTable.dataSource = self;
    self.settingTable.bounces = NO;
    self.settingTable.layer.cornerRadius = 15;
    self.settingTable.showsVerticalScrollIndicator = NO;
    [self.settingTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.settingTable.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];;
    [self.view addSubview:self.settingTable];
    
    [self.settingTable reloadData];
   
    NSString *select = [self.userDefaults valueForKey:@"notificationSetting"];
    NSLog(@"当前选择：%@",[self.setDic valueForKey:select]);
    NSInteger selectIndex0 = 0;
    NSInteger selectIndex1 = 1;
    NSInteger selectIndex2 = 2;
    self.setDic = @{ @"Remind at expired day":[NSIndexPath indexPathForRow:selectIndex0 inSection:0],@"Remind before one day":[NSIndexPath indexPathForRow:selectIndex1 inSection:0],@"Remind before two days":[NSIndexPath indexPathForRow:selectIndex2 inSection:0]};
    [self.settingTable selectRowAtIndexPath:[self.setDic valueForKey:select] animated:NO scrollPosition:UITableViewScrollPositionNone];
    selectedCell = [self.settingTable cellForRowAtIndexPath:[self.setDic valueForKey:select]];
    [self.settingTable cellForRowAtIndexPath:[self.setDic valueForKey:select]].accessoryType = UITableViewCellAccessoryCheckmark;

    
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
    cell.textLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    cell.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];

    cell.textLabel.text = self.dataSource[row];
    
    if (row == 3) {
        self.mswitch = [UISwitch new];
        self.mswitch.frame = CGRectMake(0, 0, 100, 100);
        self.mswitch.center = CGPointMake(screen_width-30, cell.contentView.center.y);
        cell.backgroundView.userInteractionEnabled = NO;
        [cell.contentView addSubview:self.mswitch];
        [self.mswitch addTarget:self action:@selector(autoSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    //返回cell
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 3) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (![cell.textLabel.text isEqualToString:selectedCell.textLabel.text]) {
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        selectedSetting = cell.textLabel.text;
        selectedCell = cell;
    }
}
- (void)autoSwitch:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"系统自动发送通知");
        autoNotification = @"YES";
    }else {
           NSLog(@"系统不会自动发送通知");
        autoNotification = @"NO";
    }
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell * cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryNone;
//}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.userDefaults setObject:selectedSetting forKey:@"notificationSetting"];
    [self.userDefaults setObject:autoNotification forKey:@"autonotification"];
    [self.userDefaults synchronize];
    NSLog(@"===========================%@",selectedSetting);
}
@end
