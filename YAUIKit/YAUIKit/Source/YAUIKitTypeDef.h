//
//  YAUIKitTypeDef.h
//  YAUIKit
//
//  Created by liuyan on 13-11-6.
//  Copyright (c) 2013年 liu yan. All rights reserved.
//

#ifndef YAUIKit_YAUIKitTypeDef_h
#define YAUIKit_YAUIKitTypeDef_h

typedef void(^YAAnimationLayoutViewsBlock)(UIView *fromView, UIView *toView);
typedef void(^YAAnimationLayoutViewsSuccessBlock)(UIView *fromView, UIView *toView, BOOL success);
typedef void(^YAAnimationLayoutViewsChangedBlock)(UIView *fromView, UIView *toView, CGFloat changedPrecent);
typedef void(^YAAnimationLayoutViewControllersBlock)(UIViewController *fromViewController, UIViewController *toViewController);
typedef void(^YAAnimationLayoutViewControllersSuccessBlock)(UIViewController *fromViewController, UIViewController *toViewController, BOOL success);
typedef void(^YAAnimationLayoutViewControllersChangedBlock)(UIViewController *fromViewController, UIViewController *toViewController, CGFloat changedPrecent);

// YARefresh
typedef NS_ENUM(NSUInteger, YARefreshState)
{
  kYARefreshStateStop = 1 << 0,
  kYARefreshStateTrigger = 1 << 1,
  kYARefreshStateLoading = 1 << 2,
};

#endif
