//
//  UIColor+YAHexColor.h
//  YAUIKit
//
//  Created by liu yan on 4/10/13.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (YAHexColor)

+ (UIColor *)colorWithHex:(NSInteger)rgbHexValue;
+ (UIColor *)colorWithHex:(NSInteger)rgbHexValue alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)hexStr;

@end
