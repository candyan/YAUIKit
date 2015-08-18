//
//  UICollectionView+YAReusableCell.m
//
//
//  Created by liuyan on 6/12/15.
//
//

#import "UITableView+YAReusableCell.h"

@implementation UICollectionView (YAReusableCell)

- (void)registerReuseCellClass:(Class)cellClass
{
    [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)registerReuseClass:(Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind
{
    [self registerClass:viewClass
        forSupplementaryViewOfKind:elementKind
               withReuseIdentifier:NSStringFromClass(viewClass)];
}

- (instancetype)dequeueReusableCellWithClass:(Class)aClass forIndexPath:(NSIndexPath *)indexPath;
{
    return [self dequeueReusableCellWithReuseIdentifier:NSStringFromClass(aClass) forIndexPath:indexPath];
}

- (instancetype)dequeueReusableWithClass:(Class)aClass
              forSupplementaryViewOfKind:(NSString *)elementKind
                            forIndexPath:(NSIndexPath *)indexPath
{
    [self dequeueReusableSupplementaryViewOfKind:elementKind
                             withReuseIdentifier:NSStringFromClass(aClass)
                                    forIndexPath:indexPath];
}

@end
