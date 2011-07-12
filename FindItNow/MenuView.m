//
//  MenuView.m
//  FindItNow
//
//  Created by Chanel Huang on 2011/7/7.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import "MenuView.h"


@implementation MenuView

@synthesize text;
@synthesize mapView;

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

- (IBAction) getCategory {
    NSURL *URL=[[NSURL alloc] initWithString:@"http://www.fincdn.org/getCategories.php"];
    NSString *results = [[NSString alloc] initWithContentsOfURL :URL];
    [text setText:results ];
}

@end
