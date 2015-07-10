//
//  YAPlaceHolderTextView.m
//  YAUIKit
//
//  Created by liu yan on 4/9/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "YAPlaceHolderTextView.h"

static CGFloat const kPlaceholderEdgeInset = 8.0f;
static CGFloat const kPlaceholderLeftEdgeInset = 5.0f;

@implementation YAPlaceHolderTextView

@synthesize placeholder = _placeholder;
@synthesize placeholderColor = _placeholderColor;

#pragma mark - init & setup
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPlaceHolderTextView];
        [self setFont:[UIFont systemFontOfSize:12.0f]];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupPlaceHolderTextView];
}

- (void)setupPlaceHolderTextView
{
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.placeholder length] > 0 && [self.text length] == 0) {
        [[self _placeHolderLabel] setText:self.placeholder];

        if ([self respondsToSelector:@selector(textContainerInset)]) {
            [[self _placeHolderLabel]
                setFrame:CGRectMake(
                             kPlaceholderLeftEdgeInset + self.textContainerInset.left, self.textContainerInset.top,
                             self.bounds.size.width - self.textContainerInset.left + self.textContainerInset.right, 0)];
        } else {
            [[self _placeHolderLabel] setFrame:CGRectMake(kPlaceholderEdgeInset + self.contentInset.left,
                                                          kPlaceholderEdgeInset + self.contentInset.top,
                                                          self.bounds.size.width - 2 * kPlaceholderEdgeInset, 0)];
        }

        [[self _placeHolderLabel] sizeToFit];
        [[self _placeHolderLabel] setHidden:NO];
    } else {
        [[self _placeHolderLabel] setHidden:YES];
    }
}

#pragma mark - Prop
- (UILabel *)_placeHolderLabel
{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_placeHolderLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [_placeHolderLabel setNumberOfLines:0];
        [_placeHolderLabel setBackgroundColor:[UIColor clearColor]];
        [_placeHolderLabel setFont:self.font];
        [_placeHolderLabel setTextColor:_placeholderColor];
        [_placeHolderLabel setHidden:YES];
        [self addSubview:_placeHolderLabel];
    }
    return _placeHolderLabel;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textChanged:nil];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [[self _placeHolderLabel] setTextColor:placeholderColor];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    [self setNeedsLayout];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [[self _placeHolderLabel] setFont:font];
}

#pragma mark - Notification
- (void)textChanged:(NSNotification *)notification
{
    if ([self.placeholder length] == 0)
        return;

    if ([self.text length] == 0) {
        [[self _placeHolderLabel] setHidden:NO];
    } else {
        [[self _placeHolderLabel] setHidden:YES];
    }
    [self setNeedsLayout];
}

@end