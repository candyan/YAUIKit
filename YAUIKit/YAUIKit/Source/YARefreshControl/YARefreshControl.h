//
//  YARefreshContrl.h
//  YAUIKit
//
//  Created by liu yan on 9/23/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUIntenger, YARefreshPosition)
{
  kYARefreshPositionTop    = 1 << 0,
  kYARefreshPositionBottom = 1 << 1,
}

typedef NS_ENUM(NSUIntenger, YARefreshState)
{
  kYARefreshStateStopped   = 1 << 0,
  kYARefreshStateTriggered = 1 << 1,
  kYARefreshStateLoading   = 1 << 2,
}

@interface YARefreshControl : NSObject

@property (nonatomic, readonly) YARefreshState    refreshState;
@property (nonatomic, readonly) YARefreshPosition refreshPosition;
@property (nonatomic, assign)   BOOL              refreshEnable;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView 
                   refreshPosition:(YARefreshPosition)refreshPosition;

- (void)setTilte:(NSString *)title forState:(YARefreshState)state;
- (void)setSubTitle:(NSString *)subTitle forState:(YARefreshState)state;
- (void)setCustomView:(UIView *)customView forState:(YARefreshState)state;

- (void)beginRefresh;
- (void)endRefresh;

@end