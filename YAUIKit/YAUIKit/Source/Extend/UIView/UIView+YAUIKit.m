//
//  UIView+YAUIKit.m
//  YAUIKit
//
//  Created by liu yan on 4/7/13.
//
//

#import "UIView+YAUIKit.h"

@implementation UIView (YAUIKit)

#pragma mark - Set Frame Property
- (void) setFrameOriginX:(CGFloat)originX {
  CGRect originFrame = self.frame;
  originFrame.origin.x = originX;
  self.frame = originFrame;
}

- (void) setFrameOriginY:(CGFloat)originY {
  CGRect originFrame = self.frame;
  originFrame.origin.y = originY;
  self.frame = originFrame;
}

- (void) setFrameWidth:(CGFloat)width {
  CGRect originFrame = self.frame;
  originFrame.size.width = width;
  self.frame = originFrame;
}

- (void) setFrameHeight:(CGFloat)height {
  CGRect originFrame = self.frame;
  originFrame.size.height = height;
  self.frame = originFrame;
}

#pragma mark - Set Bounds Property
- (void) setBoundsOriginX:(CGFloat)originX {
  CGRect originFrame = self.bounds;
  originFrame.origin.x = originX;
  self.bounds = originFrame;
}

- (void) setBoundsOriginY:(CGFloat)originY {
  CGRect originFrame = self.bounds;
  originFrame.origin.y = originY;
  self.bounds = originFrame;
}

- (void) setBoundsWidth:(CGFloat)width {
  CGRect originFrame = self.bounds;
  originFrame.size.width = width;
  self.bounds = originFrame;
}

- (void) setBoundsHeight:(CGFloat)height {
  CGRect originFrame = self.bounds;
  originFrame.size.height = height;
  self.bounds = originFrame;
}

#pragma mark -SubViews
- (void) removeAllSubViews {
  while ([self.subviews count] != 0) {
    UIView *subView = [self.subviews lastObject];
    [subView removeFromSuperview];
  }
}

@end
