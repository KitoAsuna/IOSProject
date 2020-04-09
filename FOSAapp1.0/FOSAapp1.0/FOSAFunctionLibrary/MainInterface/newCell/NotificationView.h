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
@end

@interface NotificationView : UIView
@property (nonatomic,strong) UIButton *bellBtn,*selectbtn,*backBtn,*deleBtn;
@property (nonatomic,strong) UITableView *notificationList;
@property (weak,nonatomic) id<closeViewDelegate> closeDelegate;
- (void)getFoodDataFromSql;

@end

NS_ASSUME_NONNULL_END
