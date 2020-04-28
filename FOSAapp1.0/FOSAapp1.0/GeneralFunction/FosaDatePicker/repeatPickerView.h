//
//  repeatPickerView.h
//  FOSAapp1.0
//
//  Created by hs on 2020/4/27.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol repeatPickerViewDelegate <NSObject>

/**
 保存按钮代理方法
 @param times 选择的数据
 
 */
- (void)repeatPickerViewSaveBtnClickDelegate:(NSInteger)times timeIntetval:(NSInteger)interval;
/**
 取消按钮代理方法
 */
- (void)repeatPickerViewCancelBtnClickDelegate;

@end

@interface repeatPickerView : UIView
@property (nonatomic,strong) UIButton *saveBtn,*cancelBtn;
@property (nonatomic,strong) UILabel *repeatTimeLabel,*repeatIntevalLabel;
@property (nonatomic,strong) UIPickerView *picker;
@property (weak,nonatomic) id<repeatPickerViewDelegate> repeatDelegate;
@end

NS_ASSUME_NONNULL_END
