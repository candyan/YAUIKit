//
//  MSPullToRefreshController.m
//
//  Created by John Wu on 3/5/12.
//  Copyright (c) 2012 TFM. All rights reserved.
//

#import "MSPullToRefreshController.h"

@interface MSPullToRefreshController ()

@property (nonatomic, assign) MSRefreshingDirections refreshingDirections;
@property (nonatomic, assign) MSRefreshableDirections refreshableDirections;
@property (nonatomic, assign) id <MSPullToRefreshDelegate> delegate;

- (void) _checkOffsetsForDirection:(MSRefreshDirection)direction change:(NSDictionary *)change;

@end

@implementation MSPullToRefreshController
@synthesize refreshingDirections = _refreshingDirections;
@synthesize refreshableDirections = _refreshableDirections;
@synthesize delegate = _delegate;
@synthesize scrollView = _scrollView;
@synthesize originEdgeInsets = _originEdgeInsets;

#pragma mark - Object Life Cycle

- (id) initWithScrollView:(UIScrollView *)scrollView delegate:(id <MSPullToRefreshDelegate>)delegate {
    self = [super init];
    if (self) {
        // set ivars
        _delegate = delegate;
        _scrollView = [scrollView retain];
        _originEdgeInsets = scrollView.contentInset;
        // observe the contentOffset. NSKeyValueObservingOptionPrior is CRUCIAL!
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior context:NULL];
    }
    return self;
}

- (void) dealloc {
    // basic clean up
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [_scrollView release];
    _delegate = nil;
    [super dealloc];
}

#pragma mark - KVO

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        // for each direction, check to see if refresh sequence needs to be updated.
        for (MSRefreshDirection direction = MSRefreshDirectionTop; direction <= MSRefreshDirectionRight; direction++) {
            BOOL canRefresh = [_delegate pullToRefreshController:self canRefreshInDirection:direction];
            if (canRefresh)
                [self _checkOffsetsForDirection:direction change:change];
        }

        _wasDragging = _scrollView.dragging;
    }
}

#pragma mark - Public Methods

- (void) startRefreshingDirection:(MSRefreshDirection)direction {
    [self startRefreshingDirection:direction animated:YES];
}

- (void) startRefreshingDirection:(MSRefreshDirection)direction animated:(BOOL)animated {
    MSRefreshingDirections refreshingDirection = MSRefreshingDirectionNone;
    MSRefreshableDirections refreshableDirection = MSRefreshableDirectionNone;
    UIEdgeInsets contentInset = _scrollView.contentInset;
    CGPoint contentOffset = CGPointZero;

    CGFloat refreshingInset = [_delegate pullToRefreshController:self refreshingInsetForDirection:direction];

    switch (direction) {
        case MSRefreshDirectionTop:
            refreshableDirection = MSRefreshableDirectionTop;
            refreshingDirection = MSRefreshingDirectionTop;
            contentInset = UIEdgeInsetsMake(refreshingInset, contentInset.left, contentInset.bottom, contentInset.right);
            contentOffset = CGPointMake(0, -refreshingInset);
            break;
        case MSRefreshDirectionLeft:
            refreshableDirection = MSRefreshableDirectionLeft;
            refreshingDirection = MSRefreshingDirectionLeft;
            contentInset = UIEdgeInsetsMake(contentInset.top, refreshingInset, contentInset.bottom, contentInset.right);
            contentOffset = CGPointMake(-refreshingInset, 0);
            break;
        case MSRefreshDirectionBottom:
            refreshableDirection = MSRefreshableDirectionBottom;
            refreshingDirection = MSRefreshingDirectionBottom;
            contentOffset = CGPointMake(0, _scrollView.contentSize.height - _scrollView.bounds.size.height
                                        + refreshingInset + contentInset.bottom);
            break;
        case MSRefreshDirectionRight:
            refreshableDirection = MSRefreshableDirectionRight;
            refreshingDirection = MSRefreshingDirectionRight;
            contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, contentInset.bottom, refreshingInset);
            contentOffset = CGPointMake(_scrollView.contentSize.width + refreshingInset, 0);
            break;
        default:
            break;
    }

  if (animated) {
    [UIView animateWithDuration:.3f animations:^{
      _scrollView.contentInset = contentInset;
      _scrollView.contentOffset = contentOffset;
    } completion:^(BOOL finished) {
      self.refreshingDirections |= refreshingDirection;
      self.refreshableDirections &= ~refreshableDirection;
      if ([_delegate respondsToSelector:@selector(pullToRefreshController:didEngageRefreshDirection:)]) {
        [_delegate pullToRefreshController:self didEngageRefreshDirection:direction];
      }
    }];
  } else {
    self.refreshingDirections |= refreshingDirection;
    self.refreshableDirections &= ~refreshableDirection;
    if ([_delegate respondsToSelector:@selector(pullToRefreshController:didEngageRefreshDirection:)]) {
      [_delegate pullToRefreshController:self didEngageRefreshDirection:direction];
    }
  }
  
}

- (void) finishRefreshingDirection:(MSRefreshDirection)direction complate:(void(^)())complate {
    [self finishRefreshingDirection:direction animated:YES complate:complate];
}

