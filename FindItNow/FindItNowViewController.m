//
//  FindItNowViewController.m
//  FindItNow
//
//  Created by Eric Hare on 5/7/11.
//  Copyright 2011 University of Washington. All rights reserved.
//

#import "FindItNowViewController.h"
#import "InfoPopUpView.h"

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
    self.view = tabBarController.view;
    
//    [menuViewController initOnStart]; w
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

-(IBAction) openPopup:(id)sender
{
    //LOOK@
    // www.applausible.com/blog/?p=489
    
    //Create a popup
    InfoPopUpView *popup = [ [InfoPopUpView alloc] initWithFrame:CGRectMake(50, 100, 250, 100)];
    
    //Perform animation
    //[popup appear];
    //need a UIViewAppear class
    
    [self.view addSubview:popup];
    
    //  [popup release];
}

@end
