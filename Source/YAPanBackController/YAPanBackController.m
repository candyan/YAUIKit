//
//  YAPanBackController.m
//  YAUIKit
//
//  Created by liu yan on 4/12/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "YAPanBackController.h"
#import "UIView+YAUIKit.h"

@implementation YAPanBackController {
  CGFloat _panBackStartPointX;
  UIViewController *_toViewController;
  NSMutableArray *_ignoreTouchClasses;
}

#pragma mark - init
- (id)initWithCurrentViewController:(UIViewController *)currentViewController {
  self = [super init];
  if (self) {
    _currentViewController = currentViewController;
    _ignoreTouchClasses = [NSMutableArray arrayWithObject:[UISlider class]];
    self.canPanBack = YES;
    [self createPanBackGestureRecongizer];
    
    [self setPanBackPrelayoutsBlock:^(UIView *fromView, UIView *toView) {
      [toView addSubview:[[UIView alloc] initWithFrame:toView.bounds]];
      [[toView.subviews lastObject] setBackgroundColor:[UIColor blackColor]];
      [[toView.subviews lastObject] setAlpha:0.7];
    } panChangedBlock:^(UIView *fromView, UIView *toView, CGFloat changedPrecent) {
      [fromView setFrameOriginX:changedPrecent * fromView.bounds.size.width];
      [[toView.subviews lastObject] setAlpha:(1 - changedPrecent) * 0.7];
      CGFloat scaleValue = changedPrecent * 0.03 + 0.97;
      toView.transform = CGAffineTransformMakeScale(scaleValue, scaleValue);
    } animationsBlock:^(UIView *fromView, UIView *toView, BOOL success) {
      if (success) {
        [fromView setFrameOriginX:fromView.frame.size.width];
        [[toView.subviews lastObject] setAlpha:0];
        toView.transform = CGAffineTransformMakeScale(1, 1);
      } else {
        [fromView setFrameOriginX:0];
        [[toView.subviews lastObject] setAlpha:.7];
        toView.transform = CGAffineTransformMakeScale(0.97, 0.97);
      }
    } completionBlock:^(UIView *fromView, UIView *toView, BOOL success) {
      if (success) {
        [[toView.subviews lastObject] removeFromSuperview];
      } else {
        toView.transform = CGAffineTransformMakeScale(1, 1);
        [[toView.subviews lastObject] removeFromSuperview];
      }
    }];
  }
  return self;
}

#pragma mark - Create SubView
- (void) createPanBackGestureRecongizer {
  _panBackGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanBackGR:)];
  [_panBackGR setDelegate:self];
  [_panBackGR setMinimumNumberOfTouches:1];
  [_panBackGR setMaximumNumberOfTouches:1];
}

#pragma mark - Set
- (void)setPanBackPrelayoutsBlock:(void (^)(UIView *, UIView *))prelayouts
                  panChangedBlock:(void (^)(UIView *, UIView *, CGFloat))panChanged
                  animationsBlock:(void (^)(UIView *, UIView *, BOOL))animations
                  completionBlock:(void (^)(UIView *, UIView *, BOOL))completion
{
  if (prelayouts) {
    _prelayoutsBlock = ^(UIViewController *fromViewController, UIViewController *toViewController) {
      prelayouts(fromViewController.view, toViewController.view);
    };
  }

  if (panChanged) {
    _panChangedBlock = ^(UIViewController *fromViewController, UIViewController *toViewController, CGFloat changedPrecent) {
      panChanged(fromViewController.view, toViewController.view, changedPrecent);
    };
  }

  if (animations) {
    _animationsBlock = ^(UIViewController *fromViewController, UIViewController *toViewController, BOOL success) {
      animations(fromViewController.view, toViewController.view, success);
    };
  }

  if (completion) {
    _completionBlock = ^(UIViewController *fromViewController, UIViewController *toViewController, BOOL success) {
      completion(fromViewController.view, toViewController.view, success);
    };
  }
}

