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
        _objects = [NSMutableArray array];
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
    if (tableView == nil)
        return nil;

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

#pragma mark - Objects

- (NSArray *)allSectionObjects
{
    return [NSArray arrayWithArray:_objects];
}

- (void)setAllSectionObjects:(NSArray *)objects
{
    [_objects removeAllObjects];
    if (objects) {
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (id object in objects) {
            if (![object isKindOfClass:[NSArray class]]) {
                [tmpArray addObject:object];
            } else {
                if (tmpArray.count != 0)
                    [_objects addObject:[NSMutableArray arrayWithArray:tmpArray]];
                [_objects addObject:[NSMutableArray arrayWithArray:object]];
                [tmpArray removeAllObjects];
            }
        }
        if (tmpArray.count != 0)
            [_objects addObject:[NSMutableArray arrayWithArray:tmpArray]];
    }
    [_tableView reloadData];
}

- (void)addSectionObjects:(NSArray *)objects
{
    [self insertSectionObjects:objects atIndex:_objects.count];
}

- (void)insertSectionObjects:(NSArray *)objects atIndex:(NSUInteger)index
{
    if (objects.count != 0 && index <= objects.count) {
        [_objects insertObject:[NSMutableArray arrayWithArray:objects] atIndex:index];
        [_tableView insertSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)removeObjectsAtSection:(NSUInteger)section
{
    if (section < _objects.count) {
        [_objects removeObjectAtIndex:section];
        [_tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSArray *)objectsAtSection:(NSUInteger)sectiion
{
    return (sectiion < _objects.count) ? [NSArray arrayWithArray:_objects[sectiion]] : nil;
}

- (void)addObject:(id)object atSection:(NSUInteger)section
{
    [self addObjects:@[ object ] atSection:section];
}

- (void)addObjects:(NSArray *)objects atSection:(NSUInteger)section
{
    if (objects.count != 0 && section < _objects.count) {
        NSMutableArray *sectionObjects = _objects[section];
        [sectionObjects addObjectsFromArray:objects];

        NSMutableArray *insertIndexPaths = [NSMutableArray array];
        for (id insertedObject in objects) {
            [insertIndexPaths addObject:[NSIndexPath indexPathForRow:[sectionObjects indexOfObject:insertedObject]
                                                           inSection:section]];
        }
        [_tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    if (object && indexPath.section < _objects.count) {
        NSMutableArray *sectionObjects = _objects[indexPath.section];
        if (indexPath.row <= sectionObjects.count) {
            [sectionObjects insertObject:object atIndex:indexPath.row];
            [_objects replaceObjectAtIndex:indexPath.section withObject:sectionObjects];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                      withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (void)removeObject:(id)object atSection:(NSUInteger)section
{
    if (object) {
        NSArray *sectionObjects = [self objectsAtSection:section];
        NSUInteger removeObjectIndex = [sectionObjects indexOfObject:object];
        [self removeObjectAtIndexPath:[NSIndexPath indexPathForRow:removeObjectIndex inSection:section]];
    }
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < _objects.count) {
        NSMutableArray *sectionObjects = _objects[indexPath.section];

        if (indexPath.row != NSNotFound && indexPath.row < sectionObjects.count) {
            [sectionObjects removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionObjects = [self objectsAtSection:indexPath.section];
    return indexPath.row < sectionObjects.count ? sectionObjects[indexPath.row] : nil;
}

- (void)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    if ([self objectAtIndexPath:indexPath] != nil && object) {
        NSMutableArray *objectsInSection = [[self objectsAtSection:indexPath.section] mutableCopy];
        [objectsInSection replaceObjectAtIndex:indexPath.row withObject:object];

        [_objects replaceObjectAtIndex:indexPath.section withObject:objectsInSection];

        [_tableView reloadData];
    }
}

#pragma mark - Dealloc

- (void)dealloc
{
    [[YASkinManager sharedManager] removeObserver:self forKeyPath:@"skinName" context:NULL];
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
    if ([self.scrollDelegate
         respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
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
    return _objects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self objectsAtSection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id selectedObject = [self objectAtIndexPath:indexPath];
    if (self.delegate) {
        if (selectedObject &&
            [self.delegate respondsToSelector:@selector(tableDataSource:didSelectObject:atIndexPath:)]) {
            [self.delegate tableDataSource:self didSelectObject:selectedObject atIndexPath:indexPath];
        }
    }
}

@end
