//
//  repeatPickerView.m
//  FOSAapp1.0
//
//  Created by hs on 2020/4/27.
//  Copyright © 2020 hs. All rights reserved.
//

#import "repeatPickerView.h"

@interface repeatPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>{
    NSInteger selectTime,selectTimeInterval;
}
@property (nonatomic,strong) NSArray<NSString *> *time,*timeInterval;
@end

@implementation repeatPickerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screen_width/2, Height(50))];
        [self.cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:FOSAgreen forState:UIControlStateHighlighted];
        [self.cancelBtn setTitleColor:FOSAGray forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancelPicker) forControlEvents:UIControlEventTouchUpInside];
        
        self.saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(screen_width/2, 0, screen_width/2, Height(50))];
        [self.saveBtn setTitle:@"save" forState:UIControlStateNormal];
        [self.saveBtn setTitleColor:FOSAgreen forState:UIControlStateHighlighted];
        [self.saveBtn setTitleColor:FOSAGray forState:UIControlStateNormal];
        [self.saveBtn addTarget:self action:@selector(savePicker) forControlEvents:UIControlEventTouchUpInside];
        
        self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, Height(50), screen_width, self.bounds.size.height - Height(50))];
        self.picker.delegate = self;
        self.picker.dataSource = self;
        
        [self addSubview:self.cancelBtn];
        [self addSubview:self.saveBtn];
        [self addSubview:self.picker];
        
        self.time = @[@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15"];
        self.timeInterval = @[@"1",@"2",@"3"];
        
    }
    return self;
}

#pragma mark - 点击事件
- (void)cancelPicker{
    if ([self.repeatDelegate respondsToSelector:@selector(repeatPickerViewCancelBtnClickDelegate)]) {
        [self.repeatDelegate repeatPickerViewCancelBtnClickDelegate];
    }
}
- (void)savePicker{
    if ([self.repeatDelegate respondsToSelector:@selector(repeatPickerViewSaveBtnClickDelegate:timeIntetval:)]) {
        [self.repeatDelegate repeatPickerViewSaveBtnClickDelegate:selectTime timeIntetval:selectTimeInterval];
    }
}
#pragma mark pickerview function
//返回有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
//返回指定列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return  [self.timeInterval count];
    }else{
        return  [self.time count];
    }
}

//返回指定列，行的高度，就是自定义行的高度

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 20.0f;
}

//返回指定列的宽度

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component==0) {
        return  screen_width/2;
    }else{
        return  screen_width/2;
    }
}
// 自定义指定列的每行的视图，即指定列的每行的视图行为一致
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    if (component == 0) {
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width/2, 20)];
        text.textAlignment = NSTextAlignmentCenter;
        text.text = [self.timeInterval objectAtIndex:row];
        [view addSubview:text];
    }else{
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width/2, 20)];
        text.textAlignment = NSTextAlignmentCenter;
        text.text = [self.time objectAtIndex:row];
        [view addSubview:text];
    }
//    //隐藏上下直线
//    [self.picker.subviews objectAtIndex:1].backgroundColor = [UIColor clearColor];
//    [self.picker.subviews objectAtIndex:2].backgroundColor = [UIColor clearColor];
    return view;
}

////显示的标题
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    //NSString *str = [_nameArray objectAtIndex:row];
//    if (component == 0) {
//        return @"timeInterval";
//    }else{
//        return @"times";
//    }
//    //return str;
//
//}
//
////显示的标题字体、颜色等属性
//
//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
//
//    NSString *str = [self.time objectAtIndex:row];
//
//    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
//
//    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
//
//    return AttributedString;
//
//}//NS_AVAILABLE_IOS(6_0);
//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        NSLog(@"重复间隔:%@",[self.timeInterval objectAtIndex:row]);
        selectTimeInterval = [[self.timeInterval objectAtIndex:row] integerValue];
    }else{
        NSLog(@"重复次数:%@",[self.time objectAtIndex:row])
        selectTime = [[self.time objectAtIndex:row] integerValue];
    }
   
}

@end
