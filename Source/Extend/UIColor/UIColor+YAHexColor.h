//
//  UIColor+YAHexColor.h
//  YAUIKit
//
//  Created by liu yan on 4/10/13.
//
//

#import <UIKit/UIKit.h>
#import "YAUIKitTypeDef.h"

@interface UIColor (YAHexColor)

/**
 Creates and returns a color with a hex number

 @param rgbHexValue a hex number of color (ARGB or RGB)
 @note the hex number can be 0xFF0000(red) or 0x8000FF00(green with 0.5 alpha)
 */
+ (UIColor *)colorWithHex:(NSInteger)rgbHexValue;

/**
 * Creates and returns a color with a hex number and alpha value
 * @param rgbHexValue a hex number of color
 * @param alpha alpha value of the color
 */
+ (UIColor *)colorWithHex:(NSInteger)rgbHexValue alpha:(CGFloat)alpha;

/**
 * Creates and returns a color with a hex string
 * @see -colorWithHex:
 */
+ (UIColor *)colorWithHexString:(NSString *)hexStr YA_DEPRECATED_ATTRIBUTE("Use colorWithHex: to replace it");

@end
