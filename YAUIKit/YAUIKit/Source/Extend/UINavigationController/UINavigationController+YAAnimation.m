//
//  UINavigationController+YAAnimation.m
//  YAUIKit
//
//  Created by liu yan on 4/2/13.
//  Copyright (c) 2013 Douban. All rights reserved.
//

#import "UINavigationController+YAAnimation.h"

@implementation UINavigationController (YAAnimation)

#pragma mark - Push

- (void)pushViewController:(UIViewController *)toViewController
                  duration:(NSTimeInterval)duration
                prelayouts:(void (^)(UIView *, UIView *))preparation
                animations:(void (^)(UIView *, UIView *))animations
                completion:(void (^)(UIView *, UIView *))completion
{
  [self pushViewController:toViewController
                  duration:duration
                   options:UIViewAnimationOptionCurveEaseInOut
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
  [self pushViewController:toViewController
                  duration:duration
                   options:options
      controllerPrelayouts:^(UIViewController *fromViewController, UIViewController *toViewController)
  {
    if (preparation) {
      preparation(fromViewController.view, toViewController.view);
    }
  } controllerAnimations:^(UIViewController *fromViewController, UIViewController *toViewController) {
    if (animations) {
      animations(fromViewController.view, toViewController.view);
    }
  } completion:^(UIViewController *fromViewController, UIViewController *toViewController) {
    if (completion) {
      completion(fromViewController.view, toViewController.view);
    }
  }];
}

- (void)pushViewController:(UIViewController *)toViewController
                  duration:(NSTimeInterval)duration
      controllerPrelayouts:(void (^)(UIViewController *fromViewController, UIViewController *toViewController))preparation
      controllerAnimations:(void (^)(UIViewController *fromViewController, UIViewController *toViewController))animations
                completion:(void (^)(UIViewController *fromViewController, UIViewController *toViewController))completion
{
  [self pushViewController:toViewController
                  duration:duration
                   options:UIViewAnimationOptionCurveEaseInOut 
      controllerPrelayouts:preparation
      controllerAnimations:animations
                completion:completion];
}

- (void)pushViewController:(UIViewController *)toViewController
                  duration:(NSTimeInterval)duration
                   options:(UIViewAnimationOptions)options
      controllerPrelayouts:(void (^)(UIViewController *fromViewController, UIViewController *toViewController))preparation
      controllerAnimations:(void (^)(UIViewController *fromViewController, UIViewController *toViewController))animations
                completion:(void (^)(UIViewController *fromViewController, UIViewController *toViewController))completion
{
  __block UIViewController *fromViewController = self.visibleViewController;

  [self pushViewController:toViewController animated:NO];
  [self.view layoutIfNeeded] ;

  __block UIView *superView = toViewController.view.superview;
  [superView insertSubview:fromViewController.view
              belowSubview:toViewController.view];

  if (preparation) {
    preparation(fromViewController, toViewController);
  }

  [UIView animateWithDuration:duration
                        delay:0.0
                      options:options
                   animations:^{
                     if (animations) {
                       animations(fromViewController, toViewController);
                     }
                   }
                   completion:^(BOOL finished) {
                     if (completion) {
                       completion(fromViewController, toViewController);
                     }
                     [fromViewController.view removeFromSuperview];
                   }];
}

#pragma mark - Pop

- (UIViewController *)popViewControllerWithDuration:(NSTimeInterval)duration
                                         prelayouts:(YAAnimationLayoutViewsBlock)preparation
                                         animations:(YAAnimationLayoutViewsBlock)animations
                                         completion:(YAAnimationLayoutViewsBlock)completion
{
  UIViewController *fromViewController = [self popViewControllerWithDuration:duration
                                                                     options:UIViewAnimationOptionCurveEaseInOut
                                                                  prelayouts:preparation
                                                                  animations:animations
                                                                  completion:completion];
  return fromViewController;
}

- (UIViewController *)popViewControllerWithDuration:(NSTimeInterval)duration
                                            options:(UIViewAnimationOptions)options
                                         prelayouts:(YAAnimationLayoutViewsBlock)preparation
                                         animations:(YAAnimationLayoutViewsBlock)animations
                                         completion:(YAAnimationLayoutViewsBlock)completion
{
  NSInteger count = [self.viewControllers count];
  if (count <= 1) {
    return nil;
  }

  return [[self popToViewController:[[self viewControllers] objectAtIndex:(count - 2)]
                           duration:duration
                            options:options
                         prelayouts:preparation
                         animations:animations
                         completion:completion] lastObject];
}

- (UIViewController *)popViewControllerWithDuration:(NSTimeInterval)duration
                               controllerPrelayouts:(YAAnimationLayoutViewControllersBlock)preparation
                               controllerAnimations:(YAAnimationLayoutViewControllersBlock)animations
                                         completion:(YAAnimationLayoutViewControllersBlock)completion
{
  return [self popViewControllerWithDuration:duration
                                     options:UIViewAnimationOptionCurveEaseInOut
                        controllerPrelayouts:preparation
                        controllerAnimations:animations
                                  completion:completion];
}

- (UIViewController *)popViewControllerWithDuration:(NSTimeInterval)duration
                                            options:(UIViewAnimationOptions)options
                               controllerPrelayouts:(YAAnimationLayoutViewControllersBlock)preparation
                               controllerAnimations:(YAAnimationLayoutViewControllersBlock)animations
                                         completion:(YAAnimationLayoutViewControllersBlock)completion
{
  NSInteger count = [self.viewControllers count];
  if (count <= 1) {
    return nil;
  }

  return [[self popToViewController:[[self viewControllers] objectAtIndex:(count - 2)]
                           duration:duration
                            options:options
               controllerPrelayouts:preparation
               controllerAnimations:animations
                         completion:completion] lastObject];
}

- (NSArray *)popToViewController:(UIViewController *)viewController
                        duration:(NSTimeInterval)duration
                      prelayouts:(YAAnimationLayoutViewsBlock)preparation
                      animations:(YAAnimationLayoutViewsBlock)animations
                      completion:(YAAnimationLayoutViewsBlock)completion
{
  return [self popToViewController:viewController
                          duration:duration
                           options:UIViewAnimationOptionCurveEaseInOut
                        prelayouts:preparation
                        animations:animations
                        completion:completion];
}

- (NSArray *)popToViewController:(UIViewController *)viewController
                        duration:(NSTimeInterval)duration
                         options:(UIViewAnimationOptions)options
                      prelayouts:(YAAnimationLayoutViewsBlock)preparation
                      animations:(YAAnimationLayoutViewsBlock)animations
                      completion:(YAAnimationLayoutViewsBlock)completion
{
  return [self popToViewController:viewController
                          duration:duration
                           options:options
              controllerPrelayouts:^(UIViewController *fromViewController, UIViewController *toViewController)
  {
    if (preparation) {
      preparation(fromViewController.view, toViewController.view);
    }
  } controllerAnimations:^(UIViewController *fromViewController, UIViewController *toViewController) {
    if (animations) {
      animations(fromViewController.view, toViewController.view);
    }
  } completion:^(UIViewController *fromViewController, UIViewController *toViewController) {
    if (completion) {
      completion(fromViewController.view, toViewController.view);
    }
  }];
}

- (NSArray *)popToViewController:(UIViewController *)viewController
                        duration:(NSTimeInterval)duration
            controllerPrelayouts:(YAAnimationLayoutViewControllersBlock)preparation
            controllerAnimations:(YAAnimationLayoutViewControllersBlock)animations
                      completion:(YAAnimationLayoutViewControllersBlock)completion
{
  return [self popToViewController:viewController
                          duration:duration
                           options:UIViewAnimationOptionCurveEaseInOut
              controllerPrelayouts:preparation
              controllerAnimations:animations
                        completion:completion];
}

- (NSArray *)popToViewController:(UIViewController *)viewController
                        duration:(NSTimeInterval)duration
                         options:(UIViewAnimationOptions)options
            controllerPrelayouts:(YAAnimationLayoutViewControllersBlock)preparation
            controllerAnimations:(YAAnimationLayoutViewControllersBlock)animations
                      completion:(YAAnimationLayoutViewControllersBlock)completion
{
  if ([self.viewControllers indexOfObject:viewController] == NSNotFound) {
    return nil;
  }

  __block UIViewController *fromViewController = self.visibleViewController;
  NSArray *popedViewControllers = [self popToViewController:viewController animated:NO];
  [self.view layoutIfNeeded];

  __block UIViewController *toViewController = self.visibleViewController;
  UIView *superView = toViewController.view.superview;
  [superView addSubview:fromViewController.view];

  [self.view layoutIfNeeded];
  if (preparation) {
    preparation(fromViewController, toViewController);
  }

  [UIView animateWithDuration:duration
                        delay:0.0
                      options:options
                   animations:^{
                     if (animations) {
                       animations(fromViewController, toViewController);
                     }
                   }
                   completion:^(BOOL finished) {
                     if (completion) {
                       completion(fromViewController, toViewController);
                     }
                     [fromViewController.view removeFromSuperview];
                   }];

  return popedViewControllers;
}

@end
