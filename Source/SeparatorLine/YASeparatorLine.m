//
//  YASeparatorLine.m
//  YAUIKit
//
//  Created by Candyan on 14-3-23.
//  Copyright (c) 2014 Candyan. All rights reserved.
//

#import "YASeparatorLine.h"

@implementation YASeparatorLine

@synthesize lineColor = _lineColor;
@synthesize lineWidth = _lineWidth;

#pragma mark - init

- (id)initWithFrame:(CGRect)frame lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth
{
  self = [super initWithFrame:frame];
  if (self) {
    _lineColor = lineColor;
    _lineWidth = lineWidth;
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

#pragma mark - prop

- (UIColor *)lineColor
{
  if (!_lineColor) {
    _lineColor = [UIColor whiteColor];
  }
  return _lineColor;
}

- (void)setLineColor:(UIColor *)lineColor
{
  _lineColor = lineColor;
  [self setNeedsDisplay];
}

- (CGFloat)lineWidth
{
  if (!_lineWidth) {
    _lineWidth = 1.0f;
  }
  return _lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
  _lineWidth = lineWidth;
  [self setNeedsDisplay];
}

#pragma mark - draw

- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);

  CGFloat startX = (self.bounds.size.height > self.bounds.size.width) ? self.bounds.size.width : 0;
  CGFloat startY = (self.bounds.size.height > self.bounds.size.width) ? 0 :self.bounds.size.height;

  CGContextSetLineWidth(context, self.lineWidth);
  CGContextMoveToPoint(context, startX, startY); //start at this point
  CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height); //draw to this point
  // and now draw the Path!
  CGContextStrokePath(context);
  CGContextStrokePath(context);
}

@end
