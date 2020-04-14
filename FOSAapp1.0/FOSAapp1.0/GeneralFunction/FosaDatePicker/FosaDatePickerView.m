//
//  FosaDatePickerView.m
//  FOSA
//
//  Created by hs on 2019/12/10.
//  Copyright © 2019 hs. All rights reserved.
//

#import "FosaDatePickerView.h"
#import "fosaView.h"

@interface FosaDatePickerView()<UIPickerViewDelegate, UIPickerViewDataSource>{
    CGFloat height;
    
}

@property (strong, nonatomic) UIPickerView *pickerView; // 选择器
@property (strong, nonatomic) UIView *toolView; // 工具条
@property (strong, nonatomic) UILabel *titleLbl; // 标题

@property (strong, nonatomic) NSMutableArray *dataArray; // 数据源
@property (copy, nonatomic) NSString *selectStr; // 选中的时间
@property (copy, nonatomic) NSString *selectRemindStr;

@property (strong, nonatomic) NSMutableArray *yearArr; // 年数组
@property (strong, nonatomic) NSMutableArray *monthArr; // 月数组
@property (strong, nonatomic) NSMutableArray *dayArr; // 日数组
@property (strong, nonatomic) NSMutableArray *hourArr; // 时数组
@property (strong, nonatomic) NSMutableArray *minuteArr; // 分数组
@property (strong, nonatomic) NSArray *timeArr; // 选中时间数组
@property (nonatomic,strong)  NSArray *currentTime;//当前时间

@property (copy, nonatomic) NSString *year; // 选中年
@property (copy, nonatomic) NSString *month; //选中月
@property (copy, nonatomic) NSString *day; //选中日
@property (copy, nonatomic) NSString *hour; //选中时
@property (copy, nonatomic) NSString *minute; //选中分

@property (nonatomic,strong) fosaView *repeatView,*AlarView;

@end

#define THColorRGB(rgb)    [UIColor colorWithRed:(rgb)/255.0 green:(rgb)/255.0 blue:(rgb)/255.0 alpha:1.0]

@implementation FosaDatePickerView

#pragma mark - init
/// 初始化
- (instancetype)initWithFrame:(CGRect)frame expireDate:(NSString *)expirestr remindDate:(NSString *)remindstr repeatWay:(NSString *)repeat
{
    self = [super initWithFrame:frame];
    if (self) {
        height = self.bounds.size.height;
        self.backgroundColor = FOSAColor(242, 242, 242);

        self.timeArr = [NSArray array];
        self.dataArray = [NSMutableArray array];
        self.minuteArr = [NSMutableArray array];
        
        NSLog(@"expiry:%@,remind:%@",expirestr,remindstr);
        
        [self.dataArray addObject:self.dayArr];
        [self.dataArray addObject:self.monthArr];
        [self.dataArray addObject:self.yearArr];
        [self.dataArray addObject:self.hourArr];
        self.selectRemindStr = @"";
        
        [self configData:expirestr remind:remindstr repeatway:repeat];
        [self configToolView];
        [self configPickerView];
        [self configReminder];
    }
    return self;
}

- (void)configData:(NSString *)expirestr remind:(NSString *)remindstr repeatway:repeat{

    NSLog(@"expirestr:%@",expirestr);
    self.isSlide = YES;
    self.minuteInterval = 5;

    NSDate *date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy/HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    NSString *newDate = [dateStr stringByReplacingOccurrencesOfString:@":" withString:@"/"];
    self.currentTime = [NSMutableArray arrayWithArray:[newDate componentsSeparatedByString:@"/"]];
    NSLog(@"%@",self.currentTime);
    
    self.reminderDate = remindstr;
    self.repeatWay = repeat;
}

