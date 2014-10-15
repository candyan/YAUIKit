//
//  YATextEditorViewController.m
//  YAUIKit
//
//  Created by liuyan on 14-10-15.
//  Copyright (c) 2014年 liu yan. All rights reserved.
//

#import "YATextEditorViewController.h"
#import "UIFont+YAUIKit.h"
#import "UIView+YAUIKit.h"

@interface YATextEditorViewController ()

@end

@implementation YATextEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(ya_keyboardWillShowNotification:)
                   name:UIKeyboardWillShowNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(ya_keyboardWillHiddenNotification:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self
                      name:UIKeyboardWillShowNotification
                    object:nil];
    [center removeObserver:self
                      name:UIKeyboardWillHideNotification
                    object:nil];
}

#pragma mark - Property

- (UIView *)editContainer
{
  if (_editContainer == nil) {
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    [view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    view.backgroundColor = self.view.backgroundColor;
    _editContainer = view;
    [self.view addSubview:_editContainer];
  }
  return _editContainer;
}

- (YAPlaceHolderTextView *)inputTextView
{
  if (_inputTextView == nil) {
    YAPlaceHolderTextView *textView = [[YAPlaceHolderTextView alloc] initWithFrame:self.editContainer.bounds];
    [textView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    _inputTextView = textView;

      _inputTextView.font = [UIFont helveticaFontOfSize:15.0];

    [self.editContainer addSubview:_inputTextView];
  }
  return _inputTextView;
}

#pragma mark - Action

- (void)sendAction:(id)sender
{
  //TODO: Implementation in subclass.
}

- (void)cancelAction:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:^{
    if ([self.delegate respondsToSelector:@selector(textEditorControllerDidCancel:)]) {
        [self.delegate textEditorControllerDidCancel:self];
    }
  }];
}

#pragma mark - keyboard notification

- (void)ya_keyboardWillShowNotification:(NSNotification *)notification
{
  NSDictionary *userInfo = notification.userInfo;

  NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  UIViewAnimationOptions animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
  CGFloat keyboardOriginY = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;

  [UIView animateWithDuration:duration delay:0.0f options:animationCurve animations:^{
    [self.editContainer setFrameHeight:keyboardOriginY - CGRectGetMinY(self.editContainer.frame)];
  } completion:nil];
}

- (void)ya_keyboardWillHiddenNotification:(NSNotification *)notification
{
  NSDictionary *userInfo = notification.userInfo;
  NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  UIViewAnimationOptions animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];

  [UIView animateWithDuration:duration delay:0.0f options:animationCurve animations:^{
    [self.editContainer setFrameHeight:CGRectGetHeight(self.view.bounds)];
  } completion:nil];
}

@end
