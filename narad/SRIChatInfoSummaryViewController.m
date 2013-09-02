//
//  SRIChatInfoSummaryViewController.m
//  narad
//
//  Created by srjk on 9/1/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIChatInfoSummaryViewController.h"
#import "UIColor+FlatUI.h"

@interface SRIChatInfoSummaryViewController ()

@property (nonatomic, strong) NSArray *users;

@end

@implementation SRIChatInfoSummaryViewController

- (void)awakeFromNib
{
  self.users = @[@"A Person", @"B Person"
                     ];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ChatInfoSummaryCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorFromHexCode:@"1ABC9C"];
    bgColorView.layer.cornerRadius = 0;
    bgColorView.layer.masksToBounds = YES;
    cell.selectedBackgroundView = bgColorView;
  }
  
  
  cell.textLabel.text = [self.users objectAtIndex:indexPath.row];
  
  return cell;


}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  }

@end
