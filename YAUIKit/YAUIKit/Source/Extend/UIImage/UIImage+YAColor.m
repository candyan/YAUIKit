//
//  UIImage+YAColor.m
//  YAUIKit
//
//  Created by liu yan on 4/8/13.
//
//

#import "UIImage+YAColor.h"

@implementation UIImage (YAColor)

+ (UIImage *)imageWithColor:(UIColor *)color {
  CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  
  UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return theImage;
}

@end
