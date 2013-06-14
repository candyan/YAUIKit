//
//  UIImage+YARotate.m
//  YAUIKit
//
//  Created by liu yan on 6/14/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "UIImage+YARotate.h"

@implementation UIImage (YARotate)

- (UIImage *) imageForRotateDegrees:(CGFloat)degrees {
  UIGraphicsBeginImageContext(self.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextRotateCTM (context, degrees * M_PI / 180.0);
  [self drawAtPoint:CGPointMake(0, 0)];
  return UIGraphicsGetImageFromCurrentImageContext();
}

@end
