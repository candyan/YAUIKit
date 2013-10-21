//
//  YARefreshControl.m
//  YAUIKit
//
//  Created by liuyan on 13-10-18.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//
#import "YARefreshControl.h"

#import "UIView+YAUIKit.h"
#import "UIFont+YAUIKit.h"
#import "YARefreshIndicator.h"

static CGFloat const kYARefreshViewDefaultHeight = 44.0f;
static CGFloat const kYARefreshIndicatorDefaultHeight = 24.0f;
static CGFloat const kRefreshLabelLeftPadding = 37.0f;
static CGFloat const kRefreshLabelTopPadding = 10.0f;

static NSInteger const kYARefreshTitleTag = 1000;
static NSInteger const kYARefreshIndicatorTag = 1001;
static NSInteger const kYARefreshSubTitleTag = 1002;

@interface YARefreshControl ()

@property (nonatomic, assign) YARefreshableDirection refreshableDirection;
@property (nonatomic, readwrite, assign) YARefreshDirection refreshingDirection;

@property (nonatomic, strong) NSMutableDictionary *titles;
@property (nonatomic, strong) NSMutableDictionary *subTitles;
@property (nonatomic, strong) NSDate *lastRefreshDate;

@end

@implementation YARefreshControl

#pragma mark - init
- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
  self = [super init];
  if (self) {
    // set ivars
    _scrollView = scrollView;
    _originContentInsets = scrollView.contentInset;
    // observe the contentOffset. NSKeyValueObservingOptionPrior is CRUCIAL!
    [_scrollView addObserver:self
                  forKeyPath:@"contentOffset"
                     options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior
                     context:NULL];
  }
  return self;
}

#pragma mark - life cycle

