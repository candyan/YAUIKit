//
//  ToggleViewController.m
//  YAUIKit
//
//  Created by liu yan on 4/11/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "ToggleViewController.h"

#import "YAToggleView.h"

@interface ToggleViewController () {
  YAToggleView *_toggleView;
}

@end

@implementation ToggleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      _toggleView = [[YAToggleView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 60) / 2,
                                                                   (self.view.bounds.size.height - 27) / 2,
                                                                   60,
                                                                   27)];
      __block ToggleViewController *tempViewController = self;
      [_toggleView setValueChangedBlock:^(BOOL on) {
        if (on) {
          [tempViewController.view setBackgroundColor:[UIColor whiteColor]];
        } else {
          [tempViewController.view setBackgroundColor:[UIColor blackColor]];
        }
      }];
      [self.view addSubview:_toggleView];
    }
    return self;
}

- (void)loadView {
  self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
