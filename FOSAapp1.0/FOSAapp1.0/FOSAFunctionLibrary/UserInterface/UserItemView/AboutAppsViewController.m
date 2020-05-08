//
//  AboutAppsViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/1/13.
//  Copyright © 2020 hs. All rights reserved.
//

#import "AboutAppsViewController.h"

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
- (UILabel *)versionTitleLable{
    if (_versionTitleLable == nil) {
        _versionTitleLable = [[UILabel alloc]init];
    }
    return _versionTitleLable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self CreatView];
}

- (void)CreatView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.logo.frame = CGRectMake(screen_width*3/8, screen_height/6, screen_width/3, screen_width/3);
    self.logo.center = CGPointMake(self.view.center.x, self.view.center.y-screen_width/4);
    self.logo.image = [UIImage imageNamed:@"icon_FOSAlogoHL"];
    [self.view addSubview:self.logo];

    self.versionLable.frame = CGRectMake(0, CGRectGetMaxY(self.logo.frame)+10, screen_width, 40);
    self.versionLable.text  = @"Current Version 1.0 ";
    self.versionLable.font  = [UIFont systemFontOfSize:font(20)];
    self.versionLable.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];

    self.versionLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.versionLable];
}

@end
