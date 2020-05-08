//
//  LoginViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/1/3.
//  Copyright © 2020 hs. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "FMDB.h"
#import "resetAccountViewController.h"
#import "AFNetworking.h"

@interface LoginViewController ()<UITextFieldDelegate>{
    FMDatabase *db;
    NSString *docPath;
    Boolean isSecure;
}
@property(nonatomic,strong) NSUserDefaults *userDefaults;
// 当前获取焦点的UITextField
@property (strong, nonatomic) UITextField *currentResponderTextField;
//缓冲图标
@property (nonatomic,strong) UIActivityIndicatorView *FOSAloadingView;
@end

@implementation LoginViewController

- (UIView *)logoContainer{
    if (_logoContainer == nil) {
        _logoContainer = [[UIView alloc]initWithFrame:CGRectMake(0, screen_width*5/12, screen_width, screen_width/2)];
    }
    return _logoContainer;
}
- (UIView *)userContainer{
    if (_userContainer == nil) {
        _userContainer = [[UIView alloc]initWithFrame:CGRectMake(screen_width/12, screen_width, screen_width*5/6, screen_height/15)];
    }
    return _userContainer;
}
- (UIView *)passwordContainer{
    if (_passwordContainer == nil) {
        _passwordContainer = [[UIView alloc]initWithFrame:CGRectMake(screen_width/12, screen_height/15+screen_width, screen_width*5/6, screen_height/15)];
    }
    return _passwordContainer;
}

- (UIView *)rememberContainer{
    if (_rememberContainer == nil) {
        _rememberContainer = [[UIView alloc]initWithFrame:CGRectMake(screen_width/12, CGRectGetMaxY(self.passwordContainer.frame)+Height(10), screen_width*5/6, screen_height/20)];
    }
    return _rememberContainer;
}

- (UIView *)LoginContainer{
    if (_LoginContainer == nil) {
        _LoginContainer = [[UIView alloc]initWithFrame:CGRectMake(screen_width/12, CGRectGetMaxY(self.rememberContainer.frame)+Height(10), screen_width*5/6, screen_height/20)];
    }
    return _LoginContainer;
}
- (UIImageView *)FOSALogo{
    if (_FOSALogo == nil) {
        _FOSALogo = [[UIImageView alloc]init];
    }
    return _FOSALogo;
}
- (UITextField *)userNameInput{
    if (_userNameInput == nil) {
        _userNameInput = [[UITextField alloc]init];
    }
    return _userNameInput;
}
- (UITextField *)passwordInput{
    if (_passwordInput == nil) {
        _passwordInput = [[UITextField alloc]init];
    }
    return _passwordInput;
}
- (UIButton *)checkPassword{
    if (_checkPassword == nil) {
        _checkPassword = [[UIButton alloc]init];
    }
    return _checkPassword;
}
- (UISwitch *)remember{
    if (_remember == nil) {
        _remember = [[UISwitch alloc]init];
    }
    return _remember;
}
- (UILabel *)forgetPassword{
    if (_forgetPassword == nil) {
        _forgetPassword = [[UILabel alloc]init];
    }
    return _forgetPassword;
}
- (UILabel *)rememberLabel{
    if (_rememberLabel == nil) {
        _rememberLabel = [[UILabel alloc]init];
    }
    return _rememberLabel;
}
- (UIButton *)login{
    if (_login == nil) {
        _login = [[UIButton alloc]init];
    }
    return _login;
}
- (UIButton *)signUp{
    if (_signUp == nil) {
        _signUp = [[UIButton alloc]init];
    }
    return _signUp;
}
- (UILabel *)guestMode{
    if (_guestMode == nil) {
        _guestMode = [UILabel new];
    }
    return _guestMode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 在ViewController加载到时候注册通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(keyboardWillShow:)     // 软键盘出现的时候，回调到方法
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(keyboardWillHide:)     // 软键盘消失的时候，回调到方法
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [self CreatLoginView];
    [self SetUserNameAndPassword];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)CreatLoginView{
    self.userDefaults = [NSUserDefaults standardUserDefaults];// 初始化
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.logoContainer];
    [self.view addSubview:self.userContainer];
    [self.view addSubview:self.passwordContainer];
    [self.view addSubview:self.rememberContainer];
    [self.view addSubview:self.LoginContainer];

    CGFloat logoW = self.logoContainer.frame.size.width;
    CGFloat logoH = self.logoContainer.frame.size.height;
    CGFloat logoX = (logoW - logoH)/2;
    self.FOSALogo.frame = CGRectMake(logoX, 0, logoH, logoH);
    self.FOSALogo.image = [UIImage imageNamed:@"icon_fosalogo"];
    [self.logoContainer addSubview:self.FOSALogo];
    
    self.userNameInput.frame = CGRectMake(0, 5, screen_width*5/6, screen_height/15-10);
    self.userNameInput.placeholder = @"    Username/Email";
    self.userNameInput.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    self.userNameInput.returnKeyType = UIReturnKeyDone;
    self.userNameInput.delegate = self;
    self.userNameInput.layer.cornerRadius = self.userNameInput.frame.size.height/3;
    [self.userNameInput setValue:[NSNumber numberWithInt:20] forKey:@"paddingLeft"];//设置输入文本的起始位置
    [self.userContainer addSubview:self.userNameInput];
    
    self.passwordInput.frame = CGRectMake(0, 5, screen_width*5/6, screen_height/15-10);
    self.passwordInput.placeholder = @"    Password";
    self.passwordInput.secureTextEntry = YES ; //隐藏密码
    self.passwordInput.returnKeyType = UIReturnKeyDone;
    self.passwordInput.delegate = self;
    self.passwordInput.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    self.passwordInput.layer.cornerRadius = self.passwordInput.frame.size.height/3;
    [self.passwordInput setValue:[NSNumber numberWithInt:20] forKey:@"paddingLeft"];//设置输入文本的起始位置
    [self.passwordContainer addSubview:self.passwordInput];

