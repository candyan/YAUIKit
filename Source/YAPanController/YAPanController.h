//
//  YAPanController.h
//  YAUIKit
//
//  Created by liu yan on 6/28/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YAPanController : NSObject<UIGestureRecognizerDelegate>

@property (assign, nonatomic) BOOL canPan;

- (id) initWithView:(UIView *)view;

- (void) setPanPrelayoutsBlock:(void(^)())prelayouts
               panChangedBlock:(void(^)(CGFloat changedPrecent))panChanged
               animationsBlock:(void(^)(BOOL success))animations
               completionBlock:(void(^)(BOOL success))completion;

@end
