//
//  categoryCollectionViewCell.m
//  FOSAapp1.0
//
//  Created by hs on 2020/3/7.
//  Copyright © 2020 hs. All rights reserved.
//

#import "categoryCollectionViewCell.h"

@implementation categoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.kind = [[UITextField alloc]init];
        self.kind.textAlignment = NSTextAlignmentCenter;
        self.kind.textColor = [UIColor grayColor];
        [self addSubview:self.kind];
        self.rootView = [[UIView alloc]init];
        [self addSubview:self.rootView];
        self.categoryPhoto = [[UIImageView alloc]init];
        self.badgeBtn = [UIButton new];
        self.badgeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.rootView addSubview:self.badgeBtn];
        self.badgeBtn.hidden = YES;
        self.editbtn = [UIButton new];
        [self.rootView addSubview:self.editbtn];
        self.editbtn.hidden = YES;
        [self.rootView addSubview:self.categoryPhoto];
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    int width = self.bounds.size.width;
    int height = self.bounds.size.height;
    self.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    self.kind.frame = CGRectMake(0, width, width, height-width);
    self.kind.font  = [UIFont systemFontOfSize:12];
    self.kind.adjustsFontSizeToFitWidth = YES;
    self.kind.userInteractionEnabled = NO;
    self.rootView.frame = CGRectMake(0, 0, width, width);
    self.rootView.layer.cornerRadius = width/2;
    self.rootView.backgroundColor = [UIColor whiteColor];
    self.categoryPhoto.frame = CGRectMake(self.rootView.frame.size.width/5, self.rootView.frame.size.width/5, self.rootView.frame.size.width*3/5, self.rootView.frame.size.width*3/5);
    
    self.badgeBtn.frame = CGRectMake(width*2/3, 0, width/3, width/3);
    self.badgeBtn.layer.cornerRadius = width/6;
    self.badgeBtn.backgroundColor = FOSAgreen;
    self.editbtn.frame = CGRectMake(width*3/5, 0, width*4/10, width*4/10);
    self.editbtn.layer.cornerRadius = width/5;
    self.editbtn.backgroundColor = FOSARed;
    [self.editbtn setImage:[UIImage imageNamed:@"icon_editW"] forState:UIControlStateNormal];
    
    self.categoryPhoto.backgroundColor = [UIColor clearColor];
    //self.categoryPhoto.layer.cornerRadius = width/2;

}
@end