#pragma mark - 配置界面
/// 配置工具条
- (void)configToolView {

    self.toolView = [[UIView alloc] init];
    self.toolView.frame = CGRectMake(0, 0, self.frame.size.width, height/10);
    self.toolView.backgroundColor = FOSAWhite;
    [self addSubview:self.toolView];
    
    UIButton *saveBtn = [[UIButton alloc] init];
    saveBtn.frame = CGRectMake(self.frame.size.width - 90, 0, 80, height/10);
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:font(18)];
    [saveBtn setTitleColor:FOSAColor(2, 121, 255) forState:UIControlStateNormal];
    //[saveBtn setImage:[UIImage imageNamed:@"icon_select1"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:saveBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.frame = CGRectMake(10, 0, 80, height/10);
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:font(18)];
    [cancelBtn setTitleColor:FOSARed forState:UIControlStateNormal];

    //[cancelBtn setImage:[UIImage imageNamed:@"icon_revocation1"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:cancelBtn];
    
    self.titleLbl = [[UILabel alloc] init];
    self.titleLbl.frame = CGRectMake(60, 0, self.frame.size.width - 120, height/10);
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.titleLbl.textColor = THColorRGB(34);
    self.titleLbl.font = [UIFont systemFontOfSize:font(18)];
    [self.toolView addSubview:self.titleLbl];
}

/// 配置UIPickerView
- (void)configPickerView {
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolView.frame), self.frame.size.width, self.frame.size.height*3/10)];
    self.pickerView.backgroundColor = FOSAWhite;FOSAColor(242, 242, 242);
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    //self.pickerView.showsSelectionIndicator = YES;
    [self addSubview:self.pickerView];
}

