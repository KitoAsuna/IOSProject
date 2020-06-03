//
//  FosaButton.m
//  FOSAapp1.0
//
//  Created by hs on 2020/6/3.
//  Copyright © 2020 hs. All rights reserved.
//

#import "FosaButton.h"

@interface FosaButton()
@property(nonatomic, unsafe_unretained) CGFloat oldAlpha;
@end

@implementation FosaButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
      //[self commonInit];
  }
  return self;
}

//- (void)commonInit {
//  //self.oldAlpha = self.alpha;
//    self.backgroundColor = f;
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
    self.backgroundColor = FOSAGray;
}
 
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
    self.backgroundColor = FOSAWhite;
}
 
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
    self.backgroundColor = FOSAWhite;
}
 
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
}
//扩大点击范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect bounds = self.bounds;
    //扩大原热区直径至26，可以暴露个接口，用来设置需要扩大的半径。
    CGFloat widthDelta = MAX(100, 0);
    CGFloat heightDelta = MAX(100, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}
@end