//    self.checkPassword.frame = CGRectMake(screen_width*5/6-screen_height/12, screen_height/48, screen_height/12-10, screen_height/24);
//    [self.checkPassword setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
//    [self.passwordContainer addSubview:self.checkPassword];
//    isSecure = true;
//    [self.checkPassword addTarget:self action:@selector(pwdtextSwitch) forControlEvents:UIControlEventTouchUpInside];

    self.remember.frame = CGRectMake(0, 0, 51, 30);
    self.remember.onTintColor = [UIColor colorWithRed:90/255.0 green:172/255.0 blue:51/255.0 alpha:1];
    //self.remember.thumbTintColor = FOSAAlertBlue;
    [self.remember addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.rememberContainer addSubview:self.remember];
    self.rememberLabel.frame = CGRectMake(60, 0, self.rememberContainer.frame.size.width/2, 40);
    self.rememberLabel.text = @"Remember Account";
    self.rememberLabel.font = [UIFont systemFontOfSize:13*(screen_width/414.0)];
    self.rememberLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [self.rememberContainer addSubview:self.rememberLabel];
    
    self.forgetPassword.frame = CGRectMake(self.rememberContainer.frame.size.width*2/3, 0, self.rememberContainer.frame.size.width/3, 40);
    self.forgetPassword.userInteractionEnabled = YES;
    self.forgetPassword.font = [UIFont systemFontOfSize:13*(screen_width/414.0)];
    //文字添加下划线
    NSDictionary * underAttribtDic  = @{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor blackColor]};
    NSMutableAttributedString * underAttr = [[NSMutableAttributedString alloc] initWithString:@"Forget password" attributes:underAttribtDic];
    self.forgetPassword.attributedText = underAttr;
    self.forgetPassword.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    UITapGestureRecognizer *forgetrecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(JumpToReset)];
    self.forgetPassword.userInteractionEnabled = YES;
    [self.forgetPassword addGestureRecognizer:forgetrecognizer];
    [self.rememberContainer addSubview:self.forgetPassword];
    
    self.login.frame = CGRectMake(0, 0, self.LoginContainer.frame.size.width*4/9, self.LoginContainer.frame.size.height);
    [self.login setTitle:@"Log In" forState:UIControlStateNormal];
    self.login.backgroundColor = FOSAgreen;

    self.login.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.login.titleLabel.font = [UIFont systemFontOfSize:25];
    self.login.layer.cornerRadius = self.login.frame.size.height/2;
    [self.login addTarget:self action:@selector(vertifyUser) forControlEvents:UIControlEventTouchUpInside];
    [self.login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.signUp.frame = CGRectMake(self.LoginContainer.frame.size.width*5/9, 0, self.LoginContainer.bounds.size.width*4/9, self.LoginContainer.frame.size.height);
    [self.signUp setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.signUp setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.signUp.layer.borderColor = FOSAgreen.CGColor;  //设置边界颜色
    self.signUp.layer.borderWidth = 1;
    self.signUp.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.signUp.titleLabel.font = [UIFont systemFontOfSize:25];
    self.signUp.layer.cornerRadius = self.login.frame.size.height/2;
    
    //跳转到注册界面
    [self.signUp addTarget:self action:@selector(JumpToRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.LoginContainer addSubview:self.login];
    [self.LoginContainer addSubview:self.signUp];
    
    self.guestMode.frame = CGRectMake(screen_width*5/18, CGRectGetMaxY(self.LoginContainer.frame), screen_width*4/9, self.LoginContainer.frame.size.height);
    self.guestMode.text = @"Guest Mode";
    self.guestMode.textColor = FOSAgreen;
    self.guestMode.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer *guestRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startGuestMode)];
    self.guestMode.userInteractionEnabled = YES;
    [self.guestMode addGestureRecognizer:guestRecognizer];
    [self.view addSubview:self.guestMode];
}