- (void)configReminder{

    self.remindView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pickerView.frame)+10, screen_width, height/10)];
    self.remindView.backgroundColor = FOSAWhite;
    [self addSubview:self.remindView];
    
    self.remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(font(15), 0, screen_width/4, height/10)];
    self.remindSwitch = [UISwitch new];
    self.remindSwitch.center = CGPointMake(screen_width-50, height/20);
    [self.remindSwitch addTarget:self action:@selector(autoSwitch:) forControlEvents:UIControlEventValueChanged];

    self.remindLabel.text = @"Remind Me";
    [self.remindView addSubview:self.remindLabel];
    [self.remindView addSubview:self.remindSwitch];
    UIView *boundary1 = [[UIView alloc]initWithFrame:CGRectMake(font(15), CGRectGetMaxY(self.remindLabel.frame), screen_width-font(15), 1)];
    boundary1.backgroundColor = FOSAColor(242, 242, 242);
    [self.remindView addSubview:boundary1];

    self.AlarView = [[fosaView alloc]initWithFrame:CGRectMake(0, height/5, screen_width, height/10)];
    self.AlarView.backgroundColor = FOSAWhite;
    self.AlarView.userInteractionEnabled = YES;
    UITapGestureRecognizer *clickRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openDatePicker)];
    self.AlarView.tag = 0;
    [self.AlarView addGestureRecognizer:clickRecognizer];

    self.Alarm = [[UILabel alloc]initWithFrame:CGRectMake(font(15), 0, screen_width/4, height/10)];
    self.Alarm.text = @"Alarm";

    self.rightDatelabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/3, 0, screen_width*2/3-font(20), height/10)];
    NSDate *current = [NSDate new];
    self.rightDatelabel.text = [self getTimeAndWeekDay:current];
    self.rightDatelabel.textColor = FOSAGray;
    self.rightDatelabel.textAlignment = NSTextAlignmentRight;
    
    self.leftDatelabel = [[UILabel alloc]initWithFrame:CGRectMake(font(15), 0, screen_width-10, height/10)];
    self.leftDatelabel.text = [self getTimeAndWeekDay:current];
    self.leftDatelabel.textColor = FOSAColor(2, 121, 255);
    self.leftDatelabel.hidden = YES;
    
    [self.AlarView addSubview:self.leftDatelabel];

    [self.AlarView addSubview:self.rightDatelabel];
    
    UIView *boundary2 = [[UIView alloc]initWithFrame:CGRectMake(font(15), CGRectGetMaxY(self.Alarm.frame), screen_width-font(15), 1)];
    boundary2.backgroundColor = FOSAColor(242, 242, 242);
    [self.remindView addSubview:boundary2];

    self.remindDatepicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.AlarView.frame), screen_width, 0)];//(self.frame.size.height/2-22)/2
    self.remindDatepicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.remindDatepicker.minimumDate = [NSDate new];
    [self.remindDatepicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.remindView addSubview:self.remindDatepicker];
    
    [self.AlarView addSubview:self.Alarm];
    self.AlarView.hidden = YES;
    [self.remindView addSubview:self.AlarView];
    
    self.repeatView = [[fosaView alloc]initWithFrame:CGRectMake(0, height/10, screen_width, height/10)];
    self.repeatView.backgroundColor = FOSAWhite;
    self.repeatView.userInteractionEnabled = YES;
    UITapGestureRecognizer *repeatRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectRepeatWay)];
    [self.repeatView addGestureRecognizer:repeatRecognizer];
    
    self.repeatLabel = [[UILabel alloc]initWithFrame:CGRectMake(font(15), 0, screen_width/4, height/10)];
    self.repeatLabel.text = @"Repeat";
    self.repeatView.hidden = YES;
    self.repeatWayLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-font(60)-height/13, 0, font(60), height/10)];
    self.repeatWayLabel.textAlignment = NSTextAlignmentRight;
    self.repeatWayLabel.adjustsFontSizeToFitWidth = YES;
    if (self.repeatWay == NULL) {
        self.repeatWayLabel.text = @"Never";
    }else{
        self.repeatWayLabel.text = self.repeatWay;
    }

    self.repeatWayLabel.textColor = FOSAGray;
    self.repeatWayLabel.hidden = YES;
    
    self.rightSign = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-height/13, height/40, height/20, height/20)];
    self.rightSign.image = [UIImage imageNamed:@"icon_arrowright"];
    
    UIView *boundary3 = [[UIView alloc]initWithFrame:CGRectMake(font(15), CGRectGetMaxY(self.repeatLabel.frame), screen_width-font(15), 1)];
    boundary3.backgroundColor = FOSAColor(242, 242, 242);
    [self.remindView addSubview:boundary3];
    [self.repeatView addSubview:self.repeatWayLabel];
    [self.repeatView addSubview:self.rightSign];
    [self.repeatView addSubview:self.repeatLabel];
    [self.remindView addSubview:self.repeatView];

    if (![self.reminderDate isEqualToString:@""]) {
        [self.remindSwitch setOn:true];
        [self autoSwitch:_remindSwitch];
        //self.leftDatelabel.text = self.reminderDate;
        self.rightDatelabel.text = self.reminderDate;
//        NSArray *array = [self.reminderDate componentsSeparatedByString:@","];
//        NSDateFormatter *format = [NSDateFormatter new];
//        [format setDateFormat:@" dd  MM, yyyy ,hh:mm  a"];
//        NSDate *date = [format dateFromString:[NSString stringWithFormat:@"%@,%@,%@",array[1],array[2],array[3]]];
//        NSLog(@"****************%@",date);
//        [self.remindDatepicker setDate:date];
           //[self.remindSwitch respondsToSelector:@selector(autoSwitch:)];
    }
}
- (void)openDatePicker{
    NSLog(@"======================================================");
    //float height = (self.bounds.size.height-CGRectGetMaxY(self.alarmView.frame))/2;
    if (self.AlarView.tag == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.Alarm.hidden = YES;
            self.rightDatelabel.hidden = YES;
            self.leftDatelabel.hidden = NO;
            self.remindDatepicker.hidden = NO;
            self.remindView.frame = CGRectMake(0, CGRectGetMaxY(self.pickerView.frame)+10, screen_width, self->height*3/5-10);
            self.remindDatepicker.frame = CGRectMake(0, CGRectGetMaxY(self.AlarView.frame), screen_width, self->height/4);
            //self.repeatView.frame = CGRectMake(0, CGRectGetMaxY(self.remindDatepicker.frame), screen_width, self->height/10);
        }];
        self.AlarView.tag = 1;
    }else{
        //self.alarmView.alpha = 0.5;
        [UIView animateWithDuration:0.2 animations:^{
            self.leftDatelabel.hidden = YES;
            self.Alarm.hidden = NO;
            self.rightDatelabel.hidden = NO;

            self.remindView.frame = CGRectMake(0, CGRectGetMaxY(self.pickerView.frame)+10, screen_width, self->height*3/10);
            self.remindDatepicker.frame = CGRectMake(0, CGRectGetMaxY(self.AlarView.frame), screen_width, 0);
            //self.repeatView.frame = CGRectMake(0, CGRectGetMaxY(self.alarmView.frame), screen_width, self->height/10);
            self.remindDatepicker.hidden = YES;
            //self.alarmView.alpha = 1;
        }];
        self.AlarView.tag = 0;
    }
}

- (void)selectRepeatWay{
    if ([self.delegate respondsToSelector:@selector(jumpToRepeatView)]) {
        [self.delegate jumpToRepeatView];
    }
}

