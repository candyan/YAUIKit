//
//  YABadgeView.m
//  YAUIKit
//
//  Created by liu yan on 6/30/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "YABadgeView.h"

#import <QuartzCore/QuartzCore.h>

#define kDefaultBadgeTextColor [UIColor whiteColor]
#define kDefaultBadgeBackgroundColor [UIColor redColor]
#define kDefaultOverlayColor [UIColor colorWithWhite:1.0f alpha:0.3]

#define kDefaultBadgeTextFont [UIFont boldSystemFontOfSize:[UIFont systemFontSize]]

#define kDefaultBadgeShadowColor [UIColor clearColor]

#define kBadgeStrokeColor [UIColor whiteColor]
#define kBadgeStrokeWidth 2.0f

#define kMarginToDrawInside (kBadgeStrokeWidth * 2)

#define kShadowOffset CGSizeMake(0.0f, 3.0f)
#define kShadowOpacity 0.4f
#define kShadowColor [UIColor colorWithWhite:0.0f alpha:kShadowOpacity]
#define kShadowRadius 1.0f

#define kBadgeHeight 16.0f
#define kBadgeTextSideMargin 8.0f

#define kBadgeCornerRadius 10.0f

#define kDefaultBadgeAlignment YABadgeViewAlignmentTopRight

@interface YABadgeView()

- (void)_init;
- (CGSize)sizeOfTextForCurrentSettings;

@end

@implementation YABadgeView

@synthesize badgeAlignment = _badgeAlignment;

@synthesize badgePositionAdjustment = _badgePositionAdjustment;
@synthesize frameToPositionInRelationWith = _frameToPositionInRelationWith;

@synthesize badgeText = _badgeText;
@synthesize badgeTextColor = _badgeTextColor;
@synthesize badgeTextShadowColor = _badgeTextShadowColor;
@synthesize badgeTextShadowOffset = _badgeTextShadowOffset;
@synthesize badgeTextFont = _badgeTextFont;
@synthesize badgeBackgroundColor = _badgeBackgroundColor;

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  [self _init];
}

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame]))
  {
    [self _init];
  }
  
  return self;
}

- (id)initWithParentView:(UIView *)parentView alignment:(YABadgeViewAlignment)alignment
{
  if ((self = [self initWithFrame:CGRectZero]))
  {
    self.badgeAlignment = alignment;
    [parentView addSubview:self];
  }
  
  return self;
}

- (void)_init
{
  self.backgroundColor = [UIColor clearColor];
  
  self.badgeAlignment = kDefaultBadgeAlignment;
  
  self.badgeBackgroundColor = kDefaultBadgeBackgroundColor;
  self.badgeOverlayColor = kDefaultOverlayColor;
  self.badgeTextColor = kDefaultBadgeTextColor;
  self.badgeTextShadowColor = kDefaultBadgeShadowColor;
  self.badgeTextFont = kDefaultBadgeTextFont;
}

#pragma mark - Layout

