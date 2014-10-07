//
//  UIBarButtonItem+YAItemFactory.h
//  YAUIKit
//
//  Created by Candyan on 14-3-4.
//  Copyright (c) 2014 Candyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (YAItemFactory)

+ (NSArray *)barButtonItemsWithImage:(UIImage *)image actionBlock:(void(^)())actionBlock;
+ (NSArray *)barButtonItemsWithImage:(UIImage *)image space:(CGFloat)space actionBlock:(void(^)())actionBlock;

+ (NSArray *)barButtonItemsWithTitle:(NSString *)title actionBlock:(void(^)())actionBlock;
+ (NSArray *)barButtonItemsWithTitle:(NSString *)title space:(CGFloat)space actionBlock:(void (^)())actionBlock;

+ (NSArray *)barButtonItemsWithCustomView:(UIView *)customView;
+ (NSArray *)barButtonItemsWithCustomView:(UIView *)customView space:(CGFloat)space;

@end
