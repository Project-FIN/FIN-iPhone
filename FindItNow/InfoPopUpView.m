//
// InfoPopUpView.m
// FindItNow
//
// Created by Chanel Huang on 2011/7/30.
// Copyright 2011年 University of Washington. All rights reserved.
//

#import "InfoPopUpView.h"
#import "FloorInfoTableViewController.h"
#import "SQLiteManager.h"
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
        [self setBackgroundColor:[UIColor clearColor]];
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
    [buildingNameLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:buildingNameLabel];
    [buildingNameLabel release];
    
    //Category Type
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, CGRectGetWidth(self.frame)-20, 15)];
    categoryLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [categoryLabel setText:category];
    [categoryLabel setBackgroundColor:[UIColor clearColor]];
    [categoryLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:categoryLabel];
    [categoryLabel release];
    
    
    //Indoor Detail
    NSString *str = [[floorDetail objectForKey: buildingName] objectForKey:category];
    CGFloat detailHeight = 0;
    if (![str isEqualToString:@""])
    {
        NSArray *textline = [str componentsSeparatedByString:@"\\n"];
        str = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        detailHeight = [textline count]*20;
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, CGRectGetWidth(self.frame)-20, detailHeight)];
        detailLabel.lineBreakMode = UILineBreakModeWordWrap;
        detailLabel.font = [UIFont systemFontOfSize:14.0f];
        [detailLabel setTextColor:[UIColor whiteColor]];
        [detailLabel setBackgroundColor:[UIColor clearColor]];
        detailLabel.textAlignment = UITextAlignmentLeft;
        detailLabel.numberOfLines = 0;
        [detailLabel setText:str];
        [self addSubview:detailLabel];
        [detailLabel release];
    }
    
    //Distance
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, detailHeight + 70, CGRectGetWidth(self.frame)-20, 20)];
    distanceLabel.font = [UIFont systemFontOfSize:14.0f];
    [distanceLabel setText:[NSString stringWithFormat:@"Distance to here: %.1f mi", distance]];
    [distanceLabel setBackgroundColor:[UIColor clearColor]];
    [distanceLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:distanceLabel];
    [distanceLabel release];
    
    //Walking Time
    UILabel *walkingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, detailHeight + 90, CGRectGetWidth(self.frame)-20, 20)];
    walkingLabel.font = [UIFont systemFontOfSize:14.0f];
    [walkingLabel setTextColor:[UIColor whiteColor]];
    [walkingLabel setBackgroundColor:[UIColor clearColor]];
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
    [buildingNameLabel setBackgroundColor:[UIColor clearColor]];
    [buildingNameLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:buildingNameLabel];
    [buildingNameLabel release];
    
    //Category Type
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, CGRectGetWidth(self.frame)-20, 15)];
    categoryLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [categoryLabel setText:category];
    [categoryLabel setBackgroundColor:[UIColor clearColor]];
    [categoryLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:categoryLabel];
    [categoryLabel release];
    
    //Distance
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, CGRectGetWidth(self.frame)-20, 20)];
    distanceLabel.font = [UIFont systemFontOfSize:14.0f];
    [distanceLabel setText:[NSString stringWithFormat:@"Distance to here: %.1f mi", distance]];
    [self addSubview:distanceLabel];
    [distanceLabel setBackgroundColor:[UIColor clearColor]];
    [distanceLabel setTextColor:[UIColor whiteColor]];
    [distanceLabel release];
    
    //Walking Time
    UILabel *walkingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, CGRectGetWidth(self.frame)-20, 20)];
    walkingLabel.font = [UIFont systemFontOfSize:14.0f];
    [walkingLabel setText:[NSString stringWithFormat:@"Walking Time: %d Minutes", walkingTime]];
    [walkingLabel setTextColor:[UIColor whiteColor]];
    [walkingLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:walkingLabel];
    [walkingLabel release];
    
    //Show Info Button:
    isInfoHidden = true;
    UIButton *showHide = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [showHide setTitle:@"Show Floors" forState:UIControlStateNormal];
    [showHide addTarget:self action:@selector(addRemInfoTable) forControlEvents:UIControlEventTouchDown];
    showHide.frame = CGRectMake(CGRectGetMaxX(self.frame)-150, 120, 120, 30);
    [self addSubview:showHide];
}

