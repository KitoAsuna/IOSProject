//
//  qrCodeWebViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/3/17.
//  Copyright © 2020 hs. All rights reserved.
//

#import "qrCodeWebViewController.h"
#import <WebKit/WebKit.h>

@interface qrCodeWebViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSArray *qrData;
    int qrkind;
    
}
//@property(nonatomic,strong) WKWebView *qrWebView;
//@property (nonatomic,strong) UIProgressView *progressView;
@end

@implementation qrCodeWebViewController
#pragma mark - 延迟加载

- (UIScrollView *)preview{
    if (_preview == nil) {
        _preview = [UIScrollView new];
    }
    return _preview;
}

- (UIButton *)printBtn{
    if (_printBtn == nil) {
        _printBtn = [UIButton new];
    }
    return _printBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //[self creatWebView];
    [self InitData];
    [self creatQrGenerator];
}

- (void)InitData{
    qrData = @[@"Page size",@"Color",@"L1",@"L2",@"L3",@"L4"];
    qrkind = 0;
}
- (void)creatQrGenerator{
    //self.navigationController.navigationBar.translucent = NO;
    self.preview.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), screen_width, screen_height*2/7);
    self.preview.backgroundColor = FOSAgreen;
    [self.view addSubview:self.preview];
    
    self.qrTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.preview.frame)+Height(10), screen_width, Height(50)*qrData.count) style:UITableViewStylePlain];
    self.qrTable.delegate = self;
    self.qrTable.dataSource = self;
    self.qrTable.bounces = NO;
    self.qrTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.qrTable];
    
    self.printBtn.frame = CGRectMake(screen_width/3, CGRectGetMaxY(self.qrTable.frame)+Height(25), screen_width/3, Height(40));
    self.printBtn.layer.cornerRadius = Height(20);
    [self.printBtn setTitle:@"Download" forState:UIControlStateNormal];
    [self.printBtn setTitleColor:FOSABlue forState:UIControlStateNormal];
    [self.printBtn setTitleColor:FOSABlueHL forState:UIControlStateHighlighted];
    self.printBtn.backgroundColor = FOSAGray;
    
    [self.view addSubview:self.printBtn];
    
}

#pragma mark -UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Height(50);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return qrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"qrcell";
       //初始化cell，并指定其类型
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        //创建cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    NSInteger row = indexPath.row;
    //取消点击cell时显示的背景
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:20*(([UIScreen mainScreen].bounds.size.width/414.0))];
    cell.textLabel.text = qrData[row];
    cell.backgroundColor = FOSAWhite;
    switch (row) {
        case 0:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"3R(5x6)";
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"Black & White";
            break;
        case 2:
        case 3:
        case 4:
        case 5:
            if (cell.tag == 1) {
                if(qrkind>0){
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",24/qrkind];
                }
            }else{
                cell.detailTextLabel.text = @"0";
                cell.tag = 0;
            }
            break;
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger row = indexPath.row;
    //cell.backgroundColor = [UIColor grayColor];
    NSLog(@"%ld",row);
    switch (row) {
        case 0:
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            cell.detailTextLabel.text = @"3R(5x6)";
            break;
        case 1:
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            cell.detailTextLabel.text = @"Black & White";
            break;
        case 2:
        case 3:
        case 4:
        case 5:
                if (cell.tag == 0) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    cell.tag = 1;
                    qrkind ++;
                }else if(cell.tag == 1){
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.tag = 0;
                    qrkind --;
                }
                break;
        default:
            break;
    }
    [self.qrTable reloadData];
}
//
//- (void)creatWebView{
//    //创建网络配置对象
//    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
//    self.qrWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NavigationBarH, screen_width, screen_height-NavigationBarH) configuration:config];
//    self.qrWebView.UIDelegate = self;
//    self.qrWebView.navigationDelegate = self;
//    self.qrWebView.allowsBackForwardNavigationGestures = YES;
//
//    WKPreferences *prefrences = [WKPreferences new];
//    //最小字体大小
//    prefrences.minimumFontSize = 0;
//    //设置支持JavaScript,默认支持
//    prefrences.javaScriptEnabled = YES;
//    //在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
//    prefrences.javaScriptCanOpenWindowsAutomatically = YES;
//    config.preferences = prefrences;
//
//    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
//    config.allowsInlineMediaPlayback = YES;
//    //config.allowsAirPlayForMediaPlayback = YES;
//    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
//    config.mediaTypesRequiringUserActionForPlayback = YES;
//    //设置是否允许画中画技术 在特定设备上有效
//    config.allowsPictureInPictureMediaPlayback = YES;
//    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
//    config.applicationNameForUserAgent = @"ChinaDailyForiPad";
//
//    [self.qrWebView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];//https://fosahome.com/qrlabel/////https://www.bilibili.com
//    NSLog(@"%@",self.urlString);
//    [self.view addSubview:self.qrWebView];
//
//    //加载进度条
//    //进度条高度不可修改
//    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(50, screen_height/2, screen_width-100, 40)];
//    //设置进度条的颜色
//    self.progressView.progressTintColor = [UIColor blueColor];
//    //设置进度条的当前值，范围：0~1；
//    self.progressView.progress = 0;
//    self.progressView.progressViewStyle = UIProgressViewStyleDefault;
//    [self.view addSubview:self.progressView];
//    //添加观察者
//    [self.qrWebView addObserver:self forKeyPath:@"estimatedProgress" options:0 context:nil];
//}
//
//   //kvo 监听进度 必须实现此方法
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
//        && object == self.qrWebView) {
//       NSLog(@"网页加载进度 = %f",self.qrWebView.estimatedProgress);
//        self.progressView.progress = self.qrWebView.estimatedProgress;
//        if (self.qrWebView.estimatedProgress >= 1.0f) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.progressView.progress = 0;
//            });
//        }
//    }else if([keyPath isEqualToString:@"title"]
//             && object == self.qrWebView){
//        self.navigationItem.title = self.qrWebView.title;
//    }else{
//        [super observeValueForKeyPath:keyPath
//                             ofObject:object
//                               change:change
//                              context:context];
//    }
//}
//    // 页面开始加载时调用
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
//    NSLog(@"开始加载");
//}
//// 页面加载失败时调用
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"%@",error);
//    [self.navigationController popViewControllerAnimated:YES];
//}
// // 页面加载完成之后调用
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    NSLog(@"加载完成");
//    //[self.qrWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
//    [self.progressView removeFromSuperview];
//}
@end
