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
        [self setBackgroundColor:[UIColor whiteColor]];
        
        //Add a button
       // UIButton *button = [[UIButton alloc]];
        
        //Building Name
        UILabel *buildingName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(frame)-20, 20)];
        buildingName.font = [UIFont boldSystemFontOfSize:16.0f];
        [buildingName setText:@"Meany Hall (Hardcoded)"];
        [buildingName setBackgroundColor:[UIColor clearColor]];
        [buildingName setTextColor:[UIColor purpleColor]];
        [self addSubview:buildingName];
        [buildingName release];
        
        //Category Type
        UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, CGRectGetWidth(frame)-20, 15)];
        categoryLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [categoryLabel setText:@"Vending (Hardcoded)"];
        [self addSubview:categoryLabel];
        [categoryLabel release];
        
        //Distance
        UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, CGRectGetWidth(frame)-20, 20)];
        distanceLabel.font = [UIFont systemFontOfSize:14.0f];
        [distanceLabel setText:@"Distance to Here: 0.14 mi (Hardcoded)"];
        [self addSubview:distanceLabel];
        [distanceLabel release];
        
        //Walking Time
        UILabel *walkingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, CGRectGetWidth(frame)-20, 20)];
        walkingLabel.font = [UIFont systemFontOfSize:14.0f];
        [walkingLabel setText:@"Walking Time: 10 Minutes"];
        [self addSubview:walkingLabel];
        [walkingLabel release];
        
        
        //information table
        UITableView *table = [ [UITableView alloc] initWithFrame:CGRectMake(10, 110, CGRectGetWidth(frame)-20, 150)];
        BuildingViewController *infoTable = [ [BuildingViewController alloc] init];
        infoTable.tableView = table;
        [table setBackgroundColor:[UIColor brownColor]];
        
        
        [self addSubview:table];

    }
    return self;
}

-(void) addExitTapGesture{
    if (self.superview == nil){
        NSLog(@"tjlrjtlf");
    }
    
    UITapGestureRecognizer *exitTap = 
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(exit:)];
    [self.superview addGestureRecognizer:exitTap];
}

- (IBAction) exit:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.superview];

    if ( !CGRectContainsPoint(self.frame, location) )
    {
        UIView *overlay = self.superview;
        [self removeFromSuperview];
        [overlay removeGestureRecognizer:recognizer];
        [overlay removeFromSuperview];

    }
}

@end
