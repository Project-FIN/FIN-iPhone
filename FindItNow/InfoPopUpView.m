//
//  InfoPopUpView.m
//  FindItNow
//
//  Created by Chanel Huang on 2011/7/30.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import "InfoPopUpView.h"
#import "FloorInfoTableViewController.h"

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
        
        //Show Info Button:
        isInfoHidden = true;
        UIButton *showHide = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [showHide setTitle:@"Show Table" forState:UIControlStateNormal];
        [showHide addTarget:self action:@selector(addRemInfoTable) forControlEvents:UIControlEventTouchDown];
        showHide.frame = CGRectMake(100, 120, 120, 30);
        [self addSubview:showHide];
        
    }
    return self;
}
-(IBAction) addRemInfoTable
{
    int tableHeight = 150;
    
    [self removeExitTapArea];
    
    if (!isInfoHidden)
    {
        self.frame = CGRectMake(CGRectGetMinX(self.frame),CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-tableHeight);
        [infoTable removeFromSuperview];
        isInfoHidden = true;
    }
    else
    {
        isInfoHidden = false;
        self.frame = CGRectMake(CGRectGetMinX(self.frame),CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)+tableHeight);
    
        //information table
        infoTable = [ [UITableView alloc] initWithFrame:CGRectMake(10, 160, CGRectGetWidth(self.frame)-20, 150)];
        FloorInfoTableViewController *infoTableCtrl = [ [FloorInfoTableViewController alloc] init];
        infoTableCtrl.tableView = infoTable;
        [infoTable setBackgroundColor:[UIColor brownColor]];
        [self addSubview:infoTable];
    }
    [self addExitTapGesture];
}
-(void) addExitTapGesture{  
        
    exitAreas = [[NSMutableArray alloc] initWithCapacity:4];
    //the top block
    UITapGestureRecognizer *exitTap = 
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(exit:)];
    UIView *topTapArea = [ [UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.superview.frame), CGRectGetMinY(self.frame)) ];
    [topTapArea setBackgroundColor:[UIColor clearColor]];
    [topTapArea addGestureRecognizer:exitTap];
    [self.superview addSubview:topTapArea];
    [exitAreas addObject:topTapArea];
    [exitTap release];
    
    //the left block
    exitTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(exit:)];
    UIView *leftTapArea = [ [UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.frame), CGRectGetMinX(self.frame), CGRectGetHeight(self.frame)) ];
    [leftTapArea setBackgroundColor:[UIColor clearColor]];
    [leftTapArea addGestureRecognizer:exitTap];
    [self.superview addSubview:leftTapArea];
    [exitAreas addObject:leftTapArea];
    [exitTap release];
    
    //the right block
    exitTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(exit:)];
    UIView *rightTapArea = [ [UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame), 
        CGRectGetMaxX(self.superview.frame) - CGRectGetMaxX(self.frame), 
        CGRectGetHeight(self.frame)) ];
    [rightTapArea setBackgroundColor:[UIColor clearColor]];
    [rightTapArea addGestureRecognizer:exitTap];
    [self.superview addSubview:rightTapArea];
    [exitAreas addObject:rightTapArea];
    [exitTap release];
    
    //the bottom block
    exitTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(exit:)];
    UIView *bottomTapArea = [ [UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.superview.frame), 
        CGRectGetMaxY(self.superview.frame) - CGRectGetMaxY(self.frame) )];
    [bottomTapArea setBackgroundColor:[UIColor clearColor]];
    [bottomTapArea addGestureRecognizer:exitTap];
    [self.superview addSubview:bottomTapArea];
    [exitAreas addObject:bottomTapArea];
    [exitTap release];

}

-(void) removeExitTapArea
{
    NSLog(@"Test");

    for (UIView *subView in exitAreas)
    {
        [subView removeFromSuperview];
        for (int i=0; i<[subView.gestureRecognizers count]; i++)
        {
            [subView removeGestureRecognizer:[subView.gestureRecognizers objectAtIndex:i]];
        }
    }
}

- (IBAction) exit:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.superview];
  //  NSLog(@"x: %f", location.x);
  //  NSLog(@"y: %f", location.y);

    if ( CGRectContainsPoint(recognizer.view.frame, location) )
    {
        UIView *overlay = self.superview;
        [self removeExitTapArea];
        [self removeFromSuperview];
        [overlay removeFromSuperview];
    }
}

@end
