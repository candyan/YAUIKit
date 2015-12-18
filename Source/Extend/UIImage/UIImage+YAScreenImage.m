//
//  UIImage+YAScreenImage.m
//  YAUIKit
//
//  Created by liuyan on 12/18/15.
//  Copyright © 2015 liu yan. All rights reserved.
//

#import "UIImage+YAScreenImage.h"

@implementation UIImage (YAScreenImage)

+ (UIImage *)screenImageWithName:(NSString *)imageName
{
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat screenScale = [UIScreen mainScreen].scale;

    NSString *imageFullName = nil;
    if (screenHeight == 480) {
        if (screenScale > 1) {
            imageFullName = [NSString stringWithFormat:@"%@_480h@2x", imageName];
        }
        else {
            imageFullName = [NSString stringWithFormat:@"%@_480h", imageName];
        }
    }
    else if (screenHeight == 568) {
        imageFullName = [NSString stringWithFormat:@"%@_568h@2x", imageName];
    }
    else if (screenHeight == 667) {
        imageFullName = [NSString stringWithFormat:@"%@_667h@2x", imageName];
    }
    else if (screenHeight == 736) {
        imageFullName = [NSString stringWithFormat:@"%@_736h@3x", imageName];
    }
    else {
        return [UIImage imageNamed:imageName];
    }

    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageFullName ofType:@"png"];
    return [[UIImage alloc] initWithContentsOfFile:imagePath];
}

@end