- (void)layoutSubviews
{
  CGRect newFrame = self.frame;
  CGRect superviewFrame = CGRectIsEmpty(_frameToPositionInRelationWith) ? self.superview.frame : _frameToPositionInRelationWith;
  
  CGFloat textWidth = [self sizeOfTextForCurrentSettings].width;
  
  CGFloat viewWidth = textWidth + kBadgeTextSideMargin + (kMarginToDrawInside * 2);
  CGFloat viewHeight = kBadgeHeight + (kMarginToDrawInside * 2);
  
  CGFloat superviewWidth = superviewFrame.size.width;
  CGFloat superviewHeight = superviewFrame.size.height;
  
  newFrame.size.width = viewWidth;
  newFrame.size.height = viewHeight;
  
  switch (self.badgeAlignment) {
    case YABadgeViewAlignmentTopLeft:
      newFrame.origin.x = -viewWidth / 2.0f;
      newFrame.origin.y = -viewHeight / 2.0f;
      break;
    case YABadgeViewAlignmentTopRight:
      newFrame.origin.x = superviewWidth - (viewWidth / 2.0f);
      newFrame.origin.y = -viewHeight / 2.0f;
      break;
    case YABadgeViewAlignmentTopCenter:
      newFrame.origin.x = (superviewWidth - viewWidth) / 2.0f;
      newFrame.origin.y = -viewHeight / 2.0f;
      break;
    case YABadgeViewAlignmentCenterLeft:
      newFrame.origin.x = -viewWidth / 2.0f;
      newFrame.origin.y = (superviewHeight - viewHeight) / 2.0f;
      break;
    case YABadgeViewAlignmentCenterRight:
      newFrame.origin.x = superviewWidth - (viewWidth / 2.0f);
      newFrame.origin.y = (superviewHeight - viewHeight) / 2.0f;
      break;
    case YABadgeViewAlignmentBottomLeft:
      newFrame.origin.x = -viewWidth / 2.0f;
      newFrame.origin.y = superviewHeight - (viewHeight / 2.0f);
      break;
    case YABadgeViewAlignmentBottomRight:
      newFrame.origin.x = superviewWidth - (viewWidth / 2.0f);
      newFrame.origin.y = superviewHeight - (viewHeight / 2.0f);
      break;
    case YABadgeViewAlignmentBottomCenter:
      newFrame.origin.x = (superviewWidth - viewWidth) / 2.0f;
      newFrame.origin.y = superviewHeight - (viewHeight / 2.0f);
      break;
    case YABadgeViewAlignmentCenter:
      newFrame.origin.x = (superviewWidth - viewWidth) / 2.0f;
      newFrame.origin.y = (superviewHeight - viewHeight) / 2.0f;
      break;
    default:
      NSAssert(NO, @"Unimplemented YABadgeAligment type %d", self.badgeAlignment);
  }
  
  newFrame.origin.x += _badgePositionAdjustment.x;
  newFrame.origin.y += _badgePositionAdjustment.y;
  
  self.frame = CGRectIntegral(newFrame);
  
  [self setNeedsDisplay];
}

#pragma mark - Private

- (CGSize)sizeOfTextForCurrentSettings
{
  return [self.badgeText sizeWithFont:self.badgeTextFont];
}

#pragma mark - Setters

- (void)setBadgeAlignment:(YABadgeViewAlignment)badgeAlignment
{
  if (badgeAlignment != _badgeAlignment)
  {
    _badgeAlignment = badgeAlignment;
    
    switch (badgeAlignment)
    {
      case YABadgeViewAlignmentTopLeft:
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        break;
      case YABadgeViewAlignmentTopRight:
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        break;
      case YABadgeViewAlignmentTopCenter:
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        break;
      case YABadgeViewAlignmentCenterLeft:
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        break;
      case YABadgeViewAlignmentCenterRight:
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        break;
      case YABadgeViewAlignmentBottomLeft:
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        break;
      case YABadgeViewAlignmentBottomRight:
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        break;
      case YABadgeViewAlignmentBottomCenter:
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        break;
      case YABadgeViewAlignmentCenter:
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        break;
      default:
        NSAssert(NO, @"Unimplemented YABadgeAligment type %d", self.badgeAlignment);
    }
    
    [self setNeedsLayout];
  }
}

- (void)setBadgePositionAdjustment:(CGPoint)badgePositionAdjustment
{
  _badgePositionAdjustment = badgePositionAdjustment;
  
  [self setNeedsLayout];
}

