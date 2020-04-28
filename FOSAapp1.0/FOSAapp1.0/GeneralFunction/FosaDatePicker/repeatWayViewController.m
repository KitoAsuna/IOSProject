//
//  repeatWayViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/4/13.
//  Copyright © 2020 hs. All rights reserved.
//

#import "repeatWayViewController.h"
#import "repeatPickerView.h"

@interface repeatWayViewController ()<UITableViewDelegate,UITableViewDataSource,repeatPickerViewDelegate>{
    NSInteger time,timeInterval;
}
@property (nonatomic,strong) repeatPickerView *picker;
@end

@implementation repeatWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
       self.navigationItem.title = @"Language";
       self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
       [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0],NSForegroundColorAttributeName, nil]];
       [self creatRepeatTable];
}
- (void)creatRepeatTable{
    self.dataSource = [NSMutableArray new];
    [self.dataSource addObjectsFromArray:@[@"Never",@"Daily",@"Weekly",@"Monthly",@"Custom reminder"]];
    self.repeatTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationBarH*3, screen_width, Height(44)*5) style:UITableViewStylePlain];
    
    self.repeatTable.delegate = self;
    self.repeatTable.dataSource = self;
    self.repeatTable.bounces = NO;
    self.repeatTable.layer.cornerRadius = 15;
    self.repeatTable.showsVerticalScrollIndicator = NO;
    [self.repeatTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.repeatTable.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:self.repeatTable];

    [self.repeatTable reloadData];
    NSInteger selectedIndex;
    if (self.currentRepeat != nil) {
        selectedIndex = [self.dataSource indexOfObject:self.currentRepeat];
    }else{
        selectedIndex = 0;
    }
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self.repeatTable selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.repeatTable cellForRowAtIndexPath:selectedIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.picker = [[repeatPickerView alloc]initWithFrame:CGRectMake(0, screen_height, screen_width, screen_height/5)];
    self.picker.backgroundColor = FOSAWhite;
    self.picker.repeatDelegate = self;
    [self.view addSubview:self.picker];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.repeatTable.frame.size.height/self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
     NSInteger row = indexPath.row;
    //取消点击cell时显示的背景色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:20*(([UIScreen mainScreen].bounds.size.width/414.0))];
    //cell.detailTextLabel.text = @"1111";
    cell.textLabel.text = self.dataSource[row];
    cell.textLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    cell.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    //返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.repeatTable cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"Custom reminder"]) {
        [UIView animateWithDuration:0.2 animations:^{
            self.picker.center = CGPointMake(screen_width/2, screen_height*9/10);
        }];
        self.repeatBlock(cell.textLabel.text);
    }else{
        self.repeatBlock(cell.textLabel.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

#pragma mark - repeatpickerView
- (void)repeatPickerViewSaveBtnClickDelegate:(NSInteger)times timeIntetval:(NSInteger)interval{
//    time = times;
//    timeInterval = interval;
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setInteger:times forKey:@"repeatTimes"];
    [userdefault setInteger:interval forKey:@"repeatTimeInterval"];
    [userdefault synchronize];
//    NSLog(@"重复次数: %@,重复间隔: %@",[userdefault valueForKey:@"repeatTimes"],[userdefault valueForKey:@"repeatTimeInterval"]);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)repeatPickerViewCancelBtnClickDelegate{
    [UIView animateWithDuration:0.2 animations:^{
        self.picker.center = CGPointMake(screen_width/2, screen_height*11/10);
    }];
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell * cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryNone;
//}
@end
