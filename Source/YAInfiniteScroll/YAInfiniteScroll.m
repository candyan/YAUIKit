//
//  YAInfiniteScroll.m
//  YAUIKit
//
//  Created by Candyan on 14-11-18.
//  Copyright (c) 2014年 Candyan. All rights reserved.
//

#import "YAInfiniteScroll.h"
#import <objc/runtime.h>

#import "YATableViewController.h"
#import "UIView+YAUIKit.h"

@implementation YAInfiniteScroll

@synthesize loadMoreFooterView = _loadMoreFooterView;

#pragma mark - init

- (id)init
{
  self = [super init];
  if (self) {
    _loadingMore = NO;
    _shouldLoadMore = NO;
    _hasMore = YES;
  }
  return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
  self = [self init];
  if (self) {
    _scrollView = scrollView;
  }
  return self;
}

#pragma mark - Property

- (void)setLoadMoreFooterView:(UIView *)loadMoreFooterView
{
  UIEdgeInsets contentInsets = _scrollView.contentInset;
  contentInsets.bottom -= CGRectGetHeight(_loadMoreFooterView.bounds);

  [_loadMoreFooterView removeFromSuperview];
  _loadMoreFooterView = loadMoreFooterView;
  if (_loadMoreFooterView) {
    CGRect footerRect = _loadMoreFooterView.frame;
    footerRect.origin = CGPointMake(0, _scrollView.contentSize.height);
    footerRect.size = CGSizeMake(CGRectGetWidth(_scrollView.bounds), footerRect.size.height);
    [_loadMoreFooterView setFrame:footerRect];
    [_scrollView addSubview:_loadMoreFooterView];

    contentInsets.bottom += CGRectGetHeight(_loadMoreFooterView.bounds);
  }
  _scrollView.contentInset = contentInsets;
}

- (void)setHasMore:(BOOL)hasMore
{
  _hasMore = hasMore;
  if (!hasMore
      && [self.delegate respondsToSelector:@selector(infiniteScrollNoMoreView:)]) {
    self.loadMoreFooterView = [self.delegate infiniteScrollNoMoreView:self];
  } else {
    self.loadMoreFooterView = nil;
  }
}

#pragma mark - Set

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [self.loadMoreFooterView setFrameOriginY:scrollView.contentSize.height];

  if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height * 1.5)
      && self.loadingMore == NO
      && self.hasMore == YES
      && _shouldLoadMore == NO) {
    _shouldLoadMore = YES;

    if ([self.delegate respondsToSelector:@selector(infiniteScrollLoadingMoreView:)]) {
      self.loadMoreFooterView = [self.delegate infiniteScrollLoadingMoreView:self];
    }
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  if (self.loadingMore == NO
      && _shouldLoadMore == YES) {
    self.loadingMore = YES;
    _shouldLoadMore = NO;
    if (self.loadMoreBlock) self.loadMoreBlock();
  }
}

#pragma mark - End

- (void)endLoadMore
{
  self.loadingMore = NO;
}

@end


@implementation YATableViewController(YAInfiniteScroll)

- (YAInfiniteScroll *)infiniteScroll
{
  YAInfiniteScroll *infiniteScroll = objc_getAssociatedObject(self, @selector(infiniteScroll));
  if (infiniteScroll == nil) {
    infiniteScroll = [[YAInfiniteScroll alloc] initWithScrollView:self.tableView];
    infiniteScroll.hasMore = NO;
    objc_setAssociatedObject(self, @selector(infiniteScroll), infiniteScroll, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return infiniteScroll;
}

@end
