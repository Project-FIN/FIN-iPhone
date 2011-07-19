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
@synthesize btnGrid;

-(void) initOnStart
{
    [self initBtnGrid];
}


- (void) initBtnGrid
{
    NSURL *URL=[[NSURL alloc] initWithString:@"http://www.fincdn.org/getCategories.php"];
    NSString *results = [[NSString alloc] initWithContentsOfURL :URL];
    
    NSArray *categories = [results componentsSeparatedByString:@","];
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:[categories count]];
    int btnSize = ( CGRectGetHeight(btnGrid.frame) - 50 )/([categories count]/2);
    //int btnWidth = CGRectGetWidth(btnGrid.frame) / ([categories count
    for (int i=0; i < [categories count]; i = i+1) {
        UIButton *butt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        butt.frame = CGRectMake(25+((i%2)*(btnSize+50)), 25+((i/2)*btnSize), btnSize, btnSize);
        
        [butt setTitle:[categories objectAtIndex:i] forState:UIControlStateNormal];
        [btnGrid addSubview:butt];
        [buttons addObject:butt];
    }
}

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
    [text setCenter:CGPointMake(100, 150)];
}

@end
