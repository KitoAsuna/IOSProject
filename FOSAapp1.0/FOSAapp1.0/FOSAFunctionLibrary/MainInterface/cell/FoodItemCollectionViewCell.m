//
//  FoodItemCollectionViewCell.m
//  FOSAapp1.0
//
//  Created by hs on 2019/12/31.
//  Copyright © 2019 hs. All rights reserved.
//

#import "FoodItemCollectionViewCell.h"
#import "FoodModel.h"

@implementation FoodItemCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat cellWidth = self.bounds.size.width;
        CGFloat cellHeight = self.bounds.size.height;
        
        //文字添加阴影
        NSShadow *shadow = [[NSShadow alloc] init];

        shadow.shadowBlurRadius = 5;//阴影半径，默认值3

        shadow.shadowColor = [UIColor blackColor];//阴影颜色

        shadow.shadowOffset = CGSizeMake(1, 5);//阴影偏移量，x向右偏移，y向下偏移，默认是（0，-3）

        NSAttributedString * attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSShadowAttributeName:shadow}];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(cellWidth/8, cellHeight*5/6-5, cellWidth*7/8, cellHeight/6)];
        self.nameLabel.textColor = [UIColor whiteColor];
        [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18*(screen_width/414.0)]];
        self.nameLabel.userInteractionEnabled = NO;
        self.nameLabel.attributedText = attributedText;
        [self insertSubview:_nameLabel atIndex:20];

        self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(cellWidth/8, 5, cellWidth*7/8,cellHeight/6)];
        self.dateLabel.textColor = [UIColor whiteColor];
    
        [self.dateLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18*(screen_width/414.0)]];
        self.dateLabel.userInteractionEnabled = NO;
        self.dateLabel.attributedText = attributedText;
        [self insertSubview:_dateLabel atIndex:20];
        
        self.foodImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
        self.foodImageview.contentMode = UIViewContentModeScaleAspectFill;
        self.foodImageview.clipsToBounds = YES;
        [self.contentView addSubview:self.foodImageview];
    }
    return self;
}
- (void)setModel:(FoodModel *)model
{
    NSArray<NSString *> *timeArray;
    _model = model;
    self.foodImageview.image = [self getImage:model.foodPhoto];
    self.nameLabel.text  = model.foodName;
    timeArray = [model.remindDate componentsSeparatedByString:@"/"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@  %@",timeArray[1],[mouth valueForKey:timeArray[0]]];
    //NSDictionary *mouth = [NSDictionary dictionaryWithObjectsAndKeys:@"Jan",@"01",@"Feb",@"02",@"Mar",@"03",@"Apr",@"04",@"May",@"05",@"June",@"06",@"July",@"07",@"Aug",@"08",@"Sept",@"09",@"Oct",@"10",@"Nov",@"11",@"Dec",@"12",nil];
    NSLog(@"对应月份：%@",[mouth valueForKey:timeArray[0]]);
}
- (void)initMouth{
    
}
//取出保存在本地的图片
- (UIImage*)getImage:(NSString *)filepath{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *photopath = [NSString stringWithFormat:@"%@%d.png",filepath,1];
    NSString *imagePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",photopath]];
    // 保存文件的名称
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    NSLog(@"===%@", img);
    return img;
}
@end