-(IBAction) addRemInfoTable
{
    NSArray* floors = [self getDesendFloor];
    int tableHeight = MAX([floorDetail count] * (180/4),[floors count] * (180/4)); //about 4 cells' height
    
    if (tableHeight > 180)
        tableHeight = 180;
    
    [self removeExitTapArea];
    
    if (!isInfoHidden)
    {
        //perform animation
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.frame = CGRectMake(CGRectGetMinX(self.frame),CGRectGetMinY(self.frame)+(tableHeight/2), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-tableHeight-20);
                             [infoTable setFrame:CGRectMake(10, 160, CGRectGetWidth(self.frame)-20, 0)];
                         }completion:^(BOOL finished) {
                                     [infoTable removeFromSuperview];
                         }];
        isInfoHidden = true;
    }
    else
    {
        isInfoHidden = false;
        
        //information table
        infoTable = [ [UITableView alloc] initWithFrame:CGRectMake(10, 160, CGRectGetWidth(self.frame)-20, 0)];
        FloorInfoTableViewController *infoTableCtrl = [ [FloorInfoTableViewController alloc] initWithDict:floorDetail Floors:floors andIsDoubleExpendable:[category isEqualToString:@""]];
        infoTableCtrl.tableView = infoTable;
        infoTable.alwaysBounceVertical = NO;
        [infoTable setBackgroundColor:[UIColor clearColor]];
        [self addSubview:infoTable];
        
        //perform animation
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.frame = CGRectMake(CGRectGetMinX(self.frame),CGRectGetMinY(self.frame)-(tableHeight/2), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)+tableHeight+20);
                             [infoTable setFrame:CGRectMake(10, 160, CGRectGetWidth(self.frame)-20, tableHeight)];
                         }completion:^(BOOL finished) {
                         }];
        
    }
    [self addExitTapGesture];
}

-(NSArray*) getDesendFloor
{
    SQLiteManager *dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:@"FIN_LOCAL.db"] autorelease];
    NSMutableArray *flr = [[[NSMutableArray alloc] initWithCapacity:[floorDetail count]] autorelease];
    NSMutableDictionary *fnumToName = [[[NSMutableDictionary alloc] initWithCapacity:[floorDetail count]] autorelease];
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT bid FROM buildings WHERE name = '%@'", buildingName];
    NSArray *itemsList = [dbManager getRowsForQuery:sqlStr];
    NSInteger bid = [[[itemsList objectAtIndex:0] objectForKey:@"bid"] intValue];
    if ([category isEqualToString:@""]){
        sqlStr = [NSString stringWithFormat:@"SELECT name,fnum FROM floors WHERE bid = %d", bid];
        itemsList = [dbManager getRowsForQuery:sqlStr];
        for (NSDictionary *dict in itemsList){
            [flr addObject:[dict objectForKey:@"fnum"]];
            [fnumToName setValue:[dict objectForKey:@"name"] forKey:[NSString stringWithFormat:@"%d",[dict objectForKey:@"fnum"] ] ];
        }
        [flr sortUsingSelector:@selector(compare:)];
        flr = [[[NSMutableArray alloc] initWithArray:[[flr reverseObjectEnumerator] allObjects]] autorelease];
        //don't auto relase desendFlr, it'll crash.
        NSMutableArray *desendFlr = [[NSMutableArray alloc] initWithCapacity:[itemsList count]];
        for (NSString *fnum in flr){
            [desendFlr addObject:[fnumToName objectForKey:[NSString stringWithFormat:@"%d", fnum]]];
        }
        return desendFlr;
    }else {
        for(NSString* str in [floorDetail keyEnumerator]){
            sqlStr = [NSString stringWithFormat:@"SELECT fnum FROM floors WHERE name = '%@' AND bid = %d", str, bid];
            itemsList = [dbManager getRowsForQuery:sqlStr];
            [fnumToName setValue:str forKey:[NSString stringWithFormat:@"%d",[[[itemsList objectAtIndex:0] objectForKey:@"fnum"] intValue]]];
            [flr addObject:[NSString stringWithFormat:@"%d",[[[itemsList objectAtIndex:0] objectForKey:@"fnum"] intValue]]];
        }
        [flr sortUsingSelector:@selector(compare:)];
        flr = [[[NSMutableArray alloc] initWithArray:[[flr reverseObjectEnumerator] allObjects]] autorelease];
        NSMutableArray *desendFlr = [[NSMutableArray alloc] initWithCapacity:[flr count]];
        for (NSString *fnum in flr){
            [desendFlr addObject:[fnumToName objectForKey:fnum]];
        }
        return desendFlr;
    }
}