- (void)dealloc
{
  [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - Set & Get

- (NSMutableDictionary *)titles
{
  if (!_titles) {
    NSDictionary *refreshTopTitles = @{@(kYARefreshStateStop): NSLocalizedString(@"下拉可以刷新", nil),
                                       @(kYARefreshStateTrigger): NSLocalizedString(@"松开即可刷新", nil),
                                       @(kYARefreshStateLoading): NSLocalizedString(@"正在刷新...", nil)};
    NSDictionary *refreshBottomTitles = @{@(kYARefreshStateStop): NSLocalizedString(@"上拉可以加载更多", nil),
                                          @(kYARefreshStateTrigger): NSLocalizedString(@"松开即可加载更多", nil),
                                          @(kYARefreshStateLoading): NSLocalizedString(@"正在加载更多...", nil)};
    _titles = [NSMutableDictionary dictionaryWithObjectsAndKeys:
               refreshTopTitles, @(kYARefreshDirectionTop),
               refreshBottomTitles, @(kYARefreshDirectionBottom), nil];
  }
  return _titles;
}

- (NSMutableDictionary *)subTitles
{
  if (!_subTitles) {

    _subTitles = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  @{}, @(kYARefreshDirectionTop),
                  @{}, @(kYARefreshDirectionBottom), nil];
  }
  return _subTitles;
}

- (UIView *)refreshViewAtDirection:(YARefreshDirection)direction
{
  return [self.scrollView viewWithTag:direction];
}

- (void)setRefreshView:(UIView *)customView forDirection:(YARefreshDirection)direction
{
  [customView setTag:direction];
  UIView *refreshView = [self refreshViewAtDirection:direction];
  if (refreshView) {
    [refreshView removeFromSuperview];
  }
  [self.scrollView insertSubview:customView atIndex:0];
  [self _layoutRefreshViewForDirection:direction];
}

- (void)setTitle:(NSString *)title forState:(YARefreshState)state atDirection:(YARefreshDirection)direction
{
  __weak typeof(self) weakSelf = self;
  [self _enumerateForHandleDirection:direction hanldeBlock:^(YARefreshDirection direction) {
    NSMutableDictionary *titlesForDirection = [NSMutableDictionary dictionaryWithDictionary:weakSelf.titles[@(direction)]];
    [titlesForDirection setObject:title forKey:@(state)];
    [weakSelf.titles setObject:[titlesForDirection copy] forKey:@(direction)];
  }];
}

- (void)setSubTilte:(NSString *)subTitle forState:(YARefreshState)state atDirection:(YARefreshDirection)direction
{
  __weak typeof(self) weakSelf = self;
  [self _enumerateForHandleDirection:direction hanldeBlock:^(YARefreshDirection direction) {
    NSMutableDictionary *subTitlesForDirection = [NSMutableDictionary dictionaryWithDictionary:weakSelf.subTitles[@(direction)]];
    [subTitlesForDirection setObject:subTitle forKey:@(state)];
    [weakSelf.subTitles setObject:[subTitlesForDirection copy] forKey:@(direction)];
  }];
}

- (void)setCanRefreshDirection:(YARefreshableDirection)canRefreshDirection
{
  _canRefreshDirection = canRefreshDirection;

  [self _enumerateForHandleDirection:(YARefreshDirection)canRefreshDirection hanldeBlock:^(YARefreshDirection direction) {
    [self _layoutRefreshViewForDirection:direction];
  }];
}

#pragma mark - custom refresh view style

- (void)setIndicatorColor:(UIColor *)indicatorColor forDirection:(YARefreshDirection)direction
{
  [self _enumerateForHandleDirection:direction hanldeBlock:^(YARefreshDirection handleDirection) {
    UIView *refreshView = [self refreshViewAtDirection:handleDirection];
    YARefreshIndicator *indicator = (YARefreshIndicator *)[refreshView viewWithTag:kYARefreshIndicatorTag];
    [indicator setIndicatorColor:indicatorColor];
  }];
}

- (void)setTitleColor:(UIColor *)titleColor forDirection:(YARefreshDirection)direction
{
  [self _enumerateForHandleDirection:direction hanldeBlock:^(YARefreshDirection handleDirection) {
    UIView *refreshView = [self refreshViewAtDirection:handleDirection];
    UILabel *titleLabel = (UILabel *)[refreshView viewWithTag:kYARefreshTitleTag];
    [titleLabel setTextColor:titleColor];
  }];
}

- (void)setSubTilteColor:(UIColor *)subTitleColor forDirection:(YARefreshDirection)direction
{
  [self _enumerateForHandleDirection:direction hanldeBlock:^(YARefreshDirection handleDirection) {
    UIView *refreshView = [self refreshViewAtDirection:handleDirection];
    UILabel *subTitleLabel = (UILabel *)[refreshView viewWithTag:kYARefreshSubTitleTag];
    [subTitleLabel setTextColor:subTitleColor];
  }];
}

- (void)setTitleFont:(UIFont *)titleFont forDirection:(YARefreshDirection)direction
{
  [self _enumerateForHandleDirection:direction hanldeBlock:^(YARefreshDirection handleDirection) {
    UIView *refreshView = [self refreshViewAtDirection:handleDirection];
    UILabel *titleLabel = (UILabel *)[refreshView viewWithTag:kYARefreshTitleTag];
    [titleLabel setFont:titleFont];
  }];
}

- (void)setSubTilteFont:(UIFont *)subTitleFont forDirection:(YARefreshDirection)direction
{
  [self _enumerateForHandleDirection:direction hanldeBlock:^(YARefreshDirection handleDirection) {
    UIView *refreshView = [self refreshViewAtDirection:handleDirection];
    UILabel *subTitleLabel = (UILabel *)[refreshView viewWithTag:kYARefreshSubTitleTag];
    [subTitleLabel setFont:subTitleFont];
  }];
}

#pragma mark - KVO

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
  if ([keyPath isEqualToString:@"contentOffset"]) {
    // for each direction, check to see if refresh sequence needs to be updated.
    for (NSInteger index = 0; index < 4; index++) {
      YARefreshDirection direction = 1 << index;
      BOOL canRefresh = (self.canRefreshDirection & direction);
      if ([self.delegate respondsToSelector:@selector(refreshControl:canRefreshInDirection:)]) {
        canRefresh = [self.delegate refreshControl:self canRefreshInDirection:direction];
      }
      if (canRefresh) {
        [self _checkOffsetsForDirection:direction change:change];
      }
    }
    _wasDragging = _scrollView.dragging;
  }
}

#pragma mark - trigger & stop refresh

- (void)triggerRefreshAtDirection:(YARefreshDirection)direction
{
  [self triggerRefreshAtDirection:direction animated:NO];
}

