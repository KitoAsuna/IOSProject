//
//  qrSelectorViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/4/29.
//  Copyright © 2020 hs. All rights reserved.
//

#import "qrSelectorViewController.h"

@interface qrSelectorViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation qrSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = FOSAColor(241, 241, 241);
    NSLog(@"%@",self.selectData);
    [self creatSelector];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)creatSelector{
     [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil]];
    self.selectorTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame)+Height(20), screen_width, Height(50)*self.selectData.count) style:UITableViewStylePlain];
    self.selectorTable.delegate = self;
    self.selectorTable.dataSource = self;
    self.selectorTable.bounces = NO;
    [self.view addSubview:self.selectorTable];
    [self.selectorTable reloadData];
    
    //设置当前选中
    NSInteger selectedIndex;
    if (self.current != nil) {
        selectedIndex = [self.selectData indexOfObject:self.current];
    }else{
        selectedIndex = 0;
    }
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self.selectorTable selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.selectorTable cellForRowAtIndexPath:selectedIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)self.selectData.count);
    return self.selectData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Height(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"selectorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        //创建cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    NSInteger row = indexPath.row;
    //取消点击cell时显示的背景色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:20*(([UIScreen mainScreen].bounds.size.width/414.0))];
    //cell.detailTextLabel.text = @"1111";
    cell.textLabel.text = self.selectData[row];
    NSLog(@"----%@",self.selectData[row]);
    cell.textLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    cell.backgroundColor = FOSAWhite;//[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    //返回cell
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.seletBlock(self.selectData[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
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
