//
//  YAPanBackController.h
//  YAUIKit
//
//  Created by liu yan on 4/12/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YAPanBackController : NSObject <UIGestureRecognizerDelegate> {
  UIPanGestureRecognizer *_panBackGR;
  __unsafe_unretained UIViewController *_currentViewController;
  
  void(^_prelayoutsBlock)(UIView *fromView, UIView *toView);
  void(^_panChangedBlock)(UIView *fromView, UIView *toView, CGFloat changedPrecent);
  void(^_animationsBlock)(UIView *fromView, UIView *toView, BOOL success);
  void(^_completionBlock)(UIView *fromView, UIView *toView, BOOL success);
}

@property (assign, nonatomic) BOOL canPanBack;

- (id) initWithCurrentViewController:(UIViewController *)currentViewController;

- (void) addPanBackToView:(UIView *)view;
- (void) removePanBackFromView:(UIView *)view;

- (void) setPanBackPrelayoutsBlock:(void(^)(UIView *fromView, UIView *toView))prelayouts
                   panChangedBlock:(void(^)(UIView *fromView, UIView *toView, CGFloat changedPrecent))panChanged
                   animationsBlock:(void(^)(UIView *fromView, UIView *toView, BOOL success))animations
                   completionBlock:(void(^)(UIView *fromView, UIView *toView, BOOL success))completion;

@end
