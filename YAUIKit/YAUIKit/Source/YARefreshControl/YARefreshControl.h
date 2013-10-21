//
//  YARefreshControl.h
//  YAUIKit
//
//  Created by liuyan on 13-10-18.
//  Copyright (c) 2013年 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>

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

typedef NS_ENUM(NSUInteger, YARefreshState)
{
  kYARefreshStateStop = 1 << 0,
  kYARefreshStateTrigger = 1 << 1,
  kYARefreshStateLoading = 1 << 2,
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

- (void)setTitle:(NSString *)title forState:(YARefreshState)state atDirection:(YARefreshDirection)direction;
- (void)setSubTilte:(NSString *)subTitle forState:(YARefreshState)state atDirection:(YARefreshDirection)direction;

- (void)setIndicatorColor:(UIColor *)indicatorColor forDirection:(YARefreshDirection)direction;
- (void)setTitleColor:(UIColor *)titleColor forDirection:(YARefreshDirection)direction;
- (void)setSubTilteColor:(UIColor *)subTitleColor forDirection:(YARefreshDirection)direction;
- (void)setTitleFont:(UIFont *)titleFont forDirection:(YARefreshDirection)direction;
- (void)setSubTilteFont:(UIFont *)subTitleFont forDirection:(YARefreshDirection)direction;

@end

@protocol YARefreshControlDelegate <NSObject>

@optional

/*
 * asks the delegate which refresh directions it would like enabled
 */
- (BOOL)refreshControl:(YARefreshControl *)refreshController canRefreshInDirection:(YARefreshDirection)direction;

/*
 * inset threshold to engage refresh
 */
- (CGFloat)refreshControl:(YARefreshControl *)refreshController refreshableInsetForDirection:(YARefreshDirection)direction;

/*
 * inset that the direction retracts back to after refresh started
 */
- (CGFloat)refreshControl:(YARefreshControl *)refreshController refreshingInsetForDirection:(YARefreshDirection)direction;

/*
 * informs the delegate that lifting your finger will trigger a refresh
 * in that direction. This is only called when you cross the refreshable
 * offset defined in the respective MSInflectionOffsets.
 */
- (void)refreshControl:(YARefreshControl *)refreshControl canEngageRefreshDirection:(YARefreshDirection)direction;

/*
 * informs the delegate that lifting your finger will NOT trigger a refresh
 * in that direction. This is only called when you cross the refreshable
 * offset defined in the respective MSInflectionOffsets.
 */
- (void)refreshControl:(YARefreshControl *)refreshControl didDisengageRefreshDirection:(YARefreshDirection)direction;

/*
 * informs the delegate that refresh sequence has been started by the user
 * in the specified direction. A good place to start any async work.
 */
- (void)refreshControl:(YARefreshControl *)refreshControl didEngageRefreshDirection:(YARefreshDirection)direction;

@end
