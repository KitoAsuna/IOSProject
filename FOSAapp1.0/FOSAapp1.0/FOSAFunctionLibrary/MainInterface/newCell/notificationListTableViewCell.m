//
//  notificationListTableViewCell.m
//  FOSAapp1.0
//
//  Created by hs on 2020/4/9.
//  Copyright © 2020 hs. All rights reserved.
//

#import "notificationListTableViewCell.h"

@implementation notificationListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.foodImgView = [UIImageView new];
        
        self.foodImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.foodImgView.clipsToBounds = true;
        self.foodImgView.layer.cornerRadius = font(5);
        
        [self.contentView addSubview:self.foodImgView];
        self.foodNameLabel = [UILabel new];
        [self.contentView addSubview:self.foodNameLabel];
        self.timeLabel = [UILabel new];
        [self.contentView addSubview:self.timeLabel];
        self.dateLabel = [UILabel new];
        [self.contentView addSubview:self.dateLabel];
        self.sendSwitch = [UISwitch new];
        [self.contentView addSubview:self.sendSwitch];
        
        self.selectImgView = [UIImageView new];
        self.selectImgView.hidden = YES;
        self.selectImgView.image = [UIImage imageNamed:@"icon_unselect"];
        [self.contentView addSubview:self.selectImgView];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    int cellWidth = self.bounds.size.width;
    int cellHeight = self.bounds.size.height;
    
    self.foodImgView.frame = CGRectMake(cellWidth/20, cellHeight*2/16, cellHeight*10/16, cellHeight*10/16);
    
    self.foodNameLabel.frame = CGRectMake(CGRectGetMaxX(self.foodImgView.frame)+font(10), cellHeight/8, cellWidth*2/3, cellHeight/4);
    self.foodNameLabel.font = [UIFont systemFontOfSize:font(20)];
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.foodImgView.frame)+font(10), CGRectGetMaxY(self.foodNameLabel.frame), cellWidth*2/3, cellHeight/5);
    self.timeLabel.textColor = FOSAColor(255, 193, 96);
    self.timeLabel.font = [UIFont systemFontOfSize:font(15)];
    self.dateLabel.frame = CGRectMake(CGRectGetMaxX(self.foodImgView.frame)+font(10), CGRectGetMaxY(self.timeLabel.frame), cellWidth*2/3, cellHeight/5);
    self.dateLabel.textColor = FOSAGray;
    self.dateLabel.font = [UIFont systemFontOfSize:font(15)];
    self.sendSwitch.center = CGPointMake(cellWidth*19/20-25, cellHeight/2);
    self.selectImgView.frame = CGRectMake(0, 0, cellHeight/4, cellHeight/4);
    self.selectImgView.center = CGPointMake(cellWidth*19/20-25, cellHeight/2);
    self.selectImgView.userInteractionEnabled = YES;
    self.selectImgView.tag  = 0;
//    UITapGestureRecognizer *selectRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectItem:)];
//    [self.selectImgView addGestureRecognizer:selectRecognizer];
    
}

//- (void)selectItem:(UIImageView *)imageview{
//    if (imageview.tag == 0) {
//        imageview.image = self.selectImgView.image = [UIImage imageNamed:@"icon_select"];
//        imageview.tag = 1;
//    }else{
//        imageview.image = self.selectImgView.image = [UIImage imageNamed:@"icon_unselect"];
//        imageview.tag = 0;
//    }
//}

@end
