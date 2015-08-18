//
//  UICollectionView+YAReusableCell.h
//
//
//  Created by liuyan on 6/12/15.
//
//

#import <UIKit/UIKit.h>

@interface UICollectionView (YAReusableCell)

- (void)registerReuseCellClass:(Class)cellClass;
- (void)registerReuseClass:(Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind;

- (instancetype)dequeueReusableCellWithClass:(Class)aClass forIndexPath:(NSIndexPath *)indexPath;
- (instancetype)dequeueReusableWithClass:(Class)aClass
              forSupplementaryViewOfKind:(NSString *)elementKind
                            forIndexPath:(NSIndexPath *)indexPath;

@end
