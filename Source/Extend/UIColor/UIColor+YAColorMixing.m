//
//  UIColor+YAColorMixing.m
//
//
//  Created by liuyan on 7/8/15.
//
//

#import "UIColor+YAColorMixing.h"

@implementation UIColor (YAColorMixing)

- (UIColor *)colorByAddingColor:(UIColor *)addingColor
{
    CGFloat upperRed, upperGreen, upperBlue, upperAlpha = 0;
    CGFloat underRed, underGreen, underBlue, underAlpha = 0;
    CGFloat resultRed, resultGreen, resultBlue, resultAlpha = 0;
    
    [addingColor getRed:&upperRed green:&upperGreen blue:&upperBlue alpha:&upperAlpha];
    [self getRed:&underRed green:&underGreen blue:&underBlue alpha:&underAlpha];

    resultRed = upperRed * upperAlpha + underRed * underAlpha * (1 - upperAlpha);
    resultGreen = upperGreen * upperAlpha + underGreen * underAlpha * (1 - upperAlpha);
    resultBlue = upperBlue * upperAlpha + underBlue * underAlpha * (1 - upperAlpha);
    resultAlpha = 1 - (1 - upperAlpha) * (1 - underAlpha);

    resultRed /= resultAlpha;
    resultGreen /= resultAlpha;
    resultBlue /= resultAlpha;

    return [UIColor colorWithRed:resultRed green:resultGreen blue:resultBlue alpha:resultAlpha];
}

@end
