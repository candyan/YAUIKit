//
//  PullRefreshViewController.m
//  YAUIKit
//
//  Created by liu yan on 4/16/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "PullRefreshViewController.h"
#import "YAUIKit.h"

@interface PullRefreshViewController ()<UITableViewDataSource, UITableViewDelegate, YARefreshControlDelegate> {
  NSMutableArray *_numberArray;
}

@property (nonatomic, strong) YARefreshControl *refreshControl;

@end

@implementation PullRefreshViewController

#pragma mark -  init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  [self.view setBackgroundColor:[UIColor whiteColor]];
  _numberArray = [NSMutableArray arrayWithObjects:@1, @2, @3, @4, @5, @6, nil];
  [self.tableView setBackgroundView:nil];

  __weak typeof(self) weakSelf = self;
  [self.refreshControl setCanRefreshDirection:kYARefreshableDirectionTop | kYARefreshableDirectionBottom];
  [self.refreshControl setRefreshHandleAction:^(YARefreshDirection direction) {
    if (direction == kYARefreshDirectionTop) {
      [weakSelf refreshNumber];
    } else if (direction == kYARefreshDirectionBottom) {
      [weakSelf loadMoreNumber];
    }
  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Prop

- (UITableView *)tableView
{
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setFrameOriginY:64];
    [_tableView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight
                                     | UIViewAutoresizingFlexibleWidth)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
  }
  return _tableView;
}

- (YARefreshControl *)refreshControl
{
  if (!_refreshControl) {
    _refreshControl = [[YARefreshControl alloc] initWithScrollView:self.tableView];

    _refreshControl.delegate = self;
  }
  return _refreshControl;
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_numberArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentify = @"NumberCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentify];
  }
  
  [cell.textLabel setText:[NSString stringWithFormat:@"%@", [_numberArray objectAtIndex:indexPath.row]]];
  return cell;
}

#pragma mark - refresh Method
- (void) refreshNumber {
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [_numberArray removeAllObjects];
    for (NSInteger index = 0; index < 7; index++) {
      [_numberArray addObject:@(random())];
    }
    sleep(3);
    dispatch_async(dispatch_get_main_queue(), ^{
      [_tableView reloadData];
      [self.refreshControl stopRefreshAtDirection:kYARefreshDirectionTop animated:YES completion:nil];
    });
  });
}

- (void) loadMoreNumber {
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [_numberArray addObject:[NSNumber numberWithInteger:[_numberArray count]]];
    sleep(2);
    dispatch_async(dispatch_get_main_queue(), ^{
      [_tableView reloadData];
      [self.refreshControl stopRefreshAtDirection:kYARefreshDirectionBottom animated:YES completion:nil];
    });
  });
}

#pragma mark - delegate

- (void)refreshControl:(YARefreshControl *)refreshControl didShowRefreshViewHeight:(CGFloat)progress atDirection:(YARefreshDirection)direction
{
  if (direction == kYARefreshDirectionTop) {
    YARefreshView *refreshView = (YARefreshView *)[refreshControl refreshViewAtDirection:direction];
    NSLog(@"%f", (progress / CGRectGetHeight(refreshView.bounds)));
    [refreshView.refreshIndicator didLoaded:(progress / CGRectGetHeight(refreshView.bounds))];
  }
}

@end
