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
  kYARefreshableDirectionTop = MSRefreshDirectionTop,
  kYARefreshableDirectionRight = MSRefreshDirectionRight,
  kYARefreshvDirectionLeft = MSRefreshDirectionLeft,
  kYARefreshableDirectionButtom = MSRefreshDirectionBottom,
} YARefreshableDirection;

typedef void(^CanEngageRefresh)(YARefreshDirection direction);
typedef void(^DidEngageRefresh)(YARefreshDirection direction);
typedef void(^DidDisengageRefresh)(YARefreshDirection direction);

@interface YAPullRefreshController : NSObject<MSPullToRefreshDelegate> {
  MSPullToRefreshController *_ptrc;
}

@property (nonatomic, retain) UIView *pullRefreshHeaderView;
@property (nonatomic, retain) UIView *pullRefreshFooterView;
@property (nonatomic, assign) YARefreshableDirection refreshableDirection;
@property (nonatomic, assign) UIEdgeInsets refreshingInsets;
@property (nonatomic, assign) UIEdgeInsets refreshableInsets;
@property (nonatomic, copy) CanEngageRefresh canEngageRefreshBlock;
@property (nonatomic, copy) DidEngageRefresh didEngageRefreshBlock;
@property (nonatomic, copy) DidDisengageRefresh didDisengageRefreshBlock;

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

- (void) setCanEngageRefreshBlock:(CanEngageRefresh)canEngageRefreshBlock
         didDisengageRefreshBlock:(DidDisengageRefresh)didDisengageRefreshBlock
            didEngageRefreshBlock:(DidEngageRefresh)didEngageRefreshBlock;

@end
