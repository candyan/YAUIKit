//
//  YAPanBackController.h
//  YAUIKit
//
//  Created by liu yan on 4/12/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAUIKitTypeDef.h"

@interface YAPanBackController : NSObject <UIGestureRecognizerDelegate> {
  UIPanGestureRecognizer *_panBackGR;
  __unsafe_unretained UIViewController *_currentViewController;

  YAAnimationLayoutViewControllersBlock _prelayoutsBlock;
  YAAnimationLayoutViewControllersChangedBlock _panChangedBlock;
  YAAnimationLayoutViewControllersSuccessBlock _animationsBlock;
  YAAnimationLayoutViewControllersSuccessBlock _completionBlock;
}

@property (assign, nonatomic) BOOL canPanBack;

- (instancetype)initWithCurrentViewController:(UIViewController *)currentViewController;

- (void)addPanBackToView:(UIView *)view;
- (void)removePanBackFromView:(UIView *)view;

- (void)ignoreTouchesOnViewOfClass:(Class)clazz;

- (void)setPanBackPrelayoutsBlock:(YAAnimationLayoutViewsBlock)prelayouts
                  panChangedBlock:(YAAnimationLayoutViewsChangedBlock)panChanged
                  animationsBlock:(YAAnimationLayoutViewsSuccessBlock)animations
                  completionBlock:(YAAnimationLayoutViewsSuccessBlock)completion;

- (void)setPanBackControllerPrelayoutsBlock:(YAAnimationLayoutViewControllersBlock)prelayouts
                            panChangedBlock:(YAAnimationLayoutViewControllersChangedBlock)panChanged
                            animationsBlock:(YAAnimationLayoutViewControllersSuccessBlock)animations
                            completionBlock:(YAAnimationLayoutViewControllersSuccessBlock)completion;

@end
