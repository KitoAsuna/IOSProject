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
        self.timelabel = [UILabel new];
        [self addSubview:self.timelabel];
        self.line = [UIView new];
        //[self addSubview:self.line];
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
    self.foodNamelabel.frame = CGRectMake(width/30, height*5/6, width*3/5, height/10);
    
    self.dayLabel.frame = CGRectMake(width*2/3, height*4/5, width/6, height/5);
    self.dayLabel.adjustsFontSizeToFitWidth = YES;
    self.dayLabel.font = [UIFont systemFontOfSize:27];
    self.dayLabel.textColor = FOSAGray;
    
    self.timelabel.frame = CGRectMake(width*5/6, height*5/6, width/6, height/15);
    self.timelabel.font = [UIFont systemFontOfSize:10];
    self.timelabel.textColor = FOSAGray;
    self.timelabel.textAlignment = NSTextAlignmentLeft;

    self.mouthLabel.frame = CGRectMake(width*5/6, CGRectGetMaxY(self.timelabel.frame), width/6, height/15);
    self.mouthLabel.font = [UIFont systemFontOfSize:10];
    self.mouthLabel.textColor = FOSAGray;
    self.mouthLabel.textAlignment = NSTextAlignmentLeft;
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
    self.timelabel.text = timeArray[3];
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
    //判断当前日期与过期日期
    //获取当前日期
    NSDate *currentDate = [[NSDate alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy/MM/dd"];

    NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
    [formatter2 setDateFormat:@"MM/dd/yyyy HH:mm"];

    NSString *str = [formatter stringFromDate:currentDate];
    currentDate = [formatter dateFromString:str];
    NSLog(@"--------------%@",str);
    NSDate *foodDate = [[NSDate alloc]init];
    
    NSArray<NSString *> *dateArray = [self.model.expireDate componentsSeparatedByString:@"/"];
    NSString *RDate = [NSString stringWithFormat:@"%@/%@/%@ %@",dateArray[1],dateArray[0],dateArray[2],dateArray[3]];
    
    foodDate = [formatter2 dateFromString:RDate];
    NSLog(@"foodDate:%@",foodDate);
    RDate = [formatter stringFromDate:foodDate];
    foodDate = [formatter dateFromString:RDate];
    //比较过期日期与今天的日期
    NSComparisonResult result = [currentDate compare:foodDate];
    if (result == NSOrderedDescending) {//foodDate 在 currentDate 之前,即是食物已过期
        [FOSARed setFill];
    }else{
        [FOSAGray setFill];
    }
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