//进入游客模式
- (void)startGuestMode{
    NSString *guestID = [NSString stringWithFormat:@"Guest"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:guestID forKey:@"currentUser"];
    [defaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

//记住用户名和密码
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
    NSLog(@"YES");
    NSString *username = self.userNameInput.text;
    NSString *password = self.passwordInput.text;
    NSLog(@"%@======%@",username,password);
    [self.userDefaults setObject:username forKey:@"username"];
    [self.userDefaults setObject:password forKey:@"password"];
    [self.userDefaults setBool:isButtonOn forKey:@"isOn"];
    [self.userDefaults synchronize];
}else {
    NSLog(@"NO");
    }
}
//取出用户名和密码
- (void)SetUserNameAndPassword{
    NSLog(@"取出用户名密码");
    NSString *username = [self.userDefaults valueForKey:@"username"];
    NSString *password = [self.userDefaults valueForKey:@"password"];
    NSLog(@"%@======%@",username,password);
    Boolean isOn = [self.userDefaults boolForKey:@"isOn"];
    if (username != NULL && password != NULL) {
        self.userNameInput.text = username;
        self.passwordInput.text = password;
        [self.remember setOn:isOn];
    }
}
////密码的状态转换
//-(void)pwdtextSwitch{
//    if (isSecure) {
//        NSString *pwd = self.passwordInput.text;
//        isSecure = false;
//        self.passwordInput.secureTextEntry = NO;
//        [self.checkPassword setImage:[UIImage imageNamed:@"icon_checkHL"] forState:UIControlStateNormal];
//        self.passwordInput.text = pwd;
//    }else{
//        NSString *pwd = self.passwordInput.text;
//        isSecure = true;
//        self.passwordInput.secureTextEntry = YES;
//        [self.checkPassword setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
//        self.passwordInput.text = pwd;
//    }
//}
//跳转到注册界面
- (void)JumpToRegister{
    RegisterViewController *regist = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:regist animated:YES];
}
//跳转到重置密码界面
- (void)JumpToReset{
    resetAccountViewController *reset = [resetAccountViewController new];
    [self.navigationController pushViewController:reset animated:YES];
}
//验证用户信息
- (void)vertifyUser{
    //[self CreatSqlDatabase:@"FOSA"];
    //https://fosa.care/crmapi/?lang=cn&uname=demodemo&upw=123456
    if ([self.userNameInput.text isEqualToString:@""] || [self.passwordInput.text isEqualToString:@""]) {
        [self SystemAlert:@"please input your ID or password"];
    }else{
        [self CreatLoadView];
        ///1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //注册账号
        NSString *categoryAddr = [NSString stringWithFormat:@"https://fosa.care/uapi/?lang=en&uname=%@&upw=%@",self.userNameInput.text,self.passwordInput.text];
         [manager GET:categoryAddr parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog(@"success--%@--%@",[responseObject class],responseObject);
             int returnCode = [responseObject[@"ReturnCode"] intValue];
             if (returnCode == 1) {
                 [self.FOSAloadingView stopAnimating];
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:responseObject[@"id"] forKey:@"currentUser"];
                 [defaults setObject:responseObject[@"email"] forKey:@"currentUserEmail"];
                 [defaults synchronize];
                 [self SystemAlert:@"login Successfully"];
             }else if (returnCode == 6){
                 [self.FOSAloadingView stopAnimating];
                 [self SystemAlert:@"Name and password do not match"];
             }else if (returnCode == 7){
                 [self.FOSAloadingView stopAnimating];
                 [self SystemAlert:@"The length of the name or password is less than 6"];
             }else if (returnCode == 11){
                 [self.FOSAloadingView stopAnimating];
                 [self SystemAlert:@"This account has not verified the email!"];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"failure--%@",error);
         }];
    }
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
    self.FOSAloadingView.center = self.view.center;
    //设置小菊花颜色
    self.FOSAloadingView.color = FOSAgreen;
    //设置背景颜色
    self.FOSAloadingView.backgroundColor = [UIColor clearColor];
//刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    self.FOSAloadingView.hidesWhenStopped = YES;
    [self.FOSAloadingView startAnimating];
}

#pragma mark - UItextFiled
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.currentResponderTextField = textField;
    return YES;
}
//#pragma mark - 数据库操作
//- (void)CreatSqlDatabase:(NSString *)dataBaseName{
//    //获取数据库地址
//    docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
//    NSLog(@"%@",docPath);
//    //设置数据库名
//    NSString *fileName = [docPath stringByAppendingPathComponent:dataBaseName];
//    //创建数据库
//    db = [FMDatabase databaseWithPath:fileName];
//    if([db open]){
//        NSLog(@"打开数据库成功");
//        [self CreatUserTable];
//    }else{
//        NSLog(@"打开数据库失败");
//    }
//    [db close];
//}
//
//- (void)CreatUserTable{
//    NSString *UserTableSql = @"create table if not exists Fosa_User(id integer primary key,userName text,password text)";
//    BOOL result = [db executeUpdate:UserTableSql];
//    if (result) {
//        NSLog(@"打开用户表成功!");
//        [self SelectUserInfoByName:self.userNameInput.text];
//    }else{
//        NSLog(@"打开用户表失败");
//    }
//}
//- (void)SelectUserInfoByName:(NSString *)username{
//    NSString *selSql = [NSString stringWithFormat:@"select * from Fosa_User where userName = '%@'",username];
//    NSLog(@"%@",selSql);
//        FMResultSet *set = [db executeQuery:selSql];
//        if (![set next]) {
//            //[self SystemAlert:@"the user does not exist.Please sign up"];
//            self.failTips.frame = CGRectMake(0, CGRectGetMaxY(self.login.frame), screen_width/2, 40);
//            self.failTips.text = @"Authentication Failed";
//            self.failTips.textColor = [UIColor redColor];
//            [self.LoginContainer addSubview:self.failTips];
//        }else{
//            NSString *sql_userName = [set stringForColumn:@"userName"];
//            NSString *sql_password = [set stringForColumn:@"password"];
//            if ([self.remember isOn]) {
//                NSString *username = self.userNameInput.text;
//                NSString *password = self.passwordInput.text;
//                 NSLog(@"%@======%@",username,password);
//                [self.userDefaults setObject:username forKey:@"username"];
//                [self.userDefaults setObject:password forKey:@"password"];
//                [self.userDefaults setBool:true forKey:@"isOn"];
//                [self.userDefaults synchronize];
//            }
//            NSLog(@"%@-------%@",sql_userName,sql_password);
//                if ([sql_userName isEqualToString:self.userNameInput.text]&&[sql_password isEqualToString:self.passwordInput.text]) {
//                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                    [defaults setObject:self.userNameInput.text forKey:@"currentUser"];
//                    [defaults synchronize];
//                    [self.navigationController popViewControllerAnimated:YES];
//                }else{
//                    [self SystemAlert:@"Incorrect user name or password"];
//                }
//    }
//}

