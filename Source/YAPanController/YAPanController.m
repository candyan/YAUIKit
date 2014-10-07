//
//  YAPanController.m
//  YAUIKit
//
//  Created by liu yan on 6/28/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "YAPanController.h"

@implementation YAPanController {
  CGFloat _panStartPointX;
  
  void(^_prelayoutBlock)();
  void(^_panChangedBlock)(CGFloat changedPrecent);
  void(^_animationsBlock)(BOOL success);
  void(^_completionBlock)(BOOL success);
  
  __unsafe_unretained UIView *_panView;
}

- (id)initWithView:(UIView *)view {
  self = [super init];
  if (self) {
    self.canPan = YES;
    _panView = view;
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGR:)];
    [panGR setDelegate:self];
    [panGR setMinimumNumberOfTouches:1];
    [panGR setMaximumNumberOfTouches:1];
    [view addGestureRecognizer:panGR];
  }
  return self;
}

#pragma mark - Set
- (void)setPanPrelayoutsBlock:(void (^)())prelayouts
              panChangedBlock:(void (^)(CGFloat))panChanged
              animationsBlock:(void (^)(BOOL))animations
              completionBlock:(void (^)(BOOL))completion {
  _prelayoutBlock = [prelayouts copy];
  _panChangedBlock = [panChanged copy];
  _animationsBlock = [animations copy];
  _completionBlock = [completion copy];
}

#pragma mark - Event
- (void) handlePanGR:(UIPanGestureRecognizer *)gestureRecongnizer {
  if (gestureRecongnizer.state == UIGestureRecognizerStateBegan) {
    _panStartPointX = [gestureRecongnizer translationInView:_panView].x;
    
    if (_prelayoutBlock) {
      _prelayoutBlock();
    }
    
  } else if (gestureRecongnizer.state == UIGestureRecognizerStateEnded) {
    
    CGFloat diffPointX = [gestureRecongnizer translationInView:_panView].x - _panStartPointX;
    BOOL backSuccess = NO;
    if (diffPointX > 100) {
      backSuccess = YES;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
      if (_animationsBlock) {
        _animationsBlock(backSuccess);
      }
    } completion:^(BOOL finished) {
      if (_completionBlock) {
        _completionBlock(backSuccess);
      }
    }];
    
  } else if (gestureRecongnizer.state == UIGestureRecognizerStateChanged) {
    CGFloat diffPointX = [gestureRecongnizer translationInView:_panView].x - _panStartPointX;
    if (diffPointX > 0) {
      if (_panChangedBlock) {
        _panChangedBlock((diffPointX / CGRectGetWidth(_panView.frame)));
      }
    }
  }
}

#pragma mark - GR(delegate)
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  UIPanGestureRecognizer *panGR = (UIPanGestureRecognizer *)gestureRecognizer;
  CGPoint velocity = [panGR velocityInView:_panView];
  if (velocity.x > ABS(velocity.y)) {
    return YES;
  }
  return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  if ([[touch view] isKindOfClass:[UISlider class]] ||
      !self.canPan) {
    return NO;
  }
  return YES;
}

@end
