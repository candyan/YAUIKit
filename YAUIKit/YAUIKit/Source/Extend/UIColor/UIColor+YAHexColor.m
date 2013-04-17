//
//  UIColor+YAHexColor.m
//  YAUIKit
//
//  Created by liu yan on 4/10/13.
//
//

#import "UIColor+YAHexColor.h"

@implementation UIColor (YAHexColor)

+ (UIColor *) colorWithHex:(NSInteger)rgbHexValue {
  return [UIColor colorWithHex:rgbHexValue alpha:1.0];
}

+ (UIColor *)colorWithHex:(NSInteger)rgbHexValue
                    alpha:(CGFloat)alpha {
  return [UIColor colorWithRed:((float)((rgbHexValue & 0xFF0000) >> 16))/255.0
                         green:((float)((rgbHexValue & 0xFF00) >> 8))/255.0
                          blue:((float)(rgbHexValue & 0xFF))/255.0
                         alpha:alpha];
}

@end
