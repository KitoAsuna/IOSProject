//
//  resetAccountViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/3/24.
//  Copyright © 2020 hs. All rights reserved.
//

#import "resetAccountViewController.h"

@interface resetAccountViewController ()

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
- (UITextField *)passwordInput{
    if (_passwordInput == nil) {
        _passwordInput = [UITextField new];
    }
    return _passwordInput;
}
- (UITextField *)passwordConfirm{
    if (_passwordConfirm == nil) {
        _passwordConfirm = [UITextField new];
    }
    return _passwordConfirm;
}
- (UITextField *)smsCodeInput{
    if (_smsCodeInput == nil) {
        _smsCodeInput = [UITextField new];
    }
    return _smsCodeInput;
}
- (UILabel *)verificationLabel{
    if (_verificationLabel == nil) {
        _verificationLabel = [UILabel new];
    }
    return _verificationLabel;
}

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
    self.logoImageView.frame = CGRectMake(screen_width/4, screen_width*5/12, screen_width/2, screen_width/2);
    self.logoImageView.image = [UIImage imageNamed:@"icon_FOSAlogoHL"];
    [self.view addSubview:self.logoImageView];
    
    self.accountInput.frame = CGRectMake(screen_width/12, CGRectGetMaxY(self.logoImageView.frame)+10, screen_width*5/6, screen_height/15-10);
    self.accountInput.placeholder = @"    Input Account";
    self.accountInput.layer.cornerRadius = self.accountInput.frame.size.height/3;
    [self.accountInput setValue:[NSNumber numberWithInt:20] forKey:@"paddingLeft"];
    self.accountInput.backgroundColor =  [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [self.view addSubview:self.accountInput];
    
    self.passwordInput.frame = CGRectMake(screen_width/12, CGRectGetMaxY(self.accountInput.frame)+10, screen_width*5/6, screen_height/15-10);
    self.passwordInput.placeholder = @"    New password";
    self.passwordInput.layer.cornerRadius = self.passwordInput.frame.size.height/3;
    [self.passwordInput setValue:[NSNumber numberWithInt:20] forKey:@"paddingLeft"];
    self.passwordInput.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [self.view addSubview:self.passwordInput];
    
    self.passwordConfirm.frame = CGRectMake(screen_width/12, CGRectGetMaxY(self.passwordInput.frame)+10, screen_width*5/6, screen_height/15-10);
    self.passwordConfirm.placeholder = @"    Confirm password";
    self.passwordConfirm.layer.cornerRadius = self.passwordInput.frame.size.height/3;
    [self.passwordConfirm setValue:[NSNumber numberWithInt:20] forKey:@"paddingLeft"];
    self.passwordConfirm.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [self.view addSubview:self.passwordConfirm];
    
    self.smsCodeInput.frame = CGRectMake(screen_width/12, CGRectGetMaxY(self.passwordConfirm.frame)+10, screen_width*5/12, screen_height/15-10);
    self.smsCodeInput.placeholder = @"    SMS Code";
    self.smsCodeInput.layer.cornerRadius = self.passwordInput.frame.size.height/3;
    [self.smsCodeInput setValue:[NSNumber numberWithInt:20] forKey:@"paddingLeft"];
    self.smsCodeInput.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [self.view addSubview:self.smsCodeInput];
    
    self.verificationLabel.frame = CGRectMake(screen_width*7/12, CGRectGetMaxY(self.passwordConfirm.frame)+10, screen_width/3, screen_height/15-10);
    self.verificationLabel.textAlignment = NSTextAlignmentRight;
    self.verificationLabel.font = [UIFont systemFontOfSize:14*(screen_width/414)];
       //文字添加下划线
    NSDictionary * underAttribtDic  = @{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor blackColor]};
    NSMutableAttributedString * underAttr = [[NSMutableAttributedString alloc] initWithString:@"    Get SMS code" attributes:underAttribtDic];

    self.verificationLabel.attributedText = underAttr;
    self.verificationLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [self.view addSubview:self.verificationLabel];
    
    self.doneBtn.frame = CGRectMake(screen_width/3, CGRectGetMaxY(self.smsCodeInput.frame)+20, screen_width/3, screen_height/20);
    self.doneBtn.backgroundColor = FOSAgreen;
    self.doneBtn.layer.cornerRadius = self.doneBtn.frame.size.height/2;
    [self.doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [self.view addSubview:self.doneBtn];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
