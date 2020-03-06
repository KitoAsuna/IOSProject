//
//  FOSATabbar.m
//  FOSAapp1.0
//
//  Created by hs on 2020/2/26.
//  Copyright © 2020 hs. All rights reserved.
//

#import "FOSATabbar.h"
@interface FOSATabbar()

@end

@implementation FOSATabbar

#pragma mark -- 懒加载
- (UIButton *)addFoodItemBtn{
    if (_addFoodItemBtn == nil) {
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //publishButton.backgroundColor = XMGRandomColor;
//        [publishButton setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
//        [publishButton setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [publishButton setImage:[UIImage imageNamed:@"icon_Addbtn"] forState:UIControlStateNormal];
        //[publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishButton];
        _addFoodItemBtn = publishButton;
        [_addFoodItemBtn addTarget:self action:@selector(JumpToAdd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addFoodItemBtn;
}

#pragma mark - 初始化
/**
 * 布局子控件
 */
- (void)layoutSubviews
{
 [super layoutSubviews];
 /**** 设置所有UITabBarButton的frame ****/
 // 按钮的尺寸
 CGFloat buttonW = self.frame.size.width / 2;
 CGFloat buttonH = self.frame.size.height;
 CGFloat buttonY = 0;
 // 按钮索引
 int buttonIndex = 0;
  
 for (UIView *subview in self.subviews) {
 // 过滤掉非UITabBarButton
// if (![@"UITabBarButton" isEqualToString:NSStringFromClass(subview.class)]) continue;
 if (subview.class != NSClassFromString(@"UITabBarButton")) continue;
  
 // 设置frame
 CGFloat buttonX = buttonIndex * buttonW;
// if (buttonIndex == 1) { // 右边的1个UITabBarButton
//     buttonX += buttonW;
// }
 subview.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
  
 // 增加索引
 buttonIndex++;
 }
 /**** 设置中间的发布按钮的frame ****/
 self.addFoodItemBtn.frame = CGRectMake(0, 0, buttonH*3/4, buttonH*3/4);
 self.addFoodItemBtn.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.1);
}

//重写系统的hitTest方法让处于tabbar外部的按钮部分也可以被点击

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    if (self.isHidden == NO) { // 当前界面 tabBar显示
        CGPoint newPoint = [self convertPoint:point toView:self.addFoodItemBtn];
        if ( [self.addFoodItemBtn pointInside:newPoint withEvent:event]) { // 点 属于按钮范围
            return self.addFoodItemBtn;
        }else{
            return [super hitTest:point withEvent:event];
        }
    }else {
        return [super hitTest:point withEvent:event];
    }
}

- (void)JumpToAdd{
    NSLog(@"#######################");
    if ([self.tabBarDelegate respondsToSelector:@selector(ButtonClick:)]) {
        [self.tabBarDelegate ButtonClick:self];
    }
}

@end
