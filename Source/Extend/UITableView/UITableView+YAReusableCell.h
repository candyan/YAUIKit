//
//  UITableView+YAReusableCell.h
//
//
//  Created by liuyan on 6/12/15.
//
//

#import <UIKit/UIKit.h>

@interface UITableView (YAReusableCell)

/** Returns a reusable table-view cell object for the specified reuse class and adds it to the table.
 *  @param aClass  A table-view cell class to be reused. This parameter must not be nil and subclass of
 * UITableViewCell.
 */
- (instancetype)dequeueReusableCellWithClass:(Class)aClass;

- (void)registerReuseCellClass:(Class)cellClass;

- (id)dequeueReusableHeaderFooterViewWithClass:(Class)aClass;
- (void)registerReuseHeaderFooterClass:(Class)aClass;

@end
