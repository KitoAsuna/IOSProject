//
//  notificationViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/4/17.
//  Copyright © 2020 hs. All rights reserved.
//

#import "notificationViewController.h"
#import "NotificationView.h"

@interface notificationViewController ()
@property (nonatomic,strong) NotificationView *notifyView;
@end

@implementation notificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = FOSAWhite;
    self.notifyView = [[NotificationView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.notifyView];
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
