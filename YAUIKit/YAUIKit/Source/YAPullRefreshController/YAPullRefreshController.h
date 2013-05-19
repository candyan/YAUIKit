//
//  YAPullRefreshController.h
//  YAUIKit
//
//  Created by liu yan on 4/16/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPullToRefreshController.h"

typedef enum {
  kYARefreshDirectionTop = MSRefreshDirectionTop,
  kYARefreshDirectionRight = MSRefreshDirectionRight,
  kYARefreshDirectionLeft = MSRefreshDirectionLeft,
  kYARefreshDirectionButtom = MSRefreshDirectionBottom,
} YARefreshDirection;

typedef enum {
  kYARefreshableDirectionNone = 0,
  kYARefreshableDirectionTop = MSRefreshDirectionTop,
  kYARefreshableDirectionRight = MSRefreshDirectionRight,
  kYARefreshvDirectionLeft = MSRefreshDirectionLeft,
  kYARefreshableDirectionButtom = MSRefreshDirectionBottom,
} YARefreshableDirection;

@protocol YAPullRefreshDelegate;

@interface YAPullRefreshController : NSObject<MSPullToRefreshDelegate> {
  MSPullToRefreshController *_ptrc;
}

@property (nonatomic, retain) UIView *pullRefreshHeaderView;
@property (nonatomic, retain) UIView *pullRefreshFooterView;
@property (nonatomic, assign) YARefreshableDirection refreshableDirection;
@property (nonatomic, assign) UIEdgeInsets refreshingInsets;
@property (nonatomic, assign) UIEdgeInsets refreshableInsets;
@property (nonatomic, unsafe_unretained) id<YAPullRefreshDelegate> delegate;

- (id) initWithScrollView:(UIScrollView *)scrollView;

- (id) initWithScrollView:(UIScrollView *)scrollView
     refreshableDirection:(YARefreshableDirection)refreshableDirection;

- (void) startRefreshWithDirection:(YARefreshDirection)refreshDirection
                          animated:(BOOL)animated;

- (void) startRefreshWithDirection:(YARefreshDirection)refreshDirection;

- (void) finishRefreshWithDirection:(YARefreshDirection)refreshDirection
                           animated:(BOOL)animated
                           complate:(void(^)())complate;

- (void) finishRefreshWithDirection:(YARefreshDirection)refreshDirection
                           complate:(void(^)())complate;

- (void) setOriginEdgeInsets:(UIEdgeInsets)edgeInsets;

@end

@protocol YAPullRefreshDelegate <NSObject>

@optional
- (void) pullRefreshController:(YAPullRefreshController *)pullRefreshController canEngageRefreshDirection:(YARefreshDirection)direction;
- (void) pullRefreshController:(YAPullRefreshController *)pullRefreshController didEngageRefreshDirection:(YARefreshDirection)direction;
- (void) pullRefreshController:(YAPullRefreshController *)pullRefreshController didDisengageRefreshDirection:(YARefreshDirection)direction;

@end
