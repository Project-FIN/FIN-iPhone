//
//  MenuView.m
//  FindItNow
//
//  Created by Chanel Huang on 2011/7/7.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import "MenuView.h"


@implementation MenuView

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)map {
    [self addSubview:mapView];
}

@end
