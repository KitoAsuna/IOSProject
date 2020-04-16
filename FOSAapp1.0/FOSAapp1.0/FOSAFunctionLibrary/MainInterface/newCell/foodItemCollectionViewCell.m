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
        self.foodImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.foodImgView.clipsToBounds = YES;
        [self addSubview:self.foodImgView];
        self.squre = [UIView new];
        [self.foodImgView addSubview:self.squre];
        
        self.likebtn = [UIButton new];
        [self.likebtn setImage:[UIImage imageNamed:@"img_foodCode"] forState:UIControlStateNormal];
        [self.foodImgView addSubview:self.likebtn];
        self.likebtn.hidden = YES;
        self.foodNamelabel = [UILabel new];
        [self addSubview:self.foodNamelabel];
        self.locationLabel = [UILabel new];
        [self addSubview:self.locationLabel];
        self.dayLabel = [UILabel new];
        //self.dayLabel.font = [UIFont systemFontOfSize:25*(414.0/screen_width)];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.dayLabel];
        self.timelabel = [UILabel new];
        [self addSubview:self.timelabel];
        self.mouthLabel = [UILabel new];
        self.mouthLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.mouthLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    int width = self.bounds.size.width;
    int height = self.bounds.size.height;
    self.foodImgView.frame = CGRectMake(0, 0, width, width*9/10);
    
    self.likebtn.frame = CGRectMake(width/30, width*3/4, width/10, width/10);
    //self.likebtn.hidden = YES;
    
    self.squre.frame = CGRectMake(0, 0, width/8, width/8);
    self.squre.center = self.likebtn.center;
    self.squre.layer.borderColor = FOSAWhite.CGColor;
    self.squre.layer.borderWidth = 2;
    //self.squre.hidden = YES;
    
    self.foodNamelabel.frame = CGRectMake(width/30, CGRectGetMaxY(self.foodImgView.frame)+(height*49/60-width*9/10)/2, width*3/5, (height-width*9/10)/2);
    self.foodNamelabel.adjustsFontSizeToFitWidth = YES;
    self.locationLabel.frame = CGRectMake(width/30, CGRectGetMaxY(self.foodNamelabel.frame), width*3/5, height/15);
    self.locationLabel.font = [UIFont systemFontOfSize:font(10)];
    self.locationLabel.textColor = FOSAGray;
    
    self.dayLabel.frame = CGRectMake(width*19/30, CGRectGetMaxY(self.foodImgView.frame)+(height*49/60-width*9/10)/2, width/6, height/7);
    self.dayLabel.adjustsFontSizeToFitWidth = YES;//self.dayLabel.backgroundColor = FOSAgreen;
    self.dayLabel.font = [UIFont systemFontOfSize:font(30)];
    self.dayLabel.textColor = FOSAGray;
    
    self.timelabel.frame = CGRectMake(width*24/30, height*49/60+(height*49/60-width*9/10)/2, width/6, height/18);
    self.timelabel.font = [UIFont systemFontOfSize:font(10)];
    self.timelabel.textColor = FOSAGray;
    self.timelabel.textAlignment = NSTextAlignmentLeft;

    self.mouthLabel.frame = CGRectMake(width*24/30, CGRectGetMaxY(self.timelabel.frame), width/6, height/18);
    self.mouthLabel.font = [UIFont systemFontOfSize:font(10)];
    self.mouthLabel.textColor = FOSAGray;
    self.mouthLabel.textAlignment = NSTextAlignmentLeft;
}
- (void)setModel:(FoodModel *)model
{
    NSArray<NSString *> *timeArray;
    _model = model;
    if ([self getImage:model.foodPhoto] != nil) {
        self.foodImgView.image = [self getImage:model.foodPhoto];
    }

    if (![model.device isEqualToString:@"null"]) {
        self.likebtn.hidden = NO;
        self.squre.hidden = NO;
    }else{
        self.likebtn.hidden = YES;
        self.squre.hidden = YES;
    }
    
    self.foodNamelabel.text = model.foodName;
    self.locationLabel.text = model.location;

    if (![model.expireDate isEqualToString:@""]) {
        timeArray = [model.expireDate componentsSeparatedByString:@"/"];
        self.dayLabel.text = timeArray[0];
        self.mouthLabel.text = timeArray[1];
        self.timelabel.text = timeArray[3];
    }
}
//取出保存在本地的图片
- (UIImage*)getImage:(NSString *)filepath{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //NSString *photopath = [NSString stringWithFormat:@"%@%d.png",filepath,1];
    NSString *photopath = [NSString stringWithFormat:@"%@.png",filepath];
    NSString *imagePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",photopath]];
    // 保存文件的名称
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    if (img == nil) {
        img = [UIImage imageNamed:[NSString stringWithFormat:@"icon_defaultImg%ld",self.indexOfImg+1]];
    }
    NSLog(@"===%@", img);
    return img;
}

- (void)drawRect:(CGRect)rect {
    /**
     系统调用此方法
     */
    [[UIColor whiteColor] setFill];//使背景颜色为白色
    UIRectFill(rect);
    int rectHight = (int) self.bounds.size.height;
    int rectWidth = (int) self.bounds.size.width;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, rectWidth*19/30, rectHight*39/40);
    CGContextAddLineToPoint(context, rectWidth, rectHight*39/40);
    CGContextAddLineToPoint(context, rectWidth, rectHight);
    CGContextAddLineToPoint(context, rectWidth*19/30-rectHight/40, rectHight);
    CGContextAddLineToPoint(context, rectWidth*19/30, rectHight*39/40);
    CGContextClosePath(context);
    [[UIColor whiteColor] setStroke];
    [FOSAWhite setFill];
    if([self.isDraw isEqualToString:@"YES"] && ![self.model.expireDate isEqualToString:@""]){
        //判断当前日期与过期日期
        //获取当前日期
        NSDate *currentDate = [[NSDate alloc]init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yy/MM/dd"];

        NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
        [formatter2 setDateFormat:@"MM/dd/yyyy HH:mm"];

        NSString *str = [formatter stringFromDate:currentDate];
        currentDate = [formatter dateFromString:str];
        NSDate *foodDate;
        
        NSArray<NSString *> *dateArray = [self.model.expireDate componentsSeparatedByString:@"/"];

        NSString *RDate = [NSString stringWithFormat:@"%@/%@/%@ %@",dateArray[1],dateArray[0],dateArray[2],dateArray[3]];

        foodDate = [formatter2 dateFromString:RDate];
        RDate = [formatter stringFromDate:foodDate];
        foodDate = [formatter dateFromString:RDate];
        //比较过期日期与今天的日期
        NSComparisonResult result = [currentDate compare:foodDate];
        if (result == NSOrderedDescending) {//foodDate 在 currentDate 之前,即是食物已过期
            [FOSAGray setFill];
        }else if(result == NSOrderedSame){
            [FOSARed setFill];
        }else{
            [FOSAgreen setFill];
        }
    }
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
