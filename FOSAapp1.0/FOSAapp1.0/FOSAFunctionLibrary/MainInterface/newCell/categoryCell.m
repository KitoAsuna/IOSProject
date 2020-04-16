//
//  categoryCell.m
//  FOSAapp1.0
//
//  Created by hs on 2020/4/16.
//  Copyright © 2020 hs. All rights reserved.
//

#import "categoryCell.h"

@implementation categoryCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.categoryView = [UIImageView new];
        [self addSubview:self.categoryView];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    self.categoryView.frame = CGRectMake(width/6, width/6, width*2/3, width*2/3);
    self.categoryView.layer.cornerRadius = width/3;
}
@end
