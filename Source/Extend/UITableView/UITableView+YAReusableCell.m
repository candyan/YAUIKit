//
//  UITableView+YAReusableCell.m
//
//
//  Created by liuyan on 6/12/15.
//
//

#import "UITableView+YAReusableCell.h"

@implementation UITableView (YAReusableCell)

- (void)registerReuseCellClass:(Class)cellClass
{
    [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (instancetype)dequeueReusableCellWithClass:(Class)aClass
{
    if ([aClass isSubclassOfClass:[UITableViewCell class]]) {
        return [self dequeueReusableCellWithIdentifier:NSStringFromClass(aClass)];
    }
    return nil;
}

- (void)registerReuseHeaderFooterClass:(Class)aClass
{
    return [self registerClass:aClass forHeaderFooterViewReuseIdentifier:NSStringFromClass(aClass)];
}

- (id)dequeueReusableHeaderFooterViewWithClass:(Class)aClass
{
    return [self dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(aClass)];
}

@end
