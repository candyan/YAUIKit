//
//  UIColor+YAColorMixing.h
//
//
//  Created by liuyan on 7/8/15.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (YAColorMixing)

/**
 * Return a new color made by overlaying a given color to the top of receiver.
 * @param addingColor The color to overlay to the top of the receiver. This value must not be nil.
 */
- (UIColor *)colorByAddingColor:(UIColor *)addingColor;

@end
