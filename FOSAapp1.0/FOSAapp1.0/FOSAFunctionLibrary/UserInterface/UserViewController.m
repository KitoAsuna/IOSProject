//
//  UserViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2019/12/30.
//  Copyright © 2019 hs. All rights reserved.
//

#import "UserViewController.h"
#import "AboutAppsViewController.h"
#import "toturialViewController.h"
#import "settingViewController.h"
#import "languageViewController.h"
#import "qrCodeWebViewController.h"

@interface UserViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *ItemLogoArray,*ItemArray;
}
@property(nonatomic,strong) NSUserDefaults *userDefaults;
@end

@implementation UserViewController

#pragma mark - 懒加载属性
- (UIView *)header{
    if (_header == nil) {
        //_header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height/4)];
        _header = [[UIView alloc]init];
    }
    return _header;
}
- (UIImageView *)headerBackgroundImgView{
    if (_headerBackgroundImgView == nil) {
        _headerBackgroundImgView = [[UIImageView alloc]init];
    }
    return _headerBackgroundImgView;
}
- (UIImageView *)userIcon{
    if (_userIcon == nil) {
        //_userIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.header.frame.size.height/4, self.header.frame.size.height/2, self.header.frame.size.height/2)];
        _userIcon = [[UIImageView alloc]init];
    }
    return _userIcon;
}
- (UILabel *)userName{
    if (_userName == nil) {
        //_userName = [[UILabel alloc]initWithFrame:CGRectMake(self.header.frame.size.height/2+30, self.header.frame.size.height/3, self.header.frame.size.width/3, self.header.frame.size.height/3)];
        _userName = [[UILabel alloc]init];
    }
    return _userName;
}
- (UITableView *)userItemTable{
    if (_userItemTable == nil) {
        _userItemTable = [[UITableView alloc]initWithFrame:CGRectMake(0, screen_height*15/48, screen_width, screen_height/3) style:UITableViewStylePlain];
        //_userItemTable = [[UITableView alloc]init];
    }
    return _userItemTable;
}
- (UIImageView *)qrCodeGenerateView{
    if (_qrCodeGenerateView == nil) {
        _qrCodeGenerateView = [UIImageView new];
    }
    return _qrCodeGenerateView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(200, 200, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(JUMP) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:btn];
    
    [self CreatHeader];
    [self CreatUserItemTable];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self SetCurrentUser];
    [self InitData];
}

- (void)InitData{
    ItemArray = @[@"Tutorial",@"Language/Location",@"Setting",@"About FOSA",@"About Apps"];
    ItemLogoArray = @[@"icon_tutorial",@"icon_language",@"icon_setting",@"icon_fosalogo",@"icon_app"];
}

- (void)CreatHeader{
    self.userDefaults = [NSUserDefaults standardUserDefaults];// 初始化
    int headerWidth = screen_width;
    int headerHeight = screen_height/3;
    
    self.header.frame = CGRectMake(0, 0, headerWidth, headerHeight);
    [self.view addSubview:self.header];
    self.header.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    self.headerBackgroundImgView.frame = self.header.frame;
    self.headerBackgroundImgView.image = [UIImage imageNamed:@"img_UserBackground"];
    self.headerBackgroundImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerBackgroundImgView.clipsToBounds = YES;
    [self.header addSubview:self.headerBackgroundImgView];
    
    self.userIcon.frame = CGRectMake(headerWidth/15, headerHeight/4, headerWidth/5, headerWidth/5);
    self.userIcon.image = [UIImage imageNamed:@"icon_User"];
    [self.header addSubview:self.userIcon];
    
    self.userName.frame = CGRectMake(0, headerHeight/2, headerWidth/3, headerWidth/4);
    self.userName.userInteractionEnabled = YES;
    //self.userName.layer.borderWidth = 0.5;
    self.userName.layer.cornerRadius = 5;
    self.userName.textAlignment = NSTextAlignmentCenter;
    self.userName.font = [UIFont systemFontOfSize:20*(screen_width/414.0)];
    self.userName.textColor = [UIColor whiteColor];
    UITapGestureRecognizer *login = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(JUMP)];
    [self.userName addGestureRecognizer:login];
    [self.header addSubview:self.userName];
}

- (void)CreatUserItemTable{
    [self.view addSubview:self.userItemTable];
    
    self.userItemTable.delegate = self;
    self.userItemTable.dataSource = self;
    self.userItemTable.bounces = NO;
    self.userItemTable.layer.cornerRadius = 15;
    self.userItemTable.showsVerticalScrollIndicator = NO;
    [self.userItemTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    self.qrCodeGenerateView.frame = CGRectMake(screen_width*5/66, CGRectGetMaxY(self.userItemTable.frame)+screen_height*3/143, screen_width*28/33, screen_width*14/33);
    self.qrCodeGenerateView.image = [UIImage imageNamed:@"img_qrcodegenerator"];
    
    //UIGestureRecognizer 不适用
    UITapGestureRecognizer *qrrecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToQrCodeGenerator:)];
    self.qrCodeGenerateView.userInteractionEnabled = YES;
    [self.qrCodeGenerateView addGestureRecognizer:qrrecognizer];
    [self.view addSubview:self.qrCodeGenerateView];
}

//取出用户名和密码
- (void)SetCurrentUser{
    NSLog(@"确认当前登录用户");
    NSString *currentUser= [self.userDefaults valueForKey:@"currentUser"];
    if (currentUser != NULL) {
        self.userName.text = currentUser;
    }else{
        self.userName.text = @"Login/Sign Up";
    }
}

#pragma mark - UItableViewDelegate

//行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.userItemTable.frame.size.height/(ItemArray.count);
}
//每组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",ItemArray.count);
    return ItemArray.count;
}
//组数
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
    //取消点击cell时显示的背景
    cell.textLabel.font = [UIFont systemFontOfSize:20*(([UIScreen mainScreen].bounds.size.width/414.0))];
    cell.imageView.image = [UIImage imageNamed:ItemLogoArray[row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = ItemArray[row];
    cell.textLabel.textColor = FOSAGray;
    //添加选中效果
    //返回cell
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    AboutAppsViewController *about = [AboutAppsViewController new];
    toturialViewController *tutorial = [toturialViewController new];
    languageViewController *language = [languageViewController new];
    settingViewController *setting = [settingViewController new];
    switch (index) {
        case 0:
            tutorial.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tutorial animated:YES];
            break;
        case 1:
            language.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:language animated:YES];
            break;
        case 2:
            setting.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setting animated:YES];
            break;
        case 4:
            about.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:about animated:YES];
            break;
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}
- (void)JUMP{
    LoginViewController *login = [[LoginViewController alloc]init];
    login.hidesBottomBarWhenPushed = YES;
    RegisterViewController *regist = [[RegisterViewController alloc]init];
    regist.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:login animated:YES];
}

- (void)jumpToQrCodeGenerator:(UIGestureRecognizer *)sender{
    NSLog(@"Click************");
    qrCodeWebViewController *qrCodeGenerator = [qrCodeWebViewController new];
    qrCodeGenerator.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qrCodeGenerator animated:YES];
}
/**隐藏底部横条，点击屏幕可显示*/
- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

@end
