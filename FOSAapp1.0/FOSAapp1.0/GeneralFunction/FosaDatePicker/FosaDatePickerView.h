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

@end

@interface FosaDatePickerView : UIView

@property (copy, nonatomic) NSString *title;

/// 是否自动滑动 默认YES
@property (assign, nonatomic) BOOL isSlide;

/// 选中的时间
@property (copy, nonatomic) NSString *date;

@property (nonatomic,copy) NSString *reminderDate;

/// 分钟间隔 默认5分钟
@property (assign, nonatomic) NSInteger minuteInterval;

@property (weak, nonatomic) id <FosaDatePickerViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame expireDate:(NSString *)expirestr remindDate:(NSString *)remindstr;
/// 显示
- (void)show;

@end

NS_ASSUME_NONNULL_END
