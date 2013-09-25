//
//  YARefreshContrl.h
//  YAUIKit
//
//  Created by liu yan on 9/23/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YARefreshState)
{
  kYARefreshStateStopped   = 1 << 0,
  kYARefreshStateTriggered = 1 << 1,
  kYARefreshStateLoading   = 1 << 2,
};

@interface YARefreshControl : NSObject

@property (nonatomic, readonly) YARefreshState    refreshState;
@property (nonatomic, assign)   BOOL              refreshEnable;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView 
               refreshActionHandle:(void(^)())actionHandle;

- (void)setTitle:(NSString *)title forState:(YARefreshState)state;
- (void)setSubTitle:(NSString *)subTitle forState:(YARefreshState)state;
//- (void)setCustomView:(UIView *)customView forState:(YARefreshState)state;

- (void)setTitleColor:(UIColor *)color;
- (void)setTitleFont:(UIFont *)font;
- (void)setIndicatorColor:(UIColor *)color;

- (void)beginRefresh;
- (void)endRefresh;

@end