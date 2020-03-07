//
//  foodKindCollectionViewCell.m
//  FOSAapp1.0
//
//  Created by hs on 2020/1/9.
//  Copyright © 2020 hs. All rights reserved.
//

#import "foodKindCollectionViewCell.h"

@implementation foodKindCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.kind = [[UILabel alloc]init];
        self.kind.textAlignment = NSTextAlignmentCenter;
        self.kind.textColor = [UIColor grayColor];
        [self addSubview:self.kind];
        self.rootView = [[UIView alloc]init];
        [self addSubview:self.rootView];
        self.categoryPhoto = [[UIImageView alloc]init];
        [self.rootView addSubview:self.categoryPhoto];
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    int width = self.bounds.size.width;
    int height = self.bounds.size.height;
    
    
    self.kind.frame = CGRectMake(0, 0, width, height-width);
    self.kind.adjustsFontSizeToFitWidth = YES;
    self.rootView.frame = CGRectMake(0, height-width, width, width);
    self.rootView.layer.cornerRadius = width/2;
    self.rootView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    self.categoryPhoto.frame = CGRectMake(self.rootView.frame.size.width/5, self.rootView.frame.size.width/5, self.rootView.frame.size.width*3/5, self.rootView.frame.size.width*3/5);
    self.categoryPhoto.backgroundColor = [UIColor clearColor];
    //self.categoryPhoto.layer.cornerRadius = width/2;
    
}
//
//- (void)setSelected:(BOOL)selected{
//    [super setSelected:selected];
//    if(selected) {
//        self.kind.backgroundColor = FOSAgreen;
//    }else{
//        self.kind.backgroundColor = [UIColor whiteColor];
//    }
//
//}
@end
