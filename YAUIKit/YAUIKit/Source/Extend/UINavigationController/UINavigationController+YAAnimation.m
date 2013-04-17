//
//  UINavigationController+YAAnimation.m
//  YAUIKit
//
//  Created by liu yan on 4/2/13.
//  Copyright (c) 2013 Douban. All rights reserved.
//

#import "UINavigationController+YAAnimation.h"

@implementation UINavigationController (YAAnimation)

- (void)pushViewController:(UIViewController *)toViewController
                  duration:(NSTimeInterval)duration
                prelayouts:(void (^)(UIView *, UIView *))preparation
                animations:(void (^)(UIView *, UIView *))animations
                completion:(void (^)(UIView *, UIView *))completion
{
  [self pushViewController:toViewController
                  duration:duration
                   options:0
                prelayouts:preparation
                animations:animations
                completion:completion];
}

- (void)pushViewController:(UIViewController *)toViewController
                  duration:(NSTimeInterval)duration
                   options:(UIViewAnimationOptions)options
                prelayouts:(void (^)(UIView *, UIView *))preparation
                animations:(void (^)(UIView *, UIView *))animations
                completion:(void (^)(UIView *, UIView *))completion
{
  __block UIViewController *fromViewController = self.visibleViewController;
  
  [self pushViewController:toViewController animated:NO];
  [self.view layoutIfNeeded] ;
  
  __block UIView *superView = toViewController.view.superview;
  [superView addSubview:fromViewController.view];
  [superView bringSubviewToFront:toViewController.view];
  
  if (preparation) {
    preparation(fromViewController.view, toViewController.view);
  }
  
  [UIView animateWithDuration:duration
                        delay:0.0
                      options:options
                   animations:^{
                     if (animations) {
                       animations(fromViewController.view, toViewController.view);
                     }
                   }
                   completion:^(BOOL finished) {
                     if (completion) {
                       completion(fromViewController.view, toViewController.view);
                     }
                     [fromViewController.view removeFromSuperview];
                   }];
}

- (UIViewController *)popViewControllerWithDuration:(NSTimeInterval)duration
                                         prelayouts:(void (^)(UIView *, UIView *))preparation
                                         animations:(void (^)(UIView *, UIView *))animations
                                         completion:(void (^)(UIView *, UIView *))completion
{
  UIViewController *fromViewController = [self popViewControllerWithDuration:duration
                                                                     options:0
                                                                  prelayouts:preparation
                                                                  animations:animations
                                                                  completion:completion];
  return fromViewController;
}

- (UIViewController *)popViewControllerWithDuration:(NSTimeInterval)duration
                                            options:(UIViewAnimationOptions)options
                                         prelayouts:(void (^)(UIView *, UIView *))preparation
                                         animations:(void (^)(UIView *, UIView *))animations
                                         completion:(void (^)(UIView *, UIView *))completion
{
  NSInteger count = [self.viewControllers count];
  if (count <= 1) {
    return nil;
  }
  
  __block UIViewController *fromViewController = self.visibleViewController;
  [self popViewControllerAnimated:NO];
  [self.view layoutIfNeeded];
  
  __block UIViewController *toViewController = self.visibleViewController;
  UIView *superView = toViewController.view.superview;
  [superView addSubview:fromViewController.view];
  
  [self.view layoutIfNeeded];
  if (preparation) {
    preparation(fromViewController.view, toViewController.view);
  }
  
  [UIView animateWithDuration:duration
                        delay:0.0
                      options:options
                   animations:^{
                     if (animations) {
                       animations(fromViewController.view, toViewController.view);
                     }
                   }
                   completion:^(BOOL finished) {
                     if (completion) {
                       completion(fromViewController.view, toViewController.view);
                     }
                     [fromViewController.view removeFromSuperview];
                   }];
  
  return fromViewController;
}

@end
