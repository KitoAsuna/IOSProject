//
//  WebViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/6/1.
//  Copyright © 2020 hs. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property(nonatomic,strong) WKWebView *qrWebView;
@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = FOSAWhite;
    [self creatWebView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)creatWebView{
    //创建网络配置对象
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    self.qrWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height-NavigationBarH*3/2) configuration:config];

    self.qrWebView.UIDelegate = self;
    self.qrWebView.navigationDelegate = self;
    self.qrWebView.allowsBackForwardNavigationGestures = YES;
    self.qrWebView.scrollView.bounces = YES;

    WKPreferences *prefrences = [WKPreferences new];
    //最小字体大小
    prefrences.minimumFontSize = 0;
    //设置支持JavaScript,默认支持
    prefrences.javaScriptEnabled = YES;
    //在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    prefrences.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = prefrences;

    [self.qrWebView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];//https://fosahome.com/qrlabel/////https://www.bilibili.com
    NSLog(@"%@",self.urlString);
    [self.view addSubview:self.qrWebView];

    //加载进度条
    //进度条高度不可修改
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(50, screen_height/2, screen_width-100, 40)];
    //设置进度条的颜色
    self.progressView.progressTintColor = [UIColor blueColor];
    //设置进度条的当前值，范围：0~1；
    self.progressView.progress = 0;
    self.progressView.progressViewStyle = UIProgressViewStyleDefault;
    [self.view addSubview:self.progressView];
    //添加观察者
    [self.qrWebView addObserver:self forKeyPath:@"estimatedProgress" options:0 context:nil];
}
   //kvo 监听进度 必须实现此方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == self.qrWebView) {
       NSLog(@"网页加载进度 = %f",self.qrWebView.estimatedProgress);
        self.progressView.progress = self.qrWebView.estimatedProgress;
        if (self.qrWebView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
    }else if([keyPath isEqualToString:@"title"]
             && object == self.qrWebView){
        self.navigationItem.title = self.qrWebView.title;
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}
    // 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载");
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@",error);
    [self.navigationController popViewControllerAnimated:YES];
}
 // 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    [self.progressView removeFromSuperview];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}
@end
