//
//  MenuTableViewCell.m
//  FOSAapp1.0
//
//  Created by hs on 2019/12/30.
//  Copyright © 2019 hs. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

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
        self.categoryIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:self.categoryIcon];
        self.categoryTitle = [[UILabel alloc]init];
        [self.contentView addSubview:self.categoryTitle];
        self.categoryTitle.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

//设置控件的样式
- (void)layoutSubviews{
    [super layoutSubviews];

    int cellWidth = self.bounds.size.width;
    int cellHeight = self.bounds.size.height;
    self.categoryIcon.frame = CGRectMake(cellWidth/2-cellHeight/3, 0, cellHeight*2/3, cellHeight*2/3);
    self.categoryTitle.frame = CGRectMake(0, cellHeight*2/3, cellWidth, cellHeight/3);
}
@end