-(void) addExitTapGesture{
    
    exitAreas = [[NSMutableArray alloc] initWithCapacity:4];
    //the top block
    UITapGestureRecognizer *exitTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(exitAnimation:)];
    UIView *topTapArea = [[ [UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.superview.frame), CGRectGetMinY(self.frame)) ] autorelease];
    [topTapArea setBackgroundColor:[UIColor clearColor]];
    [topTapArea addGestureRecognizer:exitTap];
    [self.superview addSubview:topTapArea];
    [exitAreas addObject:topTapArea];
    [exitTap release];
    
    //the left block
    exitTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(exitAnimation:)];
    UIView *leftTapArea = [[ [UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.frame), CGRectGetMinX(self.frame), CGRectGetHeight(self.frame)) ] autorelease];
    [leftTapArea setBackgroundColor:[UIColor clearColor]];
    [leftTapArea addGestureRecognizer:exitTap];
    [self.superview addSubview:leftTapArea];
    [exitAreas addObject:leftTapArea];
    [exitTap release];
    
    //the right block
    exitTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(exitAnimation:)];
    UIView *rightTapArea = [[ [UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame),
                                                                     CGRectGetMaxX(self.superview.frame) - CGRectGetMaxX(self.frame),
                                                                     CGRectGetHeight(self.frame)) ] autorelease];
    [rightTapArea setBackgroundColor:[UIColor clearColor]];
    [rightTapArea addGestureRecognizer:exitTap];
    [self.superview addSubview:rightTapArea];
    [exitAreas addObject:rightTapArea];
    [exitTap release];
    
    //the bottom block
    exitTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(exitAnimation:)];
    UIView *bottomTapArea = [[ [UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.superview.frame),
                                                                      CGRectGetMaxY(self.superview.frame) - CGRectGetMaxY(self.frame) )] autorelease];
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
- (IBAction) exitAnimation:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.superview];
    
    if ( CGRectContainsPoint(recognizer.view.frame, location) )
    {
        UIView *overlay = self.superview;
        
        //perform animation
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationCurveEaseInOut
                         animations:^{
                             [self setFrame:CGRectMake(20, CGRectGetHeight(overlay.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
                         }
                         completion:^(BOOL finished) {
                             [self removeExitTapArea];
                             [self removeFromSuperview];
                             [overlay removeFromSuperview];
                         }];
    }
}

- (void)drawRect:(CGRect)dirtyRect {
    // Drawing code
    
    // Get the context
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Set the drop shadow
    CGContextSaveGState(ctx);
    CGContextSetShadow(ctx, CGSizeMake(0, 0), 0);
    
    // Generate a rect
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    // Draw the background
    float radius = 5.0f;
    CGContextBeginPath(ctx);
    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor colorWithRed:43/255.0 green:57/255.0 blue:96/255.0 alpha:0.9 ] CGColor]) );
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
    CGContextAddArc(ctx, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(ctx, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI / 2, 0);
    CGContextAddArc(ctx, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI / 2, M_PI, 0);
    CGContextAddArc(ctx, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    // Restore state drawing the shadow
    CGContextRestoreGState(ctx);
    
    // Add Gradient
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 3;
    CGFloat locations[3] = { 0.0, 0.5, 1.0 };
    CGFloat components[8] = { 1.0, 1.0, 1.0, 0.25, // Start color
        1.0, 1.0, 1.0, 0.06 }; // End color
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMaxY(currentBounds));
    CGContextDrawLinearGradient(ctx, glossGradient, topCenter, bottomCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
    // Add top grey line ( to give nice effect)
    float lineYOffset = 1.5;
    CGContextBeginPath(ctx);
    CGContextSetStrokeColor(ctx, CGColorGetComponents([[UIColor colorWithRed:0.862 green:0.862 blue:0.862 alpha:0.3 ] CGColor]) );
    CGContextSetLineWidth(ctx, 1.0);
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect) + 1, CGRectGetMinY(rect) + lineYOffset);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect) - 1, CGRectGetMinY(rect) + lineYOffset);
    CGContextStrokePath(ctx);
    
    // Stroke outline
    CGContextBeginPath(ctx);
    CGContextSetStrokeColor(ctx, CGColorGetComponents([[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1 ] CGColor]) );
    CGContextSetLineWidth(ctx, 2.0);
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
    CGContextAddArc(ctx, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(ctx, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI / 2, 0);
    CGContextAddArc(ctx, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI / 2, M_PI, 0);
    CGContextAddArc(ctx, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
}

@end
