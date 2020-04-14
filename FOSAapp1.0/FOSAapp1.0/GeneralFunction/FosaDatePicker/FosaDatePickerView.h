//
//  FosaDatePickerView.h
//  FOSA
//
//  Created by hs on 2019/12/10.
//  Copyright © 2019 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FosaDatePickerViewDelegate <NSObject>
/**
 保存按钮代理方法
 @param timer 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer remindDate:(NSString *)remindTimer;
/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate;

- (void)jumpToRepeatView;

@end

@interface FosaDatePickerView : UIView

@property (copy, nonatomic) NSString *title;

/// 是否自动滑动 默认YES
@property (assign, nonatomic) BOOL isSlide;

/// 选中的时间
@property (copy, nonatomic) NSString *date;

@property (nonatomic,copy) NSString *reminderDate;

@property (nonatomic,copy) NSString *repeatWay;

/// 分钟间隔 默认5分钟
@property (assign, nonatomic) NSInteger minuteInterval;

@property (weak, nonatomic) id <FosaDatePickerViewDelegate> delegate;

//reminder
@property (nonatomic,strong) UIView *remindView;
@property (nonatomic,strong) UILabel *remindLabel;
@property (nonatomic,strong) UISwitch *remindSwitch;

@property (nonatomic,strong) UILabel *Alarm,*rightDatelabel,*leftDatelabel;
@property (nonatomic,strong) UIDatePicker *remindDatepicker;

@property (nonatomic,strong) UILabel *repeatLabel,*repeatWayLabel;
@property (nonatomic,strong) UIImageView *rightSign;


- (instancetype)initWithFrame:(CGRect)frame expireDate:(NSString *)expirestr remindDate:(NSString *)remindstr repeatWay:(NSString *)repeat;
/// 显示
- (void)show;

@end

NS_ASSUME_NONNULL_END
