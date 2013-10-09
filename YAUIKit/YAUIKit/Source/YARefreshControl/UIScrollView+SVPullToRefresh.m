//
// UIScrollView+SVPullToRefresh.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+SVPullToRefresh.h"
#import "YARefreshIndicator.h"
#import "UIView+YAUIKit.h"

//fequal() and fequalzro() from http://stackoverflow.com/a/1614761/184130
#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)

static CGFloat const SVPullToRefreshViewHeight = 60;

@interface SVPullToRefreshView ()

@property (nonatomic, copy) void (^refreshActionHandler)(void);

@property (nonatomic, weak) YARefreshIndicator *activityIndicatorView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *subtitleLabel;
@property (nonatomic, readwrite) YARefreshState refreshState;
@property (nonatomic, readwrite) YARefreshPosition refreshPosition;

@property (nonatomic, strong) NSMutableDictionary *titles;
@property (nonatomic, strong) NSMutableDictionary *subtitles;
@property (nonatomic, strong) NSMutableDictionary *viewForState;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalTopInset;
@property (nonatomic, readwrite) CGFloat originalBottomInset;

@property (nonatomic, assign) BOOL wasTriggeredByUser;
@property (nonatomic, assign) BOOL showsPullToRefresh;
@property (nonatomic, assign) BOOL showsDateLabel;
@property(nonatomic, assign) BOOL isObserving;

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForLoading;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets;

@end



#pragma mark - UIScrollView (SVPullToRefresh)
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (SVPullToRefresh)

@dynamic pullToRefreshView, showsPullToRefresh;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler
                                 position:(YARefreshPosition)position
{
  if(!self.pullToRefreshView) {
    CGFloat yOrigin;
    switch (position) {
      case kYARefreshPositionTop:
        yOrigin = 0;
        break;
      case kYARefreshPositionBottom:
        yOrigin = self.contentSize.height;
        break;
      default:
        return;
    }
    CGRect frame = CGRectMake(0, yOrigin, self.bounds.size.width, SVPullToRefreshViewHeight);
    SVPullToRefreshView *view = [[SVPullToRefreshView alloc] initWithFrame:frame];
    view.refreshActionHandler = actionHandler;
    view.scrollView = self;
    [self insertSubview:view atIndex:0];
    
    view.originalTopInset = self.contentInset.top;
    view.originalBottomInset = self.contentInset.bottom;
    view.refreshPosition = position;
    self.pullToRefreshView = view;
    self.showsPullToRefresh = YES;
  }
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler
{
  [self addPullToRefreshWithActionHandler:actionHandler
                                 position:kYARefreshPositionTop];
}

- (void)triggerPullToRefresh
{
  self.pullToRefreshView.refreshState = kYARefreshStateTriggered;
  [self.pullToRefreshView startAnimating];
}

- (void)setPullToRefreshView:(SVPullToRefreshView *)pullToRefreshView
{
  [self willChangeValueForKey:@"SVPullToRefreshView"];
  objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                           pullToRefreshView,
                           OBJC_ASSOCIATION_ASSIGN);
  [self didChangeValueForKey:@"SVPullToRefreshView"];
}

