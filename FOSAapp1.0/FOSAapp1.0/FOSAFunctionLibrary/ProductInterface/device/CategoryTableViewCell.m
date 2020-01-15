//
//  CategoryTableViewCell.m
//  FOSAapp1.0
//
//  Created by hs on 2020/1/15.
//  Copyright © 2020 hs. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

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
        self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.bounds.size.width-5, self.bounds.size.height/2)];
        self.titleLable.textAlignment = NSTextAlignmentCenter;
        self.titleLable.textColor = [UIColor blackColor];
        [self addSubview:self.titleLable];
        
        self.index = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, self.bounds.size.height)];
        self.index.backgroundColor = FOSAgreen;
        self.index.layer.cornerRadius = 1;
        [self addSubview:self.index];
        self.index.hidden = YES;
    }
    return self;
}

@end
