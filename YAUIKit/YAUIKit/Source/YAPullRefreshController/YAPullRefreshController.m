//
//  YAPullRefreshController.m
//  YAUIKit
//
//  Created by liu yan on 4/16/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "YAPullRefreshController.h"

#import "YAToolKit.h"

@implementation YAPullRefreshController

#pragma mark - init
- (id)initWithScrollView:(UIScrollView *)scrollView {
  return [self initWithScrollView:scrollView refreshableDirection:kYARefreshableDirectionTop];
}

- (id)initWithScrollView:(UIScrollView *)scrollView refreshableDirection:(YARefreshableDirection)refreshableDirection {
  self = [super init];
  if (self) {
    _ptrc = [[MSPullToRefreshController alloc] initWithScrollView:scrollView delegate:self];
    _refreshableDirection = refreshableDirection;
  }
  return self;
}

#pragma mark - Property Method
- (void) setPullRefreshHeaderView:(UIView *)pullRefreshHeaderView {
  if (_pullRefreshHeaderView != pullRefreshHeaderView) {
    [_pullRefreshHeaderView removeFromSuperview];
    
    _pullRefreshHeaderView = pullRefreshHeaderView;
    if (_pullRefreshHeaderView) {
      [_pullRefreshHeaderView setFrameOriginY:-_pullRefreshHeaderView.frame.size.height];
      [_ptrc.scrollView addSubview:_pullRefreshHeaderView];
      
      _refreshableInsets.top = _pullRefreshHeaderView.frame.size.height;
      _refreshingInsets.top = _pullRefreshHeaderView.frame.size.height;
      
      if (!(_refreshableDirection & kYARefreshableDirectionTop)) {
        [_pullRefreshHeaderView setHidden:YES];
      }
    } else {
      _refreshingInsets.top = 0;
      _refreshableInsets.top = 0;
    }
  }
}

- (void) setPullRefreshFooterView:(UIView *)pullRefreshFooterView {
  if (_pullRefreshFooterView != pullRefreshFooterView) {
    [_pullRefreshFooterView removeFromSuperview];
    
    _pullRefreshFooterView = pullRefreshFooterView;
    if (_pullRefreshFooterView) {
      [_pullRefreshFooterView setFrameOriginY:(_ptrc.scrollView.contentSize.height + _ptrc.scrollView.contentInset.bottom)];
      [_ptrc.scrollView addSubview:_pullRefreshFooterView];
      
      _refreshableInsets.bottom = _pullRefreshFooterView.frame.size.height;
      _refreshingInsets.bottom = _pullRefreshFooterView.frame.size.height;
      
      if (!(_refreshableDirection & kYARefreshableDirectionButtom)) {
        [_pullRefreshFooterView setHidden:YES];
      }
    } else {
      _refreshingInsets.bottom = 0;
      _refreshableInsets.bottom = 0;
    }
  }
}

- (void) setCanEngageRefreshBlock:(CanEngageRefresh)canEngageRefreshBlock
         didDisengageRefreshBlock:(DidDisengageRefresh)didDisengageRefreshBlock
            didEngageRefreshBlock:(DidEngageRefresh)didEngageRefreshBlock {
  [self setCanEngageRefreshBlock:canEngageRefreshBlock];
  [self setDidDisengageRefreshBlock:didDisengageRefreshBlock];
  [self setDidEngageRefreshBlock:didEngageRefreshBlock];
}

- (void)setRefreshableDirection:(YARefreshableDirection)refreshableDirection {
  _refreshableDirection = refreshableDirection;
  if (refreshableDirection & kYARefreshableDirectionTop) {
    [_pullRefreshHeaderView setHidden:NO];
  } else {
    [_pullRefreshHeaderView setHidden:YES];
  }
  
  if (refreshableDirection & kYARefreshableDirectionButtom) {
    [_pullRefreshFooterView setHidden:NO];
  } else {
    [_pullRefreshFooterView setHidden:YES];
  }
}

#pragma mark - Refresh Method
- (void)startRefreshWithDirection:(YARefreshDirection)refreshDirection {
  [self startRefreshWithDirection:refreshDirection animated:NO];
}

- (void)startRefreshWithDirection:(YARefreshDirection)refreshDirection animated:(BOOL)animated {
  [_ptrc startRefreshingDirection:(MSRefreshDirection)refreshDirection animated:animated];
}

- (void)finishRefreshWithDirection:(YARefreshDirection)refreshDirection complate:(void (^)())complate {
  [self finishRefreshWithDirection:refreshDirection animated:NO complate:complate];
}

- (void)finishRefreshWithDirection:(YARefreshDirection)refreshDirection animated:(BOOL)animated complate:(void (^)())complate {
  [_ptrc finishRefreshingDirection:(MSRefreshDirection)refreshDirection animated:animated complate:^{
    [_pullRefreshFooterView setFrameOriginY:(_ptrc.scrollView.contentSize.height + _ptrc.scrollView.contentInset.bottom)];
    if (complate) {
      complate();
    }
  }];
}

#pragma mark - MSPullToRefresh Delegate
- (BOOL)pullToRefreshController:(MSPullToRefreshController *)controller canRefreshInDirection:(MSRefreshDirection)direction {
  return (_refreshableDirection & direction);
}

- (CGFloat)pullToRefreshController:(MSPullToRefreshController *)controller refreshableInsetForDirection:(MSRefreshDirection)direction {
  switch (direction) {
    case MSRefreshDirectionTop: {
      return _refreshableInsets.top;
    }
      
    case MSRefreshDirectionRight: {
      return _refreshableInsets.right;
    }
      
    case MSRefreshDirectionLeft: {
      return _refreshableInsets.left;
    }
      
    case MSRefreshDirectionBottom: {
      return _refreshableInsets.bottom;
    }
      
    default:
      break;
  }
}

- (CGFloat)pullToRefreshController:(MSPullToRefreshController *)controller refreshingInsetForDirection:(MSRefreshDirection)direction {
  switch (direction) {
    case MSRefreshDirectionTop: {
      return _refreshingInsets.top;
    }
      
    case MSRefreshDirectionRight: {
      return _refreshingInsets.right;
    }
      
    case MSRefreshDirectionLeft: {
      return _refreshingInsets.left;
    }
      
    case MSRefreshDirectionBottom: {
      return _refreshingInsets.bottom;
    }
      
    default:
      break;
  }
}

- (void)pullToRefreshController:(MSPullToRefreshController *)controller canEngageRefreshDirection:(MSRefreshDirection)direction {
  if (_canEngageRefreshBlock) {
    _canEngageRefreshBlock((YARefreshDirection)direction);
  }
}

- (void)pullToRefreshController:(MSPullToRefreshController *)controller didEngageRefreshDirection:(MSRefreshDirection)direction {
  if (_didEngageRefreshBlock) {
    _didEngageRefreshBlock((YARefreshDirection)direction);
  }
}

- (void)pullToRefreshController:(MSPullToRefreshController *)controller didDisengageRefreshDirection:(MSRefreshDirection)direction {
  if (_didDisengageRefreshBlock) {
    _didDisengageRefreshBlock((YARefreshDirection)direction);
  }
}

@end