- (void)setBadgeText:(NSString *)badgeText
{
  if (badgeText != _badgeText)
  {
    _badgeText = [badgeText copy];
    
    [self setNeedsLayout];
  }
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor
{
  if (badgeTextColor != _badgeTextColor)
  {
    _badgeTextColor = badgeTextColor;
    
    [self setNeedsDisplay];
  }
}

- (void)setBadgeTextShadowColor:(UIColor *)badgeTextShadowColor
{
  if (badgeTextShadowColor != _badgeTextShadowColor)
  {
    _badgeTextShadowColor = badgeTextShadowColor;
    
    [self setNeedsDisplay];
  }
}

- (void)setBadgeTextShadowOffset:(CGSize)badgeTextShadowOffset
{
  _badgeTextShadowOffset = badgeTextShadowOffset;
  
  [self setNeedsDisplay];
}

- (void)setBadgeTextFont:(UIFont *)badgeTextFont
{
  if (badgeTextFont != _badgeTextFont)
  {
    _badgeTextFont = badgeTextFont;
    
    [self setNeedsDisplay];
  }
}

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor
{
  if (badgeBackgroundColor != _badgeBackgroundColor)
  {
    _badgeBackgroundColor = badgeBackgroundColor;
    
    [self setNeedsDisplay];
  }
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
  BOOL anyTextToDraw = (self.badgeText.length > 0);
  
  if (anyTextToDraw)
  {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect rectToDraw = CGRectInset(rect, kMarginToDrawInside, kMarginToDrawInside);
    
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:rectToDraw byRoundingCorners:(UIRectCorner)UIRectCornerAllCorners cornerRadii:CGSizeMake(kBadgeCornerRadius, kBadgeCornerRadius)];
    
    /* Background and shadow */
    CGContextSaveGState(ctx);
    {
      CGContextAddPath(ctx, borderPath.CGPath);
      
      CGContextSetFillColorWithColor(ctx, self.badgeBackgroundColor.CGColor);
      CGContextSetShadowWithColor(ctx, kShadowOffset, kShadowRadius, kShadowColor.CGColor);
      
      CGContextDrawPath(ctx, kCGPathFill);
    }
    CGContextRestoreGState(ctx);
    
    BOOL colorForOverlayPresent = self.badgeOverlayColor && ![self.badgeOverlayColor isEqual:[UIColor clearColor]];
    
    if (colorForOverlayPresent)
    {
      /* Gradient overlay */
      CGContextSaveGState(ctx);
      {
        CGContextAddPath(ctx, borderPath.CGPath);
        CGContextClip(ctx);
        
        CGFloat height = rectToDraw.size.height;
        CGFloat width = rectToDraw.size.width;
        
        CGRect rectForOverlayCircle = CGRectMake(rectToDraw.origin.x,
                                                 rectToDraw.origin.y - ceilf(height * 0.5),
                                                 width,
                                                 height);
        
        CGContextAddEllipseInRect(ctx, rectForOverlayCircle);
        CGContextSetFillColorWithColor(ctx, self.badgeOverlayColor.CGColor);
        
        CGContextDrawPath(ctx, kCGPathFill);
      }
      CGContextRestoreGState(ctx);
    }
    
    /* Stroke */
    CGContextSaveGState(ctx);
    {
      CGContextAddPath(ctx, borderPath.CGPath);
      
      CGContextSetLineWidth(ctx, kBadgeStrokeWidth);
      CGContextSetStrokeColorWithColor(ctx, kBadgeStrokeColor.CGColor);
      
      CGContextDrawPath(ctx, kCGPathStroke);
    }
    CGContextRestoreGState(ctx);
    
    /* Text */
    CGContextSaveGState(ctx);
    {
      CGContextSetFillColorWithColor(ctx, self.badgeTextColor.CGColor);
      CGContextSetShadowWithColor(ctx, self.badgeTextShadowOffset, 1.0, self.badgeTextShadowColor.CGColor);
      
      CGRect textFrame = rectToDraw;
      CGSize textSize = [self sizeOfTextForCurrentSettings];
      
      textFrame.size.height = textSize.height;
      textFrame.origin.y = rectToDraw.origin.y + ceilf((rectToDraw.size.height - textFrame.size.height) / 2.0f);
      
      [self.badgeText drawInRect:textFrame
                        withFont:self.badgeTextFont
                   lineBreakMode:UILineBreakModeCharacterWrap
                       alignment:UITextAlignmentCenter];
    }
    CGContextRestoreGState(ctx);
  }
}

@end
