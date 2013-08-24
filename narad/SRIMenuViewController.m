//
//  SRIMenuViewController.m
//  narad
//
//  Created by srjk on 8/23/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIMenuViewController.h"
#import "UIColor+FlatUI.h"

@interface SRIMenuViewController ()
@property (nonatomic, strong) NSArray *menuItems;

@end

@implementation SRIMenuViewController

- (void)awakeFromNib
{
  self.menuItems = @[
                     @{@"title": @"Messages", @"ctr": @"Messages"},
                     
                     @{@"title": @"Contacts", @"ctr": @"Contacts"}
                     ];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.slidingViewController setAnchorRightRevealAmount:100.0f];
  self.slidingViewController.underLeftWidthLayout = ECFullWidth;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
  return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellIdentifier = @"MenuItemCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorFromHexCode:@"1ABC9C"];
    bgColorView.layer.cornerRadius = 0;
    bgColorView.layer.masksToBounds = YES;
    cell.selectedBackgroundView = bgColorView;
  }
  
  
  cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row][@"title"];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = [self.menuItems objectAtIndex:indexPath.row][@"ctr"];
  
  UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
  
  [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
    CGRect frame = self.slidingViewController.topViewController.view.frame;
    self.slidingViewController.topViewController = newTopViewController;
    self.slidingViewController.topViewController.view.frame = frame;
    [self.slidingViewController resetTopView];
  }];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
