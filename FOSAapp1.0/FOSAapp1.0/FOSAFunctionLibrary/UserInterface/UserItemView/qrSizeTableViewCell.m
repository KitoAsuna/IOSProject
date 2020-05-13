//
//  qrSizeTableViewCell.m
//  FOSAapp1.0
//
//  Created by hs on 2020/5/13.
//  Copyright © 2020 hs. All rights reserved.
//

#import "qrSizeTableViewCell.h"

@implementation qrSizeTableViewCell

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
        self.sizeLabel = [UILabel new];
        [self.contentView addSubview:self.sizeLabel];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.sizeLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.sizeLabel.textAlignment = NSTextAlignmentCenter;
}
@end