//弹出系统提示
-(void)SystemAlert:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:message preferredStyle:UIAlertControllerStyleAlert];
        if ([message isEqualToString:@"login Successfully"]) {
            if ([self.remember isOn]) {
                NSString *username = self.userNameInput.text;
                NSString *password = self.passwordInput.text;
                 NSLog(@"%@======%@",username,password);
                [self.userDefaults setObject:username forKey:@"username"];
                [self.userDefaults setObject:password forKey:@"password"];
                [self.userDefaults setBool:true forKey:@"isOn"];
                [self.userDefaults synchronize];
            }
            [self presentViewController:alert animated:true completion:nil];
            [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:1];
        }else{
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:true completion:nil];
        }
}
- (void)dismissAlertView:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userNameInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (!(self.currentResponderTextField && [self.currentResponderTextField isKindOfClass:[UITextField class]])) {
        // 如果没有响应者不进行操作
        return;
    }
    //获取currentResponderTextField相对于self.view的frame信息
    CGRect rect = [self.currentResponderTextField.superview convertRect:self.currentResponderTextField.frame toView:self.view];
    //获取弹出键盘的frame的value值
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    //获取键盘相对于self.view的frame信息 ，传window和传nil是一样的
    keyboardRect = [self.view convertRect:keyboardRect fromView:self.view.window];
    //弹出软键盘左上角点Y轴的值
    CGFloat keyboardTop = keyboardRect.origin.y;
    //获取键盘弹出动画时间值
    NSNumber * animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = [animationDurationValue doubleValue];
    if (keyboardTop < CGRectGetMaxY(rect)) {
        // true 键盘盖住了输入框
        // 计算整体界面需要往上移动的偏移量，CGRectGetMaxY(rect)表示，输入框Y轴最大值
        CGFloat gap = keyboardTop - CGRectGetMaxY(rect);
        // 存在多个TextField的情况下，可能整体界面可能以及往上移多次，导致self.view的Y轴值不再为0，而是负数
        gap = gap + self.view.frame.origin.y;
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:animationDuration animations:^{
            weakSelf.view.frame = CGRectMake(weakSelf.view.frame.origin.x, gap, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
        }];
    }
}
- (void)keyboardWillHide:(NSNotification *)notification {
    if (!(self.currentResponderTextField && [self.currentResponderTextField isKindOfClass:[UITextField class]])) {
        // 如果没有响应者不进行操作
        return;
    }
    //获取键盘隐藏动画时间值
    NSDictionary *userInfo = [notification userInfo];
    NSNumber * animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = [animationDurationValue doubleValue];
    if (self.view.frame.origin.y < 0) {
        //true 证明已经往上移动，软键盘消失时，整个界面要恢复原样
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:animationDuration animations:^{
            weakSelf.view.frame = CGRectMake(weakSelf.view.frame.origin.x, 0, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
        }];
    }
}
- (void)dealloc
{
    // 注册了通知，在ViewController消失到时候，要移除通知的监听
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
@end
