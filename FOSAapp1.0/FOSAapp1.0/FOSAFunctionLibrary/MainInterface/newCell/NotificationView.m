//
//  NotificationView.m
//  FOSAapp1.0
//
//  Created by hs on 2020/4/9.
//  Copyright © 2020 hs. All rights reserved.
//

#import "NotificationView.h"
#import "notificationListTableViewCell.h"
#import "FosaFMDBManager.h"
#import "notificationListTableViewCell.h"
#import "FosaNotification.h"

@interface NotificationView()<UITableViewDelegate,UITableViewDataSource>{
    Boolean isSelect;
    NSMutableArray<NSString *> *selectArray;
    NSMutableArray<FoodModel *> *remindArray;
    NSMutableArray<FoodModel *> *cancelArray;
}

@property (nonatomic,strong) FosaFMDBManager *fmdbManager;
@property (nonatomic,strong) NSMutableArray<FoodModel *> *dataSource;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) FosaNotification *fosaNotification;
@end
@implementation NotificationView
//#pragma mark - 延时加载
//- (UIButton *)bellBtn{
//    if (_bellBtn == nil) {
//        _bellBtn = [UIButton new];
//    }
//    return _bellBtn;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = FOSAWhite;
        isSelect = false;
        self.bellBtn = [UIButton new];
        [self addSubview:self.bellBtn];
        self.titleLabel = [UILabel new];
        [self addSubview:self.titleLabel];
        
        self.selectbtn = [UIButton new];
        [self.selectbtn addTarget:self action:@selector(selectCell) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectbtn];
        
        self.notificationList = [[UITableView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height/8, self.bounds.size.width, self.bounds.size.height*3/4) style:UITableViewStylePlain];
        self.notificationList.delegate = self;
        self.notificationList.dataSource = self;
        self.notificationList.showsVerticalScrollIndicator = NO;
        self.notificationList.showsHorizontalScrollIndicator = NO;
        
        self.notificationList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:self.notificationList];
        
        self.backBtn = [UIButton new];
        [self.backBtn addTarget:self action:@selector(closeNotificationView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backBtn];
        
        self.deleBtn = [UIButton new];
        [self addSubview:self.deleBtn];
        self.deleBtn.hidden = YES;
        [self.deleBtn addTarget:self action:@selector(deleteReminder) forControlEvents:UIControlEventTouchUpInside];
        
        //初始化数组
        selectArray = [NSMutableArray new];
        remindArray = [NSMutableArray new];
        cancelArray = [NSMutableArray new];
        self.fosaNotification = [FosaNotification new];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat height = self.bounds.size.height;
    CGFloat width  = self.bounds.size.width;
    self.bellBtn.frame = CGRectMake(0, 0, width/12, width/12);
    self.bellBtn.center = CGPointMake(width/2, height/24);
    [self.bellBtn setBackgroundImage:[UIImage imageNamed:@"icon_bell"] forState:UIControlStateNormal];
    self.bellBtn.userInteractionEnabled = NO;
    self.titleLabel.frame = CGRectMake(width*2/5, CGRectGetMaxY(self.bellBtn.frame), width/5, height/24);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"Reminder";
    self.titleLabel.textColor = FOSAGray;
    self.titleLabel.font = [UIFont systemFontOfSize:font(15)];
 
    self.selectbtn.frame = CGRectMake(width*4/5, height/24, width/6, height/24);
    self.selectbtn.tag = 0;
    [self.selectbtn setTitleColor:FOSAGray forState:UIControlStateNormal];
    [self.selectbtn setTitleColor:FOSAgreen forState:UIControlStateHighlighted];
    [self.selectbtn setTitle:@"Select" forState:UIControlStateNormal];

    self.notificationList.frame = CGRectMake(0, height/8, width, height*3/4);
    self.notificationList.backgroundColor = FOSAWhite;
    
    self.backBtn.frame = CGRectMake(width/3, height*11/12, width/3, height/19);
    self.backBtn.layer.cornerRadius = height/38;
    self.backBtn.backgroundColor = FOSAColor(152, 153, 154);
    [self.backBtn setTitle:@"Back" forState:UIControlStateNormal];
    self.deleBtn.frame = CGRectMake(width/3, height*11/12, width/3, height/19);
    self.deleBtn.layer.cornerRadius = height/38;
    self.deleBtn.backgroundColor = FOSARed;
    [self.deleBtn setImage:[UIImage imageNamed:@"icon_dele"] forState:UIControlStateNormal];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.notificationList.frame.size.height/6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    notificationListTableViewCell *cell = [self.notificationList dequeueReusableCellWithIdentifier:@"categoryCell"];
    if (cell == nil) {
            //创建cell
        cell = [[notificationListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoryCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.foodImgView.image = [self getImage:self.dataSource[indexPath.row].foodPhoto];
    cell.foodNameLabel.text = self.dataSource[indexPath.row].foodName;
    NSArray *ary = [self.dataSource[indexPath.row].remindDate componentsSeparatedByString:@","];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@, %@",ary[3],self.dataSource[indexPath.row].repeat];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@,%@ %@",ary[0],ary[1],ary[2]];
    cell.sendSwitch.tag = indexPath.row;
    [cell.sendSwitch addTarget:self action:@selector(openSendNotification:) forControlEvents:UIControlEventValueChanged];
    cell.selectImgView.image = [UIImage imageNamed:@"icon_unselect"];
    if (isSelect) {
        cell.sendSwitch.hidden = YES;
        cell.selectImgView.hidden = NO;
    }else{
        cell.sendSwitch.hidden = NO;
        cell.selectImgView.hidden = YES;
    }
    NSLog(@"***********%@",self.dataSource[indexPath.row].isSend);
    if ([self.dataSource[indexPath.row].isSend isEqualToString:@"YES"]) {
        [cell.sendSwitch setOn:true];
    }
    
   return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    notificationListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (isSelect) {
        //如果当前处于选择编辑模式
        if(cell.selectImgView.tag == 0){
            cell.selectImgView.tag = 1;
            cell.selectImgView.image = [UIImage imageNamed:@"icon_select"];
            [selectArray addObject:self.dataSource[indexPath.row].foodName];
        }else{
            cell.selectImgView.tag = 0;
            cell.selectImgView.image = [UIImage imageNamed:@"icon_unselect"];
            [selectArray removeObjectAtIndex:[selectArray indexOfObject:self.dataSource[indexPath.row].foodName]];
        }
    }
}

- (void)selectCell{
    if (self.selectbtn.tag == 0) {
        [self.selectbtn setTitle:@"Cancel" forState:UIControlStateNormal];
        self.selectbtn.tag = 1;
        isSelect = true;
        self.backBtn.hidden = YES;
        self.deleBtn.hidden = NO;
        [self.notificationList reloadData];
    }else{
        [self.selectbtn setTitle:@"Select" forState:UIControlStateNormal];
        self.selectbtn.tag = 0;
        isSelect = false;
        self.backBtn.hidden = NO;
        self.deleBtn.hidden = YES;
        [selectArray removeAllObjects];
        [self.notificationList reloadData];
    }
}
//UIswitch事件
- (void)openSendNotification:(UISwitch *)cellSwitch{
    if ([cellSwitch isOn]) {
        [remindArray addObject:self.dataSource[cellSwitch.tag]];
        [cancelArray removeObjectAtIndex:[cancelArray indexOfObject:self.dataSource[cellSwitch.tag]]];
    }else{
        [cancelArray addObject:self.dataSource[cellSwitch.tag]];
        [remindArray removeObjectAtIndex:[remindArray indexOfObject:self.dataSource[cellSwitch.tag]]];
    }
}

- (void)closeNotificationView{
    [self saveReminder];
    if ([self.closeDelegate respondsToSelector:@selector(closeNotificationList)]) {
        [self.closeDelegate closeNotificationList];
    }
}
- (void)sendReminderNotification{
    NSLog(@"%@",remindArray);
    NSArray *tempArray;
    NSString *tempStr;
    NSDateFormatter *format = [NSDateFormatter new];
    NSDateFormatter *format2 = [NSDateFormatter new];
    [format setDateFormat:@"dd MM/yyyy hh:mm a"];
    [format2 setDateFormat:@"dd/MM/yyyy/HH:mm"];
    format.AMSymbol = @"AM";
    format.PMSymbol = @"PM";
    //设定通知
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    //获取用户设置，是否设定免打扰
    NSString *autoNotification = [userdefault valueForKey:@"autonotification"];
    if ([autoNotification isEqualToString:@"NO"] || autoNotification == nil) {
        //[self.fosaNotification initNotification];
        for (int i = 0; i < remindArray.count; i++) {
            NSString *body = [NSString stringWithFormat:@"FOSA remind you to eat your food %@ in time",remindArray[i].foodName];
            //获取通知的图片
            UIImage *image = [self getImage:remindArray[i].foodName];
            NSLog(@"%@",image)
            //另存通知图片
            [self Savephoto:image name:remindArray[i].foodName];

            tempArray = [remindArray[i].remindDate componentsSeparatedByString:@","];
            tempStr = [NSString stringWithFormat:@"%@/%@ %@",tempArray[1],tempArray[2],tempArray[3]];
            NSDate *date = [format dateFromString:tempStr];
            //NSLog(@"<<<<<<<<<<<<<<<<<<<<<<remindDate :%@",[format2 stringFromDate:date]);

            [self.fosaNotification sendNotificationByDate:remindArray[i] body:body date:[format2 stringFromDate:date] foodImg:image];
        }
    }
}

- (void)deleteReminder{
    NSLog(@"%@",selectArray);

    if ([self.fmdbManager isFmdbOpen]) {
        for (int i = 0; i < selectArray.count; i++) {
            NSString *updateSql = [NSString stringWithFormat:@"update FoodStorageInfo set remindDate = '%@',send = '%@' where foodName = '%@'",@"",@"NO",selectArray[i]];
            if ([self.fmdbManager updateDataWithSql:updateSql]) {
                NSLog(@"删除reminder，更新成功");
            }
        }
    }
    [self getFoodDataFromSql];
    [self.selectbtn setTitle:@"Select" forState:UIControlStateNormal];
    self.selectbtn.tag = 0;
    isSelect = false;
    self.backBtn.hidden = NO;
    self.deleBtn.hidden = YES;
    [self.notificationList reloadData];
}
- (void)saveReminder{
    NSLog(@"cancelArray:%@",cancelArray);
    NSLog(@"remindArray:%@",remindArray);
    if ([self.fmdbManager isFmdbOpen] && remindArray.count > 0) {
           for (int i = 0; i < remindArray.count; i++) {
               NSString *updateSql = [NSString stringWithFormat:@"update FoodStorageInfo set send = '%@' where foodName = '%@'",@"YES",remindArray[i].foodName];
               if ([self.fmdbManager updateDataWithSql:updateSql]) {
                   NSLog(@"设置reminder为YES，更新成功");
               }
           }
    }
    //取消没有开启的通知
    NSMutableArray *requestArray = [NSMutableArray new];
    for (int i = 0; i < cancelArray.count; i++) {
        NSString *updateSql = [NSString stringWithFormat:@"update FoodStorageInfo set send = '%@' where foodName = '%@'",@"NO",cancelArray[i].foodName];
        if ([self.fmdbManager updateDataWithSql:updateSql]) {
            NSLog(@"设置reminder为NO，更新成功");
        }
        [requestArray addObject:cancelArray[i].foodName];
    }
    [self.fosaNotification removeReminder:requestArray];
}

//获取数据库的食物
- (void)getFoodDataFromSql{
    self.fmdbManager = [FosaFMDBManager initFMDBManagerWithdbName:@"FOSA"];
    [self.dataSource removeAllObjects];
    NSString *sql = @"select * from FoodStorageInfo";
    self.dataSource = [self.fmdbManager selectDataWithTableName:@"FoodStorageInfo" sql:sql];
    NSLog(@"%@",self.dataSource);
    [self.notificationList reloadData];
}
//取出保存在本地的图片
- (UIImage*)getImage:(NSString *)filepath{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *photopath = [NSString stringWithFormat:@"%@.png",filepath];
    NSString *imagePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",photopath]];
    // 保存文件的名称
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    if (img == nil) {
        img = [UIImage imageNamed:@"icon_defaultImg1"];
    }
    return img;
}
//保存图片到沙盒
-(void)Savephoto:(UIImage *)image name:(NSString *)foodname{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *photoName = [NSString stringWithFormat:@"%@.png",foodname];
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent: photoName];// 保存文件的路径
    NSLog(@"这个是照片的保存地址:%@",filePath);
    BOOL result =[UIImagePNGRepresentation(image) writeToFile:filePath  atomically:YES];// 保存成功会返回YES
    if(result == YES) {
        NSLog(@"通知界面图片保存成功");
    }
}
@end
