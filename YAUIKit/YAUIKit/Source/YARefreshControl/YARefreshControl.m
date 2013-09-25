//
//  YARefreshContrl.m
//  YAUIKit
//
//  Created by liu yan on 9/23/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "YARefreshControl.h"
#import "YARefreshIndicator.h"
#import "UIView+YAUIKit.h"

#ifndef fequal
#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#endif

#ifndef equalzero
#define fequalzero(a) (fabs(a) < FLT_EPSILON)
#endif

static CGFloat const kRefreshViewHeight = 40.0f;
static NSTimeInterval const kRefreshAnimateDuration = 0.3f;

@interface YARefreshControl ()

@property (nonatomic, weak)   UIScrollView *scrollView;
@property (nonatomic, assign) YARefreshState refreshState;
@property (nonatomic, assign) UIEdgeInsets originEdgeInsets;

@property (nonatomic, assign) BOOL isObserving;

@property (nonatomic, weak)   UIView *refreshView;
@property (nonatomic, weak)   UILabel *refreshTitleLabel;
@property (nonatomic, weak)   YARefreshIndicator *indicator;

@property (nonatomic, strong) NSMutableDictionary *titleDictionary;
@property (nonatomic, strong) NSMutableDictionary *subTitleDictionary;

@property (nonatomic, copy)   void(^refreshActionHandle)();

@end

@implementation YARefreshControl

#pragma mark - init

- (instancetype)initWithScrollView:(UIScrollView *)scrollView 
               refreshActionHandle:(void (^)())actionHandle
{
  self = [super init];
  if (self) {
  	_scrollView = scrollView;
  	_originEdgeInsets = scrollView.contentInset;
    self.refreshActionHandle = actionHandle;
    
    self.refreshState = kYARefreshStateStopped;
    self.isObserving = NO;
    [self setRefreshEnable:YES];
  }
  return self;
}

- (void)dealloc
{
  [_refreshView removeFromSuperview];
  [self.scrollView removeObserver:self
                       forKeyPath:@"contentOffset"];
}

#pragma mark - Prop

- (NSMutableDictionary *)titleDictionary
{
  if (!_titleDictionary) {
    _titleDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@(kYARefreshStateStopped): @"下拉刷新",
                                                                       @(kYARefreshStateTriggered): @"松开可以刷新",
                                                                       @(kYARefreshStateLoading): @"正在刷新"}];
  }
  return _titleDictionary;
}

- (NSMutableDictionary *)subTitleDictionary
{
  if (!_subTitleDictionary) {
    _subTitleDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@(kYARefreshStateStopped): @" ",
                                                                          @(kYARefreshStateTriggered): @" ",
                                                                          @(kYARefreshStateLoading): @" "}];
  }
  return _subTitleDictionary;
}

- (UIView *)refreshView
{
  if (!_refreshView) {
    CGRect frame = self.scrollView.frame;
    frame.size.height = kRefreshViewHeight;
    frame.origin.y += self.originEdgeInsets.top;
    UIView *refreshView = [[UIView alloc] initWithFrame:frame];
    [refreshView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth
                                      | UIViewAutoresizingFlexibleBottomMargin)];
    [refreshView setBackgroundColor:[UIColor clearColor]];
    [self.scrollView.superview insertSubview:refreshView belowSubview:self.scrollView];
    _refreshView = refreshView;
  }
  return _refreshView;
}

- (UILabel *)refreshTitleLabel
{
  if (!_refreshTitleLabel) {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.refreshView.bounds];
    [titleLabel setNumberOfLines:2];
    [titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleBottomMargin)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.refreshView insertSubview:titleLabel atIndex:0];
    _refreshTitleLabel = titleLabel;
  }
  return _refreshTitleLabel;
}

- (YARefreshIndicator *)indicator
{
  if (!_indicator) {
    YARefreshIndicator *indicator = [[YARefreshIndicator alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [indicator setFrameOriginX:CGRectGetMidX(self.refreshView.bounds) / 2 - 10];
    [indicator setFrameOriginY:10];
    [indicator setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin
                                    | UIViewAutoresizingFlexibleTopMargin)];
    [self.refreshView addSubview:indicator];
    _indicator = indicator;
  }
  return _indicator;
}


#pragma mark - set & get

- (void)setRefreshEnable:(BOOL)refreshEnable
{
  _refreshEnable = refreshEnable;
  if (_refreshEnable) {
  	if (!self.isObserving) {
  	  [self.scrollView addObserver:self
  	                  forKeyPath:@"contentOffset"
  	                     options:NSKeyValueObservingOptionNew
  	                     context:nil];
  	  self.isObserving = YES;
  	}
  } else {
  	if (self.isObserving) {
  	  [self.scrollView removeObserver:self
  	  	                   forKeyPath:@"contentOffset"];
      [self _resetScrollViewContentInset];
  	  self.isObserving = NO;
  	}
  }
}

- (void)setRefreshState:(YARefreshState)refreshState
{
  if (_refreshState != refreshState) {
    YARefreshState previousState = _refreshState;
    _refreshState = refreshState;
    
    switch (refreshState) {
      case kYARefreshStateStopped:
        [self _resetScrollViewContentInset];
        break;
        
      case kYARefreshStateTriggered:
        break;
        
      case kYARefreshStateLoading:
        [self _setScrollViewContentInsetForLoading];
        
        if(previousState == kYARefreshStateTriggered
           && self.refreshActionHandle) {
          [self.indicator startLoading];
          double delayInSeconds = kRefreshAnimateDuration;
          dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
          dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.refreshActionHandle();
          });
        }
        break;
    }
    NSString *titletext = self.titleDictionary[@(refreshState)];
    NSString *subTitleText = self.subTitleDictionary[@(refreshState)];
    NSMutableArray *titleArray = [NSMutableArray array];
    if (titletext) {
      [titleArray addObject:titletext];
    }
    if (subTitleText) {
      [titleArray addObject:subTitleText];
    }
    [self.refreshTitleLabel setText:[titleArray componentsJoinedByString:@"\n"]];
  }
}

