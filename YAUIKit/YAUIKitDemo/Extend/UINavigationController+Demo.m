//
//  UINavigationController+Demo.m
//  YAUIKit
//
//  Created by liu yan on 4/9/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "UINavigationController+Demo.h"
#import "UINavigationController+YAAnimation.h"

#import <QuartzCore/QuartzCore.h>

CGFloat viewScale = 0.7;
@implementation UINavigationController (Demo)

- (void) pushViewControllerWithDemoAnimation:(UIViewController *)viewController {
  [self pushViewController:viewController
                  duration:.5f
                prelayouts:^(UIView *fromView, UIView *toView) {
                  toView.frame = CGRectMake(toView.frame.size.width,
                                            0,
                                            toView.frame.size.width,
                                            toView.frame.size.height);
                  UIView *shadowView = [[UIView alloc] initWithFrame:fromView.frame];
                  shadowView.backgroundColor = [UIColor blackColor];
                  shadowView.alpha = 0;
                  [fromView addSubview:shadowView];
                }
                animations:^(UIView *fromView, UIView *toView) {
                  toView.frame = CGRectMake(0, 0,
                                            toView.frame.size.width,
                                            toView.frame.size.height);
                  
                  fromView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(viewScale, viewScale), CGAffineTransformMakeRotation(M_PI));
                  
                  [[fromView.subviews lastObject] setAlpha:.7];
                }
                completion:^(UIView *fromView, UIView *toView) {
                  fromView.transform = CGAffineTransformMakeScale(1, 1);
                  [[fromView.subviews lastObject] removeFromSuperview];
                }];
}

- (UIViewController *) popViewControllerWithDemoAnimation {
  return [self popViewControllerWithDuration:.5f
                                  prelayouts:^(UIView *fromView, UIView *toView) {
                                    toView.transform = CGAffineTransformMakeScale(viewScale, viewScale);
                                    UIView *shadowView = [[UIView alloc] initWithFrame:fromView.frame];
                                    shadowView.backgroundColor = [UIColor blackColor];
                                    shadowView.alpha = .7;
                                    [toView addSubview:shadowView];
                                  }
                                  animations:^(UIView *fromView, UIView *toView) {
                                    toView.transform = CGAffineTransformMakeScale(1, 1);
                                    fromView.frame = CGRectMake(fromView.frame.size.width,
                                                                0,
                                                                fromView.frame.size.width,
                                                                fromView.frame.size.height);
                                    [[toView.subviews lastObject] setAlpha:0];
                                  }
                                  completion:^(UIView *fromView, UIView *toView) {
                                    [[toView.subviews lastObject] removeFromSuperview];
                                  }];
}

@end