- (SVPullToRefreshView *)pullToRefreshView
{
  return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

- (void)setShowsPullToRefresh:(BOOL)showsPullToRefresh
{
  self.pullToRefreshView.hidden = !showsPullToRefresh;
  
  if(!showsPullToRefresh) {
    if (self.pullToRefreshView.isObserving) {
      [self removeObserver:self.pullToRefreshView forKeyPath:@"contentOffset"];
      [self removeObserver:self.pullToRefreshView forKeyPath:@"frame"];
      [self.pullToRefreshView resetScrollViewContentInset];
      self.pullToRefreshView.isObserving = NO;
    }
  }
  else {
    if (!self.pullToRefreshView.isObserving) {
      [self addObserver:self.pullToRefreshView
             forKeyPath:@"contentOffset"
                options:NSKeyValueObservingOptionNew
                context:nil];
      [self addObserver:self.pullToRefreshView
             forKeyPath:@"contentSize"
                options:NSKeyValueObservingOptionNew
                context:nil];
      [self addObserver:self.pullToRefreshView
             forKeyPath:@"frame"
                options:NSKeyValueObservingOptionNew
                context:nil];
      self.pullToRefreshView.isObserving = YES;
      
      CGFloat yOrigin;
      switch (self.pullToRefreshView.refreshPosition) {
        case kYARefreshPositionTop:
          yOrigin = 0;
          break;
        case kYARefreshPositionBottom:
          yOrigin = self.contentSize.height;
          break;
      }
      
      self.pullToRefreshView.frame = CGRectMake(0, yOrigin, self.bounds.size.width, SVPullToRefreshViewHeight);
    }
  }
}

- (BOOL)showsPullToRefresh
{
  return !self.pullToRefreshView.hidden;
}

@end

#pragma mark - SVPullToRefresh
@implementation SVPullToRefreshView

// public properties
@synthesize refreshActionHandler, textColor, lastUpdatedDate, dateFormatter;

@synthesize refreshState = _refreshState;
@synthesize scrollView = _scrollView;
@synthesize showsPullToRefresh = _showsPullToRefresh;
@synthesize activityIndicatorView = _activityIndicatorView;

@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // default styling values
    self.textColor = [UIColor darkGrayColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.refreshState = kYARefreshStateStopped;
    self.showsDateLabel = NO;
    
    self.titles = [NSMutableDictionary dictionaryWithObjects:@[NSLocalizedString(@"Pull to refresh...",),
                                                               NSLocalizedString(@"Release to refresh...",),
                                                               NSLocalizedString(@"Loading...",)]
                                                     forKeys:@[@(kYARefreshStateStopped),
                                                               @(kYARefreshStateTriggered),
                                                               @(kYARefreshStateLoading)]];
    
    self.subtitles = [NSMutableDictionary dictionary];
    self.viewForState = [NSMutableDictionary dictionary];
    self.wasTriggeredByUser = YES;
  }
  return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
  if (self.superview && newSuperview == nil) {
    //use self.superview, not self.scrollView. Why self.scrollView == nil here?
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    if (scrollView.showsPullToRefresh) {
      if (self.isObserving) {
        //If enter this branch, it is the moment just before "SVPullToRefreshView's dealloc", so remove observer here
        [scrollView removeObserver:self forKeyPath:@"contentOffset"];
        [scrollView removeObserver:self forKeyPath:@"contentSize"];
        [scrollView removeObserver:self forKeyPath:@"frame"];
        self.isObserving = NO;
      }
    }
  }
}

- (void)layoutSubviews
{
  for(id otherView in self.viewForState) {
    if([otherView isKindOfClass:[UIView class]])
      [otherView removeFromSuperview];
  }
  
  id customView = [self.viewForState objectForKey:@(self.refreshState)];
  BOOL hasCustomView = [customView isKindOfClass:[UIView class]];
    
  self.titleLabel.hidden = hasCustomView;
  self.subtitleLabel.hidden = hasCustomView;
  
  if(hasCustomView) {
    [self addSubview:customView];
    CGRect viewBounds = [customView bounds];
    
    CGFloat originX = roundf((self.bounds.size.width-viewBounds.size.width)/2);
    CGFloat originY = roundf((self.bounds.size.height-viewBounds.size.height)/2);
    [customView setFrame:CGRectMake(originX,
                                    originY,
                                    viewBounds.size.width,
                                    viewBounds.size.height)];
  }
  else {
    CGFloat leftViewWidth = self.activityIndicatorView.bounds.size.width;
    
    CGFloat margin = 10;
    CGFloat marginY = 2;
    CGFloat labelMaxWidth = self.bounds.size.width - margin - leftViewWidth;
        
    self.titleLabel.text = [self.titles objectForKey:@(self.refreshState)];
        
    NSString *subtitle = [self.subtitles objectForKey:@(self.refreshState)];
    self.subtitleLabel.text = subtitle.length > 0 ? subtitle : nil;
    
    CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font
                                        constrainedToSize:CGSizeMake(labelMaxWidth, self.titleLabel.font.lineHeight)
                                            lineBreakMode:self.titleLabel.lineBreakMode];
        
    CGSize subtitleSize = [self.subtitleLabel.text sizeWithFont:self.subtitleLabel.font
                                              constrainedToSize:CGSizeMake(labelMaxWidth, self.subtitleLabel.font.lineHeight)
                                                  lineBreakMode:self.subtitleLabel.lineBreakMode];
    
    CGFloat maxLabelWidth = MAX(titleSize.width,subtitleSize.width);
    CGFloat totalMaxWidth = leftViewWidth + margin + maxLabelWidth;
    CGFloat labelX = (self.bounds.size.width / 2) - (totalMaxWidth / 2) + leftViewWidth + margin;
    
    if(subtitleSize.height > 0){
      CGFloat totalHeight = titleSize.height + subtitleSize.height + marginY;
      CGFloat minY = (self.bounds.size.height / 2)  - (totalHeight / 2);
            
      CGFloat titleY = minY;
      self.titleLabel.frame = CGRectIntegral(CGRectMake(labelX, titleY, titleSize.width, titleSize.height));
      self.subtitleLabel.frame = CGRectIntegral(CGRectMake(labelX, titleY + titleSize.height + marginY, subtitleSize.width, subtitleSize.height));
    } else {
      CGFloat totalHeight = titleSize.height;
      CGFloat minY = (self.bounds.size.height / 2)  - (totalHeight / 2);
      
      CGFloat titleY = minY;
      self.titleLabel.frame = CGRectIntegral(CGRectMake(labelX, titleY, titleSize.width, titleSize.height));
      self.subtitleLabel.frame = CGRectIntegral(CGRectMake(labelX, titleY + titleSize.height + marginY, subtitleSize.width, subtitleSize.height));
    }
    
    CGFloat indicatorX = (self.bounds.size.width / 2) - (totalMaxWidth / 2);
    CGFloat indicatorY = (self.bounds.size.height / 2) - (self.activityIndicatorView.bounds.size.height / 2);
    [self.activityIndicatorView setFrameOriginPoint:CGPointMake(indicatorX, indicatorY)];
  }
}