- (void)setTitle:(NSString *)title forState:(YARefreshState)state
{
  if (!title) title = @"";
  
  if (state & kYARefreshStateStopped) {
    [self.titleDictionary setObject:title forKey:@(kYARefreshStateStopped)];
  }
  if (state & kYARefreshStateTriggered) {
    [self.titleDictionary setObject:title forKey:@(kYARefreshStateTriggered)];
  }
  if (state & kYARefreshStateLoading) {
    [self.titleDictionary setObject:title forKey:@(kYARefreshStateLoading)];
  }
}

- (void)setSubTitle:(NSString *)subTitle forState:(YARefreshState)state
{
  if (!subTitle) subTitle = @"";
  
  if (state & kYARefreshStateStopped) {
    [self.subTitleDictionary setObject:subTitle forKey:@(kYARefreshStateStopped)];
  }
  if (state & kYARefreshStateTriggered) {
    [self.subTitleDictionary setObject:subTitle forKey:@(kYARefreshStateTriggered)];
  }
  if (state & kYARefreshStateLoading) {
    [self.subTitleDictionary setObject:subTitle forKey:@(kYARefreshStateLoading)];
  }
}

- (void)setCustomView:(UIView *)customView forState:(YARefreshState)state
{
  
}

- (void)setTitleColor:(UIColor *)color
{
  [self.refreshTitleLabel setTextColor:color];
}

- (void)setTitleFont:(UIFont *)font
{
  [self.refreshTitleLabel setFont:font];
}

- (void)setIndicatorColor:(UIColor *)color
{
  [self.indicator setIndicatorColor:color];
}

#pragma mark - Begin * End

- (void)beginRefresh
{
  [self setRefreshState:kYARefreshStateTriggered];
  
  if(!fequal(self.scrollView.contentOffset.y, -self.originEdgeInsets.top)) {
    CGFloat targetOffsetY = - (CGRectGetHeight(self.refreshView.bounds) + self.originEdgeInsets.top);
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, targetOffsetY)
                             animated:YES];
  }
  
  [self setRefreshState:kYARefreshStateLoading];
}

- (void)endRefresh
{
  [self setRefreshState:kYARefreshStateStopped];
  
  if(self.scrollView.contentOffset.y < -self.originEdgeInsets.top) {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.originEdgeInsets.top)
                             animated:YES];
  }
  
  [self.indicator stopLoading];
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
  if ([keyPath isEqualToString:@"contentOffset"]) {
    [self _scrollViewDidChangedOffset:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
  }
}

#pragma mark - Scroll

- (void)_scrollViewDidChangedOffset:(CGPoint)contentOffset
{
  if(self.refreshState != kYARefreshStateLoading) {
    CGFloat scrollOffsetThreshold = - (CGRectGetHeight(self.refreshView.bounds) + self.originEdgeInsets.top);
    
    [self.indicator didLoaded:(1 - (contentOffset.y - scrollOffsetThreshold) / (CGRectGetHeight(self.refreshView.bounds) - 25))];
    
    if(!self.scrollView.isDragging
       && self.refreshState == kYARefreshStateTriggered) {
      [self.indicator startLoading];
      self.refreshState = kYARefreshStateLoading;
    } else if(contentOffset.y < scrollOffsetThreshold
              && self.scrollView.isDragging
              && self.refreshState == kYARefreshStateStopped) {
      self.refreshState = kYARefreshStateTriggered;
    } else if(contentOffset.y >= scrollOffsetThreshold
              && self.refreshState != kYARefreshStateStopped) {
       self.refreshState = kYARefreshStateStopped;
    }
  }
}

#pragma mark - reset scrollview content inset

- (void)_resetScrollViewContentInset
{
  [self _setScrollViewContentInset:self.originEdgeInsets animate:YES];
}

- (void)_setScrollViewContentInsetForLoading
{
  UIEdgeInsets currentInsets = self.scrollView.contentInset;
  currentInsets.top = self.originEdgeInsets.top + CGRectGetHeight(self.refreshView.bounds);
  [self _setScrollViewContentInset:currentInsets animate:YES];
}

- (void)_setScrollViewContentInset:(UIEdgeInsets)contentInset animate:(BOOL)flag
{
  NSTimeInterval duration = flag ? kRefreshAnimateDuration : 0.0;
  [UIView animateWithDuration:duration animations:^{
    [self.scrollView setContentInset:contentInset];
  }];
}

#pragma mark - Util

- (CGFloat)_scrollViewReallyHeight
{
  return MIN(self.scrollView.frame.size.height, self.scrollView.contentSize.height);
}

@end