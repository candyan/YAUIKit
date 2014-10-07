//
//  UIImage+YAUIKit.m
//  YAUIKit
//
//  Created by Tony Li on 10/14/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "UIImage+YAUIKit.h"

@implementation UIImage (YAUIKit)

+ (UIImage *)imageWithName:(NSString *)name
{
    NSString *filename = [name stringByDeletingPathExtension];
    NSString *extension = [name pathExtension];
    if ([extension length] == 0) {
        extension = @"png";
    }
    
    NSBundle *bundle = [NSBundle mainBundle];
    UIImage *image = nil;
    if ([[UIScreen mainScreen] scale] == 2.0) {
        NSString *imagePath = nil;
            // Try to get image for iPhone 5
        if ([[UIScreen mainScreen] bounds].size.height == 568.f) {
            NSString *imageForiPhone5 = [NSString stringWithFormat:@"%@-568h@2x", filename];
            imagePath = [bundle pathForResource:imageForiPhone5 ofType:extension];
        }
            // If no image specified for iPhone 5, fallback to normal retina image.
        if (imagePath == nil) {
            NSString *retinaName = [NSString stringWithFormat:@"%@@2x", filename];
            imagePath = [bundle pathForResource:retinaName ofType:extension];
        }
        
        image = [self imageWithContentsOfFile:imagePath];
    }
    
    if (image == nil) {
        NSString *imagePath = [bundle pathForResource:filename ofType:extension];
        if (imagePath) {
            image = [self imageWithContentsOfFile:imagePath];
        } else {
            NSLog(@"[YAUIKit] Failed to get image with name: %@", name);
        }
    }
    
    return image;
}

@end
