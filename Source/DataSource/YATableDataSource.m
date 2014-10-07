//
//  YATableDataSource.m
//  YAUIKit
//
//  Created by Candyan on 14-7-3.
//  Copyright (c) 2014 Candyan. All rights reserved.
//

#import "YATableDataSource.h"
#import "YASkinManager.h"

@implementation YATableDataSource

@synthesize cellHeightCache = _cellHeightCache;

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        [[YASkinManager sharedManager] addObserver:self
                                        forKeyPath:@"skinName"
                                           options:NSKeyValueObservingOptionNew
                                           context:NULL];
    }
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView
{
    NSAssert(tableView != nil, @"TableView should not be nil.");
    if (tableView == nil) return nil;
    
    self = [self init];
    if (self) {
        [self setTableView:tableView];
    }
    return self;
}

#pragma mark - Property

- (NSCache *)cellHeightCache
{
    if (_cellHeightCache == nil) {
        _cellHeightCache = [[NSCache alloc] init];
        _cellHeightCache.totalCostLimit = 100;
    }
    return _cellHeightCache;
}

- (void)setTableView:(UITableView *)tableView
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    
    _tableView.backgroundView = nil;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Dealloc

- (void)dealloc
{
    [[YASkinManager sharedManager] removeObserver:self
                                       forKeyPath:@"skinName"
                                          context:NULL];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"skinName"]) {
        [_tableView reloadRowsAtIndexPaths:_tableView.indexPathsForVisibleRows
                          withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UIScroll View

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.scrollDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.scrollDelegate scrollViewWillEndDragging:scrollView
                                          withVelocity:velocity
                                   targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.scrollDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.scrollDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:nil];
}

@end
