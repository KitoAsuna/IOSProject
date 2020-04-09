//
//  alarmView.m
//  FOSAapp1.0
//
//  Created by hs on 2020/4/9.
//  Copyright © 2020 hs. All rights reserved.
//

#import "alarmView.h"

@interface alarmView()
@property(nonatomic, unsafe_unretained) CGFloat oldAlpha;
@end
@implementation alarmView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
      [self commonInit];
  }
  return self;
}

- (void)commonInit {
  self.oldAlpha = self.alpha;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  self.alpha = self.oldAlpha / 4;
}
 
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  self.alpha = self.oldAlpha;
}
 
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
  self.alpha = self.oldAlpha;
}
 
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
}
@end
