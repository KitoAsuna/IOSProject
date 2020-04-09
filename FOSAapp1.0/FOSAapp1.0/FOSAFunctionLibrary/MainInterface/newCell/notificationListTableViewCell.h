//
//  notificationListTableViewCell.h
//  FOSAapp1.0
//
//  Created by hs on 2020/4/9.
//  Copyright © 2020 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface notificationListTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *foodImgView,*selectImgView;
@property (nonatomic,strong) UILabel *foodNameLabel,*timeLabel,*dateLabel;
@property (nonatomic,strong) UISwitch *sendSwitch;
@end

NS_ASSUME_NONNULL_END
