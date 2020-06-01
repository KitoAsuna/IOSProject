//
//  AboutAppsViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/1/13.
//  Copyright © 2020 hs. All rights reserved.
//

#import "AboutAppsViewController.h"
#import "WebViewController.h"

@interface AboutAppsViewController ()

@end

@implementation AboutAppsViewController

#pragma mark - 懒加载
- (UIImageView *)logo{
    if (_logo == nil) {
        _logo = [[UIImageView alloc]init];
    }
    return _logo;
}

- (UILabel *)versionLable{
    if (_versionLable == nil) {
        _versionLable = [[UILabel alloc]init];
    }
    return _versionLable;
}

- (UILabel *)appTitleLable{
    if (_appTitleLable == nil) {
        _appTitleLable = [[UILabel alloc]init];
    }
    return _appTitleLable;
}

- (UILabel *)privacyLabel{
    if (_privacyLabel == nil) {
        _privacyLabel = [UILabel new];
    }
    return _privacyLabel;
}

- (UILabel *)copyrightLabel{
    if (_copyrightLabel == nil) {
        _copyrightLabel = [UILabel new];
    }
    return _copyrightLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self CreatView];
}

- (void)CreatView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.logo.frame = CGRectMake(screen_width*3/8, screen_height/8, screen_width/4, screen_width/4);
    //self.logo.center = CGPointMake(self.view.center.x, self.view.center.y-screen_width/4);
    self.logo.image = [UIImage imageNamed:@"icon_FOSAlogoHL"];
    [self.view addSubview:self.logo];
    
    self.appTitleLable.frame = CGRectMake(0, CGRectGetMaxY(self.logo.frame), screen_width, Height(30));
    self.appTitleLable.text = @"FOSA";
    self.appTitleLable.font = [UIFont systemFontOfSize:font(25)];
    self.appTitleLable.textColor = FOSAColor(153, 153, 153);
    self.appTitleLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.appTitleLable];

    self.versionLable.frame = CGRectMake(0, CGRectGetMaxY(self.appTitleLable.frame), screen_width, Height(30));
    self.versionLable.text  = [NSString stringWithFormat:@"Version %@",[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]];
    self.versionLable.font  = [UIFont systemFontOfSize:font(15)];
    self.versionLable.textColor = FOSAColor(153, 153, 153);
    self.versionLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.versionLable];
    
    //隐私政策
    self.privacyLabel.frame = CGRectMake(screen_width/3, screen_height*5/6, screen_width/3, Height(20));
    self.privacyLabel.text = @"Privacy Policy";
    self.privacyLabel.font = [UIFont systemFontOfSize:font(12)];
    self.privacyLabel.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer *privacyRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPrivacyWeb)];
    self.privacyLabel.userInteractionEnabled = YES;
    [self.privacyLabel addGestureRecognizer:privacyRecognizer];
    [self.view addSubview:self.privacyLabel];
    
    //版权
    self.copyrightLabel.frame = CGRectMake(0, CGRectGetMaxY(self.privacyLabel.frame), screen_width, Height(20));
    self.copyrightLabel.font = [UIFont systemFontOfSize:font(12)];
    self.copyrightLabel.textAlignment = NSTextAlignmentCenter;
    self.copyrightLabel.text = @"Copyright © 2020 hs. All rights reserved.";
    [self.view addSubview:self.copyrightLabel];
}

- (void)openPrivacyWeb{
    WebViewController *web = [WebViewController new];
    web.urlString = @"https://fosa.care/privacy/";
    [self.navigationController pushViewController:web animated:YES];
}

@end
