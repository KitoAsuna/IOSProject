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
    self.navigationItem.title = @"Settings";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil]];
}
- (void)creatTable{

    UILabel *reminderLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, NavigationBarH*2, screen_width/2, NavigationBarH-0.5)];
    reminderLabel.text = @"Reminder";
    reminderLabel.font = [UIFont systemFontOfSize:font(20)];
    //[self.view addSubview:reminderLabel];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(reminderLabel.frame), screen_width, 0.5)];
    line.backgroundColor = FOSAGray;
    //[self.view addSubview:line];
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];// 初始化
    self.dataSource = [NSMutableArray new];
    [self.dataSource addObjectsFromArray:@[@"Language",@"Do Not Disturb"]];
    self.setDic = [[NSDictionary alloc]init];
    self.settingTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight*3, screen_width, screen_height/8) style:UITableViewStylePlain];
    self.settingTable.delegate = self;
    self.settingTable.dataSource = self;
    self.settingTable.bounces = NO;
    //self.settingTable.layer.cornerRadius = 15;
    self.settingTable.showsVerticalScrollIndicator = NO;
    [self.settingTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.settingTable.backgroundColor = FOSAWhite;//[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:self.settingTable];
    
    [self.settingTable reloadData];
   
//    selectedSetting = [self.userDefaults valueForKey:@"notificationSetting"];
//
//    NSInteger selectIndex0 = 0;
//    NSInteger selectIndex1 = 1;
//    NSInteger selectIndex2 = 2;
//    self.setDic = @{ @"On expiry day":[NSIndexPath indexPathForRow:selectIndex0 inSection:0],@"One day before expiry":[NSIndexPath indexPathForRow:selectIndex1 inSection:0],@"Two days before expiry":[NSIndexPath indexPathForRow:selectIndex2 inSection:0]};
//    [self.settingTable selectRowAtIndexPath:[self.setDic valueForKey:selectedSetting] animated:NO scrollPosition:UITableViewScrollPositionNone];
//    selectedCell = [self.settingTable cellForRowAtIndexPath:[self.setDic valueForKey:selectedSetting]];
//    [self.settingTable cellForRowAtIndexPath:[self.setDic valueForKey:selectedSetting]].accessoryType = UITableViewCellAccessoryCheckmark;
//
//    UILabel *dailyReminderLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, NavigationBarH*2, NavigationBarH*2, NavigationBarH-0.5)];
//    dailyReminderLabel.text = @"Daily Reminder";
//    dailyReminderLabel.font = [UIFont systemFontOfSize:font(20)];
//    //[self.view addSubview:dailyReminderLabel];
//
//    UIView *dailyReminderView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(dailyReminderLabel.frame), screen_width, NavigationBarH)];
//    dailyReminderView.backgroundColor = [UIColor whiteColor];
//    UILabel *autoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, screen_width/3, NavigationBarH)];
//    autoLabel.text = @"Do Not Disturb";
//    autoLabel.font = [UIFont systemFontOfSize:20*(([UIScreen mainScreen].bounds.size.width/414.0))];
//    autoLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
//    [dailyReminderView addSubview:autoLabel];
//    autoNotification = [self.userDefaults valueForKey:@"autonotification"];
//    self.mswitch = [UISwitch new];
//    //self.mswitch.frame = CGRectMake(0, 0, 100, 100);
//    self.mswitch.center = CGPointMake(screen_width-30, NavigationBarH/2);
//    if ([autoNotification isEqualToString:@"YES"]) {
//        [self.mswitch setOn:YES];
//    }
//    [dailyReminderView addSubview:self.mswitch];
//    [self.mswitch addTarget:self action:@selector(autoSwitch:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:dailyReminderView];
    
    //退出登录按钮
//    self.logOutBtn = [[UIButton alloc]initWithFrame:CGRectMake(screen_width/5, screen_height-Height(150), screen_width*3/5, Height(50))];
//    self.logOutBtn.layer.cornerRadius = Height(25);
//    [self.logOutBtn setTitle:@"Log Out" forState:UIControlStateNormal];
//    [self.logOutBtn setTitleColor:FOSAGray forState:UIControlStateNormal];
//    [self.logOutBtn setTitleColor:FOSAgreen forState:UIControlStateHighlighted];
//    self.logOutBtn.backgroundColor = FOSAWhite;
//    [self.logOutBtn addTarget:self action:@selector(logOutFunction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.logOutBtn];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
     NSInteger row = indexPath.row;
    //取消点击cell时显示的背景色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:20*(([UIScreen mainScreen].bounds.size.width/414.0))];
    cell.textLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    cell.backgroundColor = FOSAWhite;//[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    cell.textLabel.text = self.dataSource[row];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (row) {
        case 0:
            cell.detailTextLabel.text = @"English";
            break;
        case 1:
            if (_mswitch == nil) {
                autoNotification = [self.userDefaults valueForKey:@"autonotification"];
                self.mswitch = [UISwitch new];
                self.mswitch.frame = CGRectMake(0, 0, 100, 100);
                self.mswitch.center = CGPointMake(screen_width-Width(40), cell.frame.size.height/2);
                if ([autoNotification isEqualToString:@"YES"]) {
                    [self.mswitch setOn:YES];
                }
                [cell.contentView addSubview:self.mswitch];
                [self.mswitch addTarget:self action:@selector(autoSwitch:) forControlEvents:UIControlEventValueChanged];
            }
            break;
            
        default:
            break;
    }
    //返回cell
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (indexPath.row == 2) {
//        [self logOutFunction];
//    }
}
- (void)autoSwitch:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"进入勿扰模式");
        autoNotification = @"YES";
    }else {
           NSLog(@"退出勿扰模式");
        autoNotification = @"NO";
    }
}
//
//-(void)logOutFunction{
//
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    if ([self.userDefaults valueForKey:@"currentUser"]) {
//        alert.message = @"You will exit the current account";
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
//            [userdefault removeObjectForKey:@"currentUser"];
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
//        [alert addAction:action1];
//        [alert addAction:action2];
//    }else{
//        alert.message = @"Please log in your account first";
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Get it" style:UIAlertActionStyleDefault handler:nil];
//        [alert addAction:action];
//    }
//
//    [self presentViewController:alert animated:true completion:nil];
//}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self.userDefaults setObject:selectedSetting forKey:@"notificationSetting"];
    [self.userDefaults setObject:autoNotification forKey:@"autonotification"];
    [self.userDefaults synchronize];
    NSLog(@"===========================%@",selectedSetting);
}
@end
