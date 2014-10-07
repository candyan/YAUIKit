//
//  UIImage+YAImageTransform.h
//  YAUIKit
//
//  Created by liu yan on 6/14/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YAImageTransform)

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScale:(CGFloat)scale;

@end
