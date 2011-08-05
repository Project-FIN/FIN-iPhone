//
//  MapViewController.m
//  FindItNow
//
//  Created by Chanel Huang on 2011/8/2.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import "MapViewController.h"
#import "InfoPopUpView.h"

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction) removeMap
{
    [self.view removeFromSuperview];
}

-(IBAction) openPopup:(id)sender
{
    //LOOK@
    // www.applausible.com/blog/?p=489
    
    //create a dark overlay over the map
    UIView *overlay = [ [UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [overlay setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.75]];
    [self.view addSubview:overlay];
    
    //Create a popup
    InfoPopUpView *popup = [ [InfoPopUpView alloc] initWithFrame:CGRectMake(50, 100, 250, 175)];
    
    //Perform animation
    //[popup appear];
    //need a UIViewAppear class
    
    [overlay addSubview:popup];
    [popup addExitTapGesture];
    //  [popup release];
}

@end
