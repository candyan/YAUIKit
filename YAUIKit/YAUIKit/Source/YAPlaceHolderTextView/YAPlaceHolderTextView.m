//
//  YAPlaceHolderTextView.m
//  YAUIKit
//
//  Created by liu yan on 4/9/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "YAPlaceHolderTextView.h"

CGFloat placeholderEdgeInset = 8.0f;

@implementation YAPlaceHolderTextView

@synthesize placeholder = _placeholder;
@synthesize placeholderColor = _placeholderColor;

#pragma mark - init & setup
- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setupPlaceHolderTextView];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setupPlaceHolderTextView];
}

- (void) setupPlaceHolderTextView {
  [self setPlaceholder:@""];
  [self setPlaceholderColor:[UIColor lightGrayColor]];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

#pragma mark - draw

- (void)drawRect:(CGRect)rect {
  
  if ([self.placeholder length] > 0) {
    if (!_placeHolderLabel) {
      _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(placeholderEdgeInset,
                                                                    placeholderEdgeInset,
                                                                    self.bounds.size.width - 2 * placeholderEdgeInset,
                                                                    0)];
      [_placeHolderLabel setLineBreakMode:UILineBreakModeCharacterWrap];
      [_placeHolderLabel setNumberOfLines:0];
      [_placeHolderLabel setBackgroundColor:[UIColor clearColor]];
      [_placeHolderLabel setFont:self.font];
      [_placeHolderLabel setTextColor:_placeholderColor];
      [_placeHolderLabel setHidden:YES];
      [self addSubview:_placeHolderLabel];
    }
    
    [_placeHolderLabel setText:self.placeholder];
    [_placeHolderLabel sizeToFit];
    
    if ([self.text length] == 0) {
      [_placeHolderLabel setHidden:NO];
    }
  }
  
  [super drawRect:rect];
}

#pragma mark - Prop
- (void)setContentInset:(UIEdgeInsets)contentInset {
  UIEdgeInsets insets = contentInset;
  
  if (insets.bottom > placeholderEdgeInset) {
    insets.bottom = 0;
  }
  insets.top = 0;
  
  [super setContentInset:insets];
}

- (void)setContentOffset:(CGPoint)contentOffset {
  if(self.tracking || self.decelerating){
		//initiated by user...
		self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	} else {
    
		float bottomOffset = (self.contentSize.height - self.frame.size.height + self.contentInset.bottom);
		if(contentOffset.y < bottomOffset && self.scrollEnabled){
			self.contentInset = UIEdgeInsetsMake(0, 0, placeholderEdgeInset, 0); //maybe use scrollRangeToVisible?
		}
		
	}
	
	[super setContentOffset:contentOffset];
}

- (void)setText:(NSString *)text {
  [super setText:text];
  [self textChanged:nil];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
  _placeholderColor = placeholderColor;
  if (_placeHolderLabel) {
    [_placeHolderLabel setTextColor:_placeholderColor];
  }
}

- (void)setPlaceholder:(NSString *)placeholder {
  _placeholder = placeholder;
  if (_placeHolderLabel) {
    [_placeHolderLabel setText:_placeholder];
    [_placeHolderLabel sizeToFit];
  }
}

- (void)setFont:(UIFont *)font {
  [super setFont:font];
  [_placeHolderLabel setFont:font];
}

#pragma mark - Notification
- (void) textChanged:(NSNotification *)notification {
  if ([self.placeholder length] == 0) {
    return;
  }
  
  if ([self.text length] == 0) {
    [_placeHolderLabel setHidden:NO];
  } else {
    [_placeHolderLabel setHidden:YES];
  }
}

@end
