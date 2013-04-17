//
//  UINavigationController+YAAnimation.h
//  YAUIKit
//
//  Created by liu yan on 4/2/13.
//  Copyright (c) 2013 Douban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (YAAnimation)

- (void)pushViewController:(UIViewController *)toViewController
                  duration:(NSTimeInterval)duration
                prelayouts:(void (^)(UIView *fromView, UIView *toView))preparation
                animations:(void (^)(UIView *fromView, UIView *toView))animations
                completion:(void (^)(UIView *fromView, UIView *toView))completion;

- (void)pushViewController:(UIViewController *)toViewController
                  duration:(NSTimeInterval)duration
                   options:(UIViewAnimationOptions)options
                prelayouts:(void (^)(UIView *fromView, UIView *toView))preparation
                animations:(void (^)(UIView *fromView, UIView *toView))animations
                completion:(void (^)(UIView *fromView, UIView *toView))completion;

- (UIViewController *)popViewControllerWithDuration:(NSTimeInterval)duration
                                         prelayouts:(void (^)(UIView *fromView, UIView *toView))preparation
                                         animations:(void (^)(UIView *fromView, UIView *toView))animations
                                         completion:(void (^)(UIView *fromView, UIView *toView))completion;

- (UIViewController *)popViewControllerWithDuration:(NSTimeInterval)duration
                                            options:(UIViewAnimationOptions)options
                                         prelayouts:(void (^)(UIView *fromView, UIView *toView))preparation
                                         animations:(void (^)(UIView *fromView, UIView *toView))animations
                                         completion:(void (^)(UIView *fromView, UIView *toView))completion;

@end
