//
//  qrCodeWebViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/3/17.
//  Copyright © 2020 hs. All rights reserved.
//

#import "qrCodeWebViewController.h"
#import <WebKit/WebKit.h>

@interface qrCodeWebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property(nonatomic,strong) WKWebView *qrWebView;
@end

@implementation qrCodeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatWebView];
}
- (void)creatWebView{
    //创建网络配置对象
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    self.qrWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NavigationBarH, screen_width, screen_height-NavigationBarH) configuration:config];
    self.qrWebView.UIDelegate = self;
    self.qrWebView.navigationDelegate = self;
    self.qrWebView.allowsBackForwardNavigationGestures = YES;
    
    WKPreferences *prefrences = [WKPreferences new];
    //最小字体大小
    prefrences.minimumFontSize = 0;
    //设置支持JavaScript,默认支持
    prefrences.javaScriptEnabled = YES;
    //在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    prefrences.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = prefrences;
    
    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
    config.allowsInlineMediaPlayback = YES;
    //config.allowsAirPlayForMediaPlayback = YES;
    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    config.mediaTypesRequiringUserActionForPlayback = YES;
    //设置是否允许画中画技术 在特定设备上有效
    config.allowsPictureInPictureMediaPlayback = YES;
    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
    config.applicationNameForUserAgent = @"ChinaDailyForiPad";
    
    [self.qrWebView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://fosahome.com/qrlabel"]]];//https://fosahome.com/qrlabel/////https://www.bilibili.com
    [self.view addSubview:self.qrWebView];
    
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
