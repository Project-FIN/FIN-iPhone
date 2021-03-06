//
//  FindItNowViewController.m
//  FIN
//
//  Created by Eric Hare on 5/7/11.
//  Copyright 2011 University of Washington. All rights reserved.
//

#import "FindItNowViewController.h"
#import "SetRegionViewController.h"

@implementation FindItNowViewController

@synthesize tabBarController;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//where inits go
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.navigationController pushViewController:tabBarController animated:YES];
    UIButton *info = [UIButton buttonWithType:UIButtonTypeInfoLight];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:info];
    self.tabBarController.navigationItem.leftBarButtonItem = item;
    [info addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    [item release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)showActionSheet:(id)sender {
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:nil otherButtonTitles:@"Help", @"Region", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleDefault;
	[popupQuery showInView:self.navigationController.view];
	[popupQuery release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.destructiveButtonIndex && buttonIndex != actionSheet.cancelButtonIndex){
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:@"Help"]) {
            UIViewController *controller = [[UIViewController alloc] initWithNibName:@"HelpView" bundle:[self nibBundle]];
            //[self presentModalViewController:controller animated:YES];
            controller.title = @"Help";
            [self.tabBarController.navigationController pushViewController:controller animated:YES];
        
            [controller release];
        }
        else if ([title isEqualToString:@"Region"]) {
            SetRegionViewController *controller = [[SetRegionViewController alloc] initWithNibName:@"SetRegionViewController" bundle:[self nibBundle]];
            controller.delegate = self;
            //[self presentModalViewController:controller animated:YES];
            [self.tabBarController presentModalViewController:controller animated:YES];
        
            [controller release];
        }
    }
}

-(void) didDismissRegionSelectView
{
    [self.tabBarController dismissModalViewControllerAnimated:YES];
}

@end
