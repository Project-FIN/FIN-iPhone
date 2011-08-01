//
//  MapView.m
//  FindItNow
//
//  Created by Chanel Huang on 2011/7/7.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import "MapView.h"
#import "InfoPopUpView.h"

@implementation MapView


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) removeMap
{
    [self removeFromSuperview];
}

-(IBAction) openPopup:(id)sender
{
    //LOOK@
    // www.applausible.com/blog/?p=489
    
    //create a dark overlay over the map
    UIView *overlay = [ [UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [overlay setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.75]];
    [self addSubview:overlay];
    
    //Create a popup
    InfoPopUpView *popup = [ [InfoPopUpView alloc] initWithFrame:CGRectMake(50, 100, 250, 300)];
    
    //Perform animation
    //[popup appear];
    //need a UIViewAppear class
    
    [overlay addSubview:popup];
    [popup addExitTapGesture];
    //  [popup release];
}


@end