#pragma mark - Scroll View

- (void)resetScrollViewContentInset
{
  UIEdgeInsets currentInsets = self.scrollView.contentInset;
  switch (self.refreshPosition) {
    case kYARefreshPositionTop:
      currentInsets.top = self.originalTopInset;
      break;
    case kYARefreshPositionBottom:
      currentInsets.bottom = self.originalBottomInset;
      currentInsets.top = self.originalTopInset;
      break;
  }
  [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInsetForLoading
{
  CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
  UIEdgeInsets currentInsets = self.scrollView.contentInset;
  switch (self.refreshPosition) {
    case kYARefreshPositionTop:
      currentInsets.top = MIN(offset, self.originalTopInset + self.bounds.size.height);
      break;
    case kYARefreshPositionBottom:
      currentInsets.bottom = MIN(offset, self.originalBottomInset + self.bounds.size.height);
      break;
  }
  [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset
{
  [UIView animateWithDuration:0.3
                        delay:0
                      options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState)
                   animations:^{
                     self.scrollView.contentInset = contentInset;
                   }
                   completion:nil];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
  if([keyPath isEqualToString:@"contentOffset"])
  {
    CGPoint newOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
    if (self.refreshPosition == kYARefreshPositionTop) {
      [self setFrameOriginY:newOffset.y + self.originalTopInset];
    }
    [self scrollViewDidScroll:newOffset];
  }
  else if([keyPath isEqualToString:@"contentSize"]) {
    [self layoutSubviews];
    
    CGFloat yOrigin;
    switch (self.refreshPosition) {
      case kYARefreshPositionTop:
        yOrigin = 0;
        break;
      case kYARefreshPositionBottom:
        yOrigin = MAX(self.scrollView.contentSize.height, self.scrollView.bounds.size.height);
        break;
    }
    self.frame = CGRectMake(0, yOrigin, self.bounds.size.width, SVPullToRefreshViewHeight);
  }
  else if([keyPath isEqualToString:@"frame"]) {
    [self layoutSubviews];
  }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset
{
  if(self.refreshState != kYARefreshStateLoading) {
    CGFloat scrollOffsetThreshold;
    switch (self.refreshPosition) {
      case kYARefreshPositionTop:
        scrollOffsetThreshold = - (CGRectGetHeight(self.bounds) + self.originalTopInset);
        break;
      case kYARefreshPositionBottom:
        scrollOffsetThreshold = (MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height, 0.0f)
                                 + self.bounds.size.height
                                 + self.originalBottomInset);
        break;
    }
    
    CGFloat diffOffsetY = contentOffset.y - scrollOffsetThreshold;
    [self.activityIndicatorView didLoaded:(1 - diffOffsetY / (CGRectGetHeight(self.bounds) - 25))];
    
    if(!self.scrollView.isDragging
       && self.refreshState == kYARefreshStateTriggered) {
      self.refreshState = kYARefreshStateLoading;
    } else if(diffOffsetY < 0
              && self.scrollView.isDragging
              && self.refreshState == kYARefreshStateStopped
              && self.refreshPosition == kYARefreshPositionTop) {
      self.refreshState = kYARefreshStateTriggered;
    } else if(diffOffsetY >= 0
              && self.refreshState != kYARefreshStateStopped
              && self.refreshPosition == kYARefreshPositionTop) {
      self.refreshState = kYARefreshStateStopped;
    } else if(diffOffsetY > 0
              && self.scrollView.isDragging
              && self.refreshState == kYARefreshStateStopped
              && self.refreshPosition == kYARefreshPositionBottom) {
      self.refreshState = kYARefreshStateTriggered;
    } else if(diffOffsetY <= 0
              && self.refreshState != kYARefreshStateStopped
              && self.refreshPosition == kYARefreshPositionBottom) {
      self.refreshState = kYARefreshStateStopped;
    }
  } else {
    CGFloat offset;
    UIEdgeInsets contentInset;
    switch (self.refreshPosition) {
      case kYARefreshPositionTop:
        offset = MAX(self.scrollView.contentOffset.y * -1, 0.0f);
        offset = MIN(offset, self.originalTopInset + self.bounds.size.height);
        contentInset = self.scrollView.contentInset;
        self.scrollView.contentInset = UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
        break;
      case kYARefreshPositionBottom:
        if (self.scrollView.contentSize.height >= self.scrollView.bounds.size.height) {
          offset = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.bounds.size.height, 0.0f);
          offset = MIN(offset, self.originalBottomInset + self.bounds.size.height);
          contentInset = self.scrollView.contentInset;
          self.scrollView.contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, offset, contentInset.right);
        } else if (self.wasTriggeredByUser) {
          offset = MIN(self.bounds.size.height, self.originalBottomInset + self.bounds.size.height);
          contentInset = self.scrollView.contentInset;
          self.scrollView.contentInset = UIEdgeInsetsMake(-offset, contentInset.left, contentInset.bottom, contentInset.right);
        }
        break;
    }
  }
}

#pragma mark - Getters

- (YARefreshIndicator *)activityIndicatorView
{
  if(!_activityIndicatorView) {
    CGRect frame = CGRectMake(0, 0, self.bounds.size.height - 30, self.bounds.size.height - 30);
    YARefreshIndicator *refreshIndicator = [[YARefreshIndicator alloc] initWithFrame:frame];
    [self addSubview:refreshIndicator];
    
    _activityIndicatorView = refreshIndicator;
  }
  return _activityIndicatorView;
}

- (UILabel *)titleLabel
{
  if(!_titleLabel) {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
    _titleLabel.text = NSLocalizedString(@"Pull to refresh...",);
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = textColor;
    [self addSubview:_titleLabel];
  }
  return _titleLabel;
}

- (UILabel *)subtitleLabel
{
  if(!_subtitleLabel) {
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
    _subtitleLabel.font = [UIFont systemFontOfSize:12];
    _subtitleLabel.backgroundColor = [UIColor clearColor];
    _subtitleLabel.textColor = textColor;
    [self addSubview:_subtitleLabel];
  }
  return _subtitleLabel;
}

- (UILabel *)dateLabel
{
  return self.showsDateLabel ? self.subtitleLabel : nil;
}

- (NSDateFormatter *)dateFormatter
{
  if(!dateFormatter) {
    dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		dateFormatter.locale = [NSLocale currentLocale];
  }
  return dateFormatter;
}

- (UIColor *)textColor
{
  return self.titleLabel.textColor;
}

#pragma mark - Setters

- (void)setTitle:(NSString *)title forState:(YARefreshState)state
{
  if(!title) title = @"";
  
  if (state & kYARefreshStateStopped) {
    [self.titles setObject:title forKey:@(kYARefreshStateStopped)];
  }
  if (state & kYARefreshStateTriggered) {
    [self.titles setObject:title forKey:@(kYARefreshStateTriggered)];
  }
  if (state & kYARefreshStateLoading) {
    [self.titles setObject:title forKey:@(kYARefreshStateLoading)];
  }
  
  [self setNeedsLayout];
}

- (void)setSubtitle:(NSString *)subtitle forState:(YARefreshState)state
{
  if(!subtitle) subtitle = @"";
  
  if (state & kYARefreshStateStopped) {
    [self.subtitles setObject:subtitle forKey:@(kYARefreshStateStopped)];
  }
  if (state & kYARefreshStateTriggered) {
    [self.subtitles setObject:subtitle forKey:@(kYARefreshStateTriggered)];
  }
  if (state & kYARefreshStateLoading) {
    [self.subtitles setObject:subtitle forKey:@(kYARefreshStateLoading)];
  }
  
  [self setNeedsLayout];
}

- (void)setCustomView:(UIView *)view forState:(YARefreshState)state
{
  id viewPlaceholder = view;
    
  if (state & kYARefreshStateStopped) {
    [self.viewForState setObject:viewPlaceholder forKey:@(kYARefreshStateStopped)];
  }
  if (state & kYARefreshStateTriggered) {
    [self.viewForState setObject:viewPlaceholder forKey:@(kYARefreshStateTriggered)];
  }
  if (state & kYARefreshStateLoading) {
    [self.viewForState setObject:viewPlaceholder forKey:@(kYARefreshStateLoading)];
  }
  
  [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)newTextColor
{
  textColor = newTextColor;
  self.titleLabel.textColor = newTextColor;
	self.subtitleLabel.textColor = newTextColor;
}

- (void)setLastUpdatedDate:(NSDate *)newLastUpdatedDate
{
  self.showsDateLabel = YES;
  self.dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@",), newLastUpdatedDate?[self.dateFormatter stringFromDate:newLastUpdatedDate]:NSLocalizedString(@"Never",)];
}

- (void)setDateFormatter:(NSDateFormatter *)newDateFormatter
{
	dateFormatter = newDateFormatter;
  self.dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@",), self.lastUpdatedDate?[newDateFormatter stringFromDate:self.lastUpdatedDate]:NSLocalizedString(@"Never",)];
}

#pragma mark -

- (void)triggerRefresh
{
  [self.scrollView triggerPullToRefresh];
}

- (void)startAnimating
{
  switch (self.refreshPosition) {
    case kYARefreshPositionTop: {
      if(fequalzero(self.scrollView.contentOffset.y)) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.frame.size.height) animated:YES];
        self.wasTriggeredByUser = NO;
      } else {
        self.wasTriggeredByUser = YES;
      }
      break;
    }
    case kYARefreshPositionBottom: {
      if((fequalzero(self.scrollView.contentOffset.y) && self.scrollView.contentSize.height < self.scrollView.bounds.size.height)
         || fequal(self.scrollView.contentOffset.y, self.scrollView.contentSize.height - self.scrollView.bounds.size.height)) {
        [self.scrollView setContentOffset:(CGPoint){.y = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height, 0.0f) + self.frame.size.height} animated:YES];
        self.wasTriggeredByUser = NO;
      }
      else
        self.wasTriggeredByUser = YES;
      
      break;
    }
  }
  self.refreshState = kYARefreshStateLoading;
}

