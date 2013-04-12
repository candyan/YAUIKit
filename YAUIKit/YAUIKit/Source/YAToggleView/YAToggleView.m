//
//  YAToggleView.m
//  YAUIKit
//
//  Created by liu yan on 4/11/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "YAToggleView.h"

#define TOGGLE_SLIDE_DULATION 0.15f

@implementation YAToggleView

@synthesize on = _on;
@synthesize thumbEdgeInsets = _thumbEdgeInsets;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self createSubViews];
    [self createGestureRecognizers];
    
    [self setup];
    
    [self addObserver:self forKeyPath:@"on" options:NSKeyValueObservingOptionNew context:NULL];
    self.on = YES;
  }
  return self;
}

-(void)dealloc {
  [self removeObserver:self forKeyPath:@"on"];
}

#pragma mark - Create Subviews
- (void) createSubViews {
  _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
  [_backgroundImageView setUserInteractionEnabled:YES];
  [_backgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
  [self addSubview:_backgroundImageView];
  
  _toggleThumb = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)];
  [_toggleThumb setUserInteractionEnabled:YES];
  [_toggleThumb setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin];
  [self addSubview:_toggleThumb];
}

- (void) createGestureRecognizers {
  UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
  
  UITapGestureRecognizer *buttonTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleButtonTapGesture:)];
  UITapGestureRecognizer *backgroundtapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleButtonTapGesture:)];
  
  [_toggleThumb addGestureRecognizer:panGesture];
  [_toggleThumb addGestureRecognizer:buttonTapGesture];
  [_backgroundImageView addGestureRecognizer:backgroundtapGesture];
}

- (void) setup {

  [self setThumbImage:[UIImage imageNamed:@"toggle_thumb_btn"] toggleStatus:kYAToggleStatusOn];
  [self setThumbImage:[UIImage imageNamed:@"toggle_thumb_btn"] toggleStatus:KYAToggleStatusOff];
  
  [self setBackgroundImage:[UIImage imageNamed:@"toggle_bg_on"] toggleStatus:kYAToggleStatusOn];
  [self setBackgroundImage:[UIImage imageNamed:@"toggle_bg_off"] toggleStatus:KYAToggleStatusOff];
  
  [self setThumbEdgeInsets:UIEdgeInsetsMake(2.5, 0, 0, 0)];
  [self setThumbSize:CGSizeMake(26, 29)];
}

#pragma mark - Set
- (void)setBackgroundImage:(UIImage *)backgroundImage toggleStatus:(YAToggleStatus)toggleStatus {
  if (toggleStatus == kYAToggleStatusOn) {
    _backgroundImageOn = backgroundImage;
  } else if (toggleStatus == KYAToggleStatusOff) {
    _backgroundImageOff = backgroundImage;
  }
}

- (void)setThumbImage:(UIImage *)thumbImage toggleStatus:(YAToggleStatus)toggleStatus {
  if (toggleStatus == kYAToggleStatusOn) {
    _toggleThumbImageOn = thumbImage;
  } else if (toggleStatus == KYAToggleStatusOff) {
    _toggleThumbImageOff = thumbImage;
  }
}

- (void)setThumbSize:(CGSize)size {
  [_toggleThumb setFrame:CGRectMake(_toggleThumb.frame.origin.x, _toggleThumb.frame.origin.y, size.width, size.height)];
}

- (void)setThumbEdgeInsets:(UIEdgeInsets)thumbEdgeInsets {
  _thumbEdgeInsets = thumbEdgeInsets;
  [_toggleThumb setFrame:CGRectMake(thumbEdgeInsets.left,
                                    thumbEdgeInsets.top,
                                    _toggleThumb.frame.size.width,
                                    _toggleThumb.frame.size.height)];
}

- (void)setOn:(BOOL)on {
  if (_on == on) {
    return;
  }
  
  _on = on;
  [self setValue:[NSNumber numberWithBool:on] forKey:@"on"];
}

- (void)setValueChangedBlock:(void(^)(BOOL on))valueChangedBlock {
  _valueChangedBlock = valueChangedBlock;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:@"on"]) {
    BOOL on = [[change objectForKey:@"new"] boolValue];
    if (on) {
      [_backgroundImageView setImage:_backgroundImageOn];
      [_toggleThumb setImage:_toggleThumbImageOn];
      [self setToggleOnPosition];
    } else {
      [_backgroundImageView setImage:_backgroundImageOff];
      [_toggleThumb setImage:_toggleThumbImageOff];
      [self setToggleOffPosition];
    }
    if (_valueChangedBlock) {
      _valueChangedBlock(on);
    }
  }
}

#pragma mark - position
- (void) setToggleOnPosition {
  CGFloat maxThumbCenterX = self.bounds.size.width - _thumbEdgeInsets.right - _toggleThumb.frame.size.width / 2;
  _toggleThumb.center = CGPointMake(maxThumbCenterX, _toggleThumb.center.y);
}

