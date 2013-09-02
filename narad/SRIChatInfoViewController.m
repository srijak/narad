//
//  SRIChatInfoViewController.m
//  narad
//
//  Created by srjk on 9/1/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIChatInfoViewController.h"
#import "ListViewController.h"
#import "SRIChatInfoSummaryViewController.h"

@interface SRIChatInfoViewController ()

@end

@implementation SRIChatInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ shouldSelectViewController %@ at index %u", tabBarController, viewController, index);
  
	// Uncomment this to prevent "Tab 3" from being selected.
	//return (index != 2);
  
	return YES;
}

- (void)mh_tabBarController:(MHTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ didSelectViewController %@ at index %u", tabBarController, viewController, index);
}

- (void)viewDidLoad
{
	// Do any additional setup after loading the view.

  SRIChatInfoSummaryViewController *listViewController1 = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatInfoSummary"];
	ListViewController *listViewController2 = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
	ListViewController *listViewController3 = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
	
	listViewController1.title = @"Users";
	listViewController2.title = @"Media";
	listViewController3.title = @"Search";
  
	NSArray *viewControllers = @[listViewController1, listViewController2, listViewController3];
  self.delegate = self;
  self.viewControllers = viewControllers;
  
//	MHTabBarController *tabBarController = [[MHTabBarController alloc] init];
  
//	tabBarController.delegate = self;
//	tabBarController.viewControllers = viewControllers;
  //self.  = tabBarController;

  NSLog(@"chatInfoViewController viewDidLoad");

  /*
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [button addTarget:self
             action:@selector(aMethod:)
   forControlEvents:UIControlEventTouchDown];
  [button setTitle:@"Show View" forState:UIControlStateNormal];
  button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
  [self.view addSubview:button];
*/
     [super viewDidLoad];
  

  
}

-(void) viewDidAppear:(BOOL)animated{
 
  [super viewDidAppear:animated];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void) viewWillLayoutSubviews{
  [super viewWillLayoutSubviews];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
