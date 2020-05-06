//
//  resetAccountViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/3/24.
//  Copyright © 2020 hs. All rights reserved.
//

#import "resetAccountViewController.h"
#import "AFNetworking.h"

@interface resetAccountViewController ()
//缓冲图标
@property (nonatomic,strong) UIActivityIndicatorView *FOSAloadingView;
@end

@implementation resetAccountViewController

#pragma mark -- 延迟加载
- (UIImageView *)logoImageView{
    if (_logoImageView == nil) {
        _logoImageView = [UIImageView new];
    }
    return _logoImageView;
}
- (UITextField *)accountInput{
    if (_accountInput == nil) {
        _accountInput = [UITextField new];
    }
    return _accountInput;
}
//- (UITextField *)passwordInput{
//    if (_passwordInput == nil) {
//        _passwordInput = [UITextField new];
//    }
//    return _passwordInput;
//}
//- (UITextField *)passwordConfirm{
//    if (_passwordConfirm == nil) {
//        _passwordConfirm = [UITextField new];
//    }
//    return _passwordConfirm;
//}
//- (UITextField *)smsCodeInput{
//    if (_smsCodeInput == nil) {
//        _smsCodeInput = [UITextField new];
//    }
//    return _smsCodeInput;
//}
//- (UILabel *)verificationLabel{
//    if (_verificationLabel == nil) {
//        _verificationLabel = [UILabel new];
//    }
//    return _verificationLabel;
//}

- (UIButton *)doneBtn{
    if (_doneBtn == nil) {
        _doneBtn = [UIButton new];
    }
    return _doneBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatView];
}

- (void)creatView{
    //设置导航栏标题
    self.navigationItem.title = @"Reset password";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0],NSForegroundColorAttributeName, nil]];
    self.logoImageView.frame = CGRectMake(screen_width/4, screen_width*5/12, screen_width/2, screen_width/2);
    self.logoImageView.image = [UIImage imageNamed:@"icon_fosalogo"];
    [self.view addSubview:self.logoImageView];

    self.accountInput.frame = CGRectMake(screen_width/12, screen_width, screen_width*5/6, screen_height/15-10);
    self.accountInput.placeholder = @"    Username/Email";
    self.accountInput.layer.cornerRadius = self.accountInput.frame.size.height/3;
    [self.accountInput setValue:[NSNumber numberWithInt:20] forKey:@"paddingLeft"];
    self.accountInput.backgroundColor =  [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [self.view addSubview:self.accountInput];

//    self.passwordInput.frame = CGRectMake(screen_width/12, CGRectGetMaxY(self.accountInput.frame)+10, screen_width*5/6, screen_height/15-10);
//    self.passwordInput.placeholder = @"    New password";
//    self.passwordInput.layer.cornerRadius = self.passwordInput.frame.size.height/3;
//    [self.passwordInput setValue:[NSNumber numberWithInt:20] forKey:@"paddingLeft"];
//    self.passwordInput.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
//    [self.view addSubview:self.passwordInput];

//    self.passwordConfirm.frame = CGRectMake(screen_width/12, CGRectGetMaxY(self.passwordInput.frame)+10, screen_width*5/6, screen_height/15-10);
//    self.passwordConfirm.placeholder = @"    Confirm password";
//    self.passwordConfirm.layer.cornerRadius = self.passwordInput.frame.size.height/3;
//    [self.passwordConfirm setValue:[NSNumber numberWithInt:20] forKey:@"paddingLeft"];
//    self.passwordConfirm.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
//    [self.view addSubview:self.passwordConfirm];

//    self.smsCodeInput.frame = CGRectMake(screen_width/12, CGRectGetMaxY(self.passwordConfirm.frame)+10, screen_width*5/12, screen_height/15-10);
//    self.smsCodeInput.placeholder = @"    SMS Code";
//    self.smsCodeInput.layer.cornerRadius = self.passwordInput.frame.size.height/3;
//    [self.smsCodeInput setValue:[NSNumber numberWithInt:20] forKey:@"paddingLeft"];
//    self.smsCodeInput.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
//    [self.view addSubview:self.smsCodeInput];
//
//    self.verificationLabel.frame = CGRectMake(screen_width*7/12, CGRectGetMaxY(self.passwordConfirm.frame)+10, screen_width/3, screen_height/15-10);
//    self.verificationLabel.textAlignment = NSTextAlignmentRight;
//    self.verificationLabel.font = [UIFont systemFontOfSize:14*(screen_width/414)];
//       //文字添加下划线
//    NSDictionary * underAttribtDic  = @{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor blackColor]};
//    NSMutableAttributedString * underAttr = [[NSMutableAttributedString alloc] initWithString:@"    Get SMS code" attributes:underAttribtDic];

//    self.verificationLabel.attributedText = underAttr;
//    self.verificationLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
//    [self.view addSubview:self.verificationLabel];
    
    self.doneBtn.frame = CGRectMake(screen_width/3, CGRectGetMaxY(self.accountInput.frame)+20, screen_width/3, screen_height/20);
    self.doneBtn.backgroundColor = FOSAgreen;
    self.doneBtn.layer.cornerRadius = self.doneBtn.frame.size.height/2;
    [self.doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [self.doneBtn addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.doneBtn];
}
- (void)findPassword{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:nil preferredStyle:UIAlertControllerStyleAlert];
    if (self.accountInput.text.length == 0) {
        alert.message = @"The username or email can't be empty";
        [alert addAction:[UIAlertAction actionWithTitle:@"Get it" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        NSString *addr = [NSString stringWithFormat:@"https://fosa.care/uapi/?act=forgot&lang=en&uname=%@",self.accountInput.text];
        
        [self CreatLoadView];
        [manager GET:addr parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"success--%@--%@",[responseObject class],responseObject[@"ReturnCode"]);
            int returnCode = [responseObject[@"ReturnCode"] intValue];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:nil preferredStyle:UIAlertControllerStyleAlert];
            if (returnCode == 2) {
                alert.message = @"We have send a authentication email to you.Please receive and comfirm!";
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }else if(returnCode == 5){
                alert.message = @"The username or email is not found!";
                [alert addAction:[UIAlertAction actionWithTitle:@"Get it" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }else if(returnCode == 10){
                alert.message = @"Sending vetification email fail";
                [alert addAction:[UIAlertAction actionWithTitle:@"Get it" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            [self.FOSAloadingView stopAnimating];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Failed connection,please check the network!" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            [self.FOSAloadingView stopAnimating];
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

@end
