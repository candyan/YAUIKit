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

@interface YARefreshControl ()

@property (nonatomic, assign) YARefreshableDirection refreshableDirection;
@property (nonatomic, readwrite, assign) YARefreshDirection refreshingDirection;

@property (nonatomic, strong) NSMutableDictionary *refreshViews;

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

    _canRefreshDirection = kYARefreshableDirectionNone;

    // observe the contentOffset. NSKeyValueObservingOptionPrior is CRUCIAL!
    [_scrollView addObserver:self
                  forKeyPath:@"contentOffset"
                     options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior
                     context:NULL];

    [self setRefreshView:[self _defaultRefreshViewForDirection:kYARefreshDirectionBottom]
            forDirection:kYARefreshDirectionBottom];
    [self setRefreshView:[self _defaultRefreshViewForDirection:kYARefreshDirectionTop]
            forDirection:kYARefreshDirectionTop];
  }
  return self;
}

#pragma mark - life cycle

- (void)dealloc
{
  [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - Getter

- (NSMutableDictionary *)refreshViews
{
  if (!_refreshViews) {
    _refreshViews = [NSMutableDictionary dictionary];
  }
  return _refreshViews;
}

- (UIView *)refreshViewAtDirection:(YARefreshDirection)direction
{
  return self.refreshViews[@(direction)];
}

#pragma mark - Setter

- (void)setRefreshView:(UIView *)customView forDirection:(YARefreshDirection)direction
{
  UIView *refreshView = [self refreshViewAtDirection:direction];
  if (refreshView) {
    [refreshView removeFromSuperview];
  }
  [self.refreshViews setObject:customView forKey:@(direction)];

  if (direction == kYARefreshDirectionTop
      && [UIDevice currentDevice].systemVersion.floatValue >= 7.0f) {
    [self.scrollView insertSubview:customView atIndex:0];
  } else {
    [self.scrollView addSubview:customView];
  }

  [self _layoutRefreshViewForDirection:direction];
}

- (void)setCanRefreshDirection:(YARefreshableDirection)canRefreshDirection
{
  _canRefreshDirection = canRefreshDirection;

  for (NSInteger index = 0; index < 4; index++) {
    YARefreshDirection direction = 1 << index;
    UIView *refreshView = [self refreshViewAtDirection:direction];
    if (direction & canRefreshDirection) {
      [refreshView setHidden:NO];
      [self _layoutRefreshViewForDirection:direction];
    } else {
      [refreshView setHidden:YES];
    }
  }
}

- (void)_setRefreshState:(YARefreshState)refreshState atDirection:(YARefreshDirection)direction
{
  if ([[self refreshViewAtDirection:direction] isKindOfClass:[YARefreshView class]]) {
    YARefreshView *refreshView = (YARefreshView *)[self refreshViewAtDirection:direction];
    [refreshView layoutSubviewsForRefreshState:refreshState];
  }

  if ([self.delegate respondsToSelector:@selector(refreshControl:didRefreshStateChanged:atDirection:)]) {
    [self.delegate refreshControl:self didRefreshStateChanged:kYARefreshStateStop atDirection:direction];
  }
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
      contentInset = UIEdgeInsetsMake(refreshingInset + contentInset.top, contentInset.left, contentInset.bottom, contentInset.right);
      contentOffset = CGPointMake(0, -(refreshingInset + contentInset.top));
      break;
    case kYARefreshDirectionLeft:
      refreshableDirection = kYARefreshableDirectionLeft;
      contentInset = UIEdgeInsetsMake(contentInset.top, refreshingInset + contentInset.left, contentInset.bottom, contentInset.right);
      contentOffset = CGPointMake(-(refreshingInset + contentInset.left), 0);
      break;
    case kYARefreshDirectionBottom:
      refreshableDirection = kYARefreshableDirectionBottom;
      contentOffset = CGPointMake(0, _scrollView.contentSize.height - _scrollView.bounds.size.height
                                  + refreshingInset + contentInset.bottom);
      break;
    case kYARefreshDirectionRight:
      refreshableDirection = kYARefreshableDirectionRight;
      contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, contentInset.bottom, refreshingInset + contentInset.right);
      contentOffset = CGPointMake(_scrollView.contentSize.width + refreshingInset + contentInset.right, 0);
      break;
    default:
      break;
  }

  [self _setRefreshState:kYARefreshStateLoading atDirection:direction];

  NSTimeInterval duration = flag ? 0.3f : 0.0f;
  [UIView animateWithDuration:duration animations:^{
    _scrollView.contentInset = contentInset;
    _scrollView.contentOffset = contentOffset;
  } completion:^(BOOL finished) {
    self.refreshingDirection |= direction;
    self.refreshableDirection &= ~refreshableDirection;
    if (self.refreshHandleAction) {
      self.refreshHandleAction(direction);
    }
  }];
}

- (void)stopRefreshAtDirection:(YARefreshDirection)direction completion:(void (^)())completion
{
  [self stopRefreshAtDirection:direction animated:NO completion:completion];
}

