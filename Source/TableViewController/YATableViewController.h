//
//  YATableViewController.h
//  YAUIKit
//
//  Created by liuyan on 14-10-12.
//  Copyright (c) 2014年 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YATableDataSource.h"

@interface YATableViewController : UIViewController
{
    Class _dataSourceClass;
    YATableDataSource *_dataSource;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic, readonly) YATableDataSource *dataSource;

- (void)registerDataSourceClass:(Class)dataSourceClass;

@end
