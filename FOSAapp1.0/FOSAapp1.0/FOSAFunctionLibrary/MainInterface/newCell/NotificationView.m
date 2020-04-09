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

@interface NotificationView()<UITableViewDelegate,UITableViewDataSource>{
    Boolean isSelect;
}
@property (nonatomic,strong) FosaFMDBManager *fmdbManager;
@property (nonatomic,strong) NSMutableArray<FoodModel *> *dataSource;
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
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat height = self.bounds.size.height;
    CGFloat width  = self.bounds.size.width;
    self.bellBtn.frame = CGRectMake(0, 0, width/12, width/12);
    self.bellBtn.center = CGPointMake(width/2, height/16);
    [self.bellBtn setBackgroundImage:[UIImage imageNamed:@"icon_bell"] forState:UIControlStateNormal];
    self.bellBtn.userInteractionEnabled = NO;
    
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
    cell.timeLabel.text = ary[3];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@,%@ %@",ary[0],ary[1],ary[2]];
    
    if (isSelect) {
        cell.sendSwitch.hidden = YES;
        cell.selectImgView.hidden = NO;
    }else{
        cell.sendSwitch.hidden = NO;
        cell.selectImgView.hidden = YES;
    }
    
   return cell;
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
        [self.notificationList reloadData];
    }
   
    
}

- (void)closeNotificationView{
    if ([self.closeDelegate respondsToSelector:@selector(closeNotificationList)]) {
        [self.closeDelegate closeNotificationList];
    }
}

//获取数据库的食物
- (void)getFoodDataFromSql{
    self.fmdbManager = [FosaFMDBManager initFMDBManagerWithdbName:@"FOSA"];
    [self.dataSource removeAllObjects];
    NSString *sql = @"select * from FoodStorageInfo";
    self.dataSource = [self.fmdbManager selectDataWithTableName:@"FoodStorageInfo" sql:sql];
    NSLog(@"%@",self.dataSource);
}
//取出保存在本地的图片
- (UIImage*)getImage:(NSString *)filepath{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *photopath = [NSString stringWithFormat:@"%@%d.png",filepath,1];
    NSString *imagePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",photopath]];
    // 保存文件的名称
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%@", img);
    return img;
}
@end