- (void)setPanBackControllerPrelayoutsBlock:(YAAnimationLayoutViewControllersBlock)prelayouts
                            panChangedBlock:(YAAnimationLayoutViewControllersChangedBlock)panChanged
                            animationsBlock:(YAAnimationLayoutViewControllersSuccessBlock)animations
                            completionBlock:(YAAnimationLayoutViewControllersSuccessBlock)completion
{
  _prelayoutsBlock = prelayouts;
  _panChangedBlock = panChanged;
  _animationsBlock = animations;
  _completionBlock = completion;
}

#pragma mark - Event
- (void) handlePanBackGR:(UIPanGestureRecognizer *)gestureRecongnizer {
  NSInteger count = [_currentViewController.navigationController.viewControllers count];
  if (count <= 1) {
    return;
  }
  if (gestureRecongnizer.state == UIGestureRecognizerStateBegan) {
    _panBackStartPointX = [gestureRecongnizer translationInView:_currentViewController.view].x;

    NSInteger toViewControllerIndex = [_currentViewController.navigationController.viewControllers count] - 2;
    if (toViewControllerIndex < 0) {
      toViewControllerIndex = 0;
    }
    _toViewController = [_currentViewController.navigationController.viewControllers objectAtIndex:toViewControllerIndex];
    
    UIView *supView = _currentViewController.view.superview;
    [supView insertSubview:_toViewController.view belowSubview:_currentViewController.view];
    [_currentViewController.navigationController.view layoutIfNeeded];
    
    if (_prelayoutsBlock) {
      _prelayoutsBlock(_currentViewController, _toViewController);
    }
    
  } else if (gestureRecongnizer.state == UIGestureRecognizerStateEnded) {
    
    CGFloat diffPointX = [gestureRecongnizer translationInView:_currentViewController.view].x - _panBackStartPointX;
    BOOL backSuccess = NO;
    if (diffPointX > 100) {
      backSuccess = YES;
    }
    
    [UIView animateWithDuration:.2 animations:^{
      if (_animationsBlock) {
        _animationsBlock(_currentViewController, _toViewController, backSuccess);
      }
    } completion:^(BOOL finished) {
      if (_completionBlock) {
        _completionBlock(_currentViewController, _toViewController, backSuccess);
      }
      if (backSuccess) {
        [_currentViewController.navigationController.view layoutIfNeeded];
        [_currentViewController.navigationController popViewControllerAnimated:NO];
      } else {
        [_toViewController.view removeFromSuperview];
      }
      
    }];
    
  } else if (gestureRecongnizer.state == UIGestureRecognizerStateChanged) {
    CGFloat diffPointX = [gestureRecongnizer translationInView:_currentViewController.view].x - _panBackStartPointX;
    if (diffPointX > 0) {
      if (_panChangedBlock) {
        _panChangedBlock(_currentViewController, _toViewController, (diffPointX / _currentViewController.view.bounds.size.width));
      }
    }
  }
}

#pragma mark - GR(delegate)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  if ([_currentViewController.navigationController.viewControllers count] <= 1) {
    return YES;
  }
  return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  if (gestureRecognizer == _panBackGR) {
    CGPoint velocity = [_panBackGR velocityInView:_currentViewController.view];
    if (velocity.x > ABS(velocity.y)) {
      return YES;
    }
    return NO;
  }
  return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  if (!self.canPanBack) {
    return NO;
  }

  BOOL receive = YES;
  for (Class clz in _ignoreTouchClasses) {
    if ([touch.view isKindOfClass:clz]) {
      receive = NO;
      break;
    }
  }
  return receive;
}

- (void) addPanBackToView:(UIView *)view {
  [view addGestureRecognizer:_panBackGR];
}

- (void) removePanBackFromView:(UIView *)view {
  [view removeGestureRecognizer:_panBackGR];
}

- (void) ignoreTouchesOnViewOfClass:(Class)clazz {
  [_ignoreTouchClasses addObject:clazz];
}

@end
