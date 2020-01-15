//
//  DeviceCollectionViewCell.m
//  FOSAapp1.0
//
//  Created by hs on 2020/1/6.
//  Copyright © 2020 hs. All rights reserved.
//

#import "DeviceCollectionViewCell.h"

@implementation DeviceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        int width = self.bounds.size.width;
        int height = self.bounds.size.height;
        self.productImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
        self.productImageView.layer.cornerRadius = 15;
        self.productImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.productImageView.clipsToBounds = YES;
        [self addSubview:self.productImageView];
        
        self.productName = [[UILabel alloc]initWithFrame:CGRectMake(0, width, width, height-width)];
        self.productName.textAlignment = NSTextAlignmentCenter;
        self.productName.font = [UIFont systemFontOfSize:10*(screen_width/414.0)];
        [self addSubview:self.productName];
    }
    return self;
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    // 根据estimateditemsize，更新title这些子视图
NSLog(@"cellwidth<<<<<<<<%f----------cellheight<<<<<<<<<<%f",self.contentView.bounds.size.width,self.contentView.bounds.size.height);
}

@end
