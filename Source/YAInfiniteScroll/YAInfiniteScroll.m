//
//  YAInfiniteScroll.m
//  YAUIKit
//
//  Created by Candyan on 14-11-18.
//  Copyright (c) 2014年 Candyan. All rights reserved.
//

#import "YAInfiniteScroll.h"
#import <objc/runtime.h>
#import <KVOController/FBKVOController.h>

#import "YATableViewController.h"
#import "UIView+YAUIKit.h"

@implementation YAInfiniteScroll

@synthesize loadMoreFooterView = _loadMoreFooterView;
@synthesize scrollView = _scrollView;

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        _hasMore = YES;
        _canLoadMore = YES;

        _loadingMore = NO;
        _shouldLoadMore = NO;
    }
    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    self = [self init];
    if (self) {
        _scrollView = scrollView;

        [self.KVOController observe:scrollView
                            keyPath:@"contentSize"
                            options:NSKeyValueObservingOptionNew
                              block:^(YAInfiniteScroll *observer, id object, NSDictionary *change) {
                                [observer setNeedLayoutFooterView];
                              }];
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
        if (_scrollView.subviews.count > 1) {
            [_scrollView insertSubview:_loadMoreFooterView atIndex:1];
        } else {
            [_scrollView insertSubview:_loadMoreFooterView atIndex:0];
        }

        contentInsets.bottom += CGRectGetHeight(_loadMoreFooterView.bounds);
    }
    _scrollView.contentInset = contentInsets;
}

- (void)setHasMore:(BOOL)hasMore
{
    _hasMore = hasMore;
    [self ya_reloadFooterView];
}

- (void)setLoadingMore:(BOOL)loadingMore
{
    _loadingMore = self.canLoadMore ? loadingMore : NO;

    [self ya_reloadFooterView];
}

- (void)setCanLoadMore:(BOOL)canLoadMore
{
    _canLoadMore = canLoadMore;
    [self ya_reloadFooterView];
}

- (void)ya_reloadFooterView
{
    if (self.loadingMore) {
        if (_shouldLoadMore == NO && [self.delegate respondsToSelector:@selector(infiniteScrollLoadingMoreView:)]) {
            self.loadMoreFooterView = [self.delegate infiniteScrollLoadingMoreView:self];
        }
    } else if (self.hasMore || self.canLoadMore == NO ||
               [self.delegate respondsToSelector:@selector(infiniteScrollNoMoreView:)] == NO) {
        self.loadMoreFooterView = nil;
    } else {
        self.loadMoreFooterView = [self.delegate infiniteScrollNoMoreView:self];
    }
}

#pragma mark - Set

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_bottomStick && self.loadingMore == NO) {
        [self.loadMoreFooterView setFrameOriginY:MAX(scrollView.contentSize.height,
                                                     scrollView.contentOffset.y + CGRectGetHeight(scrollView.bounds) -
                                                         self.loadMoreFooterView.bounds.size.height)];
    } else {
        [self.loadMoreFooterView setFrameOriginY:scrollView.contentSize.height];
    }

    if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height * 1.5) &&
        self.loadingMore == NO && self.hasMore == YES && _shouldLoadMore == NO && self.canLoadMore) {
        _shouldLoadMore = YES;

        if ([self.delegate respondsToSelector:@selector(infiniteScrollLoadingMoreView:)]) {
            self.loadMoreFooterView = [self.delegate infiniteScrollLoadingMoreView:self];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.loadingMore == NO && _shouldLoadMore == YES) {
        self.loadingMore = YES;
        _shouldLoadMore = NO;
        if (self.loadMoreBlock)
            self.loadMoreBlock();
    }
}

#pragma mark - layout

- (void)setNeedLayoutFooterView
{
    if (_bottomStick) {
        [self.loadMoreFooterView setFrameOriginY:MAX(_scrollView.contentSize.height,
                                                     _scrollView.contentOffset.y + CGRectGetHeight(_scrollView.bounds) -
                                                         self.loadMoreFooterView.bounds.size.height)];
    } else {
        [self.loadMoreFooterView setFrameOriginY:_scrollView.contentSize.height];
    }
}

#pragma mark - End

- (void)triggerLoadMore
{
    if (self.loadingMore == NO && self.hasMore == YES && _shouldLoadMore == NO && self.canLoadMore == YES) {
        self.loadingMore = YES;

        if ([self.delegate respondsToSelector:@selector(infiniteScrollLoadingMoreView:)]) {
            self.loadMoreFooterView = [self.delegate infiniteScrollLoadingMoreView:self];
        }

        if (self.loadMoreBlock) {
            self.loadMoreBlock();
        }
    }
}

- (void)endLoadMore
{
    self.loadingMore = NO;
}

@end

@implementation YATableViewController (YAInfiniteScroll)

- (YAInfiniteScroll *)infiniteScroll
{
    YAInfiniteScroll *infiniteScroll = objc_getAssociatedObject(self, @selector(infiniteScroll));
    if (infiniteScroll == nil) {
        infiniteScroll = [[YAInfiniteScroll alloc] initWithScrollView:self.tableView];
        objc_setAssociatedObject(self, @selector(infiniteScroll), infiniteScroll, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return infiniteScroll;
}

@end