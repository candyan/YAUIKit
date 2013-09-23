//
//  YARefreshContrl.m
//  YAUIKit
//
//  Created by liu yan on 9/23/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "YARefreshControl.h"

static CGFloat const kRefreshViewHeight = 60.0f;

@interface YARefreshControl ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) YARefreshState refreshState;
@property (nonatomic, assign) UIEdgeInsets originEdgeInsets;

@property (nonatomic, assign)  BOOL isObserving;

@end

@implementation YARefreshControl

#pragma mark - init

- (instancetype)initWithScrollView:(UIScrollView *)scrollView 
                   refreshPosition:(YARefreshPosition)refreshPosition
{
  self = [super init];
  if (self) {
  	_scrollView = scrollView;
  	_originEdgeInsets = scrollView.contentInsets;
  	_refreshState = kYARefreshStateStopped;
  	_refreshPosition = refreshPosition;
  	_isObserving
  	self.refreshEnable = YES;
  	self.isObserving = NO;
  }
  return self;
}

#pragma mark - set & get

- (void)setRefreshEnable:(BOOL)refreshEnable
{
  _refreshEneable = refreshEnable;
  if (_refreshEneable) {
  	if (!self.isObserving) {
  	  [self.scrollView addObserver:self
  	                  forKeyPath:@"contentOffset"
  	                     options:NSKeyValueObservingOptionNew
  	                     context:nil];
  	  self.isObserving = YES;
  	}
  } else {
  	if (self.isObserving) {
  	  [self.scrollView removeObserver:self.pullToRefreshView 
  	  	                   forKeyPath:@"contentOffset"];
  	  self.isObserving = NO;
  	}
  }
}

@end