//
//  SearchViewController.m
//  YAUIKit
//
//  Created by liu yan on 4/12/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "SearchViewController.h"

#import "YASearchBar.h"
#import "YAAlertView.h"

@interface SearchViewController () {
  YASearchBar *_searchBar;
}

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  _searchBar = [[YASearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 39)];
  [self.view addSubview:_searchBar];
  
  [_searchBar setSearchBlock:^{
    __block YAAlertView *alert = [[YAAlertView alloc] initWithTitle:@"点击了Search" message:nil];
    [alert setCancelButtonWithTitle:@"取消" block:nil];
    [alert show];
  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