- (void) setToggleOffPosition {
  CGFloat minThumbCenterX = _thumbEdgeInsets.left + _toggleThumb.frame.size.width / 2;
  _toggleThumb.center = CGPointMake(minThumbCenterX, _toggleThumb.center.y);
}

#pragma mark - GR
- (void)setTogglePosition:(float)positonValue ended:(BOOL)isEnded {
  
  CGFloat minThumbCenterX = _thumbEdgeInsets.left + _toggleThumb.frame.size.width / 2;
  CGFloat maxThumbCenterX = self.bounds.size.width - _thumbEdgeInsets.right - _toggleThumb.frame.size.width / 2;
  
  if (!isEnded)
  {
    if (positonValue == 0.f)
    {
      _toggleThumb.center = CGPointMake(minThumbCenterX,
                                        _toggleThumb.center.y);
    }
    else if (positonValue == 1.f)
    {
      _toggleThumb.center = CGPointMake(maxThumbCenterX,
                                        _toggleThumb.center.y);
    }
    else
    {
      _toggleThumb.center = CGPointMake((positonValue * self.bounds.size.width), _toggleThumb.center.y);
    }
    
  }
  else //isEnded == YES;
  {
    if (positonValue == 0.f)
    {
      _toggleThumb.center = CGPointMake(minThumbCenterX, _toggleThumb.center.y);
      self.on = NO;
    }
    else if (positonValue == 1.f)
    {
      _toggleThumb.center = CGPointMake(maxThumbCenterX, _toggleThumb.center.y);
      self.on = YES;
    }
    else if (positonValue > 0.f && positonValue < 0.5f)
    {
      [UIView animateWithDuration:TOGGLE_SLIDE_DULATION animations:^{
        _toggleThumb.center = CGPointMake(minThumbCenterX, _toggleThumb.center.y);
      } completion:^(BOOL finished) {
        self.on = NO;
      }];
    }
    else if (positonValue >= 0.5f && positonValue < 1.f)
    {
      [UIView animateWithDuration:TOGGLE_SLIDE_DULATION animations:^{
        _toggleThumb.center = CGPointMake(maxThumbCenterX, _toggleThumb.center.y);
      } completion:^(BOOL finished) {
        self.on = YES;
      }];
    }
  }
}

- (void)handlePanGesture:(UIPanGestureRecognizer*) sender {
  
  CGFloat minThumbCenterX = _thumbEdgeInsets.left + _toggleThumb.frame.size.width / 2;
  CGFloat maxThumbCenterX = self.bounds.size.width - _thumbEdgeInsets.right - _toggleThumb.frame.size.width / 2;
  
  CGPoint currentPoint = [sender locationInView:self];
  float position = currentPoint.x;
  if (position < minThumbCenterX) {
    position = minThumbCenterX;
  } else if (position > maxThumbCenterX){
    position = maxThumbCenterX;
  }
  float positionValue = position / self.bounds.size.width;
  
  if (sender.state == UIGestureRecognizerStateBegan)
  {
    if (positionValue < 1.f && positionValue > 0.f)
    {
      [self setTogglePosition:positionValue ended:NO];
    }
  }
  
  if (sender.state == UIGestureRecognizerStateChanged)
  {
    if (positionValue < 1.f && positionValue > 0.f)
    {
      [self setTogglePosition:positionValue ended:NO];
    }
  }
  
  if (sender.state == UIGestureRecognizerStateEnded)
  {
    
    if (positionValue < 1.f && positionValue > 0.f)
    {
      [self setTogglePosition:positionValue ended:YES];
    }
    else if (positionValue >= 1.f)
    {
      [self setTogglePosition:1.f ended:YES];
    }
    else if (positionValue <= 0.f)
    {
      [self setTogglePosition:0.f ended:YES];
    }
  }
}

- (void)handleButtonTapGesture:(UITapGestureRecognizer*) sender {
  
  if (sender.state == UIGestureRecognizerStateEnded)
  {
    if (_toggleThumb.frame.origin.x == self.frame.size.width - _toggleThumb.frame.size.width - _thumbEdgeInsets.right)
    {
      [UIView animateWithDuration:TOGGLE_SLIDE_DULATION animations:^{
        [_toggleThumb setFrame:CGRectMake(_thumbEdgeInsets.left,
                                          _toggleThumb.frame.origin.y,
                                          _toggleThumb.frame.size.width,
                                          _toggleThumb.frame.size.height)];
      }completion:^(BOOL finished) {
        self.on = NO;
      }];
    }
    else if (_toggleThumb.frame.origin.x == _thumbEdgeInsets.left)
    {
      [UIView animateWithDuration:TOGGLE_SLIDE_DULATION animations:^{
        [_toggleThumb setFrame:CGRectMake(self.frame.size.width - _toggleThumb.frame.size.width - _thumbEdgeInsets.right,
                                          _toggleThumb.frame.origin.y,
                                          _toggleThumb.frame.size.width,
                                          _toggleThumb.frame.size.height)];
      }completion:^(BOOL finished) {
        self.on = YES;
      }];
    }
  }
}

@end