- (void)autoSwitch:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [UIView animateWithDuration:0.2 animations:^{
            self.remindView.frame = CGRectMake(0, CGRectGetMaxY(self.pickerView.frame)+10, screen_width, self->height*3/10);
            self.AlarView.hidden = NO;
            self.repeatView.hidden = NO;
            self.repeatWayLabel.hidden = NO;
        }];
    }else {
        [UIView animateWithDuration:0.2 animations:^{
            self.remindView.frame = CGRectMake(0, CGRectGetMaxY(self.pickerView.frame)+10, screen_width, self->height/10);
            self.remindDatepicker.frame = CGRectMake(0, CGRectGetMaxY(self.AlarView.frame), screen_width, 0);
            //self.repeatView.frame = CGRectMake(0, CGRectGetMaxY(self.AlarView.frame), screen_width, self->height/10);
            self.AlarView.hidden = YES;
            self.repeatView.hidden = YES;
            self.repeatWayLabel.hidden = YES;
            
            self.leftDatelabel.hidden = YES;
            self.rightDatelabel.hidden = NO;
            self.Alarm.hidden = NO;
            self.AlarView.tag = 0;
        }];
    }
}
- (void)changeDate:(UIDatePicker *)picker{
    NSLog(@"当前选择:%@",picker.date);
    self.rightDatelabel.text = [self getTimeAndWeekDay:picker.date];
    self.leftDatelabel.text  = [self getTimeAndWeekDay:picker.date];

    self.reminderDate = [self getTimeAndWeekDay:picker.date];
    //self.selectRemindStr = self.reminderDate;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLbl.text = title;
}
- (void)setDate:(NSString *)date {
    NSLog(@"====================SetDate=========================");
    _date = date;
    NSString *newDate = [date stringByReplacingOccurrencesOfString:@":" withString:@"/"];
    NSMutableArray *timerArray = [NSMutableArray arrayWithArray:[newDate componentsSeparatedByString:@"/"]];
    NSLog(@"timeArray:%@",timerArray);

    [timerArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@", timerArray[0]]];
    [timerArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@", timerArray[1]]];
    [timerArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%ld", (long)[timerArray[2] integerValue]+2000]];
    [timerArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%@", timerArray[3]]];
   [timerArray replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%@", timerArray[4]]];
    self.timeArr = timerArray;
}

- (void)setMinuteInterval:(NSInteger)minuteInterval {
    _minuteInterval = minuteInterval;

    if (self.minuteArr.count > 0) {
        [self.minuteArr removeAllObjects];
        self.minuteArr = [self configMinuteArray];
        [self.dataArray replaceObjectAtIndex:self.dataArray.count - 1 withObject:self.minuteArr];
    } else {
        self.minuteArr = [self configMinuteArray];
        [self.dataArray addObject:self.minuteArr];
    }
}

- (void)show {
    self.year = [NSString stringWithFormat:@"%ld", [self.timeArr[2] integerValue]];//self.timeArr[2];
    self.month = [NSString stringWithFormat:@"%ld", [self.timeArr[1] integerValue]];
    self.day = [NSString stringWithFormat:@"%ld", [self.timeArr[0] integerValue]];
    self.hour = [NSString stringWithFormat:@"%ld", [self.timeArr[3] integerValue]];
    self.minute = self.minuteInterval == 1 ? [NSString stringWithFormat:@"%ld", [self.timeArr[4] integerValue]] : self.minuteArr[self.minuteArr.count / 2];
    
    [self.pickerView selectRow:[self.dayArr indexOfObject:self.day] inComponent:0 animated:YES];
    /// 重新格式化转一下，是因为如果是09月/日/时，数据源是9月/日/时,就会出现崩溃
    [self.pickerView selectRow:[self.monthArr indexOfObject:self.month] inComponent:1 animated:YES];
    [self.pickerView selectRow:[self.yearArr indexOfObject:self.year] inComponent:2 animated:YES];
    [self.pickerView selectRow:[self.hourArr indexOfObject:self.hour] inComponent:3 animated:YES];
    [self.pickerView selectRow:self.minuteInterval == 1 ? ([self.minuteArr indexOfObject:self.minute]) : (self.minuteArr.count / 2) inComponent:4 animated:YES];
    
    /// 刷新日
    [self refreshDay];
}

#pragma mark - 点击方法
/// 保存按钮点击方法
- (void)saveBtnClick {
    NSLog(@"点击了保存");
    
    NSString *month = self.month.length == 2 ? [NSString stringWithFormat:@"%ld", self.month.integerValue] : [NSString stringWithFormat:@"0%ld", self.month.integerValue];
    NSString *day = self.day.length == 2 ? [NSString stringWithFormat:@"%ld", self.day.integerValue] : [NSString stringWithFormat:@"0%ld", self.day.integerValue];
    NSString *hour = self.hour.length == 2 ? [NSString stringWithFormat:@"%ld", self.hour.integerValue] : [NSString stringWithFormat:@"0%ld", self.hour.integerValue];
    NSString *minute = self.minute.length == 2 ? [NSString stringWithFormat:@"%ld", self.minute.integerValue] : [NSString stringWithFormat:@"0%ld", self.minute.integerValue];
    self.selectStr = [NSString stringWithFormat:@"%@/%@/%ld/%@:%@", month, day, [self.year integerValue]%100, hour, minute];
    if ([self.delegate respondsToSelector:@selector(datePickerViewSaveBtnClickDelegate:remindDate:)]) {
        [self.delegate datePickerViewSaveBtnClickDelegate:self.selectStr remindDate:self.reminderDate];
    }
}
/// 取消按钮点击方法
- (void)cancelBtnClick {
    NSLog(@"点击了取消");
    if ([self.delegate respondsToSelector:@selector(datePickerViewCancelBtnClickDelegate)]) {
        [self.delegate datePickerViewCancelBtnClickDelegate];
    }
}

#pragma mark - UIPickerViewDelegate and UIPickerViewDataSource
/// UIPickerView返回多少组
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.dataArray.count;
}
/// UIPickerView返回每组多少条数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return  [self.dataArray[component] count] * 200;
}
/// UIPickerView选择哪一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger time_integerValue = [self.currentTime[component] integerValue];
    switch (component) {
        case 2: { // 年
            NSString *year_integerValue = self.yearArr[row%[self.dataArray[component] count]];
            if (!self.isSlide) {
                self.year = year_integerValue;
                return;
            }
            if (year_integerValue.integerValue < time_integerValue) {
                [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
            } else {
                self.year = year_integerValue;
                /// 刷新日
                [self refreshDay];
                /// 根据当前选择的年份和月份获取当月的天数
                NSString *dayStr = [self getDayNumber:[self.year integerValue] month:[self.month integerValue]];
                if (self.dayArr.count > [dayStr integerValue]) {
                    if (self.day.integerValue > [dayStr integerValue]) {
                        [pickerView selectRow:[self.dataArray[2] indexOfObject:[dayStr stringByAppendingString:@"d"]] inComponent:2 animated:YES];
                        self.day = [dayStr stringByAppendingString:@"d"];
                    }
                }
            }
        } break;
        case 1: { // 月
            NSString *month_value = self.monthArr[row%[self.dataArray[component] count]];
            if (!self.isSlide) {
                self.month = month_value;
                /// 刷新日
                [self refreshDay];
                return;
            }
            // 如果选择年大于当前年 就直接赋值月
            if ([self.year integerValue] > [self.currentTime[2] integerValue]) {
                
                self.month = month_value;
                
                /// 根据当前选择的年份和月份获取当月的天数
                NSString *dayStr = [self getDayNumber:[self.year integerValue] month:[self.month integerValue]];
                if (self.dayArr.count > [dayStr integerValue]) {
                    if (self.day.integerValue > [dayStr integerValue]) {
                        if (self.isSlide) {
                            [pickerView selectRow:[self.dataArray[2] indexOfObject:[dayStr stringByAppendingString:@"d"]] inComponent:2 animated:YES];
                            self.day = [dayStr stringByAppendingString:@"d"];
                        } else {
                            self.month = month_value;
                        }
                    }
                }
                // 如果选择的年等于当前年，就判断月份
            } else if ([self.year integerValue] == [self.currentTime[2] integerValue]) {
                // 如果选择的月份小于当前月份 就刷新到当前月份
                if (month_value.integerValue < [self.timeArr[component] integerValue]) {
                    if (self.isSlide) {
                        [pickerView selectRow:[self.dataArray[component] indexOfObject:[NSString stringWithFormat:@"%ld", [self.timeArr[component] integerValue]]] inComponent:component animated:YES];
                    } else {
                        self.month = month_value;
                    }
                    // 如果选择的月份大于当前月份，就直接赋值月份
                } else {
                    self.month = month_value;

                    /// 根据当前选择的年份和月份获取当月的天数
                    NSString *dayStr = [self getDayNumber:[self.year integerValue] month:[self.month integerValue]];
                    if (self.dayArr.count > dayStr.integerValue) {
                        if (self.day.integerValue > dayStr.integerValue) {
                            [pickerView selectRow:[self.dataArray[2] indexOfObject:[dayStr stringByAppendingString:@"d"]] inComponent:2 animated:YES];
                            self.day = [dayStr stringByAppendingString:@"d"];
                        }
                    }
                }
            }
            /// 刷新日
            [self refreshDay];

        } break;
        case 0: { // 日
            /// 根据当前选择的年份和月份获取当月的天数
            NSString *dayStr = [self getDayNumber:[self.year integerValue] month:[self.month integerValue]];
            // 如果选择年大于当前年 就直接赋值日
            NSString *day_value = self.dayArr[row%[self.dataArray[component] count]];

            if (!self.isSlide) {
                self.day = day_value;
                return;
            }

            if ([self.year integerValue] > [self.currentTime[2] integerValue]) {
                if (self.dayArr.count <= [dayStr integerValue]) {
                    self.day = day_value;
                } else {
                    if (day_value.integerValue <= [dayStr integerValue]) {
                        self.day = day_value;
                    } else {
                        [pickerView selectRow:[self.dataArray[component] indexOfObject:[dayStr stringByAppendingString:@"d"]] inComponent:component animated:YES];
                    }
                }
                // 如果选择的年等于当前年，就判断月份
            } else if ([self.year integerValue] == [self.currentTime[2] integerValue]) {
                // 如果选择的月份大于当前月份 就直接复制
                if ([self.month integerValue] > [self.currentTime[1] integerValue]) {
                    if (self.dayArr.count <= [dayStr integerValue]) {
                        self.day = day_value;
                    } else {
                        if (day_value.integerValue <= [dayStr integerValue]) {
                            self.day = day_value;
                        } else {
                            [pickerView selectRow:[self.dataArray[component] indexOfObject:[dayStr stringByAppendingString:@"d"]] inComponent:component animated:YES];
                        }
                    }
                    // 如果选择的月份等于当前月份，就判断日
                } else if ([self.month integerValue] == [self.currentTime[1] integerValue]) {
                    // 如果选择的日小于当前日，就刷新到当前日
                    if (day_value.integerValue < [self.currentTime[component] integerValue]) {
                        if (self.isSlide) {
                            [pickerView selectRow:[self.dataArray[component] indexOfObject:[NSString stringWithFormat:@"%ld", time_integerValue]] inComponent:component animated:YES];
                        } else {
                            self.day = day_value;
                        }
                        // 如果选择的日大于当前日，就复制日
                    } else {
                        if (self.dayArr.count <= [dayStr integerValue]) {
                            self.day = day_value;
                        } else {
                            if ([self.dayArr[row%[self.dataArray[component] count]] integerValue] <= [dayStr integerValue]) {
                                self.day = day_value;
                            } else {
                                [pickerView selectRow:[self.dataArray[component] indexOfObject:[dayStr stringByAppendingString:@"d"]] inComponent:component animated:YES];
                            }
                        }
                    }
                }
            }
        } break;
        case 3: { // 时
            NSString *hour_value = self.hourArr[row%[self.dataArray[component] count]];
            if (!self.isSlide) {
                self.hour = hour_value;
                return;
            }
            // 如果选择年大于当前年 就直接赋值时
            if ([self.year integerValue] > [self.currentTime[2] integerValue]) {
                self.hour = hour_value;
                // 如果选择的年等于当前年，就判断月份
            } else if ([self.year integerValue] == [self.currentTime[2] integerValue]) {
                // 如果选择的月份大于当前月份 就直接复制时
                if ([self.month integerValue] > [self.currentTime[1] integerValue]) {
                    self.hour = hour_value;
                    // 如果选择的月份等于当前月份，就判断日
                } else if ([self.month integerValue] == [self.currentTime[1] integerValue]) {
                    // 如果选择的日大于当前日，就直接复制时
                    if ([self.day integerValue] > [self.currentTime[0] integerValue]) {
                        self.hour = hour_value;
                        // 如果选择的日等于当前日，就判断时
                    } else if ([self.day integerValue] == [self.currentTime[0] integerValue]) {
                        // 如果选择的时小于当前时，就刷新到当前时
                        if (hour_value.integerValue < [self.currentTime[component] integerValue]) {
                        if (self.isSlide) {
                            [pickerView selectRow:[self.dataArray[component] indexOfObject:[NSString stringWithFormat:@"%ld", [self.timeArr[component] integerValue]]] inComponent:component animated:YES];
                        }
                            // 如果选择的时大于当前时，就直接赋值
                        } else {
                            self.hour = hour_value;
                        }
                    }
                }
            }
        } break;
        case 4: { // 分
            // 如果选择年大于当前年 就直接赋值时
            //            if ([self.year integerValue] > [self.timeArr[0] integerValue]) {
            self.minute = self.minuteArr[row%[self.dataArray[component] count]];
            //                // 如果选择的年等于当前年，就判断月份
            //            } else if ([self.year integerValue] == [self.timeArr[0] integerValue]) {
            //                // 如果选择的月份大于当前月份 就直接复制时
            //                if ([self.month integerValue] > [self.timeArr[1] integerValue]) {
            //                    self.minute = self.minuteArr[row%[self.dataArray[component] count]];
            //                    // 如果选择的月份等于当前月份，就判断日
            //                } else if ([self.month integerValue] == [self.timeArr[1] integerValue]) {
            //                    // 如果选择的日大于当前日，就直接复制时
            //                    if ([self.day integerValue] > [self.timeArr[2] integerValue]) {
            //                        self.minute = self.minuteArr[row%[self.dataArray[component] count]];
            //                        // 如果选择的日等于当前日，就判断时
            //                    } else if ([self.day integerValue] == [self.timeArr[2] integerValue]) {
            //                        // 如果选择的时大于当前时，就直接赋值
            //                        if ([self.hour integerValue] > [self.timeArr[3] integerValue]) {
            //                            self.minute = self.minuteArr[row%[self.dataArray[component] count]];
            //                        // 如果选择的时等于当前时,就判断分
            //                        } else if ([self.hour integerValue] == [self.timeArr[3] integerValue]) {
            //                            // 如果选择的分小于当前分，就刷新分
            //                            if ([self.minuteArr[row%[self.dataArray[component] count]] integerValue] < [self.timeArr[4] integerValue]) {
            //                                [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
            //                            // 如果选择分大于当前分，就直接赋值
            //                            } else {
            //                                self.minute = self.minuteArr[row%[self.dataArray[component] count]];
            //                            }
            //                        }
            //                    }
            //                }
            //            }
        } break;
        default: break;
    }
}

/// UIPickerView返回每一行数据
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];
}
/// UIPickerView返回每一行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}
/// UIPickerView返回每一行的View
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *titleLbl;
    if (!view) {
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 44)];
        titleLbl.font = [UIFont systemFontOfSize:font(20)];
        titleLbl.textAlignment = NSTextAlignmentCenter;
    } else {
        titleLbl = (UILabel *)view;
        
    }
    if (component == 1) {
         NSString  *title = [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];
        NSLog(@"title:%ld",(long)title.integerValue);
        titleLbl.text = [self getMouthByindex:(long)title.integerValue];
        //NSLog(@"========>>>>>>>>>>>>%@", [self getMouthByindex:(int)titleLbl.text.integerValue] );
    }else{
        titleLbl.text = [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];
    }

    return titleLbl;
}