- (void)triggerRefreshAtDirection:(YARefreshDirection)direction animated:(BOOL)flag
{
  YARefreshableDirection refreshableDirection = kYARefreshableDirectionNone;
  UIEdgeInsets contentInset = _scrollView.contentInset;
  CGPoint contentOffset = CGPointZero;

  CGFloat refreshingInset = 44.0f;
  if ([self.delegate respondsToSelector:@selector(refreshControl:refreshingInsetForDirection:)]) {
    refreshingInset = [self.delegate refreshControl:self refreshingInsetForDirection:direction];
  }

  switch (direction) {
    case kYARefreshDirectionTop:
      refreshableDirection = kYARefreshableDirectionTop;
      contentInset = UIEdgeInsetsMake(refreshingInset, contentInset.left, contentInset.bottom, contentInset.right);
      contentOffset = CGPointMake(0, -refreshingInset);
      break;
    case kYARefreshDirectionLeft:
      refreshableDirection = kYARefreshableDirectionLeft;
      contentInset = UIEdgeInsetsMake(contentInset.top, refreshingInset, contentInset.bottom, contentInset.right);
      contentOffset = CGPointMake(-refreshingInset, 0);
      break;
    case kYARefreshDirectionBottom:
      refreshableDirection = kYARefreshableDirectionBottom;
      contentOffset = CGPointMake(0, _scrollView.contentSize.height - _scrollView.bounds.size.height
                                  + refreshingInset + contentInset.bottom);
      break;
    case kYARefreshDirectionRight:
      refreshableDirection = kYARefreshableDirectionRight;
      contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, contentInset.bottom, refreshingInset);
      contentOffset = CGPointMake(_scrollView.contentSize.width + refreshingInset, 0);
      break;
    default:
      break;
  }

  NSTimeInterval duration = flag ? 0.3f : 0.0f;
  [UIView animateWithDuration:duration animations:^{
    _scrollView.contentInset = contentInset;
    _scrollView.contentOffset = contentOffset;
  } completion:^(BOOL finished) {
    self.refreshingDirection |= direction;
    self.refreshableDirection &= ~refreshableDirection;
    if ([self.delegate respondsToSelector:@selector(refreshControl:didEngageRefreshDirection:)]) {
      [self.delegate refreshControl:self didEngageRefreshDirection:direction];
    }
  }];
}

- (void)stopRefreshAtDirection:(YARefreshDirection)direction completion:(void (^)())completion
{
  [self stopRefreshAtDirection:direction animated:NO completion:completion];
}

- (void)stopRefreshAtDirection:(YARefreshDirection)direction animated:(BOOL)flag completion:(void (^)())completion
{

  [self _resetRefresViewForState:kYARefreshStateStop atDirection:direction];
  NSTimeInterval duration = flag ? 0.4f : 0.0f;

  [UIView animateWithDuration:duration animations:^{
    _scrollView.contentInset = self.originContentInsets;
    self.refreshingDirection &= ~direction;
  } completion:^(BOOL finished) {
    if (finished) {
      if (completion) {
        completion();
      }
    }
  }];
}

#pragma mark - Private Methods

