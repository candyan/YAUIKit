//
// UIScrollView+SVPullToRefresh.h
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

typedef NS_ENUM(NSUInteger, YARefreshPosition) {
  kYARefreshPositionTop = 0,
  kYARefreshPositionBottom,
};

typedef NS_ENUM(NSUInteger, YARefreshState){
  kYARefreshStateStopped   = 1 << 0,
  kYARefreshStateTriggered = 1 << 1,
  kYARefreshStateLoading   = 1 << 2,
};

@interface SVPullToRefreshView : UIView

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *subtitleLabel;

@property (nonatomic, readonly) YARefreshState refreshState;
@property (nonatomic, readonly) YARefreshPosition refreshPosition;

- (void)setTitle:(NSString *)title forState:(YARefreshState)state;
- (void)setSubtitle:(NSString *)subtitle forState:(YARefreshState)state;
- (void)setCustomView:(UIView *)view forState:(YARefreshState)state;

- (void)startAnimating;
- (void)stopAnimating;

// deprecated; use setSubtitle:forState: instead
@property (nonatomic, strong, readonly) UILabel *dateLabel DEPRECATED_ATTRIBUTE;
@property (nonatomic, strong) NSDate *lastUpdatedDate DEPRECATED_ATTRIBUTE;
@property (nonatomic, strong) NSDateFormatter *dateFormatter DEPRECATED_ATTRIBUTE;

// deprecated; use [self.scrollView triggerPullToRefresh] instead
- (void)triggerRefresh DEPRECATED_ATTRIBUTE;

@end

@interface UIScrollView (SVPullToRefresh)

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler position:(YARefreshPosition)position;
- (void)triggerPullToRefresh;

@property (nonatomic, strong, readonly) SVPullToRefreshView *pullToRefreshView;
@property (nonatomic, assign) BOOL showsPullToRefresh;

@end


