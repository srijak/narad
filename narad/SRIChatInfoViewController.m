//
//  SRIChatInfoViewController.m
//  narad
//
//  Created by srjk on 9/1/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIChatInfoViewController.h"
#import "ListViewController.h"

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

  ListViewController *listViewController1 = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
	ListViewController *listViewController2 = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
	ListViewController *listViewController3 = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
	
	listViewController1.title = @"Tab 1";
	listViewController2.title = @"Tab 2";
	listViewController3.title = @"Tab 3";
  
	listViewController2.tabBarItem.image = [UIImage imageNamed:@"Taijitu"];
	listViewController2.tabBarItem.imageInsets = UIEdgeInsetsMake(0.0f, -4.0f, 0.0f, 0.0f);
	listViewController2.tabBarItem.titlePositionAdjustment = UIOffsetMake(4.0f, 0.0f);
  
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