- (void) _checkOffsetsForDirection:(YARefreshDirection)direction change:(NSDictionary *)change {

  // define some local ivars that disambiguates according to direction
  CGPoint oldOffset = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
  if (direction == kYARefreshDirectionTop
      || direction == kYARefreshDirectionBottom) {
    [self _layoutRefreshViewForDirection:direction];
  }

  if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f) {
    UIView *refreshView = [self refreshViewAtDirection:direction];
    if (direction == kYARefreshDirectionTop
        && oldOffset.y < 0
        && oldOffset.y > -kYARefreshViewDefaultHeight) {
      YARefreshIndicator *indicator = (YARefreshIndicator *)[refreshView viewWithTag:kYARefreshIndicatorTag];

      CGFloat scrollOffsetThreshold = - (CGRectGetHeight(refreshView.bounds) + self.originContentInsets.top);
      CGFloat diffOffsetY = oldOffset.y - scrollOffsetThreshold;
      CGFloat percent = (1 - diffOffsetY / CGRectGetHeight(refreshView.bounds));
      [indicator didLoaded:percent];
    }
  }

  YARefreshDirection refreshingDirection = direction;
  YARefreshableDirection refreshableDirection = kYARefreshableDirectionNone;
  BOOL canEngage = NO;
  UIEdgeInsets contentInset = _scrollView.contentInset;

  CGFloat refreshViewHeight = [self refreshViewAtDirection:direction].frame.size.height;
  CGFloat refreshableInset = refreshViewHeight;
  if ([self.delegate respondsToSelector:@selector(refreshControl:refreshableInsetForDirection:)]) {
    refreshableInset = [self.delegate refreshControl:self refreshableInsetForDirection:direction];
  }

  CGFloat refreshingInset = refreshViewHeight;
  if ([self.delegate respondsToSelector:@selector(refreshControl:refreshingInsetForDirection:)]) {
    refreshingInset = [self.delegate refreshControl:self refreshingInsetForDirection:direction];
  }

  switch (direction) {
    case kYARefreshDirectionTop:
      refreshableDirection = kYARefreshableDirectionTop;
      canEngage = oldOffset.y < - refreshableInset;
      contentInset = UIEdgeInsetsMake(refreshingInset + contentInset.top,
                                      contentInset.left,
                                      contentInset.bottom,
                                      contentInset.right);
      break;
    case kYARefreshDirectionLeft:
      refreshableDirection = kYARefreshableDirectionLeft;
      canEngage = oldOffset.x < -refreshableInset;
      contentInset = UIEdgeInsetsMake(contentInset.top,
                                      refreshingInset + contentInset.left,
                                      contentInset.bottom,
                                      contentInset.right);
      break;
    case kYARefreshDirectionBottom: {
      refreshableDirection = kYARefreshableDirectionBottom;
      if (_scrollView.frame.size.height > _scrollView.contentSize.height) {
        canEngage = (oldOffset.y > refreshableInset);
      }  else {
        CGFloat threshold = ((CGRectGetHeight(self.scrollView.bounds) + oldOffset.y)
                             - (self.scrollView.contentSize.height + self.scrollView.contentInset.bottom));
        canEngage = (threshold  > refreshableInset);
      }
      contentInset = UIEdgeInsetsMake(contentInset.top,
                                      contentInset.left,
                                      (contentInset.bottom + refreshableInset),
                                      contentInset.right);
      break;
    }
    case kYARefreshDirectionRight:
      refreshableDirection = kYARefreshableDirectionRight;
      canEngage = oldOffset.x + _scrollView.frame.size.width - _scrollView.contentSize.width > refreshableInset;
      contentInset = UIEdgeInsetsMake(contentInset.top,
                                      contentInset.left,
                                      contentInset.bottom,
                                      refreshingInset + contentInset.right);
      break;
    default:
      break;
  }

  if (!(self.refreshingDirection & refreshingDirection)) {
    // only go in here if the requested direction is enabled and not refreshing
    if (canEngage) {
      // only go in here if user pulled past the inflection offset
      if (_wasDragging != _scrollView.dragging
          && _scrollView.decelerating
          && [change objectForKey:NSKeyValueChangeNotificationIsPriorKey]
          && (self.refreshableDirection & refreshableDirection)) {
        // if you are decelerating, it means you've stopped dragging.
        self.refreshingDirection |= refreshingDirection;
        self.refreshableDirection &= ~refreshableDirection;
        [self _resetRefresViewForState:kYARefreshStateLoading atDirection:direction];
        if (direction & kYARefreshDirectionTop) {
          self.lastRefreshDate = [NSDate date];
        }
        [UIView animateWithDuration:.2f animations:^{
          _scrollView.contentInset = contentInset;
        } completion:^(BOOL finished) {
          if ([self.delegate respondsToSelector:@selector(refreshControl:didEngageRefreshDirection:)]) {
            [self.delegate refreshControl:self didEngageRefreshDirection:direction];
          } else if (self.refreshHandleAction) {
            self.refreshHandleAction(direction);
          }
        }];
      } else if (_scrollView.dragging
                 && !_scrollView.decelerating
                 && !(self.refreshableDirection & refreshableDirection)) {
        // only go in here the first time you've dragged past releasable offset
        self.refreshableDirection |= refreshableDirection;
        [self _resetRefresViewForState:kYARefreshStateTrigger atDirection:direction];
        if ([self.delegate respondsToSelector:@selector(refreshControl:canEngageRefreshDirection:)]) {
          [self.delegate refreshControl:self canEngageRefreshDirection:direction];
        }
      }
    } else if ((self.refreshableDirection & refreshableDirection) ) {
      // if you're here it means you've crossed back from the releasable offset
      self.refreshableDirection &= ~refreshableDirection;
      [self _resetRefresViewForState:kYARefreshStateStop atDirection:direction];
      if ([_delegate respondsToSelector:@selector(refreshControl:didDisengageRefreshDirection:)]) {
        [self.delegate refreshControl:self didDisengageRefreshDirection:direction];
      }
    }
  }
}

#pragma mark - layout

- (void)_resetRefresViewForState:(YARefreshState)state atDirection:(YARefreshDirection)direction
{
  UIView *refreshView = [self refreshViewAtDirection:direction];
  UILabel *titleLable = (UILabel *)[refreshView viewWithTag:kYARefreshTitleTag];
  NSString *refreshTitle = [self.titles[@(direction)] objectForKey:@(state)];
  [titleLable setText:refreshTitle];

  UILabel *subTilteLabel = (UILabel *)[refreshView viewWithTag:kYARefreshSubTitleTag];
  NSString *refreshSubTitle = [self.subTitles[@(direction)] objectForKey:@(state)];
  if (!refreshSubTitle
      && direction == kYARefreshDirectionTop) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
    [formatter setLocale:locale];

    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *lastRefreshDateString;
    if (self.lastRefreshDate) {
      lastRefreshDateString = [formatter stringFromDate:self.lastRefreshDate];
    } else {
      lastRefreshDateString = @"没有刷新";
    }
    refreshSubTitle = [NSString stringWithFormat:@"最后刷新：%@", lastRefreshDateString];
  }
  [subTilteLabel setText:refreshSubTitle];

  YARefreshIndicator *indicator = (YARefreshIndicator *)[refreshView viewWithTag:kYARefreshIndicatorTag];
  if (state == kYARefreshStateLoading) {
    [indicator startLoading];
  } else {
    [indicator stopLoading];
  }
}

