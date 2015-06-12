//
//  UITableView+YAReusableCell.h
//
//
//  Created by liuyan on 6/12/15.
//
//

#import <UIKit/UIKit.h>

@interface UITableView (YAReusableCell)

- (id)dequeueReusableCellWithClass:(Class)aClass;
- (void)registerReuseCellClass:(Class)cellClass;

- (id)dequeueReusableHeaderFooterViewWithClass:(Class)aClass;
- (void)registerReuseHeaderFooterClass:(Class)aClass;

@end
