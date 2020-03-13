//
//  foodItemCollectionViewCell.m
//  FOSAapp1.0
//
//  Created by hs on 2020/3/7.
//  Copyright © 2020 hs. All rights reserved.
//

#import "foodItemCollectionViewCell.h"
#import "FoodModel.h"

@implementation foodItemCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.foodImgView = [UIImageView new];
        self.foodImgView.image = [UIImage imageNamed:@"icon_defaultImg"];
        self.foodImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.foodImgView.clipsToBounds = YES;
        [self addSubview:self.foodImgView];
       
        self.likebtn = [UIButton new];
        [self.likebtn setImage:[UIImage imageNamed:@"icon_likeW"] forState:UIControlStateNormal];
        [self.foodImgView addSubview:self.likebtn];
        self.foodNamelabel = [UILabel new];
        //self.foodNamelabel.text = @"Apple";
        [self addSubview:self.foodNamelabel];
        //self.foodNamelabel.backgroundColor = [UIColor yellowColor];
        self.dayLabel = [UILabel new];
        //self.dayLabel.text = @"26";
        self.dayLabel.font = [UIFont systemFontOfSize:25*(414.0/screen_width)];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
       // self.dayLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.dayLabel];
        self.line = [UIView new];
        [self addSubview:self.line];
        self.mouthLabel = [UILabel new];
        //self.mouthLabel.text = @"MAR";
        self.mouthLabel.textAlignment = NSTextAlignmentCenter;
        //self.mouthLabel.backgroundColor = [UIColor blueColor];
        [self addSubview:self.mouthLabel];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    int width = self.bounds.size.width;
    int height = self.bounds.size.height;
   
    self.foodImgView.frame = CGRectMake(0, 0, width, width*9/10);
    self.foodImgView.backgroundColor = FOSAgreen;
    self.likebtn.frame = CGRectMake(width/30, width*3/4, width/8, width/8);
    self.foodNamelabel.frame = CGRectMake(0, width*9/10, width*2/3, (height-width*9/10)*2/3);
    
    self.dayLabel.frame = CGRectMake(width*2/3, width*9/10, width/3, (height-width*9/10)/2-1);
    self.mouthLabel.frame = CGRectMake(width*2/3, CGRectGetMaxY(self.dayLabel.frame), width/3, (height-width*9/10)/2-1);
    
    self.line.frame = CGRectMake(width*3/4, CGRectGetMaxY(self.dayLabel.frame)-1, width/6, 1);
    self.line.backgroundColor = [UIColor grayColor];
    
}
- (void)setModel:(FoodModel *)model
{
    NSArray<NSString *> *timeArray;
    _model = model;
    if ([self getImage:model.foodPhoto] != nil) {
        self.foodImgView.image = [self getImage:model.foodPhoto];
    }
    if ([model.islike isEqualToString:@"1"]) {
        [self.likebtn setImage:[UIImage imageNamed:@"icon_likeHL"] forState:UIControlStateNormal];
    }
    self.foodNamelabel.text = model.foodName;
    timeArray = [model.storageDate componentsSeparatedByString:@"/"];
    self.dayLabel.text = timeArray[0];
    self.mouthLabel.text = timeArray[1];
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

- (void)drawRect:(CGRect)rect {
   
    [[UIColor whiteColor] setFill];//使背景颜色为白色
    UIRectFill(rect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, self.bounds.size.width, self.bounds.size.height*14/15);
    CGContextAddLineToPoint(context, self.bounds.size.width*14/15, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextClosePath(context);
    [[UIColor whiteColor] setStroke];
    [[UIColor redColor] setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
