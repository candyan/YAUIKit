//
//  PlaceHolderTextViewController.m
//  YAUIKit
//
//  Created by liu yan on 4/9/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "PlaceHolderTextViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PlaceHolderTextViewController () {
  YAPlaceHolderTextView *_placeholderTextView;
}

@end

@implementation PlaceHolderTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      self.title = @"PlaceHolder TextView";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  _placeholderTextView = [[YAPlaceHolderTextView alloc] initWithFrame:CGRectMake(15, 15, self.view.bounds.size.width - 30, 100)];
  [_placeholderTextView.layer setBorderWidth:1];
  [self.view addSubview:_placeholderTextView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [_placeholderTextView setPlaceholder:@"这是一个Place Holder呦~~~"];
}

- (IBAction)changePlaceHolderColor:(id)sender {
  
  if (_changeColorTextField.text) {
    
    
    [_placeholderTextView setPlaceholderColor:[UIColor colorWithHex:GetIntegerFromString([_changeColorTextField.text cStringUsingEncoding:NSUTF8StringEncoding])]];
  }
  
}

int GetIntegerFromString(const char* pStr)
{
  int nValue = 0;
  for (int i = 0; i < strlen(pStr); i++)
  {
    int nLetterValue ;  //针对数字0~9。a~f自己想 （别告诉我不知道啊）
    
    switch (*(pStr+i))
    {
      case 'a':case 'A':
        nLetterValue = 10;break;
      case 'b':case 'B':
        nLetterValue = 11;break;
      case 'c': case 'C':
        nLetterValue = 12;break;
      case 'd':case 'D':
        nLetterValue = 13;break;
      case 'e': case 'E':
        nLetterValue = 14;break;
      case 'f': case 'F':
        nLetterValue = 15;break;
      default:nLetterValue = *(pStr+i) - '0';
        
    }
    nValue = nValue * 16 + nLetterValue; //16进制
  }
  return nValue;
}
@end
