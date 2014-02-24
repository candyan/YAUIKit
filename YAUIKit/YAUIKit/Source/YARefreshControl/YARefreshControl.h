//
//  YARefreshControl.h
//  YAUIKit
//
//  Created by liuyan on 13-10-18.
//  Copyright (c) 2013年 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YARefreshView.h"

typedef NS_ENUM(NSUInteger, YARefreshDirection)
{
  kYARefreshDirectionNone = 0,
  kYARefreshDirectionTop = 1 << 0,
  kYARefreshDirectionBottom = 1 << 1,
  kYARefreshDirectionLeft = 1 << 2,
  kYARefreshDirectionRight = 1 << 3,
};

typedef NS_ENUM(NSUInteger, YARefreshableDirection)
{
  kYARefreshableDirectionNone = 0,
  kYARefreshableDirectionTop = 1 << 0,
  kYARefreshableDirectionBottom = 1 << 1,
  kYARefreshableDirectionLeft = 1 << 2,
  kYARefreshableDirectionRight = 1 << 3,
};

@protocol YARefreshControlDelegate;

@interface YARefreshControl : NSObject {

  YARefreshableDirection _refreshableDirections;

  // used internally to capture the did end dragging state
  BOOL _wasDragging;
}

@property (nonatomic, readonly, strong) UIScrollView *scrollView;
@property (nonatomic, assign) UIEdgeInsets originContentInsets;
@property (nonatomic, assign) YARefreshableDirection canRefreshDirection;
@property (nonatomic, readonly, assign) YARefreshDirection refreshingDirection;
@property (nonatomic, weak) id<YARefreshControlDelegate> delegate;
@property (nonatomic, copy) void(^refreshHandleAction)(YARefreshDirection loadingDirection);

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

- (void)triggerRefreshAtDirection:(YARefreshDirection)direction;
- (void)triggerRefreshAtDirection:(YARefreshDirection)direction animated:(BOOL)flag;

- (void)stopRefreshAtDirection:(YARefreshDirection)direction completion:(void(^)())completion;
- (void)stopRefreshAtDirection:(YARefreshDirection)direction animated:(BOOL)flag completion:(void(^)())completion;

- (UIView *)refreshViewAtDirection:(YARefreshDirection)direction;
- (void)setRefreshView:(UIView *)customView forDirection:(YARefreshDirection)direction;

@end

@protocol YARefreshControlDelegate <NSObject>

@optional

- (void)refreshControl:(YARefreshControl *)refreshControl didShowRefreshViewHeight:(CGFloat)progress atDirection:(YARefreshDirection)direction;

- (void)refreshControl:(YARefreshControl *)refreshControl didRefreshStateChanged:(YARefreshState)refreshState atDirection:(YARefreshDirection)direction;

/*
 * inset threshold to engage refresh
 */
- (CGFloat)refreshControl:(YARefreshControl *)refreshController refreshableInsetForDirection:(YARefreshDirection)direction;

/*
 * inset that the direction retracts back to after refresh started
 */
- (CGFloat)refreshControl:(YARefreshControl *)refreshController refreshingInsetForDirection:(YARefreshDirection)direction;

@end
