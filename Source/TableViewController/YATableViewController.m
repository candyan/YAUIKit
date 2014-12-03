//
//  YATableViewController.m
//  YAUIKit
//
//  Created by liuyan on 14-10-12.
//  Copyright (c) 2014年 liu yan. All rights reserved.
//

#import "YATableViewController.h"

@interface YATableViewController ()

@end

@implementation YATableViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSourceClass = [YATableDataSource class];
    }
    return self;
}

#pragma mark - view lifeCycle

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

#pragma mark - Property

- (UITableView *)tableView
{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.translatesAutoresizingMaskIntoConstraints = YES;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView = tableView;
        [self.view addSubview:tableView];
    }
    return _tableView;
}

- (YATableDataSource *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[_dataSourceClass alloc] initWithTableView:self.tableView];
    }
    return _dataSource;
}

- (void)registerDataSourceClass:(Class)dataSourceClass
{
    if ([dataSourceClass isSubclassOfClass:[YATableDataSource class]]) {
        _dataSourceClass = dataSourceClass;

        YATableDataSource *newDataSource = [[_dataSourceClass alloc] initWithTableView:self.tableView];
        [newDataSource setAllSectionObjects:_dataSource.allSectionObjects];
        _dataSource = newDataSource;
    }
}


@end