- (void)stopRefreshAtDirection:(YARefreshDirection)direction animated:(BOOL)flag completion:(void (^)())completion
{
  [self _setRefreshState:kYARefreshStateStop atDirection:direction];
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

  UIView *refreshView = [self refreshViewAtDirection:direction];

  YARefreshDirection refreshingDirection = direction;
  YARefreshableDirection refreshableDirection = kYARefreshableDirectionNone;
  BOOL canEngage = NO;
  UIEdgeInsets contentInset = _scrollView.contentInset;

  CGFloat refreshViewHeight = refreshView.frame.size.height;
  CGFloat refreshableInset = refreshViewHeight;
  if ([self.delegate respondsToSelector:@selector(refreshControl:refreshableInsetForDirection:)]) {
    refreshableInset = [self.delegate refreshControl:self refreshableInsetForDirection:direction];
  }

  CGFloat refreshingInset = refreshViewHeight;
  if ([self.delegate respondsToSelector:@selector(refreshControl:refreshingInsetForDirection:)]) {
    refreshingInset = [self.delegate refreshControl:self refreshingInsetForDirection:direction];
  }

  CGFloat threshold = 0.0f;
  switch (direction) {
    case kYARefreshDirectionTop:
      refreshableDirection = kYARefreshableDirectionTop;
      threshold = -oldOffset.y - self.originContentInsets.top;
      contentInset = UIEdgeInsetsMake(refreshingInset + contentInset.top,
                                      contentInset.left,
                                      contentInset.bottom,
                                      contentInset.right);
      break;
    case kYARefreshDirectionLeft:
      refreshableDirection = kYARefreshableDirectionLeft;
      threshold = -oldOffset.x;
      canEngage = oldOffset.x < -refreshableInset;
      contentInset = UIEdgeInsetsMake(contentInset.top,
                                      refreshingInset + contentInset.left,
                                      contentInset.bottom,
                                      contentInset.right);
      break;
    case kYARefreshDirectionBottom: {
      refreshableDirection = kYARefreshableDirectionBottom;
      if (_scrollView.frame.size.height > _scrollView.contentSize.height) {
        threshold = oldOffset.y;
      }  else {
        threshold = ((CGRectGetHeight(self.scrollView.bounds) + oldOffset.y)
                     - (self.scrollView.contentSize.height + self.originContentInsets.bottom));
      }
      contentInset = UIEdgeInsetsMake(contentInset.top,
                                      contentInset.left,
                                      (contentInset.bottom + refreshableInset),
                                      contentInset.right);
      break;
    }
    case kYARefreshDirectionRight:
      refreshableDirection = kYARefreshableDirectionRight;
      threshold = oldOffset.x + _scrollView.frame.size.width - _scrollView.contentSize.width;
      contentInset = UIEdgeInsetsMake(contentInset.top,
                                      contentInset.left,
                                      contentInset.bottom,
                                      refreshingInset + contentInset.right);
      break;
    default:
      break;
  }

  canEngage = (threshold  > refreshableInset);

  if ([self.delegate respondsToSelector:@selector(refreshControl:didShowRefreshViewHeight:atDirection:)]
      && !canEngage) {
    threshold = MAX(threshold, 0);
    threshold = MIN(threshold, CGRectGetHeight(refreshView.bounds));
    [self.delegate refreshControl:self didShowRefreshViewHeight:threshold atDirection:direction];
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
        [self _setRefreshState:kYARefreshStateLoading atDirection:direction];
        [UIView animateWithDuration:.2f animations:^{
          _scrollView.contentInset = contentInset;
        } completion:^(BOOL finished) {
          if (self.refreshHandleAction) self.refreshHandleAction(direction);
        }];
      } else if (_scrollView.dragging
                 && !_scrollView.decelerating
                 && !(self.refreshableDirection & refreshableDirection)) {
        // only go in here the first time you've dragged past releasable offset
        self.refreshableDirection |= refreshableDirection;
        [self _setRefreshState:kYARefreshStateTrigger atDirection:direction];
      }
    } else if ((self.refreshableDirection & refreshableDirection) ) {
      // if you're here it means you've crossed back from the releasable offset
      self.refreshableDirection &= ~refreshableDirection;
      [self _setRefreshState:kYARefreshStateStop atDirection:direction];
    }
  }
}

#pragma mark - layout

- (void)_layoutRefreshViewForDirection:(YARefreshDirection)direction
{
  UIView *refreshView = [self refreshViewAtDirection:direction];
  CGFloat originY = 0.0f;

  if (_canRefreshDirection & direction) {
    [refreshView setHidden:NO];
    switch (direction) {
      case kYARefreshDirectionTop:
        originY = (([UIDevice currentDevice].systemVersion.floatValue < 7.0f || self.scrollView.contentOffset.y > 0)
                   ? -CGRectGetHeight(refreshView.frame) - self.originContentInsets.top
                   : self.scrollView.contentOffset.y) + self.originContentInsets.top;
        break;

      case kYARefreshDirectionBottom:
        originY = ((self.scrollView.contentSize.height > self.scrollView.frame.size.height)
                   ? self.scrollView.contentSize.height + self.originContentInsets.bottom
                   : self.scrollView.frame.size.height);
        break;

      default:
        break;
    }
    [refreshView setFrameOriginY:originY];
  } else {
    [refreshView setHidden:YES];
  }
}

#pragma mark - Factory

static CGFloat const kYARefreshViewDefaultHeight = 44.0f;
- (YARefreshView *)_defaultRefreshViewForDirection:(YARefreshDirection)direction
{
  CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), kYARefreshViewDefaultHeight);
  YARefreshView *refreshView = [[YARefreshView alloc] initWithFrame:frame];
  [refreshView layoutSubviewsForRefreshState:kYARefreshStateStop];
  return refreshView;
}

@end
