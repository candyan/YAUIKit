//
//  YATableDataSource.h
//  YAUIKit
//
//  Created by Candyan on 14-7-3.
//  Copyright (c) 2014年 Douban.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YATableDataSource;

@protocol YATableDataSourceDelegate <NSObject>

@optional
- (void)tableDataSource:(YATableDataSource *)dataSource didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

@end

@interface YATableDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>
{
    __weak UITableView *_tableView;
    NSMutableArray *_objects;
}

@property (weak, nonatomic) id<UIScrollViewDelegate> scrollDelegate;
@property (weak, nonatomic) id<YATableDataSourceDelegate> delegate;

@property (strong, nonatomic, readonly) NSCache *cellHeightCache;

- (instancetype)initWithTableView:(UITableView *)tableView;
- (void)setTableView:(UITableView *)tableView;

- (NSArray *)allSectionObjects;
- (void)setAllSectionObjects:(NSArray *)objects;

- (void)addSectionObjects:(NSArray *)objects;
- (void)insertSectionObjects:(NSArray *)objects atIndex:(NSUInteger)index;
- (void)removeObjectsAtSection:(NSUInteger)section;

- (NSArray *)objectsAtSection:(NSUInteger)sectiion;
- (void)addObject:(id)object atSection:(NSUInteger)section;
- (void)addObjects:(NSArray *)objects atSection:(NSUInteger)section;
- (void)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeObject:(id)object atSection:(NSUInteger)section;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (void)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

@end
