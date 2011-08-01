//
//  InfoPopUpView.m
//  FindItNow
//
//  Created by Chanel Huang on 2011/7/30.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import "InfoPopUpView.h"
#import "BuildingViewController.h"

@implementation InfoPopUpView



- (void)dealloc
{
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (id) initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setBackgroundColor:[UIColor blackColor]];
        [self setOpaque:YES];
        [self setAlpha:0.85];
        
        //Add a button
       // UIButton *button = [[UIButton alloc]];
        
        //Lavel
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 20)];
        [label setText:@"This is a test for the popUP"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor purpleColor]];
        [self addSubview:label];
        [label release];
        
        UITableView *table = [ [UITableView alloc] initWithFrame:CGRectMake(10, 50, CGRectGetWidth(frame)-20, 150)];
        //[table set
        BuildingViewController *infoTable = [ [BuildingViewController alloc] init];
        infoTable.tableView = table;
        
        
        [self addSubview:table];
        
    }
    return self;
}

@end
