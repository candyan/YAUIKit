//
//  UINavigationController+YAAnimation.h
//  YAUIKit
//
//  Created by liu yan on 4/2/13.
//  Copyright (c) 2013 Douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAUIKitTypeDef.h"

@interface UINavigationController (YAAnimation)

#pragma mark - Push

- (void)pushViewController:(UIViewController *)toViewController
                  duration:(NSTimeInterval)duration
                prelayouts:(YAAnimationLayoutViewsBlock)preparation
                animations:(YAAnimationLayoutViewsBlock)animations
                completion:(YAAnimationLayoutViewsBlock)completion;

- (void)pushViewController:(UIViewController *)toViewController
                  duration:(NSTimeInterval)duration
                   options:(UIViewAnimationOptions)options
                prelayouts:(YAAnimationLayoutViewsBlock)preparation
                animations:(YAAnimationLayoutViewsBlock)animations
                completion:(YAAnimationLayoutViewsBlock)completion;

- (void)pushViewController:(UIViewController *)toViewController
                  duration:(NSTimeInterval)duration
      controllerPrelayouts:(YAAnimationLayoutViewControllersBlock)preparation
      controllerAnimations:(YAAnimationLayoutViewControllersBlock)animations
                completion:(YAAnimationLayoutViewControllersBlock)completion;

- (void)pushViewController:(UIViewController *)toViewController
                  duration:(NSTimeInterval)duration
                   options:(UIViewAnimationOptions)options
      controllerPrelayouts:(YAAnimationLayoutViewControllersBlock)preparation
      controllerAnimations:(YAAnimationLayoutViewControllersBlock)animations
                completion:(YAAnimationLayoutViewControllersBlock)completion;


#pragma mark - Pop

- (UIViewController *)popViewControllerWithDuration:(NSTimeInterval)duration
                                         prelayouts:(YAAnimationLayoutViewsBlock)preparation
                                         animations:(YAAnimationLayoutViewsBlock)animations
                                         completion:(YAAnimationLayoutViewsBlock)completion;

- (UIViewController *)popViewControllerWithDuration:(NSTimeInterval)duration
                                            options:(UIViewAnimationOptions)options
                                         prelayouts:(YAAnimationLayoutViewsBlock)preparation
                                         animations:(YAAnimationLayoutViewsBlock)animations
                                         completion:(YAAnimationLayoutViewsBlock)completion;

- (UIViewController *)popViewControllerWithDuration:(NSTimeInterval)duration
                               controllerPrelayouts:(YAAnimationLayoutViewControllersBlock)preparation
                               controllerAnimations:(YAAnimationLayoutViewControllersBlock)animations
                                         completion:(YAAnimationLayoutViewControllersBlock)completion;

- (UIViewController *)popViewControllerWithDuration:(NSTimeInterval)duration
                                            options:(UIViewAnimationOptions)options
                               controllerPrelayouts:(YAAnimationLayoutViewControllersBlock)preparation
                               controllerAnimations:(YAAnimationLayoutViewControllersBlock)animations
                                         completion:(YAAnimationLayoutViewControllersBlock)completion;

- (NSArray *)popToViewController:(UIViewController *)viewController
                        duration:(NSTimeInterval)duration
                      prelayouts:(YAAnimationLayoutViewsBlock)preparation
                      animations:(YAAnimationLayoutViewsBlock)animations
                      completion:(YAAnimationLayoutViewsBlock)completion;

- (NSArray *)popToViewController:(UIViewController *)viewController
                        duration:(NSTimeInterval)duration
            controllerPrelayouts:(YAAnimationLayoutViewControllersBlock)preparation
            controllerAnimations:(YAAnimationLayoutViewControllersBlock)animations
                      completion:(YAAnimationLayoutViewControllersBlock)completion;

- (NSArray *)popToViewController:(UIViewController *)viewController
                        duration:(NSTimeInterval)duration
                         options:(UIViewAnimationOptions)options
                      prelayouts:(YAAnimationLayoutViewsBlock)preparation
                      animations:(YAAnimationLayoutViewsBlock)animations
                      completion:(YAAnimationLayoutViewsBlock)completion;

- (NSArray *)popToViewController:(UIViewController *)viewController
                        duration:(NSTimeInterval)duration
                         options:(UIViewAnimationOptions)options
            controllerPrelayouts:(YAAnimationLayoutViewControllersBlock)preparation
            controllerAnimations:(YAAnimationLayoutViewControllersBlock)animations
                      completion:(YAAnimationLayoutViewControllersBlock)completion;

@end