- (void)stopAnimating
{
  self.refreshState = kYARefreshStateStopped;
  
  switch (self.refreshPosition) {
    case kYARefreshPositionTop:
      if(!self.wasTriggeredByUser
         && self.scrollView.contentOffset.y < -self.originalTopInset) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.originalTopInset) animated:YES];
      }
      break;
    case kYARefreshPositionBottom:
      if(!self.wasTriggeredByUser
         && self.scrollView.contentOffset.y < -self.originalTopInset) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.originalBottomInset) animated:YES];
      }
      break;
  }
}

- (void)setRefreshState:(YARefreshState)refreshState
{
  if(_refreshState != refreshState) {
    YARefreshState previousState = _refreshState;
    _refreshState = refreshState;
    
    [self setNeedsLayout];
    
    switch (refreshState) {
      case kYARefreshStateStopped:
        [self.activityIndicatorView stopLoading];
        [self resetScrollViewContentInset];
        self.wasTriggeredByUser = YES;
        break;
        
      case kYARefreshStateTriggered:
        break;
        
      case kYARefreshStateLoading:
        [self.activityIndicatorView startLoading];
        [self setScrollViewContentInsetForLoading];
        
        if(previousState == kYARefreshStateTriggered
           && self.refreshActionHandler) {
          double delayInSeconds = 0.3;
          dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
          dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.refreshActionHandler();
          });
        }
        break;
    }
  }
}

@end
