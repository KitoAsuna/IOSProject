//
//  SealerAndPoundViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2019/12/30.
//  Copyright © 2019 hs. All rights reserved.
//

#import "SealerAndPoundViewController.h"

@interface SealerAndPoundViewController ()

@end

@implementation SealerAndPoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self CreatSealerView];
    [self CreatOtherSealerView];
    [self CreatPoundView];
}
- (void)CreatSealerView{
    int sealerViewWidth = screen_width*14/15;
    int sealerViewHeight = screen_height/5;
    self.sealerView = [[UIView alloc]initWithFrame:CGRectMake(screen_width/30, NavigationBarHeight, sealerViewWidth, sealerViewHeight)];
    self.sealerView.layer.shadowColor = FOSAshadowColor.CGColor;
    self.sealerView.backgroundColor = [UIColor whiteColor];
    self.sealerView.layer.shadowOffset = CGSizeMake(0,2.0f);
    self.sealerView.layer.cornerRadius = 10;
    self.sealerView.layer.shadowRadius = 10.0f;
    self.sealerView.layer.shadowOpacity =1.0f;
    self.sealerView.layer.masksToBounds =NO;
    [self.view addSubview:self.sealerView];
    
    self.sealerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width/30, sealerViewHeight/10, sealerViewHeight*4/5, sealerViewHeight*4/5)];
    self.sealerImageView.image = [UIImage imageNamed:@"IMG_Sealer"];
    self.sealerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.sealerImageView.clipsToBounds = YES;
    self.sealerImageView.layer.cornerRadius = 5;
    [self.sealerView addSubview:self.sealerImageView];
    
    self.sealerScanBtn = [[UIButton alloc]initWithFrame:CGRectMake(sealerViewWidth*4/5, sealerViewHeight*3/26, sealerViewWidth/15, sealerViewWidth/15)];
    [self.sealerScanBtn setBackgroundImage:[UIImage imageNamed:@"icon_scan"] forState:UIControlStateNormal];
    [self.sealerView addSubview:self.sealerScanBtn];
    
    self.sealerOpenbtn = [[UIButton alloc]initWithFrame:CGRectMake(sealerViewWidth*55/62, sealerViewHeight*3/26, sealerViewWidth/15, sealerViewWidth/15)];
    [self.sealerOpenbtn setBackgroundImage:[UIImage imageNamed:@"icon_Open"] forState:UIControlStateNormal];
    [self.sealerView addSubview:self.sealerOpenbtn];
}
- (void)CreatOtherSealerView{
    
    int otherSealerViewWidth = screen_width*14/15;
    int otherSealerViewHeight = screen_height/5;
    
    self.otherSealerView = [[UIView alloc]initWithFrame:CGRectMake(screen_width/30, CGRectGetMaxY(self.sealerView.frame)+screen_width/30, otherSealerViewWidth, otherSealerViewHeight)];
    self.otherSealerView.layer.shadowColor = FOSAshadowColor.CGColor;
    self.otherSealerView.backgroundColor = [UIColor whiteColor];
    self.otherSealerView.layer.shadowOffset = CGSizeMake(0,2.0f);
    self.otherSealerView.layer.cornerRadius = 10;
    self.otherSealerView.layer.shadowRadius = 10.0f;
    self.otherSealerView.layer.shadowOpacity =1.0f;
    self.otherSealerView.layer.masksToBounds =NO;
    [self.view addSubview:self.otherSealerView];
    
    self.otherSealerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width/30, otherSealerViewHeight/10, otherSealerViewHeight*4/5, otherSealerViewHeight*4/5)];
    self.otherSealerImageView.image = [UIImage imageNamed:@"IMG_OtherSealer"];
    self.otherSealerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.otherSealerImageView.clipsToBounds = YES;
    self.otherSealerImageView.layer.cornerRadius = 5;
    [self.otherSealerView addSubview:self.otherSealerImageView];
    
    
    self.otherSealerScanBtn = [[UIButton alloc]initWithFrame:CGRectMake(otherSealerViewWidth*4/5, otherSealerViewHeight*3/26, otherSealerViewWidth/15, otherSealerViewWidth/15)];
    [self.otherSealerScanBtn setBackgroundImage:[UIImage imageNamed:@"icon_scan"] forState:UIControlStateNormal];
    [self.otherSealerView addSubview:self.otherSealerScanBtn];
    
    self.otherSealerOpenBtn = [[UIButton alloc]initWithFrame:CGRectMake(otherSealerViewWidth*55/62, otherSealerViewHeight*3/26, otherSealerViewWidth/15, otherSealerViewWidth/15)];
    [self.otherSealerOpenBtn setBackgroundImage:[UIImage imageNamed:@"icon_Open"] forState:UIControlStateNormal];
    [self.otherSealerView addSubview:self.otherSealerOpenBtn];
}
- (void)CreatPoundView{
    int poundViewWidth = screen_width*14/15;
    int poundViewHeight = screen_height/5;
    self.poundView = [[UIView alloc]initWithFrame:CGRectMake(screen_width/30, CGRectGetMaxY(self.otherSealerView.frame)+screen_width/30, poundViewWidth, poundViewHeight)];
    self.poundView.layer.shadowColor = FOSAshadowColor.CGColor;
    self.poundView.backgroundColor = [UIColor whiteColor];
    self.poundView.layer.shadowOffset = CGSizeMake(0,2.0f);
    self.poundView.layer.cornerRadius = 10;
    self.poundView.layer.shadowRadius = 10.0f;
    self.poundView.layer.shadowOpacity =1.0f;
    self.poundView.layer.masksToBounds =NO;
    [self.view addSubview:self.poundView];
    
    self.poundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width/30, poundViewHeight/10, poundViewHeight*4/5, poundViewHeight*4/5)];
    self.poundImageView.image = [UIImage imageNamed:@"IMG_Pound"];
    self.poundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.poundImageView.clipsToBounds = YES;
    self.poundImageView.layer.cornerRadius = 5;
    [self.poundView addSubview:self.poundImageView];
    
    self.poundScanBtn = [[UIButton alloc]initWithFrame:CGRectMake(poundViewWidth*4/5, poundViewHeight*3/26, poundViewWidth/15, poundViewWidth/15)];
    [self.poundScanBtn setBackgroundImage:[UIImage imageNamed:@"icon_scan"] forState:UIControlStateNormal];
    [self.poundView addSubview:self.poundScanBtn];
    
    self.poundOpenBtn = [[UIButton alloc]initWithFrame:CGRectMake(poundViewWidth*55/62, poundViewHeight*3/26, poundViewWidth/15, poundViewWidth/15)];
    [self.poundOpenBtn setBackgroundImage:[UIImage imageNamed:@"icon_Open"] forState:UIControlStateNormal];
    [self.poundView addSubview:self.poundOpenBtn];
}
/**隐藏底部横条，点击屏幕可显示*/
- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}

@end