- (void)_layoutRefreshViewForDirection:(YARefreshDirection)direction
{
  UIView *refreshView = [self refreshViewAtDirection:direction];
  if (!refreshView) {
    refreshView = [self _newRefreshViewForDirection:direction];
    if (direction == kYARefreshDirectionTop
        && [UIDevice currentDevice].systemVersion.floatValue >= 7.0f) {
      [self.scrollView insertSubview:refreshView atIndex:0];
    } else {
      [self.scrollView addSubview:refreshView];
    }

  }

  CGFloat originY = 0.0f;

  switch (direction) {
    case kYARefreshDirectionTop:
      originY = (([UIDevice currentDevice].systemVersion.floatValue < 7.0f)
                 ? -CGRectGetHeight(refreshView.frame)
                 : self.scrollView.contentOffset.y);
      originY -= self.originContentInsets.top;
      break;

    case kYARefreshDirectionBottom:
      originY = self.scrollView.contentSize.height + self.originContentInsets.bottom;
      break;

    default:
      break;
  }

  [refreshView setFrameOriginY:originY];
}

#pragma mark - Util

- (UIView *)_newRefreshViewForDirection:(YARefreshDirection)direction
{
  UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                         CGRectGetWidth(self.scrollView.bounds),
                                                         kYARefreshViewDefaultHeight)];
  [refreshView setTag:direction];
  [refreshView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin)];
  [refreshView setBackgroundColor:[UIColor clearColor]];

  CGFloat labelOriginX = CGRectGetMidX(refreshView.bounds) - kRefreshLabelLeftPadding;
  CGFloat lableWidth = CGRectGetMidX(self.scrollView.bounds);
  [refreshView addSubview:({
    CGRect frame = CGRectMake(labelOriginX,
                              kRefreshLabelTopPadding,
                              lableWidth,
                              15);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
    [titleLabel setTag:kYARefreshTitleTag];
    [titleLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin)];
    [titleLabel setFont:[UIFont helveticaFontOfSize:13.0f]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];

    NSString *refreshTitle = [self.titles[@(direction)] objectForKey:@(kYARefreshStateStop)];
    [titleLabel setText:refreshTitle];

    titleLabel;
  })];

  [refreshView addSubview:({
    CGFloat subTitleHeight = 13.0f;
    CGRect frame = CGRectMake(labelOriginX,
                              CGRectGetHeight(refreshView.bounds) - subTitleHeight - 3,
                              lableWidth, subTitleHeight);
    UILabel *subTitleLable = [[UILabel alloc] initWithFrame:frame];
    [subTitleLable setTag:kYARefreshSubTitleTag];
    [subTitleLable setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
    [subTitleLable setFont:[UIFont helveticaFontOfSize:11.0f]];
    [subTitleLable setBackgroundColor:[UIColor clearColor]];

    NSString *refreshSubTitle = [self.subTitles[@(direction)] objectForKey:@(kYARefreshStateStop)];
    [subTitleLable setText:refreshSubTitle];

    subTitleLable;
  })];

  [refreshView addSubview:({
    CGRect frame = CGRectMake(CGRectGetMidX(self.scrollView.bounds) - kRefreshLabelLeftPadding - 26 - 5,
                              7, kYARefreshIndicatorDefaultHeight, kYARefreshIndicatorDefaultHeight);
    YARefreshIndicator *indicator = [[YARefreshIndicator alloc] initWithFrame:frame];
    [indicator setTag:kYARefreshIndicatorTag];
    [indicator setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin)];
    indicator;
  })];
  return refreshView;
}

- (void)_enumerateForHandleDirection:(YARefreshDirection)handleDirection
                         hanldeBlock:(void(^)(YARefreshDirection handleDirection))handleBlock
{
  for (NSInteger index = 0; index < 4; index++) {
    YARefreshDirection direction = 1 << index;
    if ((handleDirection & direction) == direction) {
      if (handleBlock) {
        handleBlock(direction);
      }
    }
  }
}

@end
