//
//  YARefreshView.m
//  YAUIKit
//
//  Created by liuyan on 14-2-21.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import "YARefreshView.h"
#import "UIFont+YAUIKit.h"
#import "UIView+YAUIKit.h"

@implementation YARefreshView

@synthesize refreshIndicator = _refreshIndicator;
@synthesize titleLabel = _titleLabel;
@synthesize subTitleLabel = _subTitleLabel;

#pragma mark - init

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    _refreshState = kYARefreshStateStop;
    _titles = [NSMutableDictionary dictionary];
    _subTitles = [NSMutableDictionary dictionary];
  }
  return self;
}

#pragma mark - layout

- (void)layoutSubviews
{
  [super layoutSubviews];
  CGSize titleSize = [self.titleLabel sizeThatFits:self.bounds.size];
  CGSize subTitleSize = [self.subTitleLabel sizeThatFits:self.bounds.size];

  [self.titleLabel setFrameSize:titleSize];
  [self.subTitleLabel setFrameSize:subTitleSize];

  CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
  [self.titleLabel setCenter:CGPointMake(boundsCenter.x,
                                         boundsCenter.y - CGRectGetMidY(self.subTitleLabel.bounds))];
  [self.subTitleLabel setCenter:CGPointMake(boundsCenter.x,
                                            boundsCenter.y - CGRectGetMidY(self.titleLabel.bounds))];

  CGFloat titleMaxWidth = MAX(titleSize.width, subTitleSize.width);
  CGFloat indicatorOffsetX =  (titleMaxWidth > 0) ? titleMaxWidth / 2  + CGRectGetMidX(self.refreshIndicator.bounds) + 8 : 0.0f;
  [self.refreshIndicator setCenter:CGPointMake(boundsCenter.x - indicatorOffsetX,
                                               boundsCenter.y)];
}

- (void)layoutSubviewsForRefreshState:(YARefreshState)refreshState
{
  _refreshState = refreshState;
  [self.titleLabel setText:[_titles objectForKey:@(refreshState)]];
  [self.subTitleLabel setText:[_subTitles objectForKey:@(refreshState)]];
  switch (refreshState) {
    case kYARefreshStateStop:
      [self.refreshIndicator stopLoading];
      break;

    case kYARefreshStateLoading:
      [self.refreshIndicator startLoading];
      break;

    default:
      break;
  }
  [self setNeedsLayout];
}

#pragma mark - getter

- (YARefreshIndicator *)refreshIndicator
{
  if (!_refreshIndicator) {
    YARefreshIndicator *indicator = [[YARefreshIndicator alloc] init];
    [self addSubview:indicator];
    _refreshIndicator = indicator;
  }
  return _refreshIndicator;
}

- (UILabel *)titleLabel
{
  if (!_titleLabel) {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont helveticaFontOfSize:15.0f]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
  }
  return _titleLabel;
}

- (UILabel *)subTitleLabel
{
  if (!_subTitleLabel) {
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [subTitleLabel setFont:[UIFont helveticaFontOfSize:12.f]];
    [subTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:subTitleLabel];
    _subTitleLabel = subTitleLabel;
  }
  return _subTitleLabel;
}

#pragma mark - setter

- (void)setTitle:(NSString *)title forRefreshState:(YARefreshState)refreshState
{
  [_titles setObject:title forKey:@(refreshState)];
  if (_refreshState == refreshState) {
    [self.titleLabel setText:title];
    [self setNeedsLayout];
  }
}

- (void)setSubTitle:(NSString *)subTitle forRefreshState:(YARefreshState)refreshState
{
  [_subTitles setObject:subTitle forKey:@(refreshState)];
  if (_refreshState == refreshState) {
    [self.subTitleLabel setText:subTitle];
    [self setNeedsLayout];
  }
}

@end
