//
//  NotificationView.h
//  FOSAapp1.0
//
//  Created by hs on 2020/4/9.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "foodModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol closeViewDelegate <NSObject>
- (void)closeNotificationList;
//- (void)deleteReminder;
@end

@interface NotificationView : UIView
@property (nonatomic,strong) UIButton *bellBtn,*selectbtn,*backBtn,*deleBtn;
@property (nonatomic,strong) UILabel *styleLabel;
@property (nonatomic,strong) UITableView *notificationList;
@property (nonatomic,strong) UISwitch *closeSwitch;
@property (weak,nonatomic) id<closeViewDelegate> closeDelegate;
- (void)getFoodDataFromSql;

@end

NS_ASSUME_NONNULL_END
