//
//  UIScrollView+YARefreshControl.m
//  YAUIKit
//
//  Created by liuyan on 13-9-24.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import "UIScrollView+YARefreshControl.h"
#import <objc/runtime.h>

static char UIScrollViewRefreshControlVar;

@implementation UIScrollView (YARefreshControl)

#pragma mark - Add Refresh

- (void)addRefreshControlWithActionHandler:(void (^)())actionHandler
{
  [self setBackgroundColor:[UIColor clearColor]];
  YARefreshControl *refreshControl = [[YARefreshControl alloc] initWithScrollView:self
                                                              refreshActionHandle:actionHandler];
  objc_setAssociatedObject(self,
                           &UIScrollViewRefreshControlVar,
                           refreshControl,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Get

- (YARefreshControl *)refreshControl
{
  return objc_getAssociatedObject(self, &UIScrollViewRefreshControlVar);
}

@end