- (void) finishRefreshingDirection:(MSRefreshDirection)direction
                          animated:(BOOL)animated
                          complate:(void(^)())complate {
    MSRefreshingDirections refreshingDirection = MSRefreshingDirectionNone;
    switch (direction) {
        case MSRefreshDirectionTop:
            refreshingDirection = MSRefreshingDirectionTop;
            break;
        case MSRefreshDirectionLeft:
            refreshingDirection = MSRefreshingDirectionLeft;
            break;
        case MSRefreshDirectionBottom:
            refreshingDirection = MSRefreshingDirectionBottom;
            break;
        case MSRefreshDirectionRight:
            refreshingDirection = MSRefreshingDirectionRight;
            break;
        default:
            break;
    }
  if (animated) {
    [UIView animateWithDuration:.4f animations:^{
      _scrollView.contentInset = _originEdgeInsets;
      self.refreshingDirections &= ~refreshingDirection;
    } completion:^(BOOL finished) {
      if (complate) {
        complate();
      }
    }];
  } else {
    _scrollView.contentInset = _originEdgeInsets;
    self.refreshingDirections &= ~refreshingDirection;
    if (complate) {
      complate();
    }
  }
}

#pragma mark - Private Methods

- (void) _checkOffsetsForDirection:(MSRefreshDirection)direction change:(NSDictionary *)change {

    // define some local ivars that disambiguates according to direction
    CGPoint oldOffset = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];

    MSRefreshingDirections refreshingDirection = MSRefreshingDirectionNone;
    MSRefreshableDirections refreshableDirection = MSRefreshableDirectionNone;
    BOOL canEngage = NO;
    UIEdgeInsets contentInset = _scrollView.contentInset;

    CGFloat refreshableInset = [_delegate pullToRefreshController:self refreshableInsetForDirection:direction];
    CGFloat refreshingInset = [_delegate pullToRefreshController:self refreshingInsetForDirection:direction];

    switch (direction) {
        case MSRefreshDirectionTop:
            refreshingDirection = MSRefreshingDirectionTop;
            refreshableDirection = MSRefreshableDirectionTop;
            canEngage = oldOffset.y < - refreshableInset;
            contentInset = UIEdgeInsetsMake(refreshingInset, contentInset.left, contentInset.bottom, contentInset.right);
            break;
        case MSRefreshDirectionLeft:
            refreshingDirection = MSRefreshingDirectionLeft;
            refreshableDirection = MSRefreshableDirectionLeft;
            canEngage = oldOffset.x < -refreshableInset;
            contentInset = UIEdgeInsetsMake(contentInset.top, refreshingInset, contentInset.bottom, contentInset.right);
            break;
        case MSRefreshDirectionBottom: {
          refreshingDirection = MSRefreshingDirectionBottom;
          refreshableDirection = MSRefreshableDirectionBottom;
          if (_scrollView.frame.size.height > _scrollView.contentSize.height) {
            canEngage = (oldOffset.y > refreshableInset);
          }  else {
            canEngage = (_scrollView.frame.size.height + oldOffset.y - _scrollView.contentSize.height - _scrollView.contentInset.bottom  > refreshableInset);
          }
          contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, (contentInset.bottom + refreshableInset), contentInset.right);
          break;
        }
        case MSRefreshDirectionRight:
            refreshingDirection = MSRefreshingDirectionRight;
            refreshableDirection = MSRefreshableDirectionRight;
            canEngage = oldOffset.x + _scrollView.frame.size.width - _scrollView.contentSize.width > refreshableInset;
            contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, contentInset.bottom, refreshingInset);
            break;
        default:
            break;
    }

    if (!(self.refreshingDirections & refreshingDirection)) {
        // only go in here if the requested direction is enabled and not refreshing
        if (canEngage) {
            // only go in here if user pulled past the inflection offset
            if (_wasDragging != _scrollView.dragging && _scrollView.decelerating && [change objectForKey:NSKeyValueChangeNotificationIsPriorKey] && (self.refreshableDirections & refreshableDirection)) {
                // if you are decelerating, it means you've stopped dragging.
                self.refreshingDirections |= refreshingDirection;
                self.refreshableDirections &= ~refreshableDirection;
                [UIView animateWithDuration:.2f animations:^{
                  _scrollView.contentInset = contentInset;
                } completion:^(BOOL finished) {
                  if ([_delegate respondsToSelector:@selector(pullToRefreshController:didEngageRefreshDirection:)]) {
                    [_delegate pullToRefreshController:self didEngageRefreshDirection:direction];
                  }
                }];              
            } else if (_scrollView.dragging && !_scrollView.decelerating && !(self.refreshableDirections & refreshableDirection)) {
                // only go in here the first time you've dragged past releasable offset
                self.refreshableDirections |= refreshableDirection;
                if ([_delegate respondsToSelector:@selector(pullToRefreshController:canEngageRefreshDirection:)]) {
                    [_delegate pullToRefreshController:self canEngageRefreshDirection:direction];
                }
            }
        } else if ((self.refreshableDirections & refreshableDirection) ) {
            // if you're here it means you've crossed back from the releasable offset
            self.refreshableDirections &= ~refreshableDirection;
            if ([_delegate respondsToSelector:@selector(pullToRefreshController:didDisengageRefreshDirection:)]) {
                [_delegate pullToRefreshController:self didDisengageRefreshDirection:direction];
            }
        }
    }

}

@end
