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

- (id) initWithFrame:(CGRect)frame WithBName:(NSString*)building category:(NSString*)cat distance:(double)dist walkTime: (int)walk
                data:(NSMutableDictionary*) data IsOutdoor:(BOOL)isOutdoor
{
    buildingName = building;
    category = cat;
    distance = dist;
    walkingTime = walk;
    floorDetail = data;
    if ((self = [super initWithFrame:frame]))
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        if (isOutdoor)
            [self constructOutdoorView];
        else
            [self constructIndoorView];
    }
    return self;
}

-(void) constructOutdoorView
{
    //Building Name
    UILabel *buildingNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.frame)-20, 20)];
    buildingNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [buildingNameLabel setText:buildingName];
    [buildingNameLabel setBackgroundColor:[UIColor clearColor]];
    [buildingNameLabel setTextColor:[UIColor purpleColor]];
    [self addSubview:buildingNameLabel];
    [buildingNameLabel release];
    
    //Category Type
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, CGRectGetWidth(self.frame)-20, 15)];
    categoryLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [categoryLabel setText:category];
    [self addSubview:categoryLabel];
    [categoryLabel release];
    
    
    //Indoor Detail
    NSString *key = [[[floorDetail keyEnumerator] allObjects] objectAtIndex:0];
    NSString *str = [floorDetail objectForKey: key];
    CGFloat detailHeight = 0;
    if (![str isEqualToString:@""])
    {
        NSArray *textline = [str componentsSeparatedByString:@"\n"];
        detailHeight = [textline count]*20;
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, CGRectGetWidth(self.frame)-20, detailHeight)];
        detailLabel.font = [UIFont systemFontOfSize:14.0f];
        detailLabel.textAlignment = UITextAlignmentLeft;
        detailLabel.numberOfLines = 0;    
        [detailLabel setText:str];
        [self addSubview:detailLabel];
        [detailLabel release];    
    }
    
    //Distance
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, detailHeight + 70, CGRectGetWidth(self.frame)-20, 20)];
    distanceLabel.font = [UIFont systemFontOfSize:14.0f];
    [distanceLabel setText:[NSString stringWithFormat:@"Distance to here: %f mi", distance]];
    [self addSubview:distanceLabel];
    [distanceLabel release];
    
    //Walking Time
    UILabel *walkingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, detailHeight + 90, CGRectGetWidth(self.frame)-20, 20)];
    walkingLabel.font = [UIFont systemFontOfSize:14.0f];
    [walkingLabel setText:[NSString stringWithFormat:@"Walking Time: %d Minutes", walkingTime]];
    [self addSubview:walkingLabel];
    [walkingLabel release];
    
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame),CGRectGetMaxY(walkingLabel.frame)+20);
}

-(void) constructIndoorView
{
    //Building Name
    UILabel *buildingNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.frame)-20, 20)];
    buildingNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [buildingNameLabel setText:buildingName];
    [buildingNameLabel setBackgroundColor:[UIColor clearColor]];
    [buildingNameLabel setTextColor:[UIColor purpleColor]];
    [self addSubview:buildingNameLabel];
    [buildingNameLabel release];
    
    //Category Type
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, CGRectGetWidth(self.frame)-20, 15)];
    categoryLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [categoryLabel setText:category];
    [self addSubview:categoryLabel];
    [categoryLabel release];
    
    //Distance
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, CGRectGetWidth(self.frame)-20, 20)];
    distanceLabel.font = [UIFont systemFontOfSize:14.0f];
    [distanceLabel setText:[NSString stringWithFormat:@"Distance to here: %f mi", distance]];
    [self addSubview:distanceLabel];
    [distanceLabel release];
    
    //Walking Time
    UILabel *walkingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, CGRectGetWidth(self.frame)-20, 20)];
    walkingLabel.font = [UIFont systemFontOfSize:14.0f];
    [walkingLabel setText:[NSString stringWithFormat:@"Walking Time: %d Minutes", walkingTime]];
    [self addSubview:walkingLabel];
    [walkingLabel release];
    
    //Show Info Button:
    isInfoHidden = true;
    UIButton *showHide = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [showHide setTitle:@"Show Table" forState:UIControlStateNormal];
    [showHide addTarget:self action:@selector(addRemInfoTable) forControlEvents:UIControlEventTouchDown];
    showHide.frame = CGRectMake(CGRectGetMaxX(self.frame)-150, 120, 120, 30);
    [self addSubview:showHide];
}

-(IBAction) addRemInfoTable
{
    int tableHeight = 180;  //about 4 cells' height
    
    [self removeExitTapArea];
    
    if (!isInfoHidden)
    {
        self.frame = CGRectMake(CGRectGetMinX(self.frame),CGRectGetMinY(self.frame)+(tableHeight/2), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-tableHeight-20);
        [infoTable removeFromSuperview];
        isInfoHidden = true;
    }
    else
    {
        isInfoHidden = false;
        self.frame = CGRectMake(CGRectGetMinX(self.frame),CGRectGetMinY(self.frame)-(tableHeight/2), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)+tableHeight+20);
    
        //information table
        infoTable = [ [UITableView alloc] initWithFrame:CGRectMake(10, 160, CGRectGetWidth(self.frame)-20, tableHeight)];
        FloorInfoTableViewController *infoTableCtrl = [ [FloorInfoTableViewController alloc] initWithDict:floorDetail];
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
