//
//  YARefreshView.h
//  YAUIKit
//
//  Created by liuyan on 14-2-21.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YARefreshIndicator.h"
#import "YAUIKitTypeDef.h"

@interface YARefreshView : UIView {
  YARefreshState _refreshState;

  NSMutableDictionary *_titles;
  NSMutableDictionary *_subTitles;
}

@property (nonatomic, weak, readonly) YARefreshIndicator *refreshIndicator;
@property (nonatomic, weak, readonly) UILabel *titleLabel;
@property (nonatomic, weak, readonly) UILabel *subTitleLabel;

- (void)layoutSubviewsForRefreshState:(YARefreshState)refreshState;

- (void)setTitle:(NSString *)title forRefreshState:(YARefreshState)refreshState;
- (void)setSubTitle:(NSString *)subTitle forRefreshState:(YARefreshState)refreshState;

@end
