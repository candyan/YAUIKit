//
//  YATableDataSource.h
//  YAUIKit
//
//  Created by Candyan on 14-7-3.
//  Copyright (c) 2014年 Douban.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YATableDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>
{
  __weak UITableView *_tableView;
}

@property (weak, nonatomic) id<UIScrollViewDelegate> scrollDelegate;
@property (strong, nonatomic, readonly) NSCache *cellHeightCache;

- (instancetype)initWithTableView:(UITableView *)tableView;
- (void)setTableView:(UITableView *)tableView;

@end