- (void)pickerViewLoaded:(NSInteger)component row:(NSInteger)row{
    NSUInteger max = 16384;
    NSUInteger base10 = (max/2)-(max/2)%row;
    [self.pickerView selectRow:[self.pickerView selectedRowInComponent:component] % row + base10 inComponent:component animated:NO];
}


/// 获取年份
- (NSMutableArray *)yearArr {
    if (!_yearArr) {
        _yearArr = [NSMutableArray array];
        for (int i = 2000; i < 2099; i ++) {
            [_yearArr addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _yearArr;
}

/// 获取月份
- (NSMutableArray *)monthArr {
    //    NSDate *today = [NSDate date];
    //    NSCalendar *c = [NSCalendar currentCalendar];
    //    NSRange days = [c rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:today];
    if (!_monthArr) {
        _monthArr = [NSMutableArray array];
        for (int i = 1; i <= 12; i ++) {
            [_monthArr addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _monthArr;
}

/// 获取当前月的天数
- (NSMutableArray *)dayArr {
    if (!_dayArr) {
        _dayArr = [NSMutableArray array];
        for (int i = 1; i <= 31; i ++) {
            [_dayArr addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _dayArr;
}

/// 获取小时
- (NSMutableArray *)hourArr {
    if (!_hourArr) {
        _hourArr = [NSMutableArray array];
        for (int i = 0; i < 24; i ++) {
            [_hourArr addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _hourArr;
}

/// 获取分钟
- (NSMutableArray *)configMinuteArray {
    NSMutableArray *minuteArray = [NSMutableArray array];
    for (int i = 0; i <= 60 - self.minuteInterval; i ++) {
        if (i % self.minuteInterval == 0) {
            [minuteArray addObject:[NSString stringWithFormat:@"%d", i]];
            continue;
        }
    }
    return minuteArray;
}

// 比较选择的时间是否小于当前时间
- (int)compareDate:(NSString *)date01 withDate:(NSString *)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy年,MM月,dd日,HH时,mm分"];
    NSDate *dt1 = [df dateFromString:date01];
    NSDate *dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result) {
            //date02比date01大
        case NSOrderedAscending: ci=1;break;
            //date02比date01小
        case NSOrderedDescending: ci=-1;break;
            //date02=date01
        case NSOrderedSame: ci=0;break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);break;
    }
    return ci;
}

- (void)refreshDay {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 1; i < [self getDayNumber:self.year.integerValue month:self.month.integerValue].integerValue + 1; i ++) {
        [arr addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    [self.dataArray replaceObjectAtIndex:0 withObject:arr];
    [self.pickerView reloadComponent:0];
}
- (NSString *)getDayNumber:(NSInteger)year month:(NSInteger)month{
    NSArray *days = @[@"31", @"28", @"31", @"30", @"31", @"30", @"31", @"31", @"30", @"31", @"30", @"31"];
    if (2 == month && 0 == (year % 4) && (0 != (year % 100) || 0 == (year % 400))) {
        return @"29";
    }
    return days[month - 1];
}
- (NSString *)getMouthByindex:(long)index{
    NSArray *mouthArray = @[@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"June",@"July",@"Aug",@"Sept",@"Oct",@"Nov",@"Dec"];
    return mouthArray[(index-1)%12];
}
//获取当前时间日期星期
- (NSString *)getTimeAndWeekDay:(NSDate *)date{
    
    NSArray * arrWeek=[NSArray arrayWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat", nil];
    NSArray * arrWeekDay=[NSArray arrayWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday", nil];

    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"hh:mm  a"];
    format.AMSymbol = @"AM";
    format.PMSymbol = @"PM";
    NSString *timeStr = [format stringFromDate:date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    /*
     NSInteger unitFlags = NSYearCalendarUnit |
     NSMonthCalendarUnit |
     NSDayCalendarUnit |
     NSWeekdayCalendarUnit |
     NSHourCalendarUnit |
     NSMinuteCalendarUnit |
     NSSecondCalendarUnit;
     */
    NSInteger unitFlags = NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday | NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week  = [comps weekday]-1;
    NSInteger year  = [comps year];
    NSInteger month = [comps month];
    NSInteger day   = [comps day];
    NSInteger minute    = [comps minute];
    NSString *minu;
    if (minute < 10) {
        minu = [NSString stringWithFormat:@"0%ld",minute];
    }else{
        minu = [NSString stringWithFormat:@"%ld",minute];
    }
   // NSString *weekStr = [NSString stringWithFormat:@"%@,%ld/%ld/%ld,%@",[arrWeek objectAtIndex:week],(long)month,(long)day,(long)year%100,timeStr];
    NSString *weekdayStr = [NSString stringWithFormat:@"%@, %ld  %@, %ld ,%@",[arrWeekDay objectAtIndex:week],day,[self getMouthByindex:(int)month],year,timeStr];
   // NSArray *arrStr = @[weekStr,weekdayStr];
    return  weekdayStr;
}

@end
