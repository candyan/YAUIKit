//
//  UIColor+YAHexColor.m
//  YAUIKit
//
//  Created by liu yan on 4/10/13.
//
//

#import "UIColor+YAHexColor.h"

@implementation UIColor (YAHexColor)

+ (UIColor *)colorWithHex:(NSInteger)rgbHexValue
{
    if (rgbHexValue <= 0xFFFFFF) {
        return [UIColor colorWithHex:rgbHexValue alpha:1.0];
    } else {
        return [UIColor colorWithHex:(rgbHexValue & 0xFFFFFF00) >> 8 alpha:((float)(rgbHexValue & 0xFF)) / 255.0];
    }
}

+ (UIColor *)colorWithHex:(NSInteger)rgbHexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((rgbHexValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((rgbHexValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(rgbHexValue & 0xFF)) / 255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hexStr
{
    @autoreleasepool
    {
    NSString *cleanString_1 = [hexStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSString *cleanString = [cleanString_1 stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    if ([cleanString length] == 3) {
        cleanString =
        [NSString stringWithFormat:@"%@%@%@%@%@%@", [cleanString substringWithRange:NSMakeRange(0, 1)],
         [cleanString substringWithRange:NSMakeRange(0, 1)],
         [cleanString substringWithRange:NSMakeRange(1, 1)],
         [cleanString substringWithRange:NSMakeRange(1, 1)],
         [cleanString substringWithRange:NSMakeRange(2, 1)],
         [cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if ([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }

    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];

    float red = ((baseValue >> 24) & 0xFF) / 255.0f;
    float green = ((baseValue >> 16) & 0xFF) / 255.0f;
    float blue = ((baseValue >> 8) & 0xFF) / 255.0f;
    float alpha = ((baseValue >> 0) & 0xFF) / 255.0f;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
}

@end
